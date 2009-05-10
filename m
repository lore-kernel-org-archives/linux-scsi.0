From: "Norman Diamond" <n0diamond@yahoo.co.jp>
Subject: Re: Adaptec driver crashes (1/3 and 2/3)
Date: Sun, 10 May 2009 19:09:25 +0900
Message-ID: <C112FA2011134214977C4C45098BBB48@DIAMOND8600>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-2022-jp";
	reply-type=response
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp11.mail.tnz.yahoo.co.jp ([203.216.226.139]:49137 "HELO
	smtp11.mail.tnz.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750830AbZEJKKE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 May 2009 06:10:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Norman Diamond (I) wrote:
> James Bottomley wrote:
>> On Wed, 2009-05-06 at 16:13 +0900, Norman Diamond wrote:
>>> The easiest 100% reproducible way to crash a Linux system is as follows.
>>>
>>> Insert either an Adaptec 1460 PCMCIA card or Adaptec 1480 CardBus card. 
>>> Remove the card.  Insert the card again.  Even if you knew to set the 
>>> console to a text mode terminal first (since Linux doesn't give Blue 
>>> Screens of Death otherwise), you still won't get a dump.  Not much to go 
>>> on without a dump, but at least it's 100% repro.
>>
>> Sounds like something's still pinned.  When you remove it the first time, 
>> can you remove the module? (that's aha152x_cs right?).
>
> With the 1460, after removing the first time, no I couldn't rmmod the 
> module.
> However, yesterday with the 1460 I couldn't repro the kernel crash. 
> Yesterday with the 1460 I could only repro less severe lossage.

Today I tried Knoppix 6.0.1, kernel 2.6.28.4.  aha152x_cs is a module here 
too.  When inserting a 1460, nothing happened.  Removing a 1460, nothing 
happened.  Inserting a 1460, nothing happened.  I modprobed aha152x_cs.  It 
modprobed successfully.  Removing a 1460, inserting, removing, inserting, 
nothing happened, even though the module remained loaded.  The older 
partially working kernel was better than this.

> Yesterday with the 1480 I did repro the kernel crash, the same as before. 
> The aic7xxx driver was compiled in, not a module.

Today with Knoppix 6.0.1, kernel 2.6.28.4, this one is worse too.  Here 
aic7xxx is a module, not compiled in.  I don't remember if I had to modprobe 
it manually but I think not.  I think that inserting a 1480 automatically 
modprobed the module and it worked for the time being.  However, removing 
the card started the time bomb.  Reinsertion was no longer necessary. 
Around 20 seconds after removal, if the console was in text mode then there 
would be a 1-line crash message with no dump.  Attempts to rmmod aic7xxx 
failed.  It didn't matter if I tried 0, 1, or multiple times while the time 
bomb was running, rmmod failed and the crash was still coming.

One time I shut down Knoppix 6.0.1 from whatever KDE's Start button is 
called, the usual way of doing a shutdown, instead of letting a crash do it. 
When the CD-ROM tray popped open, I guessed that Knoppix was nearly done 
shutting down, so I hit the Enter key, and the power went off a few seconds 
later.  Older versions had some text mode messages on the screen during 
shutdown, and told us at the same time as it popped open the CD tray.  OK, 
this one isn't the fault of a SCSI driver.

Sometimes there are reasons to stick to older partially working versions. 

--------------------------------------
Power up the Internet with Yahoo! Toolbar.
http://pr.mail.yahoo.co.jp/toolbar/
