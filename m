From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH V2 0/8] blk-mq/scsi-mq: support global tags & introduce
 force_blk_mq
Date: Tue, 6 Feb 2018 16:15:50 -0700
Message-ID: <27ff9093-82f0-c113-96b4-bbd2ceb36b75@kernel.dk>
References: <20180205152035.15016-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:34290 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753375AbeBFXPy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Feb 2018 18:15:54 -0500
Received: by mail-pl0-f66.google.com with SMTP id q17so2263352pll.1
        for <linux-scsi@vger.kernel.org>; Tue, 06 Feb 2018 15:15:54 -0800 (PST)
In-Reply-To: <20180205152035.15016-1-ming.lei@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Arun Easi <arun.easi@cavium.com>, Omar Sandoval <osandov@fb.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Don Brace <don.brace@microsemi.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Peter Rivera <peter.rivera@broadcom.com>, Paolo Bonzini <pbonzini@redhat.com>, Laurence Oberman <loberman@redhat.com>

On 2/5/18 8:20 AM, Ming Lei wrote:
> Hi All,
> 
> This patchset supports global tags which was started by Hannes originally:
> 
> 	https://marc.info/?l=linux-block&m=149132580511346&w=2
> 
> Also inroduce 'force_blk_mq' and 'host_tagset' to 'struct scsi_host_template',
> so that driver can avoid to support two IO paths(legacy and blk-mq), especially
> recent discusion mentioned that SCSI_MQ will be enabled at default soon.
> 
> 	https://marc.info/?l=linux-scsi&m=151727684915589&w=2
> 
> With the above changes, it should be easier to convert SCSI drivers'
> reply queue into blk-mq's hctx, then the automatic irq affinity issue can
> be solved easily, please see detailed descrption in commit log and the
> 8th patch for converting HPSA.
> 
> Also drivers may require to complete request on the submission CPU
> for avoiding hard/soft deadlock, which can be done easily with blk_mq
> too.
> 
> 	https://marc.info/?t=151601851400001&r=1&w=2
> 
> The 6th patch uses the introduced 'force_blk_mq' to fix virtio_scsi
> so that IO hang issue can be avoided inside legacy IO path, this issue is
> a bit generic, at least HPSA/virtio-scsi are found broken with v4.15+.
> 
> The 7th & 8th patch fixes HPSA's IO issue which is caused by the reply
> queue selection algorithem.
> 
> Laurence has verified that this patch makes HPSA working with the linus
> tree with this patchset.

Do you have any performance numbers for this patchset? I'd be curious
to know how big the hit is.

-- 
Jens Axboe
