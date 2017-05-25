From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 12/31] bsg: Check queue type before attaching to a queue
Date: Wed, 24 May 2017 22:01:21 -0400
Message-ID: <yq1shjtsnim.fsf@oracle.com>
References: <20170524003420.5381-1-bart.vanassche@sandisk.com>
        <20170524003420.5381-13-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170524003420.5381-13-bart.vanassche@sandisk.com> (Bart Van
        Assche's message of "Tue, 23 May 2017 17:34:01 -0700")
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Omar Sandoval <osandov@fb.com>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org


Bart,

> Since BSG only supports request queues for which struct scsi_request
> is the first member of their private request data, refuse to register
> block layer queues for which struct scsi_request is not the first
> member of their private data.

> +
> +	if (!blk_queue_scsi_sup(rq)) {

If you are renaming the flag, how about blk_queue_scsi_pdu()?

> +		WARN_ONCE(true, "Attempt to register a non-SCSI queue\n");
> +		return ERR_PTR(-EINVAL);
> +	}
> +
>  	if (!blk_get_queue(rq))
>  		return ERR_PTR(-ENXIO);

-- 
Martin K. Petersen	Oracle Linux Engineering
