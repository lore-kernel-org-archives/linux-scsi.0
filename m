From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCHv2 1/1] SCSI: update hosts module to use idr index
 management
Date: Tue, 6 Oct 2015 02:40:40 -0700
Message-ID: <20151006094040.GA24624@infradead.org>
References: <cover.1444085255.git.lduncan@suse.com>
 <1a69690d615610c1dee725db7e6d81cf2db28266.1444085255.git.lduncan@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1a69690d615610c1dee725db7e6d81cf2db28266.1444085255.git.lduncan@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

>  struct Scsi_Host *scsi_host_lookup(unsigned short hostnum)
>  {
> -	struct device *cdev;
> -	struct Scsi_Host *shost = NULL;
> -
> -	cdev = class_find_device(&shost_class, NULL, &hostnum,
> -				 __scsi_host_match);
> -	if (cdev) {
> -		shost = scsi_host_get(class_to_shost(cdev));
> -		put_device(cdev);
> -	}
> +	struct Scsi_Host *shost;
> +
> +	spin_lock(&host_index_lock);
> +	shost = idr_find(&host_index_idr, hostnum);
> +	spin_unlock(&host_index_lock);
> +
>  	return shost;

How does this actually grab a reference to the host?
