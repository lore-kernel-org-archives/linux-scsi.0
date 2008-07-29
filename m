From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: Poisoning of Linux initiators on SCST reboot.
Date: Tue, 29 Jul 2008 11:19:21 -0700
Message-ID: <20080729181921.GA41607@plap4-2.qlogic.org>
References: <andrew.vasquez@qlogic.com> <200807282040.m6SKeY9Q013406@wind.enjellic.com> <20080729013414.GA38093@n8027av35btxc1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:45647 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbYG2STX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jul 2008 14:19:23 -0400
Content-Disposition: inline
In-Reply-To: <20080729013414.GA38093@n8027av35btxc1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: greg@enjellic.com
Cc: scst-devel@lists.sourceforge.net, linux-driver@qlogic.com, linux-scsi@vger.kernel.org, stf_xl@wp.pl, vst@vlnb.net

On Mon, 28 Jul 2008, Andrew Vasquez wrote:

> On Mon, 28 Jul 2008, greg@enjellic.com wrote:
> 
> ....
> > SCSI host 4 is being used to access the target which is undergoing the
> > reboot test.  PWWN of the target is 210000e08b8665b5.
> > 
> > ---------------------------------------------------------------------------
> > Jul 28 14:39:00 init-test syslogd 1.4.1: restart.
> > Jul 28 14:40:01 init-test crond[4312]: (root) CMD (/usr/lib/sa/sa1 1 1)
> > Jul 28 14:40:49 init-test kernel: QLogic Fibre Channel HBA Driver: 8.02.01-k4-debug
> > Jul 28 14:40:49 init-test kernel: ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 16 (level, low) -> IRQ 16
> > Jul 28 14:40:49 init-test kernel: qla2xxx 0000:04:00.0: Found an ISP2432, irq 16, iobase 0xf8858000
> ...
> 
> These logs are good, I don't have a (formal) fix yet, but I believe
> we've reproduced this locally based on your detailed description and
> logs...  I hope to have some more details tomorrow...

Ok, here's a patch against Linus' latest git tree which corrects the
issue locally.  Could you try it out on your test configuration?  We'd
like to perform some additional sanity-testing locally before we
submit the fix formally for upstream consumption.

Sidenote: we'll also need to backport some form of this fix to stable,
but qla2xxx in kernels upto 2.6.26 didn't utilize the
terminate-rport-io infrastructure:

	commit 5f3a9a207f1fccde476dd31b4c63ead2967d934f
	Refs: v2.6.26-7259-g5f3a9a2
	Author:     Seokmann Ju <seokmann.ju@qlogic.com>
	AuthorDate: Thu Jul 10 16:55:47 2008 -0700
	Commit:     James Bottomley <James.Bottomley@HansenPartnership.com>
	CommitDate: Sat Jul 26 15:14:36 2008 -0400

	    [SCSI] qla2xxx: Add dev_loss_tmo_callbk/terminate_rport_io callback support.

	    Signed-off-by: Seokmann Ju <seokmann.ju@qlogic.com>
	    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
	    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

so the stable changes won't be as 'straight-forward'...

In any case, here's the patch...

thanks, av

---

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 2e2bf53..690a4ef 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1082,6 +1082,17 @@ qla2x00_terminate_rport_io(struct fc_rport *rport)
 {
 	fc_port_t *fcport = *(fc_port_t **)rport->dd_data;
 
+	/*
+	 * At this point all fcport's software-states are cleared.  Perform any
+	 * final firmware cleanup of resources (PCBs and XCBs).
+	 */
+	if (fcport->loop_id != FC_NO_LOOP_ID) {
+		fcport->ha->isp_ops->fabric_logout(fcport->ha, fcport->loop_id,
+		    fcport->d_id.b.domain, fcport->d_id.b.area,
+		    fcport->d_id.b.al_pa);
+		fcport->loop_id = FC_NO_LOOP_ID;
+	}
+
 	qla2x00_abort_fcport_cmds(fcport);
 	scsi_target_unblock(&rport->dev);
 }
