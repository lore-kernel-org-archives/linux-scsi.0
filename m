From: scott worley <sworley@tht.net>
Subject: Re: decoding dmesg output from aic7xxx
Date: Sun, 10 Oct 2004 11:12:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41695142.7030708@tht.net>
References: <41629089.4030902@tht.net> <4164289B.7050406@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vista.tht.net ([216.126.88.2]:42463 "EHLO tht.net")
	by vger.kernel.org with ESMTP id S268474AbUJJUid (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Oct 2004 16:38:33 -0400
In-Reply-To: <4164289B.7050406@adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: linux-scsi@vger.kernel.org

Hi Luben,

Note, kernel = debian 2.6.8-1-386

Tried both drives connected on the newer cable, channel A & B.
U320 drive was connected on second connector from HBA, U160 drive was 
connected at end of cable next to terminator.  U320 drive was jumpered 
as scsi id 1.  Neither drive as termination jumpers installed since the 
cable has a LVD/SE terminator.

Channel A: seemed to work better.  On three different boot ups, ran X, 
bonnie++ targeting the U320 drive, and tail'd the logs.  Saw the LVD to 
SE ping-ponging on the third run.  Also had smartmon running and the 
U320 reached 52 C.

Channel B: Failed in same way as above

Next, switched both drives to older cable.  This cable only has two 
connections for drives.  U160 at the end, U320 nearest HBA.

Channel A & B: failed within 30 minutes of booting. Drives were already 
hot from previous runs.  Failure generates not only LVD to SE messages 
but abort messages too.  Qualitatively, channel B appears worse than A.

Single drive connection.

Channel A with U320 drive + new cable. Fails after about two hours with 
LVD to SE messages.

Channel B with U320 drive + new cable.  Fails withing 30 minutes with 
LVD to SE and abort messages.

Before purchasing this crappy Soltek K8 board I was using a Tyan Tiger 
MPS.  The Tiger has an AMD chipset with a 64-bit 66-MHz PCI slot.  I had 
the U160 drive connected with the "old" cable to channel B and a scsi-3 
SE drive on channel A with a identical cable.  Never had any problems 
with this setup.  I believe this indicates the "old" cable + U160 drive 
is OK.

I'll run another experiment later using the "old" cable + U160 drive on 
channel A & B.

scott


Luben Tuikov wrote:

> Hi Scott,
>
> Can you try both disks on the newer cable (bus A)?
> Can you try the older cable with the older drive,
> and the newer cable with the newer drive?
>
>     Luben
>
>
>
> scott worley wrote:
>
>> Hi,
>>
>> I have an Adaptec 39160 that has been working for the past 2 years 
>> with a Seagate ST336938LW.  I just purchased a Seagate ST336607LW and 
>> started getting lots of messages from this new drive.  It appears to 
>> be switching between LVDS and SE mode.  The new drive is on channel B 
>> of the card and the older driver is on channel A.  In the past I have 
>> used the older drive on channel B with no problems.  Also, the new 
>> driver is connected to channel B with a unused cable that came with 
>> the card.  The other major difference is I'm running the card in a 
>> new mb, Soltek SL-K8AN2E-GR.  Had to go back to SCSI because the 
>> sata_nv driver will not work.
>>
>> The system usually will become slow to respond after being on for a 
>> couple of hours.  Once is starts responding again, the logs are full 
>> of SCSI driver messages.  Also, I am now sandwiching the new drive 
>> (in a bag of course) between two cold bags to find out if the problem 
>> is temperature related.  This drive is a 10K rpm cheetah and does get 
>> hot.  This is my first 10k drive so I'm not sure what is normal temp.
>>
>> dmesg output:
>> f]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 31 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> Pending list:
>>  7 SCB_CONTROL[0x70]:(MK_MESSAGE|TAG_ENB|DISCENB) SCB_SCSIID[0x7]
>> SCB_LUN[0x0]
>>  0 SCB_CONTROL[0x70]:(MK_MESSAGE|TAG_ENB|DISCENB) SCB_SCSIID[0x7]
>> SCB_LUN[0x0]
>> Kernel Free SCB list: 11 1 3 6 4 5 10 9 8
>> DevQ(0:0:0): 0 waiting
>>
>> <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
>> scsi0:0:0:0: Cmd aborted from QINFIFO
>> aic7xxx_abort returns 0x2002
>> scsi0:0:0:0: Attempting to queue an ABORT message
>> CDB: 0x2a 0x0 0x2 0x3b 0x75 0x6 0x0 0x0 0x10 0x0
>> scsi0: At time of recovery, card was not paused
>>  >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
>> scsi0: Dumping Card State while idle, at SEQADDR 0x18
>> Card was paused
>> ACCUM = 0x2, SINDEX = 0x48, DINDEX = 0xe4, ARG_2 = 0x0
>> HCNT = 0x0 SCBPTR = 0x3
>> SCSIPHASE[0x0] SCSISIGI[0x0] ERROR[0x0] SCSIBUSL[0x0]
>> LASTPHASE[0x1]:(P_BUSFREE) SCSISEQ[0x1a]:(ENAUTOATNP|ENAUTOATNO|ENRSELI)
>> SBLKCTL[0xa]:(SELWIDE|SELBUSB) SCSIRATE[0x0] SEQCTL[0x10]:(FASTMODE)
>> SEQ_FLAGS[0xc0]:(NO_CDB_SENT|NOT_IDENTIFIED) SSTAT0[0x0]
>> SSTAT1[0x0] SSTAT2[0x0] SSTAT3[0x0] SIMODE0[0x8]:(ENSWRAP)
>> SIMODE1[0xa4]:(ENSCSIPERR|ENSCSIRST|ENSELTIMO) SXFRCTL0[0x80]:(DFON)
>> DFCNTRL[0x0] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL)
>> STACK: 0x0 0x163 0x178 0x17
>> SCB count = 12
>> Kernel NEXTQSCB = 0
>> Card NEXTQSCB = 2
>> QINFIFO entries: 2
>> Waiting Queue entries:
>> Disconnected Queue entries:
>> QOUTFIFO entries:
>> Sequencer Free SCB List: 3 2 4 7 6 0 1 5 8 9 10 11 12 13 14 15 16 17 
>> 18 19 20 21 22 23 24 25 26 27 28 29 30 31
>> Sequencer SCB Info:
>>  0 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
>> SCB_LUN[0x0] SCB_TAG[0xff]
>>  1 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
>> SCB_LUN[0x0] SCB_TAG[0xff]
>>  2 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
>> SCB_LUN[0x0] SCB_TAG[0xff]
>>  3 SCB_CONTROL[0x0] SCB_SCSIID[0x7] SCB_LUN[0x0] SCB_TAG[0xff]
>>  4 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
>> SCB_LUN[0x0] SCB_TAG[0xff]
>>  5 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
>> SCB_LUN[0x0] SCB_TAG[0xff]
>>  6 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
>> SCB_LUN[0x0] SCB_TAG[0xff]
>>  7 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
>> SCB_LUN[0x0] SCB_TAG[0xff]
>>  8 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>>  9 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 10 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 11 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 12 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 13 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 14 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 15 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 16 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 17 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 18 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 19 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 20 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 21 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 22 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 23 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 24 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 25 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 26 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 27 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 28 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 29 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 30 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 31 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> Pending list:
>>  2 SCB_CONTROL[0x70]:(MK_MESSAGE|TAG_ENB|DISCENB) SCB_SCSIID[0x7]
>> SCB_LUN[0x0]
>> Kernel Free SCB list: 7 11 1 3 6 4 5 10 9 8
>> DevQ(0:0:0): 0 waiting
>>
>> <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
>> scsi0:0:0:0: Cmd aborted from QINFIFO
>> aic7xxx_abort returns 0x2002
>> scsi0:0:0:0: Attempting to queue an ABORT message
>> CDB: 0x0 0x0 0x0 0x0 0x0 0x0
>> scsi0: At time of recovery, card was not paused
>>  >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
>> scsi0: Dumping Card State while idle, at SEQADDR 0x18
>> Card was paused
>> ACCUM = 0x2, SINDEX = 0x48, DINDEX = 0xe4, ARG_2 = 0x0
>> HCNT = 0x0 SCBPTR = 0x3
>> SCSIPHASE[0x0] SCSISIGI[0x0] ERROR[0x0] SCSIBUSL[0x0]
>> LASTPHASE[0x1]:(P_BUSFREE) SCSISEQ[0x1a]:(ENAUTOATNP|ENAUTOATNO|ENRSELI)
>> SBLKCTL[0xa]:(SELWIDE|SELBUSB) SCSIRATE[0x0] SEQCTL[0x10]:(FASTMODE)
>> SEQ_FLAGS[0xc0]:(NO_CDB_SENT|NOT_IDENTIFIED) SSTAT0[0x0]
>> SSTAT1[0x0] SSTAT2[0x0] SSTAT3[0x0] SIMODE0[0x8]:(ENSWRAP)
>> SIMODE1[0xa4]:(ENSCSIPERR|ENSCSIRST|ENSELTIMO) SXFRCTL0[0x80]:(DFON)
>> DFCNTRL[0x0] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL)
>> STACK: 0x0 0x163 0x178 0x17
>> SCB count = 12
>> Kernel NEXTQSCB = 2
>> Card NEXTQSCB = 0
>> QINFIFO entries: 0
>> Waiting Queue entries:
>> Disconnected Queue entries:
>> QOUTFIFO entries:
>> Sequencer Free SCB List: 3 2 4 7 6 0 1 5 8 9 10 11 12 13 14 15 16 17 
>> 18 19 20 21 22 23 24 25 26 27 28 29 30 31
>> Sequencer SCB Info:
>>  0 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
>> SCB_LUN[0x0] SCB_TAG[0xff]
>>  1 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
>> SCB_LUN[0x0] SCB_TAG[0xff]
>>  2 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
>> SCB_LUN[0x0] SCB_TAG[0xff]
>>  3 SCB_CONTROL[0x0] SCB_SCSIID[0x7] SCB_LUN[0x0] SCB_TAG[0xff]
>>  4 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
>> SCB_LUN[0x0] SCB_TAG[0xff]
>>  5 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
>> SCB_LUN[0x0] SCB_TAG[0xff]
>>  6 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
>> SCB_LUN[0x0] SCB_TAG[0xff]
>>  7 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
>> SCB_LUN[0x0] SCB_TAG[0xff]
>>  8 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>>  9 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 10 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 11 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 12 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 13 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 14 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 15 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 16 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 17 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 18 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 19 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 20 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 21 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 22 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 23 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 24 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 25 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 26 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 27 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 28 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 29 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 30 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 31 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> Pending list:
>>  0 SCB_CONTROL[0x70]:(MK_MESSAGE|TAG_ENB|DISCENB) SCB_SCSIID[0x7]
>> SCB_LUN[0x0]
>> Kernel Free SCB list: 7 11 1 3 6 4 5 10 9 8
>> DevQ(0:0:0): 0 waiting
>>
>> <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
>> scsi0:0:0:0: Cmd aborted from QINFIFO
>> aic7xxx_abort returns 0x2002
>> scsi0:0:0:0: Attempting to queue a TARGET RESET message
>> CDB: 0x2a 0x0 0x2 0x3b 0x97 0xe6 0x0 0x0 0x8 0x0
>> scsi0:0:0:0: Command not found
>> aic7xxx_dev_reset returns 0x2002
>> scsi0:0:0:0: Attempting to queue an ABORT message
>> CDB: 0x0 0x0 0x0 0x0 0x0 0x0
>> scsi0: At time of recovery, card was not paused
>>  >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
>> scsi0: Dumping Card State while idle, at SEQADDR 0x18
>> Card was paused
>> ACCUM = 0x2, SINDEX = 0x48, DINDEX = 0xe4, ARG_2 = 0x0
>> HCNT = 0x0 SCBPTR = 0x3
>> SCSIPHASE[0x0] SCSISIGI[0x0] ERROR[0x0] SCSIBUSL[0x0]
>> LASTPHASE[0x1]:(P_BUSFREE) SCSISEQ[0x1a]:(ENAUTOATNP|ENAUTOATNO|ENRSELI)
>> SBLKCTL[0xa]:(SELWIDE|SELBUSB) SCSIRATE[0x0] SEQCTL[0x10]:(FASTMODE)
>> SEQ_FLAGS[0xc0]:(NO_CDB_SENT|NOT_IDENTIFIED) SSTAT0[0x0]
>> SSTAT1[0x0] SSTAT2[0x0] SSTAT3[0x0] SIMODE0[0x8]:(ENSWRAP)
>> SIMODE1[0xa4]:(ENSCSIPERR|ENSCSIRST|ENSELTIMO) SXFRCTL0[0x80]:(DFON)
>> DFCNTRL[0x0] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL)
>> STACK: 0x0 0x163 0x178 0x17
>> SCB count = 12
>> Kernel NEXTQSCB = 0
>> Card NEXTQSCB = 2
>> QINFIFO entries: 2
>> Waiting Queue entries:
>> Disconnected Queue entries:
>> QOUTFIFO entries:
>> Sequencer Free SCB List: 3 2 4 7 6 0 1 5 8 9 10 11 12 13 14 15 16 17 
>> 18 19 20 21 22 23 24 25 26 27 28 29 30 31
>> Sequencer SCB Info:
>>  0 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
>> SCB_LUN[0x0] SCB_TAG[0xff]
>>  1 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
>> SCB_LUN[0x0] SCB_TAG[0xff]
>>  2 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
>> SCB_LUN[0x0] SCB_TAG[0xff]
>>  3 SCB_CONTROL[0x0] SCB_SCSIID[0x7] SCB_LUN[0x0] SCB_TAG[0xff]
>>  4 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
>> SCB_LUN[0x0] SCB_TAG[0xff]
>>  5 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
>> SCB_LUN[0x0] SCB_TAG[0xff]
>>  6 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
>> SCB_LUN[0x0] SCB_TAG[0xff]
>>  7 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) SCB_SCSIID[0x7]
>> SCB_LUN[0x0] SCB_TAG[0xff]
>>  8 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>>  9 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 10 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 11 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 12 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 13 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 14 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 15 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 16 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 17 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 18 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 19 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 20 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 21 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 22 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 23 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 24 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 25 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 26 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 27 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 28 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 29 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 30 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> 31 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
>> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
>> Pending list:
>>  2 SCB_CONTROL[0x70]:(MK_MESSAGE|TAG_ENB|DISCENB) SCB_SCSIID[0x7]
>> SCB_LUN[0x0]
>> Kernel Free SCB list: 7 11 1 3 6 4 5 10 9 8
>> DevQ(0:0:0): 0 waiting
>>
>> <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
>> scsi0:0:0:0: Cmd aborted from QINFIFO
>> aic7xxx_abort returns 0x2002
>>
>> The current dmesg with some SCSI LVD to SE mode switch messages:
>> This will make me look stupid, the LVD to SE mode switch is on 
>> Channel A, the older drive.  Maybe the cable on the older drive is 
>> getting old...
>>  >896MB LOWMEM available.
>> found SMP MP-table at 000f55c0
>> On node 0 totalpages: 229376
>>  DMA zone: 4096 pages, LIFO batch:1
>>  Normal zone: 225280 pages, LIFO batch:16
>>  HighMem zone: 0 pages, LIFO batch:1
>> DMI 2.2 present.
>> ACPI: RSDP (v000 Nvidia                                    ) @ 
>> 0x000f90f0
>> ACPI: RSDT (v001 Nvidia AWRDACPI 0x42302e31 AWRD 0x00000000) @ 
>> 0x3fff3000
>> ACPI: FADT (v001 Nvidia AWRDACPI 0x42302e31 AWRD 0x00000000) @ 
>> 0x3fff3040
>> ACPI: MADT (v001 Nvidia AWRDACPI 0x42302e31 AWRD 0x00000000) @ 
>> 0x3fff7b40
>> ACPI: DSDT (v001 NVIDIA AWRDACPI 0x00001000 MSFT 0x0100000e) @ 
>> 0x00000000
>> ACPI: PM-Timer IO Port: 0x4008
>> ACPI: Local APIC address 0xfee00000
>> ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
>> Processor #0 15:12 APIC version 16
>> ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
>> ACPI: Skipping IOAPIC probe due to 'noapic' option.
>> Using ACPI for processor (LAPIC) configuration information
>> Intel MultiProcessor Specification v1.4
>>    Virtual Wire compatibility mode.
>> OEM ID: OEM00000 Product ID: PROD00000000 APIC at: 0xFEE00000
>> I/O APIC #2 Version 17 at 0xFEC00000.
>> Enabling APIC mode:  Flat.  Using 1 I/O APICs
>> Processors: 1
>> Built 1 zonelists
>> Kernel command line: root=/dev/sdb1 ro noapic
>> Initializing CPU#0
>> PID hash table entries: 4096 (order 12: 32768 bytes)
>> Detected 2222.130 MHz processor.
>> Using pmtmr for high-res timesource
>> Console: colour VGA+ 80x25
>> Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
>> Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
>> Memory: 901828k/917504k available (1329k kernel code, 14892k 
>> reserved, 727k data, 204k init, 0k highmem)
>> Checking if this processor honours the WP bit even in supervisor 
>> mode... Ok.
>> Calibrating delay loop... 4390.91 BogoMIPS
>> Security Scaffold v1.0.0 initialized
>> Mount-cache hash table entries: 512 (order: 0, 4096 bytes)
>> CPU: After generic identify, caps: 078bfbff e1d3fbff 00000000 00000000
>> CPU: After vendor identify, caps:  078bfbff e1d3fbff 00000000 00000000
>> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
>> CPU: L2 Cache: 512K (64 bytes/line)
>> CPU: After all inits, caps:        078bfbff e1d3fbff 00000000 00000010
>> CPU: AMD Athlon(tm) 64 Processor 3200+ stepping 00
>> Enabling fast FPU save and restore... done.
>> Enabling unmasked SIMD FPU exception support... done.
>> Checking 'hlt' instruction... OK.
>> Checking for popad bug... OK.
>> ACPI: IRQ9 SCI: Edge set to Level Trigger.
>> enabled ExtINT on CPU#0
>> ESR value before enabling vector: 00000000
>> ESR value after enabling vector: 00000000
>> Using local APIC timer interrupts.
>> calibrating APIC timer ...
>> ..... CPU clock speed is 2221.0754 MHz.
>> ..... host bus clock speed is 201.0977 MHz.
>> checking if image is initramfs...it isn't (ungzip failed); looks like 
>> an initrd
>> Freeing initrd memory: 4316k freed
>> NET: Registered protocol family 16
>> EISA bus registered
>> PCI: PCI BIOS revision 2.10 entry at 0xfb9b0, last bus=2
>> PCI: Using configuration type 1
>> mtrr: v2.0 (20020519)
>> ACPI: Subsystem revision 20040326
>> ACPI: Interpreter enabled
>> ACPI: Using PIC for interrupt routing
>> ACPI: PCI Root Bridge [PCI0] (00:00)
>> PCI: Probing PCI hardware (bus 00)
>> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
>> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
>> ACPI: Power Resource [ISAV] (on)
>> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGPB._PRT]
>> ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 *11 12 14 15)
>> ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, 
>> disabled.
>> ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 5 6 7 10 *11 12 14 15)
>> ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 6 7 *10 11 12 14 15)
>> ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 *5 6 7 10 11 12 14 15)
>> ACPI: PCI Interrupt Link [LUBA] (IRQs 3 4 5 6 7 *10 11 12 14 15)
>> ACPI: PCI Interrupt Link [LUBB] (IRQs *3 4 5 6 7 10 11 12 14 15)
>> ACPI: PCI Interrupt Link [LMAC] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, 
>> disabled.
>> ACPI: PCI Interrupt Link [LAPU] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, 
>> disabled.
>> ACPI: PCI Interrupt Link [LACI] (IRQs *3 4 5 6 7 10 11 12 14 15)
>> ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, 
>> disabled.
>> ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 *5 6 7 10 11 12 14 15)
>> ACPI: PCI Interrupt Link [LUB2] (IRQs *3 4 5 6 7 10 11 12 14 15)
>> ACPI: PCI Interrupt Link [LFIR] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, 
>> disabled.
>> ACPI: PCI Interrupt Link [L3CM] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, 
>> disabled.
>> ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, 
>> disabled.
>> ACPI: PCI Interrupt Link [LSID] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, 
>> disabled.
>> ACPI: PCI Interrupt Link [LFID] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, 
>> disabled.
>> ACPI: PCI Interrupt Link [APC1] (IRQs *16), disabled.
>> ACPI: PCI Interrupt Link [APC2] (IRQs *17), disabled.
>> ACPI: PCI Interrupt Link [APC3] (IRQs *18), disabled.
>> ACPI: PCI Interrupt Link [APC4] (IRQs *19), disabled.
>> ACPI: PCI Interrupt Link [APC5] (IRQs *16), disabled.
>> ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22) *0, disabled.
>> ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22) *0, disabled.
>> ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22) *0, disabled.
>> ACPI: PCI Interrupt Link [APCI] (IRQs 20 21 22) *0, disabled.
>> ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22) *0, disabled.
>> ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22) *0, disabled.
>> ACPI: PCI Interrupt Link [APCS] (IRQs *23), disabled.
>> ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22) *0, disabled.
>> ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22) *0, disabled.
>> ACPI: PCI Interrupt Link [AP3C] (IRQs 20 21 22) *0, disabled.
>> ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22) *0, disabled.
>> ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22) *0, disabled.
>> ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22) *0, disabled.
>> Linux Plug and Play Support v0.97 (c) Adam Belay
>> PnPBIOS: Scanning system for PnP BIOS support...
>> PnPBIOS: Found PnP BIOS installation structure at 0xc00fc410
>> PnPBIOS: PnP BIOS version 1.0, entry 0xf0000:0xc440, dseg 0xf0000
>> PnPBIOS: 14 nodes reported by PnP BIOS; 14 recorded by driver
>> PCI: Using ACPI for IRQ routing
>> ACPI: PCI Interrupt Link [LSMB] enabled at IRQ 5
>> ACPI: PCI interrupt 0000:00:01.1[A] -> GSI 5 (level, low) -> IRQ 5
>> ACPI: PCI Interrupt Link [LUBA] enabled at IRQ 10
>> ACPI: PCI interrupt 0000:00:02.0[A] -> GSI 10 (level, low) -> IRQ 10
>> ACPI: PCI Interrupt Link [LUBB] enabled at IRQ 3
>> ACPI: PCI interrupt 0000:00:02.1[B] -> GSI 3 (level, low) -> IRQ 3
>> ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 3
>> ACPI: PCI interrupt 0000:00:02.2[C] -> GSI 3 (level, low) -> IRQ 3
>> ACPI: PCI Interrupt Link [LACI] enabled at IRQ 3
>> ACPI: PCI interrupt 0000:00:06.0[A] -> GSI 3 (level, low) -> IRQ 3
>> ACPI: PCI Interrupt Link [LNK5] enabled at IRQ 5
>> ACPI: PCI interrupt 0000:01:00.0[A] -> GSI 5 (level, low) -> IRQ 5
>> ACPI: PCI Interrupt Link [LNK4] enabled at IRQ 10
>> ACPI: PCI interrupt 0000:02:07.0[A] -> GSI 10 (level, low) -> IRQ 10
>> ACPI: PCI Interrupt Link [LNK1] enabled at IRQ 11
>> ACPI: PCI interrupt 0000:02:08.0[A] -> GSI 11 (level, low) -> IRQ 11
>> ACPI: PCI Interrupt Link [LNK3] enabled at IRQ 11
>> ACPI: PCI interrupt 0000:02:0a.0[A] -> GSI 11 (level, low) -> IRQ 11
>> ACPI: PCI interrupt 0000:02:0a.1[B] -> GSI 10 (level, low) -> IRQ 10
>> VFS: Disk quotas dquot_6.5.1
>> Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
>> devfs: 2004-01-31 Richard Gooch (rgooch@atnf.csiro.au)
>> devfs: boot_options: 0x0
>> Initializing Cryptographic API
>> isapnp: Scanning for PnP cards...
>> isapnp: No Plug & Play device found
>> Serial: 8250/16550 driver $Revision: 1.90 $ 54 ports, IRQ sharing 
>> enabled
>> ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
>> RAMDISK driver initialized: 16 RAM disks of 8192K size 1024 blocksize
>> serio: i8042 AUX port at 0x60,0x64 irq 12
>> serio: i8042 KBD port at 0x60,0x64 irq 1
>> input: AT Translated Set 2 keyboard on isa0060/serio0
>> EISA: Probing bus 0 at eisa0
>> Cannot allocate resource for EISA slot 4
>> EISA: Detected 0 cards.
>> NET: Registered protocol family 2
>> IP: routing cache hash table of 8192 buckets, 64Kbytes
>> TCP: Hash tables configured (established 262144 bind 65536)
>> NET: Registered protocol family 8
>> NET: Registered protocol family 20
>> ACPI: (supports S0 S1 S4 S5)
>> RAMDISK: cramfs filesystem found at block 0
>> RAMDISK: Loading 4316 blocks [1 disk] into ram disk... done.
>> VFS: Mounted root (cramfs filesystem) readonly.
>> Freeing unused kernel memory: 204k freed
>> vesafb: probe of vesafb0 failed with error -6
>> NET: Registered protocol family 1
>> SCSI subsystem initialized
>> ACPI: PCI interrupt 0000:02:0a.0[A] -> GSI 11 (level, low) -> IRQ 11
>> ACPI: PCI interrupt 0000:02:0a.1[B] -> GSI 10 (level, low) -> IRQ 10
>> scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
>>        <Adaptec 3960D Ultra160 SCSI adapter>
>>        aic7899: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
>>
>> Using anticipatory io scheduler
>> (scsi0:A:0): 160.000MB/s transfers (80.000MHz DT, offset 63, 16bit)
>>  Vendor: SEAGATE   Model: ST336938LW        Rev: 0001
>>  Type:   Direct-Access                      ANSI SCSI revision: 03
>> scsi0:A:0:0: Tagged Queuing enabled.  Depth 8
>> scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
>>        <Adaptec 3960D Ultra160 SCSI adapter>
>>        aic7899: Ultra160 Wide Channel B, SCSI Id=7, 32/253 SCBs
>>
>> (scsi1:A:0): 160.000MB/s transfers (80.000MHz DT, offset 63, 16bit)
>>  Vendor: SEAGATE   Model: ST336607LW        Rev: 0007
>>  Type:   Direct-Access                      ANSI SCSI revision: 03
>> scsi1:A:0:0: Tagged Queuing enabled.  Depth 8
>> SCSI device sda: 72176567 512-byte hdwr sectors (36954 MB)
>> SCSI device sda: drive cache: write back
>> /dev/scsi/host0/bus0/target0/lun0: p1 p2 p3 < p5 p6 p7 >
>> Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
>> SCSI device sdb: 71687372 512-byte hdwr sectors (36704 MB)
>> SCSI device sdb: drive cache: write back
>> /dev/scsi/host1/bus0/target0/lun0: p1
>> Attached scsi disk sdb at scsi1, channel 0, id 0, lun 0
>> SGI XFS with ACLs, security attributes, realtime, large block 
>> numbers, no debug enabled
>> SGI XFS Quota Management subsystem
>> XFS mounting filesystem sdb1
>> Ending clean XFS mount for filesystem: sdb1
>> Adding 1951888k swap on /dev/sda2.  Priority:-1 extents:1
>> Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
>> ide: Assuming 33MHz system bus speed for PIO modes; override with 
>> idebus=xx
>> hdc: DVD-ROM DDU1621, ATAPI CD/DVD-ROM drive
>> ide1 at 0x170-0x177,0x376 on irq 15
>> hdc: ATAPI 40X DVD-ROM drive, 512kB Cache
>> Uniform CD-ROM driver Revision: 3.20
>> Capability LSM initialized
>> XFS mounting filesystem sda5
>> Ending clean XFS mount for filesystem: sda5
>> XFS mounting filesystem sda6
>> Ending clean XFS mount for filesystem: sda6
>> XFS mounting filesystem sda7
>> Ending clean XFS mount for filesystem: sda7
>> ACPI: PCI interrupt 0000:02:07.0[A] -> GSI 10 (level, low) -> IRQ 10
>> 3c59x: Donald Becker and others. www.scyld.com/network/vortex.html
>> 0000:02:07.0: 3Com PCI 3c905C Tornado at 0xd000. Vers LK1.1.19
>> Real Time Clock Driver v1.12
>> input: PC Speaker
>> input: ImPS/2 Logitech Wheel Mouse on isa0060/serio1
>> mice: PS/2 mouse device common for all mice
>> ts: Compaq touchscreen protocol output
>> inserting floppy driver for 2.6.8-1-386
>> Floppy drive(s): fd0 is 1.44M
>> FDC 0 is a post-1991 82077
>> parport: PnPBIOS parport detected.
>> parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
>> Linux agpgart interface v0.100 (c) Dave Jones
>> agpgart: Detected AGP bridge 0
>> agpgart: Setting up Nforce3 AGP.
>> agpgart: Maximum main memory to use for agp memory: 816M
>> agpgart: AGP aperture is 64M @ 0xe0000000
>> usbcore: registered new driver usbfs
>> usbcore: registered new driver hub
>> ohci_hcd: 2004 Feb 02 USB 1.1 'Open' Host Controller (OHCI) Driver (PCI)
>> ohci_hcd: block sizes: ed 64 td 64
>> ACPI: PCI interrupt 0000:00:02.0[A] -> GSI 10 (level, low) -> IRQ 10
>> ohci_hcd 0000:00:02.0: PCI device 10de:00e7 (nVidia Corporation)
>> PCI: Setting latency timer of device 0000:00:02.0 to 64
>> ohci_hcd 0000:00:02.0: irq 10, pci mem f890b000
>> ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 1
>> hub 1-0:1.0: USB hub found
>> hub 1-0:1.0: 4 ports detected
>> ACPI: PCI interrupt 0000:00:02.1[B] -> GSI 3 (level, low) -> IRQ 3
>> ohci_hcd 0000:00:02.1: PCI device 10de:00e7 (nVidia Corporation)
>> PCI: Setting latency timer of device 0000:00:02.1 to 64
>> ohci_hcd 0000:00:02.1: irq 3, pci mem f890d000
>> ohci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 2
>> hub 2-0:1.0: USB hub found
>> hub 2-0:1.0: 4 ports detected
>> usb 2-1: new full speed USB device using address 2
>> ACPI: PCI interrupt 0000:00:02.2[C] -> GSI 3 (level, low) -> IRQ 3
>> ehci_hcd 0000:00:02.2: PCI device 10de:00e8 (nVidia Corporation)
>> PCI: Setting latency timer of device 0000:00:02.2 to 64
>> ehci_hcd 0000:00:02.2: irq 3, pci mem f8934000
>> ehci_hcd 0000:00:02.2: new USB bus registered, assigned bus number 3
>> PCI: cache line size of 64 is not supported by device 0000:00:02.2
>> ehci_hcd 0000:00:02.2: USB 2.0 enabled, EHCI 1.00, driver 2004-May-10
>> hub 3-0:1.0: USB hub found
>> hub 3-0:1.0: 8 ports detected
>> usb 2-1: device not accepting address 2, error -110
>> ACPI: PCI interrupt 0000:00:06.0[A] -> GSI 3 (level, low) -> IRQ 3
>> PCI: Setting latency timer of device 0000:00:06.0 to 64
>> ohci_hcd 0000:00:02.1: wakeup
>> intel8x0_measure_ac97_clock: measured 49413 usecs
>> intel8x0: clocking to 46813
>> usb 2-1: new full speed USB device using address 4
>> NFORCE3-250: IDE controller at PCI slot 0000:00:08.0
>> NFORCE3-250: chipset revision 162
>> NFORCE3-250: not 100% native mode: will probe irqs later
>> NFORCE3-250: 0000:00:08.0 (rev a2) UDMA133 controller
>>    ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:DMA, hdb:DMA
>> NFORCE3-250: port 0x0170 already claimed by ide1
>> usb 2-1: device not accepting address 4, error -110
>> usb 2-1: new full speed USB device using address 5
>> usb 2-1: device not accepting address 5, error -110
>> cpci_hotplug: CompactPCI Hot Plug Core version: 0.2
>> pci_hotplug: PCI Hot Plug PCI Core version: 0.5
>> pciehp: PCI Express Hot Plug Controller Driver version: 0.4
>> shpchp: shpc_init : shpc_cap_offset == 0
>> shpchp: shpc_init : shpc_cap_offset == 0
>> shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
>> ieee1394: Initialized config rom entry `ip1394'
>> ohci1394: $Rev: 1223 $ Ben Collins <bcollins@debian.org>
>> ACPI: PCI interrupt 0000:02:08.0[A] -> GSI 11 (level, low) -> IRQ 11
>> ohci1394: fw-host0: Unexpected PCI resource length of 1000!
>> ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[11]  
>> MMIO=[ee044000-ee0447ff]  Max Packet=[2048]
>> ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00004c0100004155]
>> ip1394: $Rev: 1224 $ Ben Collins <bcollins@debian.org>
>> ip1394: eth1: IEEE-1394 IPv4 over 1394 Ethernet (fw-host0)
>> NET: Registered protocol family 17
>> ACPI: Processor [CPU0] (supports C1)
>> ACPI: Power Button (FF) [PWRF]
>> ACPI: Fan [FAN] (on)
>> ACPI: Thermal Zone [THRM] (0 C)
>> lp0: using parport0 (interrupt-driven).
>> NET: Registered protocol family 10
>> Disabled Privacy Extensions on device c02c95a0(lo)
>> IPv6 over IPv4 tunneling driver
>> eth0: no IPv6 routers present
>> usbcore: registered new driver usblp
>> drivers/usb/class/usblp.c: v0.13: USB Printer Device Class driver
>> scsi0: Someone reset channel A
>> scsi0: Transceiver State Has Changed to SE mode
>> scsi0: Transceiver State Has Changed to LVD mode
>>
>>
>>
>>
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

