From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [libsas PATCH v12 04/11] sysfs: handle 'parent deleted before
 child added'
Date: Fri, 23 Mar 2012 13:54:24 -0700
Message-ID: <20120323205424.GA31689@kroah.com>
References: <20120322063127.22036.23206.stgit@dwillia2-linux.jf.intel.com>
 <20120322063214.22036.77957.stgit@dwillia2-linux.jf.intel.com>
 <20120322143959.GF19835@kroah.com>
 <1332528209.23830.4.camel@ultramagnus.opencreations.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36137 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab2CWUy2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Mar 2012 16:54:28 -0400
Received: by ghrr11 with SMTP id r11so3123305ghr.19
        for <linux-scsi@vger.kernel.org>; Fri, 23 Mar 2012 13:54:28 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1332528209.23830.4.camel@ultramagnus.opencreations.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On Fri, Mar 23, 2012 at 11:43:28AM -0700, Dan Williams wrote:
> On Thu, 2012-03-22 at 07:39 -0700, Greg Kroah-Hartman wrote:
> > And note, I hate pr_err(), what's wrong with printk() in this instance?
> 
> So how about an end run around the conversion to pr_err() and just make
> these proper WARN()s since we end up calling dump_stack in both cases?
> 
> Something like:
> 
> diff --git a/lib/kobject.c b/lib/kobject.c
> index e5f86c0..1bd0893 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -192,15 +192,14 @@ static int kobject_add_internal(struct kobject *kobj)
>  
>  		/* be noisy on error issues */
>  		if (error == -EEXIST)
> -			pr_err("%s failed for %s with "
> -			       "-EEXIST, don't try to register things with "
> -			       "the same name in the same directory.\n",
> -			       __func__, kobject_name(kobj));
> +			WARN(1, "%s failed for %s with "
> +			     "-EEXIST, don't try to register things with "
> +			     "the same name in the same directory.\n",
> +			     __func__, kobject_name(kobj));
>  		else
> -			pr_err("%s failed for %s (error: %d parent: %s)\n",
> -			       __func__, kobject_name(kobj), error,
> -			       parent ? kobject_name(parent) : "'none'");
> -		dump_stack();
> +			WARN(1, "%s failed for %s (error: %d parent: %s)\n",
> +			     __func__, kobject_name(kobj), error,
> +			     parent ? kobject_name(parent) : "'none'");

I'm missing why this isn't the exact same thing that is currently
happening...

confused,

greg k-h
