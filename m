Return-Path: <SRS0=ePHC=6P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88809C47253
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 12:02:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 700B020836
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 12:02:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728653AbgEAMCl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 May 2020 08:02:41 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2144 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728570AbgEAMCk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 1 May 2020 08:02:40 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id A56E87BE833E97C50D29;
        Fri,  1 May 2020 13:02:39 +0100 (IST)
Received: from [127.0.0.1] (10.47.3.165) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Fri, 1 May 2020
 13:02:38 +0100
Subject: Re: [PATCH RFC v3 02/41] scsi: add scsi_{get,put}_reserved_cmd()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.com>
References: <20200430131904.5847-1-hare@suse.de>
 <20200430131904.5847-3-hare@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <318ece17-394e-d518-ac24-19680e93e6ff@huawei.com>
Date:   Fri, 1 May 2020 13:01:56 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200430131904.5847-3-hare@suse.de>
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

On 30/04/2020 14:18, Hannes Reinecke wrote:
> +	rq = blk_mq_alloc_request(sdev->request_queue,
> +				  data_direction == DMA_TO_DEVICE ?
> +				  REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN | REQ_NOWAIT,
> +				  BLK_MQ_REQ_RESERVED);
> +	if (IS_ERR(rq))
> +		return NULL;
> +	scmd = blk_mq_rq_to_pdu(rq);
> +	scmd->request = rq;

Should we just set scmd->device = sdev also for completeness?

Thanks,
John

> +	return scmd;
> +}
> +EXPORT_SYMBOL_GPL(scsi_get_reserved_cmd);

