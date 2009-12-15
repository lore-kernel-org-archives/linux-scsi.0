From: "Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL Tech"
	<satyasrinivasp@hcl.in>
Subject: mvsas:Issues with write and erase of SATA DVD ROM
Date: Tue, 15 Dec 2009 19:32:53 +0530
Message-ID: <6B62480106F2B34D8404CF2FDAA4D9EF5C783A59A4@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
References: <6B62480106F2B34D8404CF2FDAA4D9EF52C9F9B792@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gws07.mail.hcl.in ([203.105.186.27]:59119 "EHLO gws07.hcl.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760255AbZLOODH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2009 09:03:07 -0500
In-Reply-To: <6B62480106F2B34D8404CF2FDAA4D9EF52C9F9B792@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "ayan@marvell.com" <ayan@marvell.com>, "kewei@marvell.com" <kewei@marvell.com>
Cc: "jack_wang@usish.com" <jack_wang@usish.com>, "tom_peng@usish.com" <tom_peng@usish.com>

Hi all,

Could you please provide me some inputs on below issues?

--Srini.

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL Tech
Sent: Friday, December 11, 2009 8:28 PM
To: linux-scsi@vger.kernel.org; ayan@marvell.com; kewei@marvell.com
Subject: mvsas:Issues with write and erase of SATA DVD ROM

Hi,
I am facing an issue with write and erase of SATA DVD ROM.

HW DETAILS:
-----------
linux-sles: # cat /proc/scsi/scsi
Attached devices:
Host: scsi9 Channel: 00 Id: 01 Lun: 00
  Vendor: TSSTcorp Model: CDDVDW SH-S203D Rev: SB00
  Type:   CD-ROM ANSI SCSI revision: 05

Linux-sles: ~ # cdrecord --scanbus
scsibus9:
        9, 0, 0 900) 'TSSTcorp' 'CDDVDW SH-S203D ' 'SB00' Removable CD-ROM

ANALYSIS for erase Issue:
-------------------------
Linux-sles11:~ # cdrecord --dev=x,x,x -blank all
Timeout happened after issuing the above operation to target and LLD is initiating Abort-TMF.
Here is my analysis and solution for the same.
If we issue "blank command" to CDROM, the processing of that request will take some time to complete, mean while my timer has expired and issuing abort-task TMF.  So to avoid this situation set IMMED bit 1 in "blank command" then send to it target.
Reference from mmc4:
6.2.2.2 IMMED
If IMMED is zero, then the requested operation is processed to completion prior to returning status. If
IMMED is one, then status is returned once the operation has begun.

FIX:
....
mv_sas.c:
static int mvs_task_prep_ata(struct asc_info *asi,
       struct asc_task_exec_info *tei)
{       ...
        if (dev->sata_dev.command_set == ATAPI_COMMAND_SET) {
        ...
            if (task->ata_task.atapi_packet[0] == 0xa1) {/*a1 blank command */
                        task->ata_task.atapi_packet[1] = 0x10;
                }
      ...}
}
ANALYSIS for write issue:
-------------------------
linux-sles11:~ # cdrecord --dev=x,x,x -dao *.iso
After issuing above operation to target, receiving "reserved error" from target for one of the write command.
Dmesg:
------
mv_task_prep_ata:719:task[f52da6c0] cdb0[2a]:cdb1[0]:cdb2[0]
mv_slot_complete:2007:task[f52da6c0] rx_desc[30000]
mvsas:asc_slot_err:1845:err_dw0[80400002]
mv_sas.c 1883:find reserved error, why?
sas: command 0xf5e40bc0, task 0xf5934d00, timed out: BLK_EH_NOT_HANDLED

Here is the error location:
mv_sas.c:
static int asc_slot_err(struct asc_info *asi, struct sas_task *task,
                         u32 slot_idx)
{       ...
        if (err_dw0 == 0x80400002) {
                mv_printk("find reserved error, why?\n");
      }...
}
I don't know why we are receiving "reserved error" and how to respond to this error?
Any inputs are highly appreciated.

Thanks
Srinivas.


DISCLAIMER:
-----------------------------------------------------------------------------------------------------------------------

The contents of this e-mail and any attachment(s) are confidential and intended for the named recipient(s) only. 
It shall not attach any liability on the originator or HCL or its affiliates. Any views or opinions presented in 
this email are solely those of the author and may not necessarily reflect the opinions of HCL or its affiliates. 
Any form of reproduction, dissemination, copying, disclosure, modification, distribution and / or publication of 
this message without the prior written consent of the author of this e-mail is strictly prohibited. If you have 
received this email in error please delete it and notify the sender immediately. Before opening any mail and 
attachments please check them for viruses and defect.

-----------------------------------------------------------------------------------------------------------------------
