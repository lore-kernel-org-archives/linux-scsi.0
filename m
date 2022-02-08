Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEA67C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 17:55:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384419AbiBHRzL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 12:55:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239479AbiBHRzC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 12:55:02 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C83C061576
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 09:55:01 -0800 (PST)
Received: from fraeml710-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JtVyq0x0sz67xsG;
        Wed,  9 Feb 2022 01:54:59 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml710-chm.china.huawei.com (10.206.15.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Feb 2022 18:54:59 +0100
Received: from [10.47.82.28] (10.47.82.28) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Tue, 8 Feb
 2022 17:54:54 +0000
Message-ID: <61a02adf-823d-a933-8efd-4e0aa85873d5@huawei.com>
Date:   Tue, 8 Feb 2022 17:54:50 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v2 44/44] scsi: core: Remove struct scsi_pointer from
 struct scsi_cmnd
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, Ming Lei <ming.lei@redhat.com>,
        "Hannes Reinecke" <hare@suse.com>, Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-45-bvanassche@acm.org>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220208172514.3481-45-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.82.28]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 08/02/2022 17:25, Bart Van Assche wrote:
> Remove struct scsi_pointer from struct scsi_cmnd since the previous patches
> removed all users of that member of struct scsi_cmnd. Additionally, reorder
> the members of struct scsi_cmnd such that the statement that the field
> below can be modified by the SCSI LLD is again correct.
> 
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

FWIW, regadless of a nitpicking comment, below:

Reviewed-by: John Garry <john.garry@huawei.com>

> ---
>   include/scsi/scsi_cmnd.h | 14 +++++++-------
>   1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 6794d7322cbd..4fd2c522e914 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -123,11 +123,15 @@ struct scsi_cmnd {
>   				 * command (auto-sense). Length must be
>   				 * SCSI_SENSE_BUFFERSIZE bytes. */
>   
> +	int flags;		/* Command flags */
> +	unsigned long state;	/* Command completion state */
> +
> +	unsigned int extra_len;	/* length of alignment and padding */
> +
>   	/*
> -	 * The following fields can be written to by the host specific code.
> -	 * Everything else should be left alone.
> +	 * The fields below can be modified by the SCSI LLD but the fields
> +	 * above not.

"but the fields above not" - this sounds a bit odd, maybe this is 
better: "but the fields above may not be modified"

And I don't think that we need to mention SCSI in that comment ..

Thanks,
John

>   	 */
> -	struct scsi_pointer SCp;	/* Scratchpad used by some host adapters */
>   
>   	unsigned char *host_scribble;	/* The host adapter is allowed to
>   					 * call scsi_malloc and get some memory
> @@ -138,10 +142,6 @@ struct scsi_cmnd {
>   					 * to be at an address < 16Mb). */
>   
>   	int result;		/* Status code from lower level driver */
> -	int flags;		/* Command flags */
> -	unsigned long state;	/* Command completion state */
> -
> -	unsigned int extra_len;	/* length of alignment and padding */
>   };
>   
>   /* Variant of blk_mq_rq_from_pdu() that verifies the type of its argument. */
> .

