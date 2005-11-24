From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 1/2] libata: Remove dependence on host_set->dev for SAS
Date: Thu, 24 Nov 2005 10:53:33 +1000
Message-ID: <43850F0D.7040907@torque.net>
References: <4341A91A.3020000@us.ibm.com> <434251E0.9060000@pobox.com>	 <58cb370e0510040322q1cb7a13bjfc6c7875140d20a9@mail.gmail.com> <58cb370e0510041356h780e7a5aifda0c232f677471e@mail.gmail.com> <43443E99.4090008@pobox.com> <435D5D83.1060201@us.ibm.com> <435D5DE5.7010306@us.ibm.com> <435E7105.4010105@pobox.com> <435E87E8.9010506@us.ibm.com> <435E8AC7.1080407@pobox.com> <435EB656.1040502@adaptec.com> <4360FAC1.8020409@us.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:50364 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1030550AbVKXAwa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Nov 2005 19:52:30 -0500
In-Reply-To: <4360FAC1.8020409@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, Jeff Garzik <jgarzik@pobox.com>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, t.schorpp@gmx.de

Brian King wrote:
> Luben Tuikov wrote:
> 
>>Would it be a good idea to abstract most of this in
>>say something like 
>>
>>	struct satl_device_struct {
>>		-- data... ;
>>		
>>		/* The registering entity calls this for SATL to translate
>>		   to an ATA task(s) and execute. Filled in by the SATL Layer. */
>>		int (*execute_scsi_task)(struct satl_device_struct *, struct scsi_cmnd *);
>>		
>>		/* SATL layer calls this to send an ata_task to the device.
>>		   Filled in by the registering entity. */
>>		int (*execute_ata_task)(struct satl_device_struct *, struct ata_task *);
>>
>>		-- recovery methods common to SATA-over-anything; filled in by registering
>>			\ entity
>>	};
>>
>>(ata task to be properly constructed: FIS, sg lists, etc.)
>>
>>Then libata-scsi would only have to export two (2) functions:
>>
>>int  satl_register_device(struct satl_device_struct *);
>>void satl_unregister_device(struct satl_device_struct *);
>>
>>EXPORT_SYMBOL_GPL(satl_register_device);
>>EXPORT_SYMBOL_GPL(satl_unregister_device);
> 
> 
> Where would you be calling satl_register_device in your SAS class?
> 
> It looks like this would force libata to be the one to attach the ULD,
> which would also force it to create a separate scsi_host for each
> device, which is something I wanted to avoid. I think you really need a
> libata API that the LLDD can call from its queuecommand function
> to translate and send a command, which then calls back into the LLDD
> to send the FIS to the hardware. This allows for all SAS/SATA devices
> under the same HBA to show up under the same scsi_host.

Brian,
I don't think a SATL is that easy. One SCSI command can
translate into zero or more ATA commands. If it translates
to multiple commands, then there is the possibility of an
error prior to the last in the sequence of ATA commands
(how to report; rollback needed ?). The SATL needs to hold
state and needs a service thread if it is to support the
IMMED bit on some commands (e.g. START STOP UNIT).

libata still has a ways to go to catch up to SAT rev 7
but has made some good progress lately with the addition
of the ATA pass through commands (lk 2.6.15-rc1 and onward).
smartmontools (just prior to 5.34) now works with '-d ata'
on libata-connected SATA disks. The '-d ata' ** overrides
the guess of a SCSI disk based on the device node (e.g.
/dev/sda) and uses the HDIO_DRIVE_CMD and HDIO_DRIVE_TASK
ioctls. The absence of support for the HDIO_DRIVE_TASKFILE
ioctl means that "selective" self-test can't be done.
I'm not sure if moving smartmontools to the ATA PASS THROUGH
SCSI commands will win back the "selective" self-test
capability. Anyway, going to those ATA PASS THROUGH SCSI
commands seems the correct way to go for smartmontools.


** smartmontools has some magic in the device detection
area for 3ware controllers, which amounts to a proprietary
ATA command pass through (plus some device addressing).

Doug Gilbert
