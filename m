From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] SAM-3 status codes
Date: Mon, 27 Jan 2003 21:36:12 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E350B9C.4020203@torque.net>
References: <Pine.LNX.4.10.10301230007110.20139-100000@master.linux-ide.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Andre Hedrick <andre@linux-ide.org>
Cc: Jens Axboe <axboe@suse.de>, linux-scsi@vger.kernel.org

Andre Hedrick wrote:
> Jens,
> 
> One of the problems is chasing down all the  variations of SAM and pre
> SAM.  I do not know, and maybe Doug can help, but did bit0 become
> obsoleted in the age of SASI's transformation to SCSI ?

In SCSI-2 bits 0, 6 and 7 of the status byte were
reserved for the _implementation_. Not sure if any SCSI
devices every used them because that would make this
code:
    if (status == SCSI_CHECK_CONDITION) ....
problematic. [It should be:
    if (status & SCSI_CHECK_CONDITION)  ...
which also correctly picks up COMMAND_TERMINATED but you
don't see code like that very often.]
BTW There is a '#define SCSI_MASK 0x3e' in
the scsi.h header allowing:
    if ((status & SCSI_MASK) == SCSI_CHECK_CONDITION)  ...

In SCSI 3 (or later) bits 0 and 7 are reserved (period) and
bit 6 is in use. The masking that was (strictly speaking) required
in SCSI-2 seems to be no longer required.

> I can not find anything about it, and my knowledge in the history of SCSI
> is vastly weaker then ATA during the X3 split.
> 
> The naming issue is what stopped me in the process of working on a
> bus-phase rewrite to convert scsi to a logical state machine.  Dealing
> with all the issues related to the HBA's was more than any mad man could
> attempt, much less a sane one.
> 
> Comments on fixing 2.5 to use proper status values?

Well, the only problem is that CHECK_CONDITION in
/usr/src/linux/include/scsi/scsi.h is visible to
the user space (and is replicated in RH8.0's
/usr/include/scsi/scsi.h by the glibc people).
It would be surprising if Joerg Schilling (cdrecord)
used it but I should check SANE and a few other long
term sg users. scsiinfo + sg(3)_utils don't use it.

If we don't cause user space pain and we can change
the kernel code that uses CHECK_CONDITION (and friends)
then we could make the change in lk 2.5 . Some names
are still not ideal (e.g. "GOOD") so prefixing them
with SCSI_ or SAM_ still might be useful.
That is replace:
   #define GOOD                 0x00
   #define CHECK_CONDITION      0x01
   #define CONDITION_GOOD       0x02
   #define BUSY                 0x04
   #define INTERMEDIATE_GOOD    0x08
   #define INTERMEDIATE_C_GOOD  0x0a
   #define RESERVATION_CONFLICT 0x0c
   #define COMMAND_TERMINATED   0x11
   #define QUEUE_FULL           0x14

   #define STATUS_MASK          0x3e

with:

   #define SAM_GOOD            0x00
   #define SAM_CHECK_CONDITION 0x02
   #define SAM_CONDITION_MET   0x04
   #define SAM_BUSY            0x08
   #define SAM_IMMEDIATE       0x10
   #define SAM_IMMEDIATE_CONDITION_MET 0x14
   #define SAM_RESERVATION_CONFLICT 0x18
   #define SAM_COMMAND_TERMINATED 0x22       /* obsolete in SAM-3 */
   #define SAM_TASK_SET_FULL   0x28
   #define SAM_ACA_ACTIVE      0x30
   #define SAM_TASK_ABORTED    0x40

   #define SCSI2_MASK          0x3e
   #define SAM3_MASK           0x7e


Doug Gilbert

> 
> Cheers,
> 
> Andre Hedrick
> LAD Storage Consulting Group
> 
> On Thu, 23 Jan 2003, Jens Axboe wrote:
> 
> 
>>On Thu, Jan 23 2003, Douglas Gilbert wrote:
>>
>>>The perverse CHECK_CONDITION in include/scsi/scsi.h seems
>>>to have struck again (see "Can't burn DVD under 2.5.59 with
>>>ide-cd" thread on the linux kernel list). Most users of
>>>CHECK_CONDITION found out to their surprise that it is
>>>shifted 1 bit (right) from those values found in the
>>>standards.
>>>
>>>The attachment marks the orginal list of SCSI status codes
>>>as deprecated and supplies defines taken from the most
>>>recent SAM-3 draft.
>>>
>>>The patch is against 2.5.59 but may also be suitable for
>>>the lk 2.4 tree.
>>
>>Thanks Doug, the old defines were really sick, dunno who was smoking
>>what. I not so sure I like the naming, though. The old ones still have
>>the most obvious naming :(
>>
>>-- 
>>Jens Axboe

