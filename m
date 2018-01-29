From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [LSF/MM TOPIC] Two blk-mq related topics
Date: Mon, 29 Jan 2018 15:40:31 -0500
Message-ID: <20180129204031.GA5499@redhat.com>
References: <20180129154455.GB17176@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60700 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752015AbeA2Ukg (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
        Mon, 29 Jan 2018 15:40:36 -0500
Content-Disposition: inline
In-Reply-To: <20180129154455.GB17176@ming.t460p>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: lsf-pc@lists.linux-foundation.org, Linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org

On Mon, Jan 29 2018 at 10:46am -0500,
Ming Lei <ming.lei@redhat.com> wrote:
 
> 2. When to enable SCSI_MQ at default again?
> 
> SCSI_MQ is enabled on V3.17 firstly, but disabled at default. In V4.13-rc1,
> it is enabled at default, but later the patch is reverted in V4.13-rc7, and
> becomes disabled at default too.
> 
> Now both the original reported PM issue(actually SCSI quiesce) and the
> sequential IO performance issue have been addressed. And MQ IO schedulers
> are ready too for traditional disks. Are there other issues to be addressed
> for enabling SCSI_MQ at default? When can we do that again?
> 
> Last time, the two issues were reported during V4.13 dev cycle just when it is
> enabled at default, that seems if SCSI_MQ isn't enabled at default, it wouldn't
> be exposed to run/tested completely & fully.  
> 
> So if we continue to disable it at default, maybe it can never be exposed to
> full test/production environment.

I was going to propose revisiting this as well.

I'd really like to see all the old .request_fn block core code removed.

But maybe we take a first step of enabling:
CONFIG_SCSI_MQ_DEFAULT=Y
CONFIG_DM_MQ_DEFAULT=Y

Thanks,
Mike
