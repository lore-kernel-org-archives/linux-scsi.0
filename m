From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] scsi: mpt3sas: make sysfs error messages ratelimited
Date: Fri, 14 Sep 2018 04:26:25 -0700
Message-ID: <f1def33e05f7d6f568ee2f5259f8b1a35b413a10.camel@perches.com>
References: <20180907103924.17598-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180907103924.17598-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2018-09-07 at 11:39 +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> It is possible to heavily spam the kernel logs with messages by
> excessive reading of the mpt3sas sysfs files.  Make the error messages
> ratelimited to reduce the spamming effect.
[]
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
[]
> @@ -2958,7 +2958,7 @@ _ctl_BRM_status_show(struct device *cdev, struct device_attribute *attr,
>  	ssize_t rc = 0;
>  
>  	if (!ioc->is_warpdrive) {
> -		pr_err(MPT3SAS_FMT "%s: BRM attribute is only for"
> +		pr_err_ratelimited(MPT3SAS_FMT "%s: BRM attribute is only for"
>  		    " warpdrive\n", ioc->name, __func__);
>  		goto out;
>  	}

trivia:

All the uses of MPT3SAS_FMT in drivers/scsi/mpt3sas/ seem
not nice.  It obfuscate the format and arguments.

Perhaps better would be create ioc_<level> macros.
