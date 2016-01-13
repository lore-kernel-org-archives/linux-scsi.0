From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [LSF/MM ATTEND][LSF/MM TOPIC] Multipath redesign
Date: Wed, 13 Jan 2016 18:06:13 +0200
Message-ID: <569675F5.8070501@dev.mellanox.co.il>
References: <56961493.5010901@suse.de> <56962BDB.4080509@dev.mellanox.co.il>
 <20160113154243.GA2563@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:36284 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbcAMQGT (ORCPT
	<rfc822;Linux-scsi@vger.kernel.org>); Wed, 13 Jan 2016 11:06:19 -0500
Received: by mail-wm0-f43.google.com with SMTP id l65so299709721wmf.1
        for <Linux-scsi@vger.kernel.org>; Wed, 13 Jan 2016 08:06:19 -0800 (PST)
In-Reply-To: <20160113154243.GA2563@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, device-mapper development <dm-devel@redhat.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>


> This sounds like you aren't actually using blk-mq for the top-level DM
> multipath queue.

Hmm. I turned on /sys/module/dm_mod/parameters/use_blk_mq and indeed
saw a significant performance improvement. Anything else I was missing?

> And your findings contradicts what I heard from Keith
> Busch when I developed request-based DM's blk-mq support, from commit
> bfebd1cdb497 ("dm: add full blk-mq support to request-based DM"):
>
>       "Just providing a performance update. All my fio tests are getting
>        roughly equal performance whether accessed through the raw block
>        device or the multipath device mapper (~470k IOPS). I could only push
>        ~20% of the raw iops through dm before this conversion, so this latest
>        tree is looking really solid from a performance standpoint."

I too see ~500K IOPs, but my nvme can push ~1500K IOPs...
Its a simple nvme loopback [1] backed by null_blk.

[1]:
http://lists.infradead.org/pipermail/linux-nvme/2015-November/003001.html
http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/nvme-loop.2
