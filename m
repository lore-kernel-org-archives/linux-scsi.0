From: Matthias Prager <linux@matthiasprager.de>
Subject: Re: 'Device not ready' issue on mpt2sas since 3.1.10
Date: Tue, 17 Jul 2012 21:39:41 +0200
Message-ID: <5005BF7D.2050703@matthiasprager.de>
References: <4FE454CA.6080007@matthiasprager.de> <4FFAED4F.3080100@matthiasprager.de> <4FFB32E5.1050109@farcaster.org> <4FFB7354.8040809@matthiasprager.de> <4FFB8A86.7000009@farcaster.org> <4FFCBA4C.4000502@farcaster.org> <4FFD6F3D.2030708@matthiasprager.de> <4FFD8410.7050604@matthiasprager.de> <20120717180932.GB2878@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dd15408.kasserver.com ([85.13.136.168]:36323 "EHLO
	dd15408.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab2GQTjv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2012 15:39:51 -0400
In-Reply-To: <20120717180932.GB2878@google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Robert Trace <maillist@farcaster.org>, linux-scsi@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>

Hello Tejun,

Am 17.07.2012 20:09, schrieb Tejun Heo:
> Hello,
> 
> On Wed, Jul 11, 2012 at 03:48:00PM +0200, Matthias Prager wrote:
>> I'm trying to understand why this commit leads to the issue of i/o
>> failing on spun down drives, in hopes of being able to fix it. Meanwhile
>> maybe Tejun Heo (author of the commit) or Jens Axboe (the committer) are
>> able to shed some light on this (I've included them in the CC list).
> 
> Nothing rings a bell for me.  How does it fail?  The only thing it
> change is when and which media check commands are issued.

I will try to describe the issue as best as I can (please feel free to
point me to more helpful debugging steps or guides):
Whenever I put a drive to sleep (either via 'hdparm -y ...' or by
letting it run into standby timeout) and issue i/o's afterwards (like
with the help of 'fdisk -l') I get back i/o errors (along the lines of
'end_request: I/O error, ...' - see previous posts in this thread) and
the drive remains in standby (instead of waking up).

Robert (who also saw these errors) bisected the issue down to your
patch. And without it kernels 3.1.10 + 3.4.4 run smoothly for him and me.

I could not however reproduce the issue on any other device than a LSI
SAS controller (using SATA disks) - on a regular ICH10 using AHCI and a
SATA drive I don't see these i/o errors. But since I'm experiencing
these issues on two different systems (both with lsi controllers while
running vmware-guests on them) and Robert sees them on his
(non-virtualized) system with the same lsi controller (9211-8i), I'm
inclined to make the following assumptions:
Either it is an issue which is limited to this controller and possibly
sata disks hanging off it or it is a more general issue with sas
controllers and sata disks (again it could well affect sas disks too).
Lacking other controllers or sas disks I can't be sure.

Thank you for taking the time to look into this - it's much appreciated
Matthias
