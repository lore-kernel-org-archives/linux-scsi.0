Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88C4FC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 13 May 2022 08:03:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378015AbiEMIDk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 May 2022 04:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354665AbiEMIDh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 May 2022 04:03:37 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C13D3DDC5
        for <linux-scsi@vger.kernel.org>; Fri, 13 May 2022 01:03:36 -0700 (PDT)
Received: from fraeml741-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4L01Kg2Hy0z6H75C;
        Fri, 13 May 2022 16:00:39 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml741-chm.china.huawei.com (10.206.15.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 13 May 2022 10:03:34 +0200
Received: from [10.47.25.226] (10.47.25.226) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 13 May
 2022 09:03:33 +0100
Message-ID: <77d1a566-6745-0934-3011-93f25f949b04@huawei.com>
Date:   Fri, 13 May 2022 09:03:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 16/20] snic: reserve tag for TMF
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        <linux-scsi@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
References: <20220512111236.109851-1-hare@suse.de>
 <20220512111236.109851-17-hare@suse.de>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220512111236.109851-17-hare@suse.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.25.226]
X-ClientProxiedBy: lhreml748-chm.china.huawei.com (10.201.108.198) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/05/2022 12:12, Hannes Reinecke wrote:
> Rather than re-using the failed command the snic driver should
> reserve one command for TMFs.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>   drivers/scsi/snic/snic.h      |  2 +-
>   drivers/scsi/snic/snic_main.c |  8 +++++++
>   drivers/scsi/snic/snic_scsi.c | 44 +++++++++++++++++------------------
>   3 files changed, 31 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/scsi/snic/snic.h b/drivers/scsi/snic/snic.h
> index 4ec7e30678e1..28059b66f191 100644
> --- a/drivers/scsi/snic/snic.h
> +++ b/drivers/scsi/snic/snic.h
> @@ -380,7 +380,7 @@ int snic_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
>   int snic_abort_cmd(struct scsi_cmnd *);
>   int snic_device_reset(struct scsi_cmnd *);
>   int snic_host_reset(struct scsi_cmnd *);
> -int snic_reset(struct Scsi_Host *, struct scsi_cmnd *);
> +int snic_reset(struct Scsi_Host *);
>   void snic_shutdown_scsi_cleanup(struct snic *);
>   
>   
> diff --git a/drivers/scsi/snic/snic_main.c b/drivers/scsi/snic/snic_main.c
> index 29d56396058c..3375153dd636 100644
> --- a/drivers/scsi/snic/snic_main.c
> +++ b/drivers/scsi/snic/snic_main.c
> @@ -663,6 +663,14 @@ snic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>   		goto err_get_conf;
>   	}
>   

Hi Hannes,

> +	/*
> +	 * Hack alert: reduce can_queue by one after scsi_add_host()
> +	 * had been called.

I am not sure how this helps as I did not think that reducing 
shost->can_queue after scsi_add_host() had any effect. Maybe pre- 
6eb045e092ef it did.

As an alternative interim solution, maybe you could just allocate a 
regular single scsi request for this TMF at init time.

> +	 * This essentially reserves the topmost request for TMF.
> +	 * Should be replaced by reserved command
> +	 * once support is being added.
> +	 */
> +	shost->can_queue--;
>   	snic_set_state(snic, SNIC_ONLINE);
>   

Thanks,
John
