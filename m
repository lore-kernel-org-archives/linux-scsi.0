From: Chase Venters <chase.venters@clientec.com>
Subject: Re: More information on scsi_cmd_cache leak... (bisect)
Date: Fri, 27 Jan 2006 12:58:01 -0600 (CST)
Message-ID: <Pine.LNX.4.64.0601271255530.27170@turbotaz.ourhouse>
References: <200601270410.06762.chase.venters@clientec.com>
 <Pine.LNX.4.62.0601271335470.8977@pureeloreel.qftzy.pbz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay02.pair.com ([209.68.5.16]:49415 "HELO relay02.pair.com")
	by vger.kernel.org with SMTP id S1751553AbWA0S6F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jan 2006 13:58:05 -0500
In-Reply-To: <Pine.LNX.4.62.0601271335470.8977@pureeloreel.qftzy.pbz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ariel <askernel2615@dsgml.com>
Cc: Chase Venters <chase.venters@clientec.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, akpm@osdl.org, a.titov@host.bg, axboe@suse.de, jamie@audible.transient.net, neilb@suse.de, arjan@infradead.org

On Fri, 27 Jan 2006, Ariel wrote:
>
> On Fri, 27 Jan 2006, Chase Venters wrote:
>
>>  	After dealing with this leak for a while, I decided to do some
>>  dancing around
>>  with git bisect. I've landed on a possible point of regression:
>>
>>  commit: a9701a30470856408d08657eb1bd7ae29a146190
>>  [PATCH] md: support BIO_RW_BARRIER for md/raid1
>
> I can confirm that it only leaks with raid!
>
> I rebooted with my raid5 root, read only, and it didn't leak. As soon as I 
> remount,rw it started leaking. Go back to ro and it stopped (although it 
> didn't clean up the old leaks). Tried my raid1 /boot and same thing - rw 
> leaks, ro doesn't. But, it only leaks on activity.
>
> I then tried a regular lvm mount (with root ro), and no leaks!
>
> What's interesting is that the mount was ro NOT the md (which can be set ro 
> independently). So it looks like it only leaks if you write to the md device, 
> and that's why setting the mount ro stopped the leaks.

Yeah, if the mount is ro, md won't have any reasons to write the 
superblock any more, which means it won't be sending out bio's with 
barriers any more.

I'm in the middle of a crash course on block IO and SATA, but hopefully 
some more skillful devs will beat me to the punch :)

> 	-Ariel

Cheers,
Chase
