From: Tim Small <tim@seoss.co.uk>
Subject: Re: [PATCH 0/4] Fix performance burning or extracting audio etc.
 from multiple optical drives.
Date: Thu, 05 Nov 2015 09:36:32 +0000
Message-ID: <563B2320.9070106@seoss.co.uk>
References: <20141121100210.GC8866@infradead.org> <1416924562-16849-1-git-send-email-tim@seoss.co.uk> <20151105013806.GA21819@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay1.allsecuredomains.com ([78.47.251.4]:34204 "EHLO
	relay1.allsecuredomains.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030570AbbKEKNp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Nov 2015 05:13:45 -0500
In-Reply-To: <20151105013806.GA21819@animx.eu.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wakko Warner <wakko@animx.eu.org>
Cc: tim@buttersideup.com, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@fb.com>, Borislav Petkov <bp@alien8.de>, Tim Waugh <tim@cyberelk.net>

On 05/11/15 01:38, Wakko Warner wrote:
> I tested on a system with 3 drives.  ejecting all drives didn't happen at
> the same time, but I think it's because they are different brands and one
> didn't have a disc in.  I did notice the leds coming on about the same time
> though.  eject -t on all drives happened at the same time.
> 
> The patch I used previously on 3.3.0 removed all mutex_lock and mutex_unlock
> lines from sr.c where as this patchset didn't.  I plan on trying to burn 3
> dvds to see if it works.
> 
> Thanks for your work on the patches.

No problem.  I haven't had any time to follow up (and probably won't for
the foreseeable - I've got far too much on at the moment unfortunately),
and the locking issues looked non-trivial unfortunately.

In my testing burning, and audio extracting etc. worked pretty
flawlessly IIRC, it was just the eject/load path which seemed to have
locking issues.

The test was just a shell scripts which ran:

while true ; do eject /dev/sr0 ; eject -T /dev/sr0 ; done

for every drive in the system simultaneously.

Hopefully it's a good start if someone wants to pick it up.  It's
possible that there's an easy way of leaving the old mutexes (or adding
more) around the relevant open/eject/load paths only, but I can't
remember the code now unfortunately.

If anyone wants to have a go, I think I can probably rig up about 8
drives to a testrig here, and will be happy to give it a test.

Tim.
