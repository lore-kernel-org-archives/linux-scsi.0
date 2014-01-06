From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi_transport_srp: Fix kernel-doc warnings
Date: Mon, 06 Jan 2014 07:39:27 +0100
Message-ID: <52CA4F9F.20600@acm.org>
References: <52C0FE81.4080209@infradead.org> <52C8BB31.7020709@infradead.org> <52C92238.6060007@acm.org> <52C9C2FE.5000800@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060900040308090303070304"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp03.stone-is.org ([87.238.162.66]:40449 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbaAFGjd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jan 2014 01:39:33 -0500
In-Reply-To: <52C9C2FE.5000800@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, David Dillow <dillowda@ornl.gov>, Vu Pham <vu@mellanox.com>, Sebastian Riemer <sebastian.riemer@profitbricks.com>, Douglas Gilbert <dgilbert@interlog.com>

This is a multi-part message in MIME format.
--------------060900040308090303070304
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 01/05/14 21:39, Randy Dunlap wrote:
> On 01/05/14 01:13, Bart Van Assche wrote:
>> The following command has been used to verify that the kernel-doc
>> tool no longer complains about undocumented fields:
>>
>> scripts/kernel-doc -html drivers/scsi/scsi_transport_srp.c \
>>   include/scsi/scsi_transport_srp.h >srp-transport-doc.html
> 
> Thanks for the patch.
> I guess that your tree is different from mine.  Using 3.13-rc7, I still get
> 3 warnings:
> 
> Warning(drivers/scsi/scsi_transport_srp.c:620): No description found for parameter 'scmd'
> Warning(drivers/scsi/scsi_transport_srp.c:688): No description found for parameter 'rport'
> Warning(drivers/scsi/scsi_transport_srp.c:697): No description found for parameter 'rport'
> 
> I also had some trouble with the patch itself -- looks like some of its longer
> lines were broken (split) by your mail app (I'm guessing).
> The first split line is marked below.

Sorry but it seems like my e-mail client line-wrapped the patch. Does
the attached patch work better ? The attached patch should be identical
to what I posted except for the line wrapping. I do not see the warnings
mentioned above - maybe these were introduced by the line wrapping ?

Thanks,

Bart.

--------------060900040308090303070304
Content-Type: text/x-patch;
 name="0001-scsi_transport_srp-Fix-kernel-doc-warnings.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-scsi_transport_srp-Fix-kernel-doc-warnings.patch"

>From 6dc06b90bf848ec9bb498495b21c66b168726ef4 Mon Sep 17 00:00:00 2001
From: Bart Van Assche <bvanassche@acm.org>
Date: Sun, 5 Jan 2014 09:55:23 +0100
Subject: [PATCH] scsi_transport_srp: Fix kernel-doc warnings

The following command has been used to verify that the kernel-doc
tool no longer complains about undocumented fields:

scripts/kernel-doc -html drivers/scsi/scsi_transport_srp.c \
  include/scsi/scsi_transport_srp.h >srp-transport-doc.html

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: David Dillow <dillowda@ornl.gov>
Cc: Vu Pham <vu@mellanox.com>
Cc: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Cc: James Bottomley <jbottomley@parallels.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
---
 drivers/scsi/scsi_transport_srp.c | 12 ++++++++++++
 include/scsi/scsi_transport_srp.h | 32 ++++++++++++++++++++++++++++----
 2 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index 2700a5a..96ffc46 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -64,6 +64,9 @@ static inline struct Scsi_Host *rport_to_shost(struct srp_rport *r)
 
 /**
  * srp_tmo_valid() - check timeout combination validity
+ * @reconnect_delay: Reconnect delay in seconds.
+ * @fast_io_fail_tmo: Fast I/O fail timeout in seconds.
+ * @dev_loss_tmo: Device loss timeout in seconds.
  *
  * The combination of the timeout parameters must be such that SCSI commands
  * are finished in a reasonable time. Hence do not allow the fast I/O fail
@@ -368,6 +371,7 @@ invalid:
 
 /**
  * srp_reconnect_work() - reconnect and schedule a new attempt if necessary
+ * @work: Work structure used for scheduling this operation.
  */
 static void srp_reconnect_work(struct work_struct *work)
 {
@@ -408,6 +412,7 @@ static void __rport_fail_io_fast(struct srp_rport *rport)
 
 /**
  * rport_fast_io_fail_timedout() - fast I/O failure timeout handler
+ * @work: Work structure used for scheduling this operation.
  */
 static void rport_fast_io_fail_timedout(struct work_struct *work)
 {
@@ -426,6 +431,7 @@ static void rport_fast_io_fail_timedout(struct work_struct *work)
 
 /**
  * rport_dev_loss_timedout() - device loss timeout handler
+ * @work: Work structure used for scheduling this operation.
  */
 static void rport_dev_loss_timedout(struct work_struct *work)
 {
@@ -488,6 +494,7 @@ static void __srp_start_tl_fail_timers(struct srp_rport *rport)
 
 /**
  * srp_start_tl_fail_timers() - start the transport layer failure timers
+ * @rport: SRP target port.
  *
  * Start the transport layer fast I/O failure and device loss timers. Do not
  * modify a timer that was already started.
@@ -502,6 +509,7 @@ EXPORT_SYMBOL(srp_start_tl_fail_timers);
 
 /**
  * scsi_request_fn_active() - number of kernel threads inside scsi_request_fn()
+ * @shost: SCSI host for which to count the number of scsi_request_fn() callers.
  */
 static int scsi_request_fn_active(struct Scsi_Host *shost)
 {
@@ -522,6 +530,7 @@ static int scsi_request_fn_active(struct Scsi_Host *shost)
 
 /**
  * srp_reconnect_rport() - reconnect to an SRP target port
+ * @rport: SRP target port.
  *
  * Blocks SCSI command queueing before invoking reconnect() such that
  * queuecommand() won't be invoked concurrently with reconnect() from outside
@@ -599,6 +608,7 @@ EXPORT_SYMBOL(srp_reconnect_rport);
 
 /**
  * srp_timed_out() - SRP transport intercept of the SCSI timeout EH
+ * @scmd: SCSI command.
  *
  * If a timeout occurs while an rport is in the blocked state, ask the SCSI
  * EH to continue waiting (BLK_EH_RESET_TIMER). Otherwise let the SCSI core
@@ -674,6 +684,7 @@ static int srp_host_match(struct attribute_container *cont, struct device *dev)
 
 /**
  * srp_rport_get() - increment rport reference count
+ * @rport: SRP target port.
  */
 void srp_rport_get(struct srp_rport *rport)
 {
@@ -683,6 +694,7 @@ EXPORT_SYMBOL(srp_rport_get);
 
 /**
  * srp_rport_put() - decrement rport reference count
+ * @rport: SRP target port.
  */
 void srp_rport_put(struct srp_rport *rport)
 {
diff --git a/include/scsi/scsi_transport_srp.h b/include/scsi/scsi_transport_srp.h
index 4ebf691..69eb021 100644
--- a/include/scsi/scsi_transport_srp.h
+++ b/include/scsi/scsi_transport_srp.h
@@ -29,10 +29,26 @@ enum srp_rport_state {
 };
 
 /**
- * struct srp_rport
- * @lld_data: LLD private data.
- * @mutex:    Protects against concurrent rport reconnect / fast_io_fail /
- *   dev_loss_tmo activity.
+ * struct srp_rport - SRP initiator or target port
+ *
+ * Fields that are relevant for SRP initiator and SRP target drivers:
+ * @dev:               Device associated with this rport.
+ * @port_id:           16-byte port identifier.
+ * @roles:             Role of this port - initiator or target.
+ *
+ * Fields that are only relevant for SRP initiator drivers:
+ * @lld_data:          LLD private data.
+ * @mutex:             Protects against concurrent rport reconnect /
+ *                     fast_io_fail / dev_loss_tmo activity.
+ * @state:             rport state.
+ * @deleted:           Whether or not srp_rport_del() has already been invoked.
+ * @reconnect_delay:   Reconnect delay in seconds.
+ * @failed_reconnects: Number of failed reconnect attempts.
+ * @reconnect_work:    Work structure used for scheduling reconnect attempts.
+ * @fast_io_fail_tmo:  Fast I/O fail timeout in seconds.
+ * @dev_loss_tmo:      Device loss timeout in seconds.
+ * @fast_io_fail_work: Work structure used for scheduling fast I/O fail work.
+ * @dev_loss_work:     Work structure used for scheduling device loss work.
  */
 struct srp_rport {
 	/* for initiator and target drivers */
@@ -60,6 +76,8 @@ struct srp_rport {
 
 /**
  * struct srp_function_template
+ *
+ * Fields that are only relevant for SRP initiator drivers:
  * @has_rport_state: Whether or not to create the state, fast_io_fail_tmo and
  *     dev_loss_tmo sysfs attribute for an rport.
  * @reset_timer_if_blocked: Whether or srp_timed_out() should reset the command
@@ -71,6 +89,11 @@ struct srp_rport {
  *     srp_reconnect_rport().
  * @terminate_rport_io: Callback function for terminating all outstanding I/O
  *     requests for an rport.
+ * @rport_delete: Callback function that deletes an rport.
+ *
+ * Fields that are only relevant for SRP target drivers:
+ * @tsk_mgmt_response: Callback function for sending a task management response.
+ * @it_nexus_response: Callback function for processing an IT nexus response.
  */
 struct srp_function_template {
 	/* for initiator drivers */
@@ -104,6 +127,7 @@ extern void srp_remove_host(struct Scsi_Host *);
 
 /**
  * srp_chkready() - evaluate the transport layer state before I/O
+ * @rport: SRP target port pointer.
  *
  * Returns a SCSI result code that can be returned by the LLD queuecommand()
  * implementation. The role of this function is similar to that of
-- 
1.8.1.4


--------------060900040308090303070304--
