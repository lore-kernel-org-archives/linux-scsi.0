From: Thomas Fjellstrom <tfjellstrom@strangesoft.net>
Subject: Re: burning small isos repeatedly failing with hangcheck error
Date: Wed, 12 May 2010 19:19:23 -0600
Message-ID: <201005121919.24115.tfjellstrom@strangesoft.net>
References: <201004261855.29335.tfjellstrom@strangesoft.net> <201005101852.43114.tfjellstrom@strangesoft.net> <4BEB5132.6060201@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4BEB5132.6060201@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Robert Hancock <hancockrwd@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On May 12, 2010, Robert Hancock wrote:
> On 05/10/2010 06:52 PM, Thomas Fjellstrom wrote:
> > On May 10, 2010, Robert Hancock wrote:
> >> On 05/10/2010 05:50 PM, Thomas Fjellstrom wrote:
> >>> On May 10, 2010, Andrew Morton wrote:
> >>>> (lotsa cc's added)
> >>>> 
> >>>> On Mon, 26 Apr 2010 18:55:28 -0600
> >>>> 
> >>>> Thomas Fjellstrom<tfjellstrom@strangesoft.net>   wrote:
> >>>>> I'm having problems burning a small iso image to a DVDR,
> >>>>> every single attempt leads to the following type of errors:
> >>>>> 
> >>>>> [  192.190114] cdrom: This disc doesn't have any tracks I
> >>>>> recognize! [  192.220213] sr 1:0:0:0: [sr0] Result:
> >>>>> hostbyte=DID_OK
> >>>>> driverbyte=DRIVER_SENSE [  192.220217] sr 1:0:0:0: [sr0] Sense Key
> >>>>> : Illegal Request [current] [  192.220220] Info fld=0x0
> >>>>> [  192.220221] sr 1:0:0:0: [sr0] Add. Sense: Logical block address
> >>>>> out of range [  192.220231] sr 1:0:0:0: [sr0] CDB: Read(10): 28 00
> >>>>> 00 00 00 00 00 00 01 00 [  192.220242] end_request: I/O error, dev
> >>>>> sr0, sector 0
> >>>>> [  192.220246] Buffer I/O error on device sr0, logical block 0
> >>>>> [  192.222931] sr 1:0:0:0: [sr0] Result: hostbyte=DID_OK
> >>>>> driverbyte=DRIVER_SENSE [  192.222934] sr 1:0:0:0: [sr0] Sense Key
> >>>>> : Illegal Request [current] [  192.222936] Info fld=0x0
> >>>>> [  192.222938] sr 1:0:0:0: [sr0] Add. Sense: Logical block address
> >>>>> out of range [  192.222940] sr 1:0:0:0: [sr0] CDB: Read(10): 28 00
> >>>>> 00 00 00 00 00 00 01 00 [  192.222946] end_request: I/O error, dev
> >>>>> sr0, sector 0
> >>>>> [  192.222948] Buffer I/O error on device sr0, logical block 0
> >>>>> [  600.489102] INFO: task wodim:3587 blocked for more than 120
> >>>>> seconds. [  600.489106] "echo 0>
> >>>>> /proc/sys/kernel/hung_task_timeout_secs" disables this message. [
> >>>>> 600.489107] wodim         D ffff880005515680
> >>>>> 
> >>>>>       0  3587   2994 0x00000000 [  600.489111]  ffff88011ad80700
> >>>>> 
> >>>>> 0000000000000082 0000000000000000 ffff88013b7700d0 [  600.489115]
> >>>>> ffff88013b771e50 000000000000f8e0 ffff880078d6dfd8 0000000000015680
> >>>>> [ 600.489118]  0000000000015680 ffff8800a891e200 ffff8800a891e4f0
> >>>>> 000000013b771e50 [  600.489121] Call Trace:
> >>>>> [  600.489147]  [<ffffffffa00e10d7>] ? atapi_xlat+0x0/0x125
> >>>>> [libata] [  600.489153]  [<ffffffffa00998cc>] ? scsi_done+0x0/0xc
> >>>>> [scsi_mod] [  600.489160]  [<ffffffffa00e18d8>] ?
> >>>>> __ata_scsi_queuecmd+0x185/0x1dc [libata] [  600.489170]
> >>>>> [<ffffffff812ed4cb>] ?
> >>>>> schedule_timeout+0x2e/0xdd [  600.489174]  [<ffffffff81171918>] ?
> >>>>> blk_peek_request+0x18b/0x19f [  600.489179]  [<ffffffffa0099bb0>] ?
> >>>>> scsi_dispatch_cmd+0x1d2/0x23f [scsi_mod] [  600.489185]
> >>>>> [<ffffffffa009f4ab>] ? scsi_request_fn+0x429/0x506 [scsi_mod] [
> >>>>> 600.489187]  [<ffffffff812ed366>] ? wait_for_common+0xde/0x15b [
> >>>>> 600.489191]  [<ffffffff81042cc2>] ? default_wake_function+0x0/0x9 [
> >>>>> 600.489194]  [<ffffffff8117556c>] ? blk_execute_rq+0x9c/0xcc [
> >>>>> 600.489197]  [<ffffffff81171418>] ? __freed_request+0x26/0x83 [
> >>>>> 600.489199]  [<ffffffff81171498>] ? freed_request+0x23/0x43 [
> >>>>> 600.489202]  [<ffffffff8104f5ce>] ? capable+0x22/0x41
> >>>>> [  600.489204]  [<ffffffff81178824>] ? sg_io+0x26e/0x396
> >>>>> [  600.489207]  [<ffffffff81178e59>] ? scsi_cmd_ioctl+0x217/0x3fe
> >>>>> [  600.489210]  [<ffffffff811806a6>] ? cpumask_next_and+0x2a/0x3a
> >>>>> [  600.489213]  [<ffffffff81038ba4>] ? update_curr+0xa6/0x147
> >>>>> [  600.489218]  [<ffffffffa014dfd2>] ? cdrom_ioctl+0x42/0xef7
> >>>>> [cdrom] [  600.489222]  [<ffffffff8100f76f>] ? sched_clock+0x5/0x8
> >>>>> [  600.489224]  [<ffffffff81063b8f>] ? sched_clock_local+0x13/0x74
> >>>>> [  600.489227]  [<ffffffff81042cb5>] ? try_to_wake_up+0x248/0x255
> >>>>> [  600.489230]  [<ffffffff810f7bc4>] ? pollwake+0x53/0x5b
> >>>>> [  600.489233]  [<ffffffff8104b129>] ? current_fs_time+0x1e/0x24
> >>>>> [  600.489235]  [<ffffffff81042cc2>] ?
> >>>>> default_wake_function+0x0/0x9 [  600.489239]  [<ffffffffa016f33c>]
> >>>>> ? sr_block_ioctl+0x49/0x85 [sr_mod] [  600.489242] 
> >>>>> [<ffffffff81176738>] ?
> >>>>> __blkdev_driver_ioctl+0x7c/0xa4 [  600.489245] 
> >>>>> [<ffffffff81177005>] ? blkdev_ioctl+0x880/0x8d3 [  600.489247] 
> >>>>> [<ffffffff812ed0d9>] ? schedule+0x7f6/0x875
> >>>>> [  600.489250]  [<ffffffff810e9b69>] ? do_sync_write+0xab/0xed
> >>>>> [  600.489254]  [<ffffffff8110c8d5>] ? block_ioctl+0x38/0x3c
> >>>>> [  600.489257]  [<ffffffff810f5923>] ? vfs_ioctl+0x21/0x92
> >>>>> [  600.489259]  [<ffffffff810f5e9f>] ? do_vfs_ioctl+0x495/0x4d3
> >>>>> [  600.489262]  [<ffffffff810ea4b5>] ? vfs_write+0xcd/0x102
> >>>>> [  600.489264]  [<ffffffff810f5f2e>] ? sys_ioctl+0x51/0x70
> >>>>> [  600.489267]  [<ffffffff81008ac2>] ?
> >>>>> system_call_fastpath+0x16/0x1b [  640.816056] ata2.00: exception
> >>>>> Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen [  640.816061] sr
> >>>>> 1:0:0:0: [sr0] CDB: Synchronize Cache(10): 35 00 00 00 00 00 00 00
> >>>>> 00 00 [  640.816070] ata2.00: cmd
> >>>>> a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0 [  640.816071]         
> >>>>> res 40/00:03:00:00:f8/00:00:00:00:00/a0 Emask 0x4 (timeout) [
> >>>>> 640.816073] ata2.00: status: { DRDY }
> >>>>> [  640.816078] ata2: hard resetting link
> >>>>> [  641.137050] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl
> >>>>> 300) [  641.141821] ata2.00: ACPI cmd ef/10:06:00:00:00:a0 (SET
> >>>>> FEATURES) succeeded [  641.141824] ata2.00: ACPI cmd
> >>>>> ef/10:03:00:00:00:a0 (SET FEATURES) filtered out [  641.151672]
> >>>>> ata2.00: ACPI cmd
> >>>>> ef/10:06:00:00:00:a0 (SET FEATURES) succeeded [  641.151675]
> >>>>> ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
> >>>>> [ 641.155383] ata2.00: configured for UDMA/133
> >>>>> [  641.160639] ata2: EH complete
> >>>>> 
> >>>>> What can I do to fix this problem?
> >>>>> 
> >>>>> The machine is a Lenovo SL500 laptop, w 2.53ghz core2duo, 4G ram,
> >>>>> kernel 2.6.33-2-amd64 from debian sid (also happens with 2.6.32-5
> >>>>> from sid)
> >>>> 
> >>>> You appear to have hit several problems here.  The initial IO error
> >>>> is one.  The 440-second sulk is another.
> >>>> 
> >>>> Does wodim _ever_ terminate, or is a reboot required after this has
> >>>> happened?
> >>> 
> >>> It eventually errors out, and claims it failed to "fixate" the disk.
> >>> takes a couple minutes at least to do so.
> >>> 
> >>>> Are you able to determine whether the hardware is OK?  Does it burn
> >>>> OK with other versions of Linux, or other OS'es?
> >>> 
> >>> It works fine normally. It seems it was some /strange/ iso files that
> >>> I was burning. They apparently have invalid RockRidge extensions,
> >>> which seems to confuse the heck out of wodim or the drive some how.
> >> 
> >> The drive shouldn't care about the image contents, and neither should
> >> wodim if it's just burning an ISO file. What's the image size? I think
> >> that DVD-R has some restrictions on minimum burned radius on the disc,
> >> and if you burn a very small image then the drive has to burn a bunch
> >> more at the end to comply with that. It could be that this is why it's
> >> taking so long, and maybe the timeout wodim is using on that command
> >> doesn't account for that. DVD+R doesn't have that problem, I believe.
> >> 
> >> In that case I don't think there's a kernel problem here, except for
> >> the task blocked warning. Not sure what the best solution to that is,
> >> seeing as the command is genuinely taking more than 2 minutes to
> >> complete..
> > 
> > I've burned small images before without this happening.
> > I've tested on two different machines, and the same thing happens
> > with these specific ISOs on both.
> > 
> > Just tried a different small iso, and I get the following errors:
> > 
> > [313812.805048] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action
> > 0x6 frozen [313812.805053] sr 1:0:0:0: [sr0] CDB: Synchronize
> > Cache(10): 35 00 00 00 00 00 00 00 00 00 [313812.805063] ata2.00: cmd
> > a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0 [313812.805064]          res
> > 40/00:03:00:00:f8/00:00:00:00:00/a0 Emask 0x4 (timeout)
> > [313812.805067] ata2.00: status: { DRDY }
> > [313812.805072] ata2: hard resetting link
> > [313813.125050] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> > [313813.129685] ata2.00: ACPI cmd ef/10:06:00:00:00:a0 (SET FEATURES)
> > succeeded [313813.129689] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET
> > FEATURES) filtered out [313813.139531] ata2.00: ACPI cmd
> > ef/10:06:00:00:00:a0 (SET FEATURES) succeeded [313813.139534] ata2.00:
> > ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
> > [313813.143436] ata2.00: configured for UDMA/133
> > [313813.148831] ata2: EH complete
> > 
> > wodim times out as well.
> > 
> > I do not recall having these issues with older kernels.
> 
> Same wodim version? The commands (and ordering thereof) it is issuing
> could have an effect on this..

I can't be certain that its the same version of wodim. I have often noticed 
that it takes far longer to burn a small iso onto a DVDR than you'd 
intuitively think it would, but I've never had this timeout error happen 
prior to 2.6.33, not that that means the problem started with 2.6.33, I 
can't recall how long its been since I last had to burn a really small iso 
to a DVDR.

I can try and test various versions of the kernel and wodim, if you think it 
would help.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Thomas Fjellstrom
tfjellstrom@strangesoft.net
