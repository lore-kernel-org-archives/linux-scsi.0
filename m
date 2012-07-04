From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC][PATCH] libata: enable SATA disk fua detection on default
Date: Wed, 4 Jul 2012 15:06:04 +0800
Message-ID: <20120704070604.GA17769@gmail.com>
References: <1336447443-4685-1-git-send-email-wenqing.lz@taobao.com>
 <20120703090441.GA4804@gmail.com>
 <4FF351F8.1000003@msgid.tls.msk.ru>
 <20120704024715.GA17095@gmail.com>
 <4FF3E478.50609@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4FF3E478.50609@msgid.tls.msk.ru>
Sender: linux-ide-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 04, 2012 at 10:36:40AM +0400, Michael Tokarev wrote:
> > Thanks for the reply.  Indeed it is quite a big project but we enable
> > FUA feature for SAS disk.  Is there any differences?
> 
> Yes, there's a very big difference with SAS disks.  Even in parallel SCSI
> world DPO/FUA has been enabled since the day it has been implemented IIRC,
> because, apparently, hardware raid controllers enabled it too.  In other
> words, it has been tested and proved to be working even before linux
> implementation.  When first SAS disks started appearing, DPO/FUA were
> enabled for them in linux already -- at that time any breakage were
> solely due to the particular disk model, and were easy to blacklist,
> if necessary, since only a few disk models were in production.
> 
> With SATA disks, initial hardware implementation proved to be more
> non-functional than functional, ie, initially there were more drives
> with non-working FUA.  I have a few not-so-old SATA drives here which
> behaves strangely when FUA is enabled (I don't remember exact details,
> but I had to disable FA again after I tried to enable it once, the
> system started behaving not as good as before).  So, for SATA drives,
> we've exactly the opposite picture: we've some proof that "generally,
> drives dislikes FUA", and now when fua has been disabled for a lot
> of drives and users, turning it on by default needs lots of testing.
> 
> But I ask again: what is the benefit of turning FUA on to start with?

Thanks for your clarification. :-)

Turning FUA on can reduce the overhead of flushes AFAIK.  In our product
system we have a lot of SATA disks with FUA, but we must add a boot
parameter 'libata.fua=1' to enable it.  Meanwhile there already has a
number of SATA disks that have supported this feature.  So I think maybe
we can enable it.

Regards,
Zheng
