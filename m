From: Mark Hounschell <dmarkh@cfl.rr.com>
Subject: Re: [Bugme-new] [Bug 16058] New: [BUG] Cannot boot any kernel from
 2.6.27 on if a 256 byte sector SCSI disk is attached
Date: Fri, 28 May 2010 07:51:01 -0400
Message-ID: <4BFFAE25.4010007@cfl.rr.com>
References: <Pine.LNX.4.44L0.1005271626320.3239-100000@iolanthe.rowland.org>
Reply-To: dmarkh@cfl.rr.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.121]:40374 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334Ab0E1LvE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 May 2010 07:51:04 -0400
In-Reply-To: <Pine.LNX.4.44L0.1005271626320.3239-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: markh@compro.net, SCSI development list <linux-scsi@vger.kernel.org>, bugzilla-daemon@bugzilla.kernel.org

On 05/27/2010 04:30 PM, Alan Stern wrote:
> On Thu, 27 May 2010, Andrew Morton wrote:
>
>   
>> https://bugzilla.kernel.org/show_bug.cgi?id=16058
>>
>>            Summary: [BUG] Cannot boot any kernel from 2.6.27 on if a 256
>>                     byte sector SCSI disk is attached
>>     
>   
>> As of 2.6.27 if any SCSI disk is attached that has been formatted with a 256
>> byte sector size, the boot process hangs. 512, 768, and 1024 byte sector disks
>> do not seem to trigger this. The disks in use do NOT have a partition table.
>> They are being used by out applications via the sg_io interface only.
>>
>> A 2.6.26.8 kernel works fine. 
>>
>> I have bisected this problem to the following commit:
>>
>> # git bisect good
>> 427e59f09fdba387547106de7bab980b7fff77be is first bad commit
>> commit 427e59f09fdba387547106de7bab980b7fff77be
>> Author: James Bottomley <James.Bottomley@HansenPartnership.com>
>> Date:   Sat Mar 8 18:24:17 2008 -0600
>>
>>     [SCSI] make use of the residue value
>>
>>     USB sometimes doesn't return an error but instead returns a residue
>>     value indicating part (or all) of the command wasn't completed.  So if
>>     the driver _done() error processing indicates the command was fully
>>     processed, subtract off the residue so that this USB error gets
>>     propagated.
>>
>>     Cc: Alan Stern <stern@rowland.harvard.edu>
>>     Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
>>
>> :040000 040000 d3bad84ebe1bc231e8e7d6267907ca62fd4d0dcd
>> c85f8cb8bd4910724f0101e41054555980727e16 M      drivers
>>
>> Now, what USB has to do with my SCSI disks is beyond me. I have a
>> feeling that this commit is just uncovering another problem. I've attached
>> a bootlog from a serial console that ends where the boot hangs.
>>
>> The does the same thing on a 2.6.34 kernel. Anything I can do to help, I'm
>> available.
>>     
> I'd guess that this has nothing to do with the sector size.  Instead
> the drive probably reports a non-zero residue when it shouldn't.  Can
> you add some debugging printk's to the patch to find out in more detail
> what's going wrong?
>
> Alan Stern
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   
Alan,

I've added some printks in scsi.c and aic7xxx_core.c.

A TUR:

ahc_calc_residual: Entered
ahc_calc_residual: return Case 2 sgptr = 0x00000001

ahc_calc_residual: Entered
ahc_calc_residual: return Case 5-1 resid = 0xe
ahc_calc_residual: return Case 5-2 resid = 0xe

scsi_finish_command: Entered for cmd(6):0x00 0x00 0x00 0x00 0x00 0x00
cmd->result = 0x08000002
good_bytes = 0x0
scsi_finish_command: Complete


Another TUR:

scsi_finish_command: Entered for cmd(6):0x00 0x00 0x00 0x00 0x00 0x00
cmd->result = 0x00000000
good_bytes = 0x0
scsi_finish_command: Complete


A Read Capicity:

scsi_finish_command: Entered for cmd(10):0x25 0x00 0x00 0x00 0x00 0x00
0x00 0x00 0x00 0x00
cmd->result = 0x00000000
good_bytes = 0x8
scsi_finish_command: Complete

sd 8:0:0:0: [sde] 7260582 256-byte hardware sectors (1859 MB)


A Mode Sense:

scsi_finish_command: Entered for cmd(6):0x1a 0x00 0x3f 0x00 0x04 0x00
cmd->result = 0x00000000
good_bytes = 0x4
scsi_finish_command: Complete

sd 8:0:0:0: [sde] Write Protect is off


Another Mode Sense:

scsi_finish_command: Entered for cmd(6):0x1a 0x00 0x08 0x00 0x04 0x00
cmd->result = 0x00000000
good_bytes = 0x4
scsi_finish_command: Complete


Another Mode Sense:

ahc_calc_residual: Entered
ahc_calc_residual: return Case 5-1 resid = 0x8
ahc_calc_residual: return Case 5-2 resid = 0x8

scsi_finish_command: Entered for cmd(6):0x1a 0x00 0x08 0x00 0x20 0x00
cmd->result = 0x00000000
good_bytes = 0x20
scsi_finish_command: Complete

sd 8:0:0:0: [sde] Write cache: disabled, read cache: enabled, supports
DPO and FUA


Another TUR:

scsi_finish_command: Entered for cmd(6):0x00 0x00 0x00 0x00 0x00 0x00
cmd->result = 0x00000000
good_bytes = 0x0
scsi_finish_command: Complete


Another Read Capacity:

scsi_finish_command: Entered for cmd(10):0x25 0x00 0x00 0x00 0x00 0x00
0x00 0x00 0x00 0x00
cmd->result = 0x00000000
good_bytes = 0x8
scsi_finish_command: Complete

sd 8:0:0:0: [sde] 7260582 256-byte hardware sectors (1859 MB)


Another Mode Sense:

scsi_finish_command: Entered for cmd(6):0x1a 0x00 0x3f 0x00 0x04 0x00
cmd->result = 0x00000000
good_bytes = 0x4
scsi_finish_command: Complete

sd 8:0:0:0: [sde] Write Protect is off


Another Mode Sense:

scsi_finish_command: Entered for cmd(6):0x1a 0x00 0x08 0x00 0x04 0x00
cmd->result = 0x00000000
good_bytes = 0x4
scsi_finish_command: Complete


Another Mode Sense:

ahc_calc_residual: Entered
ahc_calc_residual: return Case 5-1 resid = 0x8
ahc_calc_residual: return Case 5-2 resid = 0x8

scsi_finish_command: Entered for cmd(6):0x1a 0x00 0x08 0x00 0x20 0x00
cmd->result = 0x00000000
good_bytes = 0x20
scsi_finish_command: Complete

sd 8:0:0:0: [sde] Write cache: disabled, read cache: enabled, supports
DPO and FUA


Another TUR:

scsi_finish_command: Entered for cmd(6):0x00 0x00 0x00 0x00 0x00 0x00
cmd->result = 0x00000000
good_bytes = 0x0
scsi_finish_command: Complete


Another Read Capacity:

scsi_finish_command: Entered for cmd(10):0x25 0x00 0x00 0x00 0x00 0x00
0x00 0x00 0x00 0x00
cmd->result = 0x00000000
good_bytes = 0x8
scsi_finish_command: Complete

sd 8:0:0:0: [sde] 7260582 256-byte hardware sectors (1859 MB)


Another Mode Sense:

scsi_finish_command: Entered for cmd(6):0x1a 0x00 0x3f 0x00 0x04 0x00
cmd->result = 0x00000000
good_bytes = 0x4
scsi_finish_command: Complete

sd 8:0:0:0: [sde] Write Protect is off


Another Mode Sense:

scsi_finish_command: Entered for cmd(6):0x1a 0x00 0x08 0x00 0x04 0x00
cmd->result = 0x00000000
good_bytes = 0x4
scsi_finish_command: Complete


Another Mode Sense:

ahc_calc_residual: Entered
ahc_calc_residual: return Case 5-1 resid = 0x8
ahc_calc_residual: return Case 5-2 resid = 0x8

scsi_finish_command: Entered for cmd(6):0x1a 0x00 0x08 0x00 0x20 0x00
cmd->result = 0x00000000
good_bytes = 0x20
scsi_finish_command: Complete

sd 8:0:0:0: [sde] Write cache: disabled, read cache: enabled, supports
DPO and FUA


First READ(10):

 sde:
ahc_calc_residual: Entered
ahc_calc_residual: return Case 5-1 resid = 0x800
ahc_calc_residual: return Case 5-2 resid = 0x800

scsi_finish_command: Entered for cmd(10):0x28 0x00 0x00 0x00 0x00 0x00
0x00 0x00 0x08 0x00
cmd->result = 0x00000000
good_bytes == old_good_bytes = 0x800  scsi_get_resid(cmd) = 0x800
New good_bytes = 0x0
scsi_finish_command: Complete

>From here it just keeps repeating this read of 8 blocks. (2048 bytes) so
it looks like the machine is hung.

Now, I know for a fact that _if_ this read CDB is actually being sent to
the drive, it's actual residual count will be zero. These are working
disks and that read CDB is valid.

Why is ahc_calc_residual saying that the residual count is as though the
read never took place? I noticed that the first read on all the SATA
drives was for 4096 bytes, why is this one only 2048? Should it have
been 4096 and ahc_calc_residual assume that?

BTW, I'll be in and out all day today so I may not be able to respond
quickly.

One thing all these machines I have doing this, have in common, is the
scsi controller (Aic7xxx).

Regards
Mark
