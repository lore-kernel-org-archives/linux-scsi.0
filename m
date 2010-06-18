From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 5/5]scsi:hosts.c Fix warning: variable 'rval' set but
 not used
Date: Fri, 18 Jun 2010 14:37:07 -0500
Message-ID: <1276889827.2850.331.camel@mulgrave.site>
References: <1276666434-11227-1-git-send-email-justinmattock@gmail.com>
	 <1276666434-11227-6-git-send-email-justinmattock@gmail.com>
	 <1276702443.2847.153.camel@mulgrave.site>  <4C18F524.4000902@gmail.com>
	 <1276709590.2847.176.camel@mulgrave.site>  <4C1A4A69.7060801@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <4C1A4A69.7060801@gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2010-06-17 at 09:16 -0700, Justin P. Mattock wrote:
> > Erm, well, as I said, error code and the fact that the thread failed to
> > start, so more
> >
> > printk(KERN_WARNING "scsi%d: error handler thread failed to spawn, error
> > = %d\n", host->host_no, PTR_ERR(shost->ehandler));
> >
> > James
> >
> 
> o.k. I looked at this a bit more and finally got the thing to build 
> through without a warning, using what you had sent, but keep in mind I 
> still need to add error  = %d\n", host->host_no, to the printk
> 
> here's what I have so far:
> 
> 
>   drivers/scsi/hosts.c |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 6660fa9..c1ff708 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -419,8 +419,9 @@ struct Scsi_Host *scsi_host_alloc(struct 
> scsi_host_template *sht, int privsize)
> 
>   	shost->ehandler = kthread_run(scsi_error_handler, shost,
>   			"scsi_eh_%d", shost->host_no);
> +	rval = PTR_ERR(shost->ehandler);
>   	if (IS_ERR(shost->ehandler)) {
> -		rval = PTR_ERR(shost->ehandler);
> +		printk(KERN_WARNING "scsi%d: error handler thread failed to spawn\n", 
> rval);

So this isn't really an improvement over the suggestion.  What you
wanted was shost->host_no, as you deduced, but the %d becomes %ld to
quiet the type warning.

James
