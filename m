From: Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: HP PSC 1350 cardreader problem + fix, needs new unusal_dev FLAG
Date: Sun, 10 Jun 2007 18:43:47 +0200
Message-ID: <466C2A43.8030300@hhs.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.versatel.nl ([62.58.50.89]:60193 "EHLO smtp2.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640AbXFJQwS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Jun 2007 12:52:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: stern@rowland.harvard.edu

<I'm not subscribed, please keep me CC-ed>

Hi all,

I send this mail initially to the usb-storage list, and Alan Stren (in the CC) 
though it would be a good idea to discuss parts of this here.

After encountering this bug in RH bugzilla while doing bug triaging:
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=158717

I thought hey, that reminds me the reader in my PSC has troubles too, lets see
if I can fix this.

So after 3 long evenings of debugging, I finally have my cardreader working
"properly" (what a piece of <beep>).

At first I tried and succeeded with US_FL_FIX_CAPACITY, that worked but gave me
warnings that the partition was larger then the device, and read access beyond
the end of device errors. But it worked now!

Further debugging has lead me to the following conclusion (with a few not
suitable for submitting usb-storage mods to proof it, proof as in it works).

The HP PSC 1350 reader will "crash" and from that moment on no longer
communicate in any sane way, if you try to read the last sector of an sdcard*
in a read that is more then 1 sector, so trying to read 8 sectors starting at
sector capicity-8 will crash it, as will reading 2 sectors starting at sector
capicity-2, however reading the last sector in a one 1 sector read will
succeed! (* xdcards seem to be fine).

I haven't tried if it will crash on larger then 1 sector writes which include
the last sector too, I immediately added code to not do that in both the read
and write paths. I have tested reading and writing the end of the disk with
this kludge in and it works.

As said I currently have an "really ugly" (tm) patch which modifies READ_10 and
WRITE_10 commands as they are passed through the usb-storage driver. Before I 
write a "proper" patch I have some questions:
1) currently I have decided to add quirk code for this to the usb-storage
    driver, as I don't want to polute the generic scsi code with this, but maybe
    it would be better to add a quirk for this to the scsi layer?
2) What on earth should I name the flag for this?
3) Currently I just shorten the read / write by one sector. The scsi layer then
    notices the 1 sector to short read/write and sends a new command for the
    last sector. This works well, but is it ok to depend on the scsi layer
    behaving this way?
4) Should I be checking for other READ_X and WRITE_x commands too?


Alan said that questions 1,3 and 4 would be best asked (and hopefully answered) 
here.

<I'm not subscribed, please keep me CC-ed>

Thanks & Regards,

Hans
