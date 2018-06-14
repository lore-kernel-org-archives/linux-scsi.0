From: "hch@lst.de" <hch@lst.de>
Subject: Re: kernel BUG at drivers/scsi/scsi_error.c:197! - git
        4.17.0-x64-08428-g7d3bf613e99a
Date: Thu, 14 Jun 2018 10:32:52 +0200
Message-ID: <20180614083252.GA18536@lst.de>
References: <201806091606.51078.randrianasulu@gmail.com> <025bf705-15b0-65e5-4b16-6c91d41c1730@infradead.org> <40617b19667b3c1302f8a903c19f2fa2f409b12a.camel@wdc.com> <5ca74fb7-af70-31c3-0e3f-bace058e5a57@oracle.com> <20180613140411.GA32701@lst.de> <09e8bd7605febd091679172d68ca1e9ca3990c91.camel@wdc.com> <20180613143558.GA1163@lst.de> <77932f7b-08ba-7ece-3778-d7da82772057@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <77932f7b-08ba-7ece-3778-d7da82772057@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "jianchao.wang" <jianchao.w.wang@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>, "randrianasulu@gmail.com" <randrianasulu@gmail.com>, "rdunlap@infradead.org" <rdunlap@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 14, 2018 at 03:49:28PM +0800, jianchao.wang wrote:
> Yes, it will work for this issue.
> But we should also clear the RQF_TIMED_OUT in __blk_mq_requeue_request and blk_mq_rq_ctx_init.

blk_mq_rq_ctx_init always clears rq_flags, so we don't need to explcitly
clear it.

__blk_mq_requeue_request probablys needs it so that we handle the
case of requeuing from the error handling indeed.
