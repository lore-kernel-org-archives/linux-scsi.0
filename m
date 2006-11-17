From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Spinup of SCSI Disks: allow_restart won't work on 2.6.18
Date: Sat, 18 Nov 2006 00:34:27 +0100
Message-ID: <455E4703.3080005@s5r6.in-berlin.de>
References: <455DF39A.6090209@fbihome.de> <455E2D44.5030903@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:60825 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1756037AbWKQXe3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Nov 2006 18:34:29 -0500
In-Reply-To: <455E2D44.5030903@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joern Quillmann <q-man@gmx.de>
Cc: linux-scsi@vger.kernel.org

Joern Quillmann wrote:
>> I have now the allow_restart entry in sysfs.
>> It's set to 0 in my machine and it won't let me change it with 'echo 1
>> > allow_restart' or echo -n. I always get a write error.
> 
> I just bought an external USB->IDE converter and tested it again.
> Of course due to the cheap concerter-chip the USB disk wont go to
> standby mode but I can set 'allow_restart' to 1 with this converter.
> 
> So maybe it's only about sbp2 implementation or specifically my OXFW911
> bridges?

FWIW, sbp2 in Linux 2.6.19-rcX sets the allow_restart flag for all HDDs
and other direct access devices. In Linux 2.6.18 it does so only for
Maxtor disks. Beyond setting that flag or leaving as it is, the sbp2
driver has nothing to do with the restart facility; it's a thing between
the SCSI error handler and the target. Of course the firmware of the
FireWire bridge has to support it in the first place. I have no data
which OXFW911 firmwares do or don't.

Also I don't remember which Linux release has the patch that exposes the
allow_restart flag as a writable sysfs attribute but I suppose if you
can see this attribute, then you have the patch. I can set and unset it
with echo on 2.6.19-rc4 just fine, as root of course.
-- 
Stefan Richter
-=====-=-==- =-== =--=-
http://arcgraph.de/sr/
