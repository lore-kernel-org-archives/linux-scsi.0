Return-Path: <SRS0=ePHC=6P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F0BBC47256
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 07:48:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08633208C3
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 07:48:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728420AbgEAHse (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 May 2020 03:48:34 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2139 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728380AbgEAHsd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 1 May 2020 03:48:33 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 2ACBDF1F7EACDF2BC6BB;
        Fri,  1 May 2020 08:48:32 +0100 (IST)
Received: from [127.0.0.1] (10.47.3.165) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Fri, 1 May 2020
 08:48:31 +0100
Subject: Re: [PATCH 13/15] scsi: sas: avoid gcc-10 zero-length-bounds warning
To:     Arnd Bergmann <arnd@arndb.de>, <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@SteelEye.com>
CC:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Hannes Reinecke <hare@suse.com>, <linux-scsi@vger.kernel.org>
References: <20200430213101.135134-1-arnd@arndb.de>
 <20200430213101.135134-14-arnd@arndb.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <b5e6ef12-c2ac-d0ce-b7a1-a58d4c8de300@huawei.com>
Date:   Fri, 1 May 2020 08:47:49 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200430213101.135134-14-arnd@arndb.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.3.165]
X-ClientProxiedBy: lhreml727-chm.china.huawei.com (10.201.108.78) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 30/04/2020 22:30, Arnd Bergmann wrote:
> Two files access the zero-length resp_data[] array, which now
> causes a compiler warning:
> 
> drivers/scsi/aic94xx/aic94xx_tmf.c: In function 'asd_get_tmf_resp_tasklet':
> drivers/scsi/aic94xx/aic94xx_tmf.c:291:22: warning: array subscript 3 is outside the bounds of an interior zero-length array 'u8[0]' {aka 'unsigned char[0]'} [-Wzero-length-bounds]
>    291 |   res = ru->resp_data[3];
>        |         ~~~~~~~~~~~~~^~~
> In file included from include/scsi/libsas.h:15,
>                   from drivers/scsi/aic94xx/aic94xx.h:16,
>                   from drivers/scsi/aic94xx/aic94xx_tmf.c:11:
> include/scsi/sas.h:557:9: note: while referencing 'resp_data'
>    557 |  u8     resp_data[0];
>        |         ^~~~~~~~~
> drivers/scsi/libsas/sas_task.c: In function 'sas_ssp_task_response':
> drivers/scsi/libsas/sas_task.c:21:30: warning: array subscript 3 is outside the bounds of an interior zero-length array 'u8[0]' {aka 'unsigned char[0]'} [-Wzero-length-bounds]
>     21 |   tstat->stat = iu->resp_data[3];
>        |                 ~~~~~~~~~~~~~^~~
> In file included from include/scsi/scsi_transport_sas.h:8,
>                   from drivers/scsi/libsas/sas_internal.h:14,
>                   from drivers/scsi/libsas/sas_task.c:3:
> include/scsi/sas.h:557:9: note: while referencing 'resp_data'
>    557 |  u8     resp_data[0];
>        |         ^~~~~~~~~
> 
> This should really be a flexible-array member, but the structure
> already has such a member, swapping it out with sense_data[] would
> cause many more warnings elsewhere.
> 


Hi Arnd,

If we really prefer flexible-array members over zero-length array 
members, then could we have a union of flexible-array members? I'm not 
sure if that's a good idea TBH (or even permitted), as these structures 
are defined by the SAS spec and good practice to keep as consistent as 
possible, but just wondering.

Apart from that:

Reviewed-by: John Garry <john.garry@huawei.com>

> As a workaround, add a temporary pointer that can be accessed without
> a warning.
> 
> Fixes: 2908d778ab3e ("[SCSI] aic94xx: new driver")
> Fixes: 366ca51f30de ("[SCSI] libsas: abstract STP task status into a function")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   drivers/scsi/aic94xx/aic94xx_tmf.c | 4 +++-
>   drivers/scsi/libsas/sas_task.c     | 3 ++-
>   2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/aic94xx/aic94xx_tmf.c b/drivers/scsi/aic94xx/aic94xx_tmf.c
> index f814026f26fa..a3139f9766c8 100644
> --- a/drivers/scsi/aic94xx/aic94xx_tmf.c
> +++ b/drivers/scsi/aic94xx/aic94xx_tmf.c
> @@ -269,6 +269,7 @@ static int asd_get_tmf_resp_tasklet(struct asd_ascb *ascb,
>   	struct ssp_frame_hdr *fh;
>   	struct ssp_response_iu   *ru;
>   	int res = TMF_RESP_FUNC_FAILED;
> +	u8 *resp;
>   
>   	ASD_DPRINTK("tmf resp tasklet\n");
>   
> @@ -287,8 +288,9 @@ static int asd_get_tmf_resp_tasklet(struct asd_ascb *ascb,
>   	fh = edb->vaddr + 16;
>   	ru = edb->vaddr + 16 + sizeof(*fh);
>   	res = ru->status;
> +	resp = ru->resp_data;
>   	if (ru->datapres == 1)	  /* Response data present */
> -		res = ru->resp_data[3];
> +		res = resp[3];
>   #if 0
>   	ascb->tag = fh->tag;
>   #endif
> diff --git a/drivers/scsi/libsas/sas_task.c b/drivers/scsi/libsas/sas_task.c
> index e2d42593ce52..4cd2f9611c4a 100644
> --- a/drivers/scsi/libsas/sas_task.c
> +++ b/drivers/scsi/libsas/sas_task.c
> @@ -12,13 +12,14 @@ void sas_ssp_task_response(struct device *dev, struct sas_task *task,
>   			   struct ssp_response_iu *iu)
>   {
>   	struct task_status_struct *tstat = &task->task_status;
> +	u8 *resp = iu->resp_data;
>   
>   	tstat->resp = SAS_TASK_COMPLETE;
>   
>   	if (iu->datapres == 0)
>   		tstat->stat = iu->status;
>   	else if (iu->datapres == 1)
> -		tstat->stat = iu->resp_data[3];
> +		tstat->stat = resp[3];
>   	else if (iu->datapres == 2) {
>   		tstat->stat = SAM_STAT_CHECK_CONDITION;
>   		tstat->buf_valid_size =
> 

