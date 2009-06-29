From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: can't access LUN >2TB with aic7xxx, Infortrend EonStor and
	2.6.31-rc1
Date: Mon, 29 Jun 2009 07:34:31 -0600
Message-ID: <20090629133431.GM5480@parisc-linux.org>
References: <20090629130835.GA3657@mother.pipebreaker.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:33374 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbZF2Ne3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2009 09:34:29 -0400
Content-Disposition: inline
In-Reply-To: <20090629130835.GA3657@mother.pipebreaker.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomasz Torcz <tomek@pipebreaker.pl>
Cc: linux-scsi@vger.kernel.org

On Mon, Jun 29, 2009 at 03:08:35PM +0200, Tomasz Torcz wrote:
>   recently I've acquired Infortrend EonStor A16U-G2421 array
> with 16x 500GB SATA drives inside. It is connected via:
> 04:00.0 SCSI storage controller: Adaptec AHA-2940U2/U2W
> to host running Fedora 12 with following kernel:
> 2.6.31-0.33.rc1.git2.fc12.x86_64
> 
>   When I export LUN >2TB from array I got following errors:
> 
> scsi 5:0:0:1: Direct-Access     VW       VRU1610          347G PQ: 0 ANSI: 5
> scsi target5:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 127)
> scsi5:A:0:1: Tagged Queuing enabled.  Depth 4
> sd 5:0:0:1: Attached scsi generic sg3 type 0
> sd 5:0:0:1: [sdd] READ CAPACITY(16) failed
> sd 5:0:0:1: [sdd] Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK
> sd 5:0:0:1: [sdd] Sense not available.
> 
>   According to manufacturer, this array supports LUNs up to 64TB, 
> although >2TB LUNs require enigmatic ,,support from OS side''.
> I was under impression that aic7xxx supports them, but it seems
> not true. What can I tweak on the Linux side to use 6TB volumes?

SCSI commands come in different sizes.  Drivers are assumed to support
commands up to 12 bytes long, unless they report otherwise by setting
their max_cmd_len parameter.  Unfortunately, the command that reports
the device capacity for devices over 2TB is a 16 byte command, and the
aic7xxx driver doesn't claim it supports 16 byte commands, so we refuse
to even send it to the driver.

It's possible the aic7xxx hardware does support 16 byte commands.  If so,
this is an easy fix.  If it doesn't, you could try replacing the card
with one that does (for example, the LSI 8xx and 10xx cards all support
16 byte commands).

You could also go for a configuration fix where you reconfigure the array
with LUNs below 2TB and then use MD or DM to stitch them back together
into a single device.

Let's hope someone who understands the aic7xxx hardware can tell us
whether it supports 16 byte commands or not.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
