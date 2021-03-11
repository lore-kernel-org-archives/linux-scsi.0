Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EF35C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 10:44:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C321164FCE
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 10:44:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbhCKKoQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 05:44:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:51566 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232500AbhCKKnx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Mar 2021 05:43:53 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id AA245AC17;
        Thu, 11 Mar 2021 10:43:51 +0000 (UTC)
Subject: Re: [PATCH] scsi: Fix a double free in myrs_cleanup
To:     Lv Yunlong <lyl2019@mail.ustc.edu.cn>, hare@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210311063005.9963-1-lyl2019@mail.ustc.edu.cn>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <0e841bdd-9903-8e69-b2a0-89e702118c14@suse.de>
Date:   Thu, 11 Mar 2021 11:43:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210311063005.9963-1-lyl2019@mail.ustc.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/11/21 7:30 AM, Lv Yunlong wrote:
> In myrs_cleanup, cs->mmio_base will be freed twice by
> iounmap().
> 
> Fixes: 77266186397c6 ("scsi: myrs: Add Mylex RAID controller (SCSI interface)")
> Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
> ---
>  drivers/scsi/myrs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
> index 4adf9ded296a..329fd025c718 100644
> --- a/drivers/scsi/myrs.c
> +++ b/drivers/scsi/myrs.c
> @@ -2273,12 +2273,12 @@ static void myrs_cleanup(struct myrs_hba *cs)
>  	if (cs->mmio_base) {
>  		cs->disable_intr(cs);
>  		iounmap(cs->mmio_base);
> +		cs->mmio_base = NULL;
>  	}
>  	if (cs->irq)
>  		free_irq(cs->irq, cs);
>  	if (cs->io_addr)
>  		release_region(cs->io_addr, 0x80);
> -	iounmap(cs->mmio_base);
>  	pci_set_drvdata(pdev, NULL);
>  	pci_disable_device(pdev);
>  	scsi_host_put(cs->host);
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
