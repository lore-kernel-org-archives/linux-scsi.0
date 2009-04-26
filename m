From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH -next] osd_uld: fix printk format warning
Date: Sun, 26 Apr 2009 18:32:57 +0300
Message-ID: <49F47EA9.3070204@panasas.com>
References: <49F0E43B.80501@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:38662 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbZDZPdE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Apr 2009 11:33:04 -0400
Received: by fxm2 with SMTP id 2so1871044fxm.37
        for <linux-scsi@vger.kernel.org>; Sun, 26 Apr 2009 08:33:03 -0700 (PDT)
In-Reply-To: <49F0E43B.80501@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>

On 04/24/2009 12:57 AM, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix printk format warnings in osd_uld:
> 
> drivers/scsi/osd/osd_uld.c:191: warning:format '%s' expects type 'char *', but argument 2 has type 'struct path'
> 
> Also fix a small typo.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/scsi/osd/osd_uld.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-next-20090423.orig/drivers/scsi/osd/osd_uld.c
> +++ linux-next-20090423/drivers/scsi/osd/osd_uld.c
> @@ -188,7 +188,7 @@ struct osd_dev *osduld_path_lookup(const
>  
>  	error = kern_path(name, LOOKUP_FOLLOW, &path);
>  	if (error) {
> -		OSD_ERR("path_lookup of %s faild=>%d\n", path, error);
> +		OSD_ERR("path_lookup of %s failed=>%d\n", name, error);
>  		return ERR_PTR(error);
>  	}
>  
> 

Hi Randy thanks for the catch.

I cannot do anything with this patch as it is a fallout of an
Al Viro's patch which I do not have access to, from any of my trees.

This is:
  Reduce path_lookup() abuses

     use kern_path() where possible

  Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

(Linux-next's fe48fce1a72439d1b70dc8a9bce80c46ac4a6c96)


Al hi

Thanks for the fix and simplification. At the time of writing this I
did not find the kern_path(), which is much better in this code, Sorry.

Please squash or apply above Randy's patch. And tell me where I can find
it so I can test it and send an ACK-BY if that's needed. (Or if you want
that I pick this code, I'm here to help)

Thanks a lot for fixing this code
Boaz
