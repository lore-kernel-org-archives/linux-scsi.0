From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Tue, 4 Mar 2008 09:59:46 +0100
Message-ID: <20080304085944.GG6704@kernel.dk>
References: <47CC7F3D.4010605@gmail.com> <20080304111056X.tomof@acm.org> <47CCB4D8.8090600@gmail.com> <20080304175302T.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080304175302T.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-ide-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: htejun@gmail.com, tomof@acm.org, James.Bottomley@HansenPartnership.com, efault@gmx.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 04 2008, FUJITA Tomonori wrote:
> On Tue, 04 Mar 2008 11:32:56 +0900
> Tejun Heo <htejun@gmail.com> wrote:
> 
> > FUJITA Tomonori wrote:
> > >> Yeah, libata did its own padding and needed to add draining.  Private
> > >> implementation was complex as hell and James suggested moving them to
> > >> block layer.  Are you suggesting moving them back to drivers?
> > > 
> > > No, I'm not. I've been working on the IOMMUs to remove such
> > > workarounds in LLDs.
> > > 
> > > What drivers need to do on this is just adding a padding length, that
> > > is, drivers don't need to change the structure of the sg list (like
> > > splitting a sg entry), right? And it doesn't break the SAS drivers
> > > that support SATAPI, does it?
> > > 
> > > But I agree that drivers want to get a complete sglist so I'm fine
> > > with adjusting sglist entries in the block layer with your secode
> > > patch (separate out padding from alignment). As we discussed, I'm fine
> > > with breaking sum(sg) == rq->data_len as long as rq->data_len means
> > > the true data length.
> > 
> > As long as the second patch is in, what value rq->data_len indicates
> > doesn't matter to drivers which don't use explicit padding or draining,
> > so the situation is much more controlled.  I don't care which value
> > rq->data_len would indicate.  I'd prefer it equal sum(sg) as that value
> > is what IDE and libata which will be the major users of padding and/or
> > draining expect in rq->data_len but fixing up that shouldn't be too
> > difficult.  I guess this can be determined by Jens.  If Jens likes
> > rq->data_len to contain requested transfer size, I'll post updated patches.
> 
> OK, I prefer rq->data_len means the true data length though you prefer
> rq->data_len means the allocated buffer length (the true data length
> plus padding and drain). We agree on other things. We can live with
> either way.
> 
> Jens, what's your preference?

I completely agree with you, ->data_len meaning true data length is way
cleaner imho. Only the driver should care for the padded length, all
other parts of the kernel only need to know what they actually got.

-- 
Jens Axboe

