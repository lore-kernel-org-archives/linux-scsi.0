From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] first cut at fixing unable to requeue with no outstanding commands
Date: Mon, 30 Sep 2002 16:28:11 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020930232811.GA1372@beaverton.ibm.com>
References: <200209302106.g8UL6ab29262@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200209302106.g8UL6ab29262@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley [James.Bottomley@steeleye.com] wrote:
> +		if(SHpnt->host_busy == 0 && SHpnt->host_blocked) {
> +			/* unblock after host_blocked iterates to zero */
> +			if(--SHpnt->host_blocked == 0) {
> +				printk("scsi%d unblocking host at zero depth\n", SHpnt->host_no);
> +			} else {
> +				blk_plug_device(q);
> +				break;
> +			}
> +		}
> +				

Are we guaranteed that blk_run_queues will be called for all types of
I/O?

-andmike
--
Michael Anderson
andmike@us.ibm.com

