From: Douglas Gilbert <dgilbert@interlog.com>
Subject: =?windows-1252?Q?Re=3A_BUG_in_kernel=3A_Wrong_Handling?=
 =?windows-1252?Q?_of_USB_HDD=92s_in_scsiglue=28slave=5Fconfigu?=
 =?windows-1252?Q?re=29_and_scsi/sd=28sd=5Fread=5Fcache=5Ftype=29?=
Date: Mon, 03 Oct 2011 18:06:17 +0200
Message-ID: <4E89DD79.6020306@interlog.com>
References: <Pine.LNX.4.44L0.1110031008190.1882-100000@iolanthe.rowland.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:38383 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291Ab1JCQGW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Oct 2011 12:06:22 -0400
In-Reply-To: <Pine.LNX.4.44L0.1110031008190.1882-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Amit Sahrawat <amit.sahrawat83@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

On 11-10-03 04:25 PM, Alan Stern wrote:
> On Mon, 3 Oct 2011, Amit Sahrawat wrote:
>
>> Hi,
>>
>> Please find the USB Analyzer - logs for '6' USB based Mass Storage
>> devices attached.
>
> Too bad the analyzer log presents only the response, not the command.
>
>> So, only for one of the USB HDD(Seagate - Free Agent), the response
>> obtained is correct.
>
> I don't understand the format of the Seagate Free Agent MODE SENSE
> data.  Maybe someone else can interpret it; here it is for reference:
>
> SCSI Op(3) ADDR(4) Tag(0x00000004) SCSI CDB MODE SENSE(6)
> _______| Data(
> __ 000: 1C 00 00 00 86 0B 00 02 00 00 12 A1 9E B0 3C 01 00 1A 0A 00 01 00 00 00 00 00 00 0B B8 00 00 00
> __ 032: 00 00 00 00 1A 0A 00 01 00 00 00 00 00 00 0B B8 A2 06 00 00 00 00 00 00 78 20 55 53 42 32 2E 30
> __ 064: 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 7F FF 00 00 00 00 80 FA 0B C2 50 21 4E 41 30 42
> __ 096: 36 58 33 4C 00 30 00 00 00 32 43 46 45 39 42 00 70 F5 12 00 74 FF 00 00 00 00 00 00 00 00 00 00
> __ 128: 3C 00 00 0B B8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02 02 50 01
> __ 160: 46 72 65 65 41 67 65 6E 74 20 47 6F 46 6C 65 78 10 50 11 46 72 65 65 41 67 65 6E 74 20 47 6F 46)

The RBC device parameters mode page followed by a Power
Condition mode page. The RBC device parameters mode page
is the only SCSI page I have seen (mode, log, VPD, etc)
with a 5 byte field!

Decoded response to a probable MODE SENSE(6) "fetch all
pages" command:
   RBC device parameters mpage:
     WCD=0 [double negative: write cache enabled]
     Logical block size: 512 bytes
     Number of logical blocks: 0x12A19EB0 *** [160 GB]
     Power/performance: 0x3c
     READD: 0 [READ enabled]
     WRITED: 0 [WRITE enabled]
     FORMATD: 0 [FORMAT UNIT enabled]
     LOCKD: 1 [media cannot be locked]
   Power Condition mpage:
     IDLE=0
     STANDBY=1
     IDLE_CONDITION_TIMER=0
     STANDBY_CONDITION_TIMER=0xbb8 [300 seconds]

References: rbc-r10a.pdf [1999] + spc3r26 [2005]

Hopefully Seagate will switch to UAS(P) in the near future.


*** That is _not_ the address of the last valid LB as in
     the SCSI READ CAPACITY command!

> For the other devices this seems clear enough.  In most of the cases,
> the data doesn't include the Caching page.  The Samsung and Transcend
> devices _do_ provide their Caching pages, and in both of them the data
> says that write caching is disabled.  (In the Samsung case this is
> wrong undoubtedly because of the JMicron bridge -- JMicron's firmware
> is notoriously buggy.)
>
> If you can suggest a robust way of determining whether or not a drive
> supports SAT (one which won't cause non-supporting devices to crash),
> it could be added.  In the meantime, I'm not sure what else we can do.
>
> Would it make sense to assume write caching is present and enabled if
> the drive does not provide a Caching page?

No. You need to also take into account the RBC
device parameters mode page if present. See above.

Doug Gilbert
