Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A60BC433EF
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Nov 2021 16:13:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2810603E7
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Nov 2021 16:13:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235700AbhKGQP7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Nov 2021 11:15:59 -0500
Received: from smtprelay0142.hostedemail.com ([216.40.44.142]:36896 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230371AbhKGQPz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Nov 2021 11:15:55 -0500
Received: from omf15.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 9A09418086DE6;
        Sun,  7 Nov 2021 16:13:11 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf15.hostedemail.com (Postfix) with ESMTPA id 14D32C4182;
        Sun,  7 Nov 2021 16:13:09 +0000 (UTC)
Message-ID: <b3961ecdf78e7f88a467650638e5935ea413bb8f.camel@perches.com>
Subject: Re: [PATCH] scsi: snic: Replace snprintf in show functions with  
 sysfs_emit
From:   Joe Perches <joe@perches.com>
To:     cgel.zte@gmail.com, kartilak@cisco.com
Cc:     sebaddel@cisco.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jing Yao <yao.jing2@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>
Date:   Sun, 07 Nov 2021 08:13:08 -0800
In-Reply-To: <20211105081454.76950-1-yao.jing2@zte.com.cn>
References: <20211105081454.76950-1-yao.jing2@zte.com.cn>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 84k33uc8wbwfjhna7tncc4ij7d8smiab
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: 14D32C4182
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+G+4FggANqAb7Rvf7hnQbb8ikH9nDPiSs=
X-HE-Tag: 1636301589-940526
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-11-05 at 08:14 +0000, cgel.zte@gmail.com wrote:
> From: Jing Yao <yao.jing2@zte.com.cn>
> 
> coccicheck complains about the use of snprintf() in sysfs show
> functions:
> WARNING use scnprintf or sprintf
> 
> Use sysfs_emit instead of scnprintf, snprintf or sprintf makes more
> sense.
[]
> diff --git a/drivers/scsi/snic/snic_attrs.c b/drivers/scsi/snic/snic_attrs.c
[]
> @@ -37,7 +37,7 @@ snic_show_state(struct device *dev,
>  {
>  	struct snic *snic = shost_priv(class_to_shost(dev));
>  
> -	return snprintf(buf, PAGE_SIZE, "%s\n",
> +	return sysfs_emit(buf, "%s\n",
>  			snic_state_str[snic_get_state(snic)]);
>  }

when you do these, please consider the ability to rewrap to 80 columns.

	return sysfs_emit(buf, "%s\n", snic_state_str[snic_get_state(snic)]);

> @@ -59,7 +59,7 @@ snic_show_link_state(struct device *dev,
>  	if (snic->config.xpt_type == SNIC_DAS)
>  		snic->link_status = svnic_dev_link_status(snic->vdev);
>  
> -	return snprintf(buf, PAGE_SIZE, "%s\n",
> +	return sysfs_emit(buf, "%s\n",
>  			(snic->link_status) ? "Link Up" : "Link Down");

And maintain parenthesis alignment

	return sysfs_emit(buf, "%s\n",
 			  snic->link_status ? "Link Up" : "Link Down");

or maybe

	return sysfs_emit(buf, "Link %s\n", snic->link_status ? "Up" : "Down");

