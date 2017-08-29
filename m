From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 3/3] scsi_transport_sas: Fix error handling in
        sas_smp_request()
Date: Tue, 29 Aug 2017 15:08:57 +0200
Message-ID: <20170829130857.GA29153@lst.de>
References: <20170828204149.28693-1-bart.vanassche@wdc.com> <20170828204149.28693-8-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170828204149.28693-8-bart.vanassche@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> -	blk_status_t ret;
> +	int ret;
>  	int (*handler)(struct Scsi_Host *, struct sas_rphy *, struct request *);

This part looks ok.

>  	while ((req = blk_fetch_request(q)) != NULL) {
> @@ -185,7 +185,9 @@ static void sas_smp_request(struct request_queue *q, struct Scsi_Host *shost,
>  				blk_rq_bytes(req->next_rq);
>  		handler = to_sas_internal(shost->transportt)->f->smp_handler;
>  		ret = handler(shost, rphy, req);
> -		scsi_req(req)->result = ret;
> +		WARN_ONCE(ret != 0 && !IS_ERR_VALUE((uintptr_t)ret),
> +			  "%s: ret = %d\n", __func__, ret);
> +		scsi_req(req)->result = ret ? DID_ERROR << 16 : 0;

This one doesn't.  All the way back until this code was fixed up
after the initial introduction it returned negative error codes
to user space.

Take a look at committs 7aa68e80bd481faae1234bc2a7e4bcc9348f98b4 and
2d507a01dac338831266b44ccbb01c69e84606ed for details.
