From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH] FC transport & lpfc : Avoid device offline cases by stalling
 aborts until device unblocked
Date: Mon, 06 Feb 2006 11:29:36 -0500
Message-ID: <43E77970.1030500@emulex.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:50100 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932148AbWBFQ3l
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Feb 2006 11:29:41 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k16GTcrf014750
	for <linux-scsi@vger.kernel.org>; Mon, 6 Feb 2006 08:29:38 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

The attached patch creates a FC transport service routine, which can
be specified in the LLDD's scsi_host_template. This allows the transport
to intercept io timeouts, check the state of rport, and if blocked,
request the midlayer to reschedule the timeout. This patch also patches
the lpfc driver to make use of this interface.

What we are trying to avoid is to have the abort handler kick in while the
rport is blocked. The rport is blocked because we have lost connectivity.
As we have no connectivity, the LLDD either fails it (most common) or busy
stalls (yech!) until rport state is resolved.  If the abort is failed, the
error handler escalates, and eventually attempts to send a TUR to the
device, which fails as we have no connectivity. As the TUR fails, the device
gets taken offline, requiring manual interaction to restore use.

The original suggestion was from James Bottomley:
http://marc.theaimsgroup.com/?l=linux-scsi&m=113682123403609&w=2
based on the thread started by Michael Reed:
http://marc.theaimsgroup.com/?l=linux-scsi&m=113477788309880&w=2

Please note:
   This does not resolve the cases where the error handlers are engaged when
   the rport is blocked.

   The need of the transport conflicted with the initial eh_timed_out design,
   which limited the rescheduling of the timeout to the number of retries
   allowed on the command plus 1.  In the case of the FC transport, we already
   have the dev_loss_tmo running to guarantee that this will not be an
   infinite stall, so penalizing the i/o (especially be incrementing the retry
   count) should be avoided.

   Also, as Christoph just recently removed the eh_timed_out use in the
   megaraid driver - he eliminated the only other (in-kernel) user of this
   interface. Perhaps we should consider changing the design and realign
   the EH_RESET_TIMER functionality to what EH_TRANSPORT_BLOCKED does.
   Thoughts ?

-- james s



diff -upNr a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c	2006-02-06 06:01:12.000000000 -0500
+++ b/drivers/scsi/scsi_error.c	2006-02-06 09:15:24.000000000 -0500
@@ -153,6 +153,25 @@ int scsi_delete_timer(struct scsi_cmnd *
   * scsi_times_out - Timeout function for normal scsi commands.
   * @scmd:	Cmd that is timing out.
   *
+ * Allows transport or LLDD to intercept command timeout for additional
+ * processing. The handler returns a status for the timeout processing:
+ *  EH_HANDLED:
+ *    The transport/LLDD has completed the timeout processing. No further
+ *    error handling is necessary. Proceed with scsi command completion
+ *    processing.
+ *  EH_RESET_TIMER:
+ *    The LLDD is requesting further delay of the timeout handler
+ *    The midlayer reschedules the timeout, but it counts against the
+ *    retry limit for the i/o.
+ *  EH_TRANSPORT_BLOCKED;
+ *    The transport is reporting that the device is in a "blocked"
+ *    state wherein it cannot be contacted (typically due to a temporary
+ *    loss of connectivity). The transport ensures that this is not an
+ *    infinite condition. The timeout is rescheduled until the transport
+ *    state changes.
+ *  EH_NOT_HANDLED:
+ *    No processing. The midlayer performs its normal timeout functions.
+ *
   * Notes:
   *     We do not need to lock this.  There is the potential for a race
   *     only in that the normal completion handling might run, but if the
@@ -173,6 +192,8 @@ void scsi_times_out(struct scsi_cmnd *sc
  			 * with allowed == 0 */
  			if (scmd->retries++ > scmd->allowed)
  				break;
+			/* FALL THRU */
+		case EH_TRANSPORT_BLOCKED:
  			scsi_add_timer(scmd, scmd->timeout_per_command,
  				       scsi_times_out);
  			return;
diff -upNr a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	2006-02-06 06:01:12.000000000 -0500
+++ b/drivers/scsi/scsi_transport_fc.c	2006-02-06 10:45:53.000000000 -0500
@@ -31,6 +31,7 @@
  #include <scsi/scsi_host.h>
  #include <scsi/scsi_transport.h>
  #include <scsi/scsi_transport_fc.h>
+#include <scsi/scsi_cmnd.h>
  #include "scsi_priv.h"

  /*
@@ -1879,6 +1880,45 @@ restart_search:
  }


+/**
+ * fc_sdev_io_timeout - FC Transport I/O timeout intercept handler
+ *
+ * @scmd:	The SCSI command which timed out
+ *
+ * This routine can be used by a FC LLDD as its eh_timed_out function in
+ * the scsi host template.
+ *
+ * This routine protects against error handlers getting invoked while a
+ * rport is in a blocked state, typically due to a temporarily loss of
+ * connectivity. If the error handlers are allowed to proceed, requests
+ * to abort i/o, reset the target, etc will likely fail as there is no way
+ * to communicate with the device to perform the requested function. These
+ * failures may result in the midlayer taking the device offline, requiring
+ * manual intervention to restore operation.
+ *
+ * This routine, called whenever an i/o times out, validates the state of
+ * the underlying rport. If the rport is blocked, it returns
+ * EH_TRANSPORT_BLOCKED, which will continue to reschedule the timeout.
+ * Eventually, either the device will return, or devloss_tmo will fire,
+ * and when the timeout then fires, it will be handled normally.
+ * If the rport is not blocked, normal error handling continues.
+ *
+ * Notes:
+ *	This routine assumes no locks are held on entry.
+ **/
+enum scsi_eh_timer_return
+fc_sdev_io_timeout(struct scsi_cmnd *scmd)
+{
+	struct fc_rport *rport = starget_to_rport(scsi_target(scmd->device));
+
+	if (rport->port_state == FC_PORTSTATE_BLOCKED)
+		return EH_TRANSPORT_BLOCKED;
+
+	return EH_NOT_HANDLED;
+}
+EXPORT_SYMBOL(fc_sdev_io_timeout);
+
+
  MODULE_AUTHOR("Martin Hicks");
  MODULE_DESCRIPTION("FC Transport Attributes");
  MODULE_LICENSE("GPL");
diff -upNr a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
--- a/include/scsi/scsi_host.h	2006-02-06 06:01:41.000000000 -0500
+++ b/include/scsi/scsi_host.h	2006-02-06 09:09:20.000000000 -0500
@@ -38,6 +38,7 @@ enum scsi_eh_timer_return {
  	EH_NOT_HANDLED,
  	EH_HANDLED,
  	EH_RESET_TIMER,
+	EH_TRANSPORT_BLOCKED,
  };


diff -upNr a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
--- a/include/scsi/scsi_transport_fc.h	2006-02-06 06:01:41.000000000 -0500
+++ b/include/scsi/scsi_transport_fc.h	2006-02-06 09:10:31.000000000 -0500
@@ -483,6 +483,7 @@ struct fc_rport *fc_remote_port_add(stru
  void fc_remote_port_delete(struct fc_rport  *rport);
  void fc_remote_port_rolechg(struct fc_rport  *rport, u32 roles);
  int scsi_is_fc_rport(const struct device *);
+enum scsi_eh_timer_return fc_sdev_io_timeout(struct scsi_cmnd *scmd);

  static inline u64 wwn_to_u64(u8 *wwn)
  {
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2006-02-06 06:01:10.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2006-02-06 09:12:31.000000000 -0500
@@ -1288,6 +1288,7 @@ struct scsi_host_template lpfc_template
  	.name			= LPFC_DRIVER_NAME,
  	.info			= lpfc_info,
  	.queuecommand		= lpfc_queuecommand,
+	.eh_timed_out		= fc_sdev_io_timeout,
  	.eh_abort_handler	= lpfc_abort_handler,
  	.eh_device_reset_handler= lpfc_reset_lun_handler,
  	.eh_bus_reset_handler	= lpfc_reset_bus_handler,

