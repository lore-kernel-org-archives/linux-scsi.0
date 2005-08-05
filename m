From: Tejun Heo <htejun@gmail.com>
Subject: Re: calling scsi_adjust_queue_depth() during I/O...
Date: Sat, 6 Aug 2005 02:10:34 +0900
Message-ID: <20050805171034.GA5046@htj.dyndns.org>
References: <20050804234155.GJ13374@plap.qlogic.org> <20050805075751.GN9369@suse.de> <20050805110911.GA22867@htj.dyndns.org> <42F350E6.2090109@gmail.com> <20050805123301.GA3311@htj.dyndns.org> <1123259528.5003.36.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.205]:1900 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262979AbVHERKk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Aug 2005 13:10:40 -0400
Received: by rproxy.gmail.com with SMTP id r35so584607rna
        for <linux-scsi@vger.kernel.org>; Fri, 05 Aug 2005 10:10:40 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1123259528.5003.36.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <axboe@suse.de>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Aug 05, 2005 at 11:32:07AM -0500, James Bottomley wrote:
> On Fri, 2005-08-05 at 21:33 +0900, Tejun Heo wrote:
> >  Here's the fix.  It basically revives bqt->real_max_depth sans
> > allocation optimization in init_tag_map.  I've also added a comment
> > explicitly noting that tag map cannot be shrunk to prevent other
> > morons like me.  :-( Please try this one and let me know how it works.
> > If this is the correct fix, I'll repost properly to Jens and lkml with
> > detailed explanation on how it was broken in the original code and how
> > I broke it with my previous patch.  Sorry.
> 
> Actually, if you really want to adjust the array size downwards, there's
> a way we can do it:
> 
> - If the bits that would be lost on shrinkage are all zero at the time
> blk_queue_resize_tags() is called, that means that there are no
> outstanding tags up there and the array can be shrunk immediately.
> 
> - If there are outstanding tags between the new and the old depth, the
> array can be shrunk when the last one of these returns, say in
> blk_rq_end_tag()
> 

 Hello, James.

 Yes, we can do that, but I'm not sure if that would be necessary.
AFAIK, queues are normally not very deep and a tag only occupies one
pointer and one bit.  Also, the shrinking operation isn't very common,
at least for traditional SPI devices and SATA drives, I think.

 Are newer SCSI devices (say, SAS/iSCSI) different? - like having very
deep queue and needing dynamic queue depth adjustment?  If that's the
case, I think I can implement shrinking in a separate patch. (and try
not to screw up this time ;-)

 Thank you.

-- 
tejun
