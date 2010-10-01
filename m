From: Hannes Reinecke <hare@suse.de>
Subject: qla2xx command abort regression
Date: Fri, 01 Oct 2010 12:33:43 +0200
Message-ID: <4CA5B907.5050102@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41531 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755078Ab0JAKdp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Oct 2010 06:33:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi Andrew,

there is a regression in the qla2xxx driver, introduced by this commit:

commit 083a469db4ecf3b286a96b5b722c37fc1affe0be
Author: Giridhar Malavali <giridhar.malavali@qlogic.com>
Date:   Fri May 28 15:08:18 2010 -0700

    [SCSI] qla2xxx: Correct use-after-free oops seen during EH-abort.

    Hold a reference to the srb (sp) while aborting an I/O -- as the
    I/O can/will complete from within the interrupt-context.

    Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
    Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
    Signed-off-by: James Bottomley <James.Bottomley@suse.de>

With this patch a reference counting is introduced for srb's.
However, there is this code in qla2xxx_eh_abort():

	spin_unlock_irqrestore(&ha->hardware_lock, flags);

	/* Wait for the command to be returned. */
	if (wait) {
		if (qla2x00_eh_wait_on_command(cmd) !=3D QLA_SUCCESS) {
			qla_printk(KERN_ERR, ha,
			    "scsi(%ld:%d:%d): Abort handler timed out -- %lx "
			    "%x.\n", vha->host_no, id, lun, serial, ret);
			ret =3D FAILED;
		}
	}

	if (got_ref)
		qla2x00_sp_compl(ha, sp);


where qla2x00_eh_wait_on_command() is waiting for a command to be
completed by the midlayer. Which will never happen, as the refcount
is held during that time and only released on the last lines.
Hence any command abort will be timed out and the error will be
escalated further.

I have fixed it by simply moving the last two lines above the
'if (wait)' condition. however I fail to see the race condition
mentioned, and hence the validity of the reference counting in the
first place.
So it might be that I'm missing something subtle here, so I would
ask you to have a look here.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
