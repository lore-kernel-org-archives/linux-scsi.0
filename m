From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Re: [patch] scsi/qla2xxx: check for null consistently
Date: Tue, 25 May 2010 11:48:27 -0700
Message-ID: <C821698B.7573%giridhar.malavali@qlogic.com>
References: <20100522201801.GK22515@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:37516 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294Ab0EYSsb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2010 14:48:31 -0400
In-Reply-To: <20100522201801.GK22515@bicker>
Content-Language: en
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux Driver <Linux-Driver@qlogic.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>, LinuxSCSI <linux-scsi@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>




On 5/22/10 1:18 PM, "Dan Carpenter" <error27@gmail.com> wrote:

> We assume that "ha->cs84xx" can be null on the previous line, so we
> should check it here as well.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
> index 3b70860..ad22baa 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -1211,7 +1211,7 @@ qla24xx_84xx_fw_version_show(struct device *dev,
>         if (ha->cs84xx && ha->cs84xx->op_fw_version == 0)
>                 rval = qla84xx_verify_chip(vha, status);
> 
> -       if ((rval == QLA_SUCCESS) && (status[0] == 0))
> +       if (ha->cs84xx && rval == QLA_SUCCESS && status[0] == 0)
>                 return snprintf(buf, PAGE_SIZE, "%u\n",
>                         (uint32_t)ha->cs84xx->op_fw_version);
> 

The checking for ha->cs84xx is redundant here since earlier check make sure
that this code does not execute for non ISP 84xx ISPs. I will cleanup and
resubmit the changes.


