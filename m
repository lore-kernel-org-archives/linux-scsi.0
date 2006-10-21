From: Sean Bruno <sean.bruno@dsl-only.net>
Subject: Re: Adaptec 29320 [aic79xx] fails on power cycle of LUN
Date: Sat, 21 Oct 2006 13:48:52 -0700
Message-ID: <1161463732.3204.66.camel@home-desk>
References: <1161210246.3204.17.camel@home-desk>
	 <1161210748.3204.22.camel@home-desk>  <1161237121.15090.9.camel@max>
	 <1161260730.3204.36.camel@home-desk>  <45378767.4080106@suse.de>
	 <1161274711.3204.41.camel@home-desk>  <45387462.10300@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iron2.pdx.net ([69.64.224.71]:5518 "EHLO iron2.pdx.net")
	by vger.kernel.org with ESMTP id S1751748AbWJUUs6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Oct 2006 16:48:58 -0400
In-Reply-To: <45387462.10300@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org

> > Better.  The patch allows me to cycle power on the array exactly once.
> > So the new regression is:
> > 
> > 1.  Hook an external SCSI array/disk to a 29320.
> > 2.  Power up SCSI array/disk
> > 3.  Power up PC with 29320.
> > 4.  When PC has booted, login and test device by creating a file
> >     system, eg. mkfs /dev/sda (or whatever disk the array is called on
> >     ur machine).
> > 5.  Power cycle array/disk
> > 6.  Retest device with another 'mkfs /dev/sda'  <-- works just fine!
> > 7.  Power cycle array/disk
> > 8.  No need to do anything, card dump in dmesg/messages appears and
> > device in not useable:
> > 
> Ok. Not bad. So we have to switch to non-pkt commands after a reset.
> Make sense. Care to try the updated patch?
> 
> Thanks for all the testing!
> 
> Cheers,

Looking much better with this patch.  

I spent some time to whack together a SCSI target on a second machine
with a QLA1040 that I have lying around and connected my test machine
with the 29320 to it. Essentially, I'm just too lazy to sit at my desk
an continually disconnect and reconnect the power on my array!  :)

After a couple of minutes of whacking on it, I was able to script
something to automatically cycle through 5 iterations of 'mkfs' then
reboot the new 'scsi disk', sleep for 120 seconds and repeat.

Seems to work fine with the patch applied to 2.6.19-rc2.  I'm running a
longer 100 iteration loop and I'll get back with results.

Sean

