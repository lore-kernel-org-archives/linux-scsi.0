From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/3] megaraid_sas: Convert dev_printk to dev_<level>
Date: Tue, 27 Oct 2015 12:35:56 -0700
Message-ID: <1445974556.2757.47.camel@perches.com>
References: <1445934375-17784-1-git-send-email-wangweidong1@huawei.com>
	 <1445934375-17784-2-git-send-email-wangweidong1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445934375-17784-2-git-send-email-wangweidong1@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Weidong Wang <wangweidong1@huawei.com>
Cc: kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com, JBottomley@odin.com, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2015-10-27 at 16:26 +0800, Weidong Wang wrote:
> Reduce object size a little by using dev_<level>
> calls instead of dev_printk(KERN_<LEVEL>.

This is also not the same output.

dev_printk(KERN_DEBUG vs dev_dbg has the same
behavior as printk(KERN_DEBUG vs pr_debug

> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
[]
> @@ -1884,7 +1884,7 @@ static int megasas_get_ld_vf_affiliation_111(struct megasas_instance *instance,
>  	cmd = megasas_get_cmd(instance);
>  
>  	if (!cmd) {
> -		dev_printk(KERN_DEBUG, &instance->pdev->dev, "megasas_get_ld_vf_affiliation_111:"
> +		dev_dbg(&instance->pdev->dev, "megasas_get_ld_vf_affiliation_111:"
>  		       "Failed to get cmd for scsi%d\n",
>  			instance->host->host_no);
>  		return -ENOMEM;
[]
> @@ -5243,7 +5243,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
>  					     &instance->consumer_h);
>  
>  		if (!instance->producer || !instance->consumer) {
> -			dev_printk(KERN_DEBUG, &pdev->dev, "Failed to allocate"
> +			dev_dbg(&pdev->dev, "Failed to allocate"
>  			       "memory for producer, consumer\n");

Note the lack of a space between coalesced string segment words.
That's one of the reasons to coalesce them.
