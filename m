From: "hch@lst.de" <hch@lst.de>
Subject: Re: kernel BUG at drivers/scsi/scsi_error.c:197! - git
        4.17.0-x64-08428-g7d3bf613e99a
Date: Wed, 13 Jun 2018 16:04:11 +0200
Message-ID: <20180613140411.GA32701@lst.de>
References: <201806091606.51078.randrianasulu@gmail.com> <025bf705-15b0-65e5-4b16-6c91d41c1730@infradead.org> <40617b19667b3c1302f8a903c19f2fa2f409b12a.camel@wdc.com> <5ca74fb7-af70-31c3-0e3f-bace058e5a57@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5ca74fb7-af70-31c3-0e3f-bace058e5a57@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "jianchao.wang" <jianchao.w.wang@oracle.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "randrianasulu@gmail.com" <randrianasulu@gmail.com>, "rdunlap@infradead.org" <rdunlap@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> I suspect this is due to we could expire a same request twice or even more.
> For scsi mid-layer, it return BLK_EH_DONE from .timeout, in fact, the request is not
> completed there, but just queue a delayed abort_work (HZ/100). If the blk_mq_timeout_work
> runs again before the abort_work, the request will be timed out again, because there is not
> any mark on it to identify this request has been timed out.
> 
> Would please try the patch attached on to see whether this issue could be fixed ?
> (this patch only works for scsi device currently)

The patch isn't really going to work without a caller of your new
__blk_mq_complete_request helper, is it?

Either way the concept of doing error handling without quiescing the
queue just looks bogus to me and will end up with some sort of race
here or there.
