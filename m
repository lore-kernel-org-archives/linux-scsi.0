From: merlin <merlin@merlin.org>
Subject: Re: possible use-after-free in 2.5.44 scsi changes
Date: Thu, 31 Oct 2002 12:41:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021031174110.5217B86E7D@primary.mx.nitric.com>
References: <20021031151212.GG6549@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
In-reply-to: <20021031151212.GG6549@suse.de> 
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Badari Pulavarty <badari@us.ibm.com>, linux-scsi@vger.kernel.org

r/axboe@suse.de/2002.10.31/16:12:12
>On Thu, Oct 31 2002, Jens Axboe wrote:
>> On Wed, Oct 30 2002, Badari Pulavarty wrote:
>> > > >- Badari
>> > > 
>> > > Hi; if it's of any use, the patch doesn't seem to solve the scsi
>> > > problem for me (2.5.44-bk3-badari). I get the usual 'Incorrect number
>> > > of segments...' and random kernel death during the boot process.
>> > > 
>> > > Merlin
>> > 
>> > Hi Merlin,
>> > 
>> > I am looking at the output  of your problem ..
>> > 
>> > 
>> > Oct 28 12:36:09 badb kernel: Incorrect number of segments after building l
>ist 
>> > Oct 28 12:36:09 badb kernel: counted 2, received 1 
>> > Oct 28 12:36:09 badb kernel: req nr_sec 8, cur_nr_sec 8 
>> > Oct 28 12:36:09 badb kernel: end_request: I/O error, dev 08:40, sector 678
>4528 
>> > Oct 28 12:36:09 badb kernel: raid5: Disk failure on scsi/host0/bus0/target
>4/lun0/part7, disabling device. Operation continuing on 4 devices 
>> > 
>> > Huh !! Your IO size is only 4K. You are using 2 sg entries ?
>> 
>> Even weirder, nr_sec == cur_nr_sec so there can only be one segment or
>> something is corrupted...
>
>Ah wait, I think I may know at least what is happening in this case.
>I've seen numerous reports of software raid problems botching bio's, and
>this above one could easily be explained with one of the bio's having
>!bi_size. In fact, it's about the only explanation, otherwise there's
>just no way we can have nr_sec == cur_nr_sec unless only _one_ bio is
>attached to the request.
>
>Merlin, please also add a
>
>	blk_dump_rq_flags(req, "scsi_init_io");
>
>to drivers/scsi/scsi_lib.c:scsi_init_io() before it calls
>scsi_end_request() and kills the request (right after the incorrect
>segment complaining).

Hi Jens,

Disabling clustering in the aic7xxx driver results in blk: request
botched, NULL dereference, panic (but no segment count complaint).

Booting with the nosmp flag results in strange aic7xxx (I believe)
death really early on.

I have tried no earlier 2.5 kernels on the machine.

For peace of mind, I switched 2.5.45 to root from an old
non--s/w-RAID drive in the machine. syslog goes to a working
root, and it lets me bring up the raid devices manually.

Kernel 2.5.45 WITH your ll_rw_blk.c patch, WITHOUT Badari's
VIRT_MERGEABLE patch, WITHOUT disabling aic7xxx clustering,
WITH this extra logging..

I can boot successfully (well, no keyboard and lots if init
garbage. but no crash) which suggests strongly that it is an
md problem. The drive is on a different controller, but I
doubt that's relevant; it's still an aic7xxx.

I could then bring up md0 (RAID 1 across two disks) and do a
basic scan (zcav) through it without problems. I didn't stress
things (typing on a zaurus isn't easy enough) but it seemed
okay.

Then I brought up md3 (RAID 5 across five disks) and ran zcav
across it. Worked for a while, then:

--8<--
Oct 31 12:00:57 badb kernel: (scsi0:A:2:0): data overrun detected in Data-in phase.  Tag == 0x6.
Oct 31 12:00:57 badb kernel: (scsi0:A:2:0): Have seen Data Phase.  Length = 8192.  NumSGs = 2.
Oct 31 12:00:57 badb kernel: sg[0] - Addr 0x037a2c000 : Length 4096
Oct 31 12:00:57 badb kernel: sg[1] - Addr 0x037a31000 : Length 4096
Oct 31 12:01:27 badb kernel: scsi0:0:4:0: Attempting to queue an ABORT message
Oct 31 12:01:27 badb kernel: scsi0: Dumping Card State in Data-in phase, at SEQADDR 0x168
Oct 31 12:01:27 badb kernel: ACCUM = 0x0, SINDEX = 0x91, DINDEX = 0xe4, ARG_2 = 0x1
Oct 31 12:01:27 badb kernel: HCNT = 0x0
Oct 31 12:01:27 badb kernel: SCSISEQ = 0x12, SBLKCTL = 0xa
Oct 31 12:01:27 badb kernel:  DFCNTRL = 0x0, DFSTATUS = 0x89
Oct 31 12:01:27 badb kernel: LASTPHASE = 0x40, SCSISIGI = 0x46, SXFRCTL0 = 0x88
Oct 31 12:01:27 badb kernel: SSTAT0 = 0x2, SSTAT1 = 0x0
Oct 31 12:01:27 badb kernel: SCSIPHASE = 0x0
Oct 31 12:01:27 badb kernel: STACK == 0x63, 0x160, 0x0, 0x34
Oct 31 12:01:27 badb kernel: SCB count = 8
Oct 31 12:01:27 badb kernel: Kernel NEXTQSCB = 0
Oct 31 12:01:27 badb kernel: Card NEXTQSCB = 7
Oct 31 12:01:27 badb kernel: QINFIFO entries: 7 1 3
Oct 31 12:01:27 badb kernel: Waiting Queue entries:
Oct 31 12:01:27 badb kernel: Disconnected Queue entries:
Oct 31 12:01:27 badb kernel: QOUTFIFO entries:
Oct 31 12:01:27 badb kernel: Sequencer Free SCB List: 0 1 2 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
Oct 31 12:01:27 badb kernel: Pending list: 3, 1, 7, 6
Oct 31 12:01:27 badb kernel: Kernel Free SCB list: 2 5 4
Oct 31 12:01:27 badb kernel: DevQ(0:0:0): 0 waiting
Oct 31 12:01:27 badb kernel: DevQ(0:1:0): 0 waiting
Oct 31 12:01:27 badb kernel: DevQ(0:2:0): 0 waiting
Oct 31 12:01:27 badb kernel: DevQ(0:3:0): 0 waiting
Oct 31 12:01:27 badb kernel: DevQ(0:4:0): 0 waiting
Oct 31 12:01:27 badb kernel: scsi0:0:4:0: Cmd aborted from QINFIFO
Oct 31 12:01:27 badb kernel: aic7xxx_abort returns 0x2002
Oct 31 12:01:37 badb kernel: scsi0:0:4:0: Attempting to queue an ABORT message
Oct 31 12:01:37 badb kernel: scsi0: Dumping Card State in Data-in phase, at SEQADDR 0x168
Oct 31 12:01:37 badb kernel: ACCUM = 0x0, SINDEX = 0x91, DINDEX = 0xe4, ARG_2 = 0x1
Oct 31 12:01:37 badb kernel: HCNT = 0x0
Oct 31 12:01:37 badb kernel: SCSISEQ = 0x12, SBLKCTL = 0xa
Oct 31 12:01:37 badb kernel:  DFCNTRL = 0x0, DFSTATUS = 0x89
Oct 31 12:01:37 badb kernel: LASTPHASE = 0x40, SCSISIGI = 0x46, SXFRCTL0 = 0x88
Oct 31 12:01:37 badb kernel: SSTAT0 = 0x2, SSTAT1 = 0x0
Oct 31 12:01:37 badb kernel: SCSIPHASE = 0x0
Oct 31 12:01:37 badb kernel: STACK == 0x63, 0x160, 0x0, 0x34
Oct 31 12:01:37 badb kernel: SCB count = 8
Oct 31 12:01:37 badb kernel: Kernel NEXTQSCB = 3
Oct 31 12:01:37 badb kernel: Card NEXTQSCB = 0
Oct 31 12:01:37 badb kernel: QINFIFO entries: 0 1 7
Oct 31 12:01:37 badb kernel: Waiting Queue entries:
Oct 31 12:01:37 badb kernel: Disconnected Queue entries:
Oct 31 12:01:37 badb kernel: QOUTFIFO entries:
Oct 31 12:01:37 badb kernel: Sequencer Free SCB List: 0 1 2 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
Oct 31 12:01:37 badb kernel: Pending list: 7, 1, 0, 6
Oct 31 12:01:37 badb kernel: Kernel Free SCB list: 2 5 4
Oct 31 12:01:37 badb kernel: DevQ(0:0:0): 0 waiting
Oct 31 12:01:37 badb kernel: DevQ(0:1:0): 0 waiting
Oct 31 12:01:37 badb kernel: DevQ(0:2:0): 0 waiting
Oct 31 12:01:37 badb kernel: DevQ(0:3:0): 0 waiting
Oct 31 12:01:37 badb kernel: DevQ(0:4:0): 0 waiting
Oct 31 12:01:37 badb kernel: scsi0:0:4:0: Cmd aborted from QINFIFO
Oct 31 12:01:37 badb kernel: aic7xxx_abort returns 0x2002
Oct 31 12:01:37 badb kernel: scsi0:0:3:0: Attempting to queue an ABORT message
Oct 31 12:01:37 badb kernel: scsi0: Dumping Card State in Data-in phase, at SEQADDR 0x168
Oct 31 12:01:37 badb kernel: ACCUM = 0x0, SINDEX = 0x91, DINDEX = 0xe4, ARG_2 = 0x1
Oct 31 12:01:37 badb kernel: HCNT = 0x0
Oct 31 12:01:37 badb kernel: SCSISEQ = 0x12, SBLKCTL = 0xa
Oct 31 12:01:37 badb kernel:  DFCNTRL = 0x0, DFSTATUS = 0x89
Oct 31 12:01:37 badb kernel: LASTPHASE = 0x40, SCSISIGI = 0x46, SXFRCTL0 = 0x88
Oct 31 12:01:37 badb kernel: SSTAT0 = 0x2, SSTAT1 = 0x0
Oct 31 12:01:37 badb kernel: SCSIPHASE = 0x0
Oct 31 12:01:37 badb kernel: STACK == 0x63, 0x160, 0x0, 0x34
Oct 31 12:01:37 badb kernel: SCB count = 8
Oct 31 12:01:37 badb kernel: Kernel NEXTQSCB = 0
Oct 31 12:01:37 badb kernel: Card NEXTQSCB = 3
Oct 31 12:01:37 badb kernel: QINFIFO entries: 3 1
Oct 31 12:01:37 badb kernel: Waiting Queue entries:
Oct 31 12:01:37 badb kernel: Disconnected Queue entries:
Oct 31 12:01:37 badb kernel: QOUTFIFO entries:
Oct 31 12:01:37 badb kernel: Sequencer Free SCB List: 0 1 2 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
Oct 31 12:01:37 badb kernel: Pending list: 1, 3, 6
Oct 31 12:01:37 badb kernel: Kernel Free SCB list: 7 2 5 4
Oct 31 12:01:37 badb kernel: DevQ(0:0:0): 0 waiting
Oct 31 12:01:37 badb kernel: DevQ(0:1:0): 0 waiting
Oct 31 12:01:37 badb kernel: DevQ(0:2:0): 0 waiting
Oct 31 12:01:37 badb kernel: DevQ(0:3:0): 0 waiting
Oct 31 12:01:37 badb kernel: DevQ(0:4:0): 0 waiting
Oct 31 12:01:37 badb kernel: scsi0:0:3:0: Cmd aborted from QINFIFO
Oct 31 12:01:37 badb kernel: aic7xxx_abort returns 0x2002
... panic (not logged)
-->8--

I'll reboot again, when people are off this machine, with
the raid devices mounted at boot time, to see if I can get
the segment error and that blk_dump_rq_flags stuff.

merlin

>Badari, I'm not so sure that Merlin's and your bug are the same. Is
>yours solved by the patch I sent out earlier? AFAICT, that should fix
>the segment miscounting.
>
>-- 
>Jens Axboe
