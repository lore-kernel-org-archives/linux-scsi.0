From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v4 1/3] ibmvscsi: make parameters max_id and max_channel
 read-only
Date: Mon, 09 Nov 2015 07:07:45 -0800
Message-ID: <1447081665.2242.5.camel@HansenPartnership.com>
References: <1447080465-17858-1-git-send-email-lvivier@redhat.com>
	 <1447080465-17858-2-git-send-email-lvivier@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57160 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750804AbbKIPHr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Nov 2015 10:07:47 -0500
In-Reply-To: <1447080465-17858-2-git-send-email-lvivier@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurent Vivier <lvivier@redhat.com>
Cc: martin.petersen@oracle.com, hare@suse.de, brking@linux.vnet.ibm.com, tyreld@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, 2015-11-09 at 15:47 +0100, Laurent Vivier wrote:
> The value of the parameter is never re-read by the driver,
> so a new value is ignored. Let know the user he
> can't modify it by removing writable attribute.

This isn't correct.  They're read in every time a new SCSI host is
bound.  I don't believe VIO is a hot plug bus, so the only way to get
the values to propagate is to unbind and rebind the driver.  Now if you
want to argue they should be read only because users are getting
confused about how to propagate the values, that's a different story,
but this is a standard pattern in quite a few drivers, so you'd need to
argue why vscsi users are special.

James

> Signed-off-by: Laurent Vivier <lvivier@redhat.com>
> ---
>  drivers/scsi/ibmvscsi/ibmvscsi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
> index 6a41c36..3e76490 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> @@ -105,9 +105,9 @@ MODULE_AUTHOR("Dave Boutcher");
>  MODULE_LICENSE("GPL");
>  MODULE_VERSION(IBMVSCSI_VERSION);
>  
> -module_param_named(max_id, max_id, int, S_IRUGO | S_IWUSR);
> +module_param_named(max_id, max_id, int, S_IRUGO);
>  MODULE_PARM_DESC(max_id, "Largest ID value for each channel");
> -module_param_named(max_channel, max_channel, int, S_IRUGO | S_IWUSR);
> +module_param_named(max_channel, max_channel, int, S_IRUGO);
>  MODULE_PARM_DESC(max_channel, "Largest channel value");
>  module_param_named(init_timeout, init_timeout, int, S_IRUGO | S_IWUSR);
>  MODULE_PARM_DESC(init_timeout, "Initialization timeout in seconds");



