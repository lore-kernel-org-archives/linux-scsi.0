From: Douglas Gilbert <dougg@torque.net>
Subject: Re: TYPE_RBC cache fixes (sbp2.c affected)
Date: Tue, 24 May 2005 01:14:03 +1000
Message-ID: <4291F33B.9060505@torque.net>
References: <20050516015955.GL1150@parcelfarce.linux.theplanet.co.uk>	 <4290273E.6050306@torque.net> <1116770775.5002.21.camel@mulgrave>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:37511 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261881AbVEWPOD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 May 2005 11:14:03 -0400
In-Reply-To: <1116770775.5002.21.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux1394-devel@lists.sourceforge.net, Jeff Garzik <jgarzik@pobox.com>

James Bottomley wrote:
> On Sun, 2005-05-22 at 16:31 +1000, Douglas Gilbert wrote:
> 
>>In my experience setting the DBD flag only increases the
>>chance of failure (from devices that don't understand the
>>DBD (i.e. disable block descriptors) bit. Also dbd should
>>be set (to 1) or cleared; not set to 8. Best to leave it clear
>>(the default) as the offset calculation below takes into
>>account any returned block descriptors.
> 
> 
> DBD is a listed *requirement* of RBC devices ... so I think we have to
> have it.  Also, it's a pass through to __scsi_mode_sense() not a bit
> flag (i.e. to set dbd in the command header, you have to set it to its
> correct bit position, i.e. 8).

No wonder our colleagues in Redmond don't want a
bar of RBC and tell USB and 1394 driver writers
to convert MODE SENSE 10 from their OS as required.

Why doesn't the RBC standard leave the DBD switch as
it is in SPC and simply say that MODE SENSE responses
shall not contain block descriptors?? That would
be too simple.

Another strange thing I saw in RBC is the 5 byte
field containing the number of logical blocks field
in the RBC device parameters mode page. Trouble is
RBC only supports READ CAPACITY (10) which is limited
to 4 bytes for the number of logical blocks.

>>James,
>>scsi_lib.c::__scsi_mode_sense() has a bug in it.
>>If dbd is set then both the DBD and LLBA bits in the
>>MODE SENSE cdb are set. However LLBA is not defined for
>>MODE SENSE 6 (in SPC or RBC). That may be why Al's
>>hardware doesn't like MODE SENSE 6 cdbs issued by the
>>SCSI mid level :-)
> 
> 
> no, look again; the statement is:
> 
> 	cmd[1] = dbd & 0x18;	/* allows DBD and LLBA bits */

Coffee didn't make up for that 4 hours of sleep
I lost to that travesty in Wales, but I digress ...

> So if you set dbd  0x08, you get dbd and 0x10 you get LLBA etc.

I feel ill.

> However, I agree, we shouldn't allow the setting of LLBA on MODE SENSE
> 6, fixed below.

Now I feel better.

For my hardware it makes no difference whether DBD
is set or not (MODE SENSE/SELECT 6 works while MODE
SENSE 10 returns a MODE SENSE 6 response).

>>>+		if ((buffer[offset] & 0x3f) != modepage) {
>>>+			printk(KERN_ERR "%s: got wrong page\n", diskname);
>>>+			goto defaults;
>>>+		}
>>
>>So here is the sanity check that I have been talking
>>about. On my hardware since a MODE SENSE 10 was issued,
>>the response is corrupt (actually the response for the
>>corresponding MODE SENSE 6 is returned) so the exercise
>>becomes futile. Note that my hardware complies with
>>the RBC standard in properly supporting MODE SENSE 6.
>>[The RBC standard doesn't say anything about what should
>>happen when MODE SENSE 10 is issued :-)]
>>
>>To work on my hardware the next move would be to
>>"sdev->use_10_for_ms = 0;" and try again (and if
>>that fails give up).
> 
> 
> Well ... what I was wondering is whether to predicate the setting of
> use_10_for_ms in the firewire slave_configure on if (sdev->type !=
> TYPE_RBC).
> 
> However, checking for corrupt mode pages in the routine seems like a
> good idea as well, does the attached work?

Yes.

This is what I saw (with WCD=0):

May 23 10:40:21 frig kernel:     <<< prior to patch >>>
sbp2: $Rev: 1219 $ Ben Collins <bcollins@debian.org>
scsi2 : SCSI emulation for IEEE-1394 SBP-2 Devices
ieee1394: sbp2: Logged into SBP-2 device
   Vendor: ST380011  Model: A                 Rev:
   Type:   Simplified D-A                     ANSI SCSI revision: 06
SCSI device sdb: 156301488 512-byte hdwr sectors (80026 MB)
sdb: got wrong page
sdb: assuming drive cache: write through
SCSI device sdb: 156301488 512-byte hdwr sectors (80026 MB)
sdb: got wrong page
sdb: assuming drive cache: write through
  sdb: sdb1 sdb2 sdb3 sdb4
Attached scsi disk sdb at scsi2, channel 0, id 1, lun 0


May 23 18:00:09 frig kernel:     <<< after patch >>>
sbp2: $Rev: 1219 $ Ben Collins <bcollins@debian.org>
scsi2 : SCSI emulation for IEEE-1394 SBP-2 Devices
ieee1394: sbp2: Logged into SBP-2 device
   Vendor: ST380011  Model: A                 Rev:
   Type:   Simplified D-A                     ANSI SCSI revision: 06
SCSI device sdb: 156301488 512-byte hdwr sectors (80026 MB)
SCSI device sdb: drive cache: write back
SCSI device sdb: 156301488 512-byte hdwr sectors (80026 MB)
SCSI device sdb: drive cache: write back
  sdb: sdb1 sdb2 sdb3 sdb4
Attached scsi disk sdb at scsi2, channel 0, id 1, lun 0


Doug Gilbert


