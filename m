From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] LDM-based scsi host lookup
Date: Wed, 28 May 2003 00:44:09 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030528074409.GB2028@beaverton.ibm.com>
References: <20030527112550.GB13798@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:52929 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S264590AbTE1H23
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 May 2003 03:28:29 -0400
Content-Disposition: inline
In-Reply-To: <20030527112550.GB13798@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

Looks good. One code comment below.

I have a core class for each child interator patch. Do you think we
should use that instead. It would protect the SCSI code in case the core
changed on how class children are protected. It does have a little more
overhead then your loop though.

Christoph Hellwig [hch@lst.de] wrote:
> @@ -522,16 +522,33 @@
>  }
>  
>  /**
> - * scsi_host_hn_get - get a Scsi_Host by host no and inc ref count
> - * @host_no:	host number to locate
> - *
> - * Return value:
> - * 	A pointer to located Scsi_Host or NULL.
> - **/
> -struct Scsi_Host *scsi_host_hn_get(unsigned short host_no)
> + * scsi_host_lookup - get a reference to a Scsi_Host by host no
> + *
> + * @hostnum:	host number to locate
> + *
> + * Return value:
> + *	A pointer to located Scsi_Host or NULL.
> + **/
> +struct Scsi_Host *scsi_host_lookup(unsigned short hostnum)
>  {
> -	/* XXX Inc ref count */
> -	return scsi_find_host_by_num(host_no);
> +	struct class *class = class_get(&shost_class);
> +	struct class_device *cdev;
> +	struct Scsi_Host *shost = NULL, *p;
> +
> +	if (class) {
> +		down_read(&class->subsys.rwsem);
> +		list_for_each_entry(cdev, &class->children, node) {
> +			p = class_to_shost(cdev);
> +			if (p->host_no == hostnum) {
> +				scsi_host_get(p);
> +				shost = p;
> +				break;
> +			}
> +		}
> +		up_read(&class->subsys.rwsem);
> +	}
> +
Need class_put(&shost_class); here ?

> +	return shost;
>  }
-andmike
--
Michael Anderson
andmike@us.ibm.com

