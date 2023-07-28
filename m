Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7504AC0015E
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jul 2023 02:05:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231578AbjG1CFj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jul 2023 22:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231768AbjG1CFh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jul 2023 22:05:37 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 379D335A9;
        Thu, 27 Jul 2023 19:05:26 -0700 (PDT)
Received: from canpemm100004.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4RBrVH2wYjzNmbT;
        Fri, 28 Jul 2023 10:01:59 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm100004.china.huawei.com (7.192.105.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 28 Jul 2023 10:05:19 +0800
Subject: Re: [PATCH v3 1/9] ata: remove reference to non-existing
 error_handler()
To:     Niklas Cassel <nks@flawful.org>,
        Damien Le Moal <dlemoal@kernel.org>
CC:     Hannes Reinecke <hare@suse.com>,
        John Garry <john.g.garry@oracle.com>,
        <linux-ide@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>,
        Niklas Cassel <niklas.cassel@wdc.com>
References: <20230721163229.399676-1-nks@flawful.org>
 <20230721163229.399676-2-nks@flawful.org>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <5c47b29e-02f0-9da3-78cf-2d1ca41a7823@huawei.com>
Date:   Fri, 28 Jul 2023 10:05:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20230721163229.399676-2-nks@flawful.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.14]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm100004.china.huawei.com (7.192.105.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/7/22 0:32, Niklas Cassel wrote:
> +	/* Non-internal qc has failed.  Fill the result TF and summon EH. */
> +	if (unlikely(qc->flags & ATA_QCFLAG_EH)) {
> +		fill_result_tf(qc);
> +		trace_ata_qc_complete_failed(qc);
> +		ata_qc_schedule_eh(qc);
> +		return;
> +	}
>   
> -		WARN_ON_ONCE(ata_port_is_frozen(ap));
> +	WARN_ON_ONCE(ata_port_is_frozen(ap));
>   
> -		/* read result TF if requested */
> -		if (qc->flags & ATA_QCFLAG_RESULT_TF)
> -			fill_result_tf(qc);
> +	/* read result TF if requested */
> +	if (qc->flags & ATA_QCFLAG_RESULT_TF)
> +		fill_result_tf(qc);
>   
> -		trace_ata_qc_complete_done(qc);
> +	trace_ata_qc_complete_done(qc);
>   
> +	/*
> +	 * For CDL commands that completed without an error, check if we have
> +	 * sense data (ATA_SENSE is set). If we do, then the command may have
> +	 * been aborted by the device due to a limit timeout using the policy
> +	 * 0xD. For these commands, invoke EH to get the command sense data.
> +	 */
> +	if (qc->result_tf.status & ATA_SENSE &&
> +	    ((ata_is_ncq(qc->tf.protocol) &&
> +	      dev->flags & ATA_DFLAG_CDL_ENABLED) ||
> +	     (!(ata_is_ncq(qc->tf.protocol) &&
> +		ata_id_sense_reporting_enabled(dev->id))))) {

Hmm, this code is a little bit unreadable. Maybe factoring out a 
function is a choice. But I think it is not directly related to this 
change and can be done in a separate patch later. So:

Reviewed-by: Jason Yan <yanaijie@huawei.com>

Thanks,
Jason
