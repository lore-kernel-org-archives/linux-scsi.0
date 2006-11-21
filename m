From: Joern Quillmann <quillman@fbihome.de>
Subject: Re: Spinup of SCSI Disks: allow_restart won't work on 2.6.18
Date: Tue, 21 Nov 2006 02:09:54 +0100
Message-ID: <456251E2.4010700@fbihome.de>
References: <455DF39A.6090209@fbihome.de> <455E2D44.5030903@gmx.de> <455E4703.3080005@s5r6.in-berlin.de> <456188FD.3020108@fbihome.de> <45619611.5020502@s5r6.in-berlin.de> <45622CF5.507@fbihome.de> <45624009.3040208@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.183]:9694 "EHLO
	moutng.kundenserver.de") by vger.kernel.org with ESMTP
	id S934213AbWKUBHU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Nov 2006 20:07:20 -0500
In-Reply-To: <45624009.3040208@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org

Stefan Richter wrote:
>>Is there a way to do some debug on the internals to see why the
>>attribute isn't actually writeable? Do you need parts of the kernel log?
> 
> 
> The responsible kernel code is drivers/scsi/sd.c::sd_store_allow_restart().
> 
> static ssize_t sd_store_allow_restart(struct class_device *cdev, const
...->
> I think the solution is easy: Replace if (sdp->type != TYPE_DISK) by
> 
> 	if (sdp->type != TYPE_DISK && sdp->type != TYPE_RBC)
> 
> As you can see further below in your log, most SBP-2 disks implement the
> RBC command set, i.e. are a somewhat special kind of SCSI HDD. I suppose
> I grabbed one of the rare SBP-2 disks which pose as TYPE_DISK when I
> tested to write to the allow_restart attribute.
> 
> I will try this modification here too and send a proper patch to the
> list if my line of thinking is correct.

Hehe  problem solved I think (or hope).
I'll test it too when applying your patch (see last paragraph).

>>sd 0:0:0:0: Attached scsi disk sda
>>ieee1394: sbp2: Error logging into SBP-2 device - timed out
>>sbp2: probe of 0001d20000093c4d-0 failed with error -16
> 
> This should not be a problem per se, although it won't be possible to
> actually use the disk after a login failure of course.

The remaining disks were not found too.

> I see from the GUIDs that the bridges were made by MacPower. They used
> to build them with the fine Oxford Semi SBP-2 bridges only, but some
> time ago they also used Prolific PL3507 for IEEE 1394A + USB 2.0 combo
> devices. I have 3 Oxford based MacPower enclosures and 1 Prolific based,
> and the latter behaves quite crappy. I get a lot of login failures on a
> 1394b host and occasional login failures on a 1394a host. Somebody else
> with, I believe, the same device as mine could fix this with a firmware
> update from http://www.prolific.com.tw/eng/downloads.asp?ID=44 (site is
> down right now, once again).
> 
> You said you have OXFW bridges, but do you know this from looking at the
> chips or merely from a spec sheet?

I know it because I actually bought them after doing a lot of research 
about the quality of different IEEE1394 bridges and Oxfords were said to 
be just the best ones.
I bought a bunch of old MacPower bridges (the OXFW911 bridges with blue 
PCB and capacity limit of 128GB) on ebay. Got 3 plain OXFW911 bridges 
and 1 with an Initio USB2.0 companion chip additionally to the OXFW911 
for a few euros.

Took me a whole night to get the "Oxsemi Uploader" Java tool for 
firmware updating and the 4.0 firmware for those bridges.
Now it says:
(Currently Running 13:59:47 Oct 15 2004 (v 4.0)  firmware.)
And thanks to some voodoo in this firmware I can use up to 160GB drives 
with those bridges. Thats the reason I bought them so my old drives 
don't go to waste.

>>------------[ cut here ]------------
>>kernel BUG at fs/sysfs/file.c:460!
>>invalid opcode: 0000 [#1]
...->
>>Code: 83 c0 74 e8 65 08 10 00 89 e8 83 c4 10 5b 5e 5f 5d c3 85 c0 89 c1
>>53 89 d3 74 10 83 78 30 00 0f 94 c2 85 db 0f 94 c0 08 c2 74 08 <0f> 0b
>>cc 01 d0 56 2b c0 8b 41 30 89 da b9 04 00 00 00 5b e9 5e
>>EIP: [<c01966c6>] sysfs_create_file+0x19/0x31 SS:ESP 0068:cb5f1eb8
> 
> 
> Hmm. This is not good. Maybe the ieee1394 driver received garbage data
> from the device's configuration ROM and sysfs blew up subsequently. I'm
> not sure if this is a realistic scenario and if so, which kinds of
> sanity checks might be missing in ieee1394. I'll check this
> eventually... Although if you can reproduce this bug, I could send you a
> patch with a bunch of printk's to narrow the offending sysfs attribute down.

Sure no problem. I'll test it asap.
Would be great to get a solution for this too. Kinda unfunny to always 
have the external disks running before the system boots.

Thank's a lot for your help and patience so far

Joern
