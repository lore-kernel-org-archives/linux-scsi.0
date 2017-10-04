From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 9/9] bsg: split handling of SCSI CDBs vs transport requeues
Date: Wed, 04 Oct 2017 09:18:11 +0200
Message-ID: <mqd7ewbidos.fsf@linux-x5ow.site>
References: <20171003104845.10417-1-hch@lst.de>
        <20171003104845.10417-10-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49722 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751331AbdJDHS3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 4 Oct 2017 03:18:29 -0400
In-Reply-To: <20171003104845.10417-10-hch@lst.de> (Christoph Hellwig's message
        of "Tue, 3 Oct 2017 12:48:45 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Benjamin Block <bblock@linux.vnet.ibm.com>

Christoph Hellwig <hch@lst.de> writes:
[...]
> @@ -965,7 +932,8 @@ void bsg_unregister_queue(struct request_queue *q)
>  EXPORT_SYMBOL_GPL(bsg_unregister_queue);
>  
>  int bsg_register_queue(struct request_queue *q, struct device *parent,
> -		       const char *name, void (*release)(struct device *))
> +		const char *name, const struct bsg_ops *ops,
> +		void (*release)(struct device *))

Wouldn't it make sense to put the ->release() method into bsg_ops as
well? The current prototype of bsg_register_queue isn't exactly what I
would call a sane API.

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
