From: "Norman Diamond" <n0diamond@yahoo.co.jp>
Subject: Re: Adaptec driver crashes (1/3 and 2/3)
Date: Sun, 10 May 2009 08:41:45 +0900
Message-ID: <4FF8388A0C334AB38FEA6F5DE0F0EA23@DIAMOND8600>
References: <8690A202112B4316A178F6DD0AD7E394@DIAMOND8600> <1241811537.3327.91.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-2022-jp";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp09.mail.tnz.yahoo.co.jp ([203.216.226.137]:36313 "HELO
	smtp09.mail.tnz.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751114AbZEIXmE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 May 2009 19:42:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Wed, 2009-05-06 at 16:13 +0900, Norman Diamond wrote:
>> The easiest 100% reproducible way to crash a Linux system is as follows.
>>
>> Insert either an Adaptec 1460 PCMCIA card or Adaptec 1480 CardBus card. 
>> Remove the card.  Insert the card again.  Even if you knew to set the 
>> console to a text mode terminal first (since Linux doesn't give Blue 
>> Screens of Death otherwise), you still won't get a dump.  Not much to go 
>> on without a dump, but at least it's 100% repro.
>
> Sounds like something's still pinned.  When you remove it the first time, 
> can you remove the module? (that's aha152x_cs right?).

With the 1460, after removing the first time, no I couldn't rmmod the 
module.  You're either right or nearly right about the module name since 
some were renamed to use hyphens instead of underbars, but I don't remember 
if that was included.  Anyway, the module was in use by 4 unknown users, and 
couldn't be rmmodded.

However, yesterday with the 1460 I couldn't repro the kernel crash. 
Yesterday with the 1460 I could only repro less severe lossage.  Removal of 
the card showed up in dmesg.  Reinsertions of the card were completely 
ignored, not showing up in dmesg, not recreating the special file /dev/sdb, 
and if I mknodded /dev/sdb it was still inaccessible (no such device).  Also 
shutdown hanged and I had to hold the power switch to shut down.

Yesterday with the 1480 I did repro the kernel crash, the same as before. 
The aic7xxx driver was compiled in, not a module.  I don't recall if removal 
of the card showed up in dmesg.  Reinsertion didn't, but the system lived 
long enough for dmesg to run and not show a reinsertion.  After that came a 
1 line kernel crash message with no dump.  If I recall correctly, 
Ctrl+Alt+Del accomplished a reboot so I didn't have to hold the power 
switch. 

--------------------------------------
Power up the Internet with Yahoo! Toolbar.
http://pr.mail.yahoo.co.jp/toolbar/
