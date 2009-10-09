From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: SCSI queue warnings under 2.6.31 with LSI SAS1064E controller
Date: Fri, 9 Oct 2009 17:34:42 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C1C8ED6A4B4@inbmail01.lsi.com>
References: <ham9d4$ihu$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:59813 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753445AbZJIMGQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Oct 2009 08:06:16 -0400
In-Reply-To: <ham9d4$ihu$1@ger.gmane.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jason White <jason@jasonjgw.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Jason,

MPTSAS driver has support for QUEUE FULL event introduced in 2.6.31.
These prints are related to QUEUE FULL events messages.

If you remove below patch things may work fine for you.
	http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=57e985136bfafdfcd72c4c7d91115955d225677e


Now coming to the real issue.
I am suspecting there may be IO errors with your drive coming very frequently.

QUEUE FULL event is coming from Firmware whenever any change happens in device queue depth. This will only happens in IO error path. (We can think of flow control will kicked off when IO error occurs at firmware level and they will inform Driver saying Queue full event).

In other words,
If you replace with newer SAS drive, things may work fine even with 2.6.31.

As you have mentioned that this SAS drive was previously used for striping, there may be possibility of poor performance of your SAS drive.

Thanks,
Kashyap








-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Jason White
Sent: Friday, October 09, 2009 8:37 AM
To: linux-scsi@vger.kernel.org
Subject: SCSI queue warnings under 2.6.31 with LSI SAS1064E controller

With apologies in advance if this is the wrong mailing list for this, after
upgrading from 2.6.30 to 2.6.31 I get the following warnings in syslog
frequently

Oct  9 12:19:21 jdc kernel: [ 1785.096275] sd 6:1:0:0: strange observation,
the queue depth is (64) meanwhile fw queue depth (65)
Oct  9 12:19:51 jdc kernel: [ 1815.312019] sd 6:1:0:0: Queue depth not changed yet

The Debian bug report is here
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=550190

Following a suggestion by Debian developers, I tried patching 2.6.31.3 with
this commit, but with no effect.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=9d2e9d66a3f032667934144cd61c396ba49f090d

However, this also shows the problem can be reproduced under 2.6.31.3.

I would prefer to avoid running git bisect on this machine if I can, but I'll
gladly test a patch if it is unlikely to corrupt the file system.

HP XW6400 workstation, two SAS drives configured for striping, x86-64
architecture.

I haven't noticed any file corruption so far - I'm not sure how serious this
problem is.


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
