From: Willem Riede <wrlk@riede.org>
Subject: Re: [PATCH] get rid of ->init in osst
Date: Sun, 3 Nov 2002 16:07:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021103210745.GQ13860@linnie.riede.org>
References: <20021103215408.A8045@lst.de>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021103215408.A8045@lst.de>; from hch@lst.de on Sun, Nov 03, 2002 at 15:54:08 -0500
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On 2002.11.03 15:54 Christoph Hellwig wrote:
> Since osst is the last driver still implementing ->init and Willem said
> he's gonna do a major update including a resync with st anyway I think
> it's okay to put this hack in for now.  Instead of ->init beeing
> directly called from the midlayer osst_attach now calls in in the
> beginning - it has an internal protection so that the initialization
> will be called only one anyway.
> 
> 
> --- 1.22/drivers/scsi/osst.c	Fri Nov  1 07:28:19 2002
> +++ edited/drivers/scsi/osst.c	Sun Nov  3 20:08:25 2002
> @@ -163,7 +163,6 @@
>         tag:		"osst",
>         scsi_type:	TYPE_TAPE,
>         detect:		osst_detect,
> -       init:		osst_init,
>         attach:		osst_attach,
>         detach:		osst_detach
>  };
> @@ -5410,6 +5409,8 @@
> 
>  	if (SDp->type != TYPE_TAPE || !osst_supports(SDp))
>  		 return 1;
> +
> +	osst_init();
> 
>  	disk = alloc_disk(1);
>  	if (!disk)
> 
That's fine. I'm debugging that major update as we speak :-)

Regards, Willem Riede.

