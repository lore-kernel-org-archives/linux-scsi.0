From: "Justin P. Mattock" <justinmattock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 5/5]scsi:hosts.c Fix warning: variable 'rval' set but
 not used
Date: Thu, 17 Jun 2010 09:16:41 -0700
Message-ID: <4C1A4A69.7060801@gmail.com>
References: <1276666434-11227-1-git-send-email-justinmattock@gmail.com>	 <1276666434-11227-6-git-send-email-justinmattock@gmail.com>	 <1276702443.2847.153.camel@mulgrave.site>  <4C18F524.4000902@gmail.com> <1276709590.2847.176.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1276709590.2847.176.camel-0iu6Cu4xQGLYCGPCin2YbQ@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-l3A5Bk7waGM@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


> Erm, well, as I said, error code and the fact that the thread failed to
> start, so more
>
> printk(KERN_WARNING "scsi%d: error handler thread failed to spawn, error
> = %d\n", host->host_no, PTR_ERR(shost->ehandler));
>
> James
>

o.k. I looked at this a bit more and finally got the thing to build 
through without a warning, using what you had sent, but keep in mind I 
still need to add error  = %d\n", host->host_no, to the printk

here's what I have so far:


  drivers/scsi/hosts.c |    3 ++-
  1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 6660fa9..c1ff708 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -419,8 +419,9 @@ struct Scsi_Host *scsi_host_alloc(struct 
scsi_host_template *sht, int privsize)

  	shost->ehandler = kthread_run(scsi_error_handler, shost,
  			"scsi_eh_%d", shost->host_no);
+	rval = PTR_ERR(shost->ehandler);
  	if (IS_ERR(shost->ehandler)) {
-		rval = PTR_ERR(shost->ehandler);
+		printk(KERN_WARNING "scsi%d: error handler thread failed to spawn\n", 
rval);
  		goto fail_kfree;
  	}

I'll continue to look at this today!!

cheers,

Justin P. Mattock
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
