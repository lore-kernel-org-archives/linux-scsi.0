From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] convert 53c700 driver to use change_queue_depth API
Date: Mon, 20 Dec 2004 16:42:02 +0100 (CET)
Message-ID: <Pine.LNX.4.60.0412201605360.15046@poirot.grange>
References: <1102812847.5232.6.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:55758 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S261576AbULTPoM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Dec 2004 10:44:12 -0500
In-Reply-To: <1102812847.5232.6.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

In the comment to the method declaration:

On Sat, 11 Dec 2004, James Bottomley wrote:

> 	/*
> +	 * fill in this function to allow the queue depth of this host
> +	 * to be changeable (on a per device basis).  returns either
> +	 * the current queue depth setting (may be different from what
> +	 * was passed in) or an error.  An error should only be
> +	 * returned if the requested depth is legal but the driver was
> +	 * unable to set it.  If the requested depth is illegal, the
> +	 * driver should set and return the closest legal queue depth.
> +	 *
> +	 */
> +	int (* change_queue_depth)(struct scsi_device *, int);

And then you implement it for the 53c700 as follows:

> ===== drivers/scsi/53c700.c 1.58 vs edited =====
> --- 1.58/drivers/scsi/53c700.c	2004-10-20 19:41:52 -05:00
> +++ edited/drivers/scsi/53c700.c	2004-12-11 17:48:57 -06:00

...

> @@ -2102,18 +2104,14 @@
>  	/* to do here: deallocate memory */
>  }
>  
> -static ssize_t
> -NCR_700_store_queue_depth(struct device *dev, const char *buf, size_t count)
> +static int
> +NCR_700_change_queue_depth(struct scsi_device *SDp, int depth)
>  {
> -	int depth;
> -
> -	struct scsi_device *SDp = to_scsi_device(dev);
> -	depth = simple_strtoul(buf, NULL, 0);
>  	if(depth > NCR_700_MAX_TAGS)
> -		return -EINVAL;
> +		depth = NCR_700_MAX_TAGS;
>  	scsi_adjust_queue_depth(SDp, MSG_ORDERED_TAG, depth);
>  
> -	return count;
> +	return depth;
>  }
>  
>  static ssize_t

Shouldn't it really be something like

 	if(depth > NCR_700_MAX_TAGS)
-		return -EINVAL;
+		depth = NCR_700_MAX_TAGS;
+	if (depth < 0)
+		depth = 0;
 	scsi_adjust_queue_depth(SDp, MSG_ORDERED_TAG, depth);
 
-	return count;
+	return SDp->queue_depth == depth ? depth : -EFAIL;
 }

And, actually (nitpicking), shouldn't the comment rather be

--- include/scsi/scsi_host.h~	Tue Dec 14 22:14:07 2004
+++ include/scsi/scsi_host.h	Mon Dec 20 16:21:08 2004
@@ -219,11 +219,10 @@
 	 * fill in this function to allow the queue depth of this host
 	 * to be changeable (on a per device basis).  returns either
 	 * the current queue depth setting (may be different from what
-	 * was passed in) or an error.  An error should only be
-	 * returned if the requested depth is legal but the driver was
-	 * unable to set it.  If the requested depth is illegal, the
-	 * driver should set and return the closest legal queue depth.
-	 *
+	 * was passed in) or an error.  If the requested depth is illegal,
+	 * the driver should set and return the closest legal queue depth.
+	 * An error should only be returned if the driver was unable to
+	 * set the new depth.
 	 */
 	int (* change_queue_depth)(struct scsi_device *, int);
 
? And one more (unrelated) question (possibly, known / discussed before): 
simple_strtoul converts "-1" to 0, whereas, glibc strtoul would return 
(unsigned long)-1. It is the intended behaviour, isn't it? Perhaps, worth 
documenting in vsprintf.c...

Thanks
Guennadi
---
Guennadi Liakhovetski

