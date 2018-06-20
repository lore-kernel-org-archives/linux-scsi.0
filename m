From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH 0/5]stop normal completion path entering a timeout req
Date: Wed, 20 Jun 2018 12:16:01 -0600
Message-ID: <20180620181601.GA24145@localhost.localdomain>
References: <1529500964-28429-1-git-send-email-jianchao.w.wang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1529500964-28429-1-git-send-email-jianchao.w.wang@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jianchao Wang <jianchao.w.wang@oracle.com>
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com, josef@toxicpanda.com, ulf.hansson@linaro.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 20, 2018 at 09:22:39PM +0800, Jianchao Wang wrote:
> Dear all
> 
> scsi timeout and error handler are based on an assumption that normal
> completion mustn't do anything on an timeout request. After 12f5b931
> (blk-mq: Remove generation seqeunce), we lost this. __blk_mq_complete
> request could ensure a request won't be completed twice, but it can
> still complete a timeout request.
> scsi (even other drivers) have been working on this assumption for many
> years, it is dangerous to discard it suddenly. This patch set is to regain this.

I certainly don't want to harm any drivers. Could you possibly explain
what about removing silent execptions from the completion handler and
letting drivers control the destiny of requests they own is "dangerous"?

A initial look at your proposal looks pretty harmful to me. A driver may
return BLK_EH_RESET_TIMER, then call blk_mq_complete_req from another
thread, and your patch will simply lose that request and escalate error
recovery. That seems exactly what you shouldn't want to happen.
