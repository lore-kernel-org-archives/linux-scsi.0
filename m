From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] block: fix sg SG_DXFER_TO_FROM_DEV regression
Date: Thu, 9 Jul 2009 09:22:23 +0900
Message-ID: <20090709092159N.fujita.tomonori@lab.ntt.co.jp>
References: <20090706161004D.fujita.tomonori@lab.ntt.co.jp>
	<4A55378A.7060808@interlog.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:60071 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756795AbZGIAWg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2009 20:22:36 -0400
In-Reply-To: <4A55378A.7060808@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, sxzzsf@gmail.com

On Thu, 09 Jul 2009 02:19:22 +0200
Douglas Gilbert <dgilbert@interlog.com> wrote:

> FUJITA Tomonori wrote:
> > I overlooked SG_DXFER_TO_FROM_DEV support when I converted sg to use
> > the block layer mapping API (2.6.28).
> > 
> > Douglas Gilbert explained SG_DXFER_TO_FROM_DEV:
> > 
> > http://www.spinics.net/lists/linux-scsi/msg37135.html
> > 
> > =
> > The semantics of SG_DXFER_TO_FROM_DEV were:
> >    - copy user space buffer to kernel (LLD) buffer
> >    - do SCSI command which is assumed to be of the DATA_IN
> >      (data from device) variety. This would overwrite
> >      some or all of the kernel buffer
> >    - copy kernel (LLD) buffer back to the user space.
> > 
> > The idea was to detect short reads by filling the original
> > user space buffer with some marker bytes ("0xec" it would
> > seem in this report). The "resid" value is a better way
> > of detecting short reads but that was only added this century
> > and requires co-operation from the LLD.
> > =
> > 
> > This patch changes the block layer mapping API to support this
> > semantics. This simply adds another field to struct rq_map_data and
> > enables __bio_copy_iov() to copy data from user space even with READ
> > requests.
> > 
> > It's better to add the flags field and kills null_mapped and the new
> > from_user fields in struct rq_map_data but that approach makes it
> > difficult to send this patch to stable trees because st and osst
> > drivers use struct rq_map_data (they were converted to use the block
> > layer in 2.6.29 and 2.6.30). Well, I should clean up the block layer
> > mapping API.
> > 
> > zhou sf reported this regiression and tested this patch:
> > 
> > http://www.spinics.net/lists/linux-scsi/msg37128.html
> > http://www.spinics.net/lists/linux-scsi/msg37168.html
> 
> Wrote my own little test program and it gave the wrong
> result (as reported by zhou sf) in lk 2.6.30 . When
> this patch was applied, the expected result (i.e. a
> response with user supplied fill characters) was observed.
> 
> Here is an INQUIRY response set up for a length of
> 128 bytes with an 0xec fill character:
> 
> $ ./sg_dxfer_to_from
> resid indicates that 96 bytes returned in response
>   00     00 00 05 02 5b 00 10 0a  4c 69 6e 75 78 20 20 20
>   10     73 63 73 69 5f 64 65 62  75 67 20 20 20 20 20 20
>   20     30 30 30 34 00 00 00 00  00 00 00 00 00 00 00 00
>   30     00 00 00 00 00 00 00 00  00 00 00 77 03 14 03 3d
>   40     0c 0f 00 00 00 00 00 00  00 00 00 00 00 00 00 00
>   50     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
>   60     ec ec ec ec ec ec ec ec  ec ec ec ec ec ec ec ec
>   70     ec ec ec ec ec ec ec ec  ec ec ec ec ec ec ec ec
> 
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

Thanks for testing!

Jens, please apply this patch.
