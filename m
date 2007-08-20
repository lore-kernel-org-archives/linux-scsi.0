From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] scsi_scan: Cope with kthread_run failing
Date: Mon, 20 Aug 2007 09:20:35 -0600
Message-ID: <20070820152035.GH30019@parisc-linux.org>
References: <118762312894-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:53009 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757117AbXHTPUg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Aug 2007 11:20:36 -0400
Content-Disposition: inline
In-Reply-To: <118762312894-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Oops.  I fail to drive git-send-email properly again.
James, when you're committing this, please use the
Subject: [PATCH] scsi_scan: Cope with kthread_run failing

On Mon, Aug 20, 2007 at 09:18:48AM -0600, Matthew Wilcox wrote:
> If kthread_run failed, we would fail to scan the host, and leak the
> allocated async_scan_data.  Since using a separate thread is just an
> optimisation, do the scan synchronously if we fail to spawn a thread.
> 
> Signed-off-by: Matthew Wilcox <matthew@wil.cx>
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 309b224..a001ca1 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1799,6 +1799,7 @@ static int do_scan_async(void *_data)
>   **/
>  void scsi_scan_host(struct Scsi_Host *shost)
>  {
> +	struct task_struct *p;
>  	struct async_scan_data *data;
>  
>  	if (strncmp(scsi_scan_type, "none", 4) == 0)
> @@ -1810,7 +1811,9 @@ void scsi_scan_host(struct Scsi_Host *shost)
>  		return;
>  	}
>  
> -	kthread_run(do_scan_async, data, "scsi_scan_%d", shost->host_no);
> +	p = kthread_run(do_scan_async, data, "scsi_scan_%d", shost->host_no);
> +	if (IS_ERR(p))
> +		do_scan_async(data);
>  }
>  EXPORT_SYMBOL(scsi_scan_host);
>  
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
