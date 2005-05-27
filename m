From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH] qla2xxx: fix bad locking during eh_abort
Date: Fri, 27 May 2005 15:04:47 -0700
Message-ID: <20050527220447.GA21593@plap.qlogic.org>
References: <20050526231938.GA31205@plap.qlogic.org> <1117224371.7379.21.camel@mulgrave> <20050527201831.GE16474@plap.qlogic.org> <42978372.9070607@pobox.com> <1117226305.7379.30.camel@mulgrave> <4297862D.5070500@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch02.qlogic.com ([198.70.193.200]:18570 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S262621AbVE0WEt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2005 18:04:49 -0400
Content-Disposition: inline
In-Reply-To: <4297862D.5070500@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 27 May 2005, Jeff Garzik wrote:

> James Bottomley wrote:
> >On Fri, 2005-05-27 at 16:30 -0400, Jeff Garzik wrote:
> >
> >>The ha->hardware_lock is obtained without spin_lock_irq(), so that's 
> >>correct.
> >
> >
> >Yes, that was my confusion
> >
> >But ... I wish you hadn't pointed it out.  Now I look at the driver, the
> >ha->hardware_lock is taken at interrupt level (in the interrupt
> >routines).
> >
> >However, this sequence of code:
> >
> >	spin_unlock_irq(ha->host->host_lock);
> >	spin_lock(&ha->hardware_lock);
> >
> >Enables interrupts then takes this lock.  If we ever get a qla interrupt
> >before we drop the ha->hardware_lock again, that will be a classic
> >deadlock.
> 
> Agreed, this was my analysis as well.
> 
> This driver appears to get locking -backwards-:
> 
> it uses spin_lock_irqsave() in interrupt handler.

Actually, the ISR function is used as a polling function during
hardware initialization.  But since at that point we've never
registered it via request_irq(), it's safe to not use the
_irqsave()/_irqrestore() variants.

> it does not use spin_lock_irqsave() outside interrupt handler.
> 

No, only within EH routines where I dealt (poorly) with the nested
locking...

> IMO this is a 2.6.12-rc issue...

Arrg...  This would essentailly revert a patch I sent last year:

	ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.00.00b14k/18-eh_fixes.patch

which I submitted to 'take care of' these nested spinlock issues.
I'll go through my old emails to look for some 'justification' for the
original patch (and subsequently climb into a dark whole for three
days, when I can't).

--
av



Index: drivers/scsi/qla2xxx/qla_os.c
===================================================================
--- d9be308337b4cca0f0829b0bd62f1d5b830954e1/drivers/scsi/qla2xxx/qla_os.c  (mode:100644)
+++ uncommitted/drivers/scsi/qla2xxx/qla_os.c  (mode:100644)
@@ -507,6 +507,7 @@
 	int ret, i;
 	unsigned int id, lun;
 	unsigned long serial;
+	unsigned long flags;
 
 	if (!CMD_SP(cmd))
 		return FAILED;
@@ -519,7 +520,7 @@
 
 	/* Check active list for command command. */
 	spin_unlock_irq(ha->host->host_lock);
-	spin_lock(&ha->hardware_lock);
+	spin_lock_irqsave(&ha->hardware_lock, flags);
 	for (i = 1; i < MAX_OUTSTANDING_COMMANDS; i++) {
 		sp = ha->outstanding_cmds[i];
 
@@ -534,7 +535,7 @@
 		    sp->state));
 		DEBUG3(qla2x00_print_scsi_cmd(cmd);)
 
-		spin_unlock(&ha->hardware_lock);
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 		if (qla2x00_abort_command(ha, sp)) {
 			DEBUG2(printk("%s(%ld): abort_command "
 			    "mbx failed.\n", __func__, ha->host_no));
@@ -543,20 +544,19 @@
 			    "mbx success.\n", __func__, ha->host_no));
 			ret = SUCCESS;
 		}
-		spin_lock(&ha->hardware_lock);
+		spin_lock_irqsave(&ha->hardware_lock, flags);
 
 		break;
 	}
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	/* Wait for the command to be returned. */
 	if (ret == SUCCESS) {
-		spin_unlock(&ha->hardware_lock);
 		if (qla2x00_eh_wait_on_command(ha, cmd) != QLA_SUCCESS) {
 			qla_printk(KERN_ERR, ha, 
 			    "scsi(%ld:%d:%d): Abort handler timed out -- %lx "
 			    "%x.\n", ha->host_no, id, lun, serial, ret);
 		}
-		spin_lock(&ha->hardware_lock);
 	}
 	spin_lock_irq(ha->host->host_lock);
 
@@ -588,6 +588,7 @@
 	int	status;
 	srb_t		*sp;
 	struct scsi_cmnd *cmd;
+	unsigned long flags;
 
 	status = 0;
 
@@ -596,11 +597,11 @@
 	 * array
 	 */
 	for (cnt = 1; cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
-		spin_lock(&ha->hardware_lock);
+		spin_lock_irqsave(&ha->hardware_lock, flags);
 		sp = ha->outstanding_cmds[cnt];
 		if (sp) {
 			cmd = sp->cmd;
-			spin_unlock(&ha->hardware_lock);
+			spin_unlock_irqrestore(&ha->hardware_lock, flags);
 			if (cmd->device->id == t) {
 				if (!qla2x00_eh_wait_on_command(ha, cmd)) {
 					status = 1;
@@ -608,7 +609,7 @@
 				}
 			}
 		} else {
-			spin_unlock(&ha->hardware_lock);
+			spin_unlock_irqrestore(&ha->hardware_lock, flags);
 		}
 	}
 	return (status);
@@ -740,6 +741,7 @@
 	int	status;
 	srb_t		*sp;
 	struct scsi_cmnd *cmd;
+	unsigned long flags;
 
 	status = 1;
 
@@ -748,17 +750,17 @@
 	 * array
 	 */
 	for (cnt = 1; cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
-		spin_lock(&ha->hardware_lock);
+		spin_lock_irqsave(&ha->hardware_lock, flags);
 		sp = ha->outstanding_cmds[cnt];
 		if (sp) {
 			cmd = sp->cmd;
-			spin_unlock(&ha->hardware_lock);
+			spin_unlock_irqrestore(&ha->hardware_lock, flags);
 			status = qla2x00_eh_wait_on_command(ha, cmd);
 			if (status == 0)
 				break;
 		}
 		else {
-			spin_unlock(&ha->hardware_lock);
+			spin_unlock_irqrestore(&ha->hardware_lock, flags);
 		}
 	}
 	return (status);
