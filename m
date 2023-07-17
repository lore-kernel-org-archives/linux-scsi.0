Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E972BEB64DC
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Jul 2023 17:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbjGQRF3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Jul 2023 13:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbjGQRF2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Jul 2023 13:05:28 -0400
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C2EDE1
        for <linux-scsi@vger.kernel.org>; Mon, 17 Jul 2023 10:05:27 -0700 (PDT)
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1b852785a65so29432965ad.0
        for <linux-scsi@vger.kernel.org>; Mon, 17 Jul 2023 10:05:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689613527; x=1692205527;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rtsop/PQWrJ0DXvpSn+qCI8nyOOPDiAYZS1j4gv8ISE=;
        b=MDgu3GIo78KB3+TrIE/Rqa81zMqxY2eNdkrqAVB+cAbhrmooI95ULvTICHqR9JHSWD
         YzbzGw5wWPFgbpZwr13SypGfPRrJyiEFspcD2c5IFthwe+j1D/ArS63jx76rvzynt3Nc
         XQEchx8OiYi3AyqKLCWnlJZzBsmBJGts1twGUYc7ZojdqDqIgAmgZt7P4JZIWcBChXcv
         I3mzFtQkdV2/NtnyT/c9tvMwD3HZflYexT4bkRz/7NlLmkpb0IPqnLdKB6m3H3ddsNm4
         EuaYFU2+yo2kQWHir/jiYedNj/u7sr/TznxZAu4VbrRGaSkMXI8K5w9+4K4NHfFdhO/o
         Qmiw==
X-Gm-Message-State: ABy/qLbOQmqCBjgahgFlPAAZn/Yz2r1iwyNq5r6w3RCJDumKEf6tAgOm
        ToLiHsF0Iln/VFQNX+IhQSU=
X-Google-Smtp-Source: APBJJlHK0MNVrSDf1f/RlzV7p7ubRcLxww659wuc0NqatToDZvYuit3SR91y9QcM3C+6S4yTDXPpTA==
X-Received: by 2002:a17:903:1d1:b0:1bb:3d05:764 with SMTP id e17-20020a17090301d100b001bb3d050764mr1082636plh.32.1689613526613;
        Mon, 17 Jul 2023 10:05:26 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:ac3:b183:3725:4b8f? ([2620:15c:211:201:ac3:b183:3725:4b8f])
        by smtp.gmail.com with ESMTPSA id jh6-20020a170903328600b001b5247cac3dsm143345plb.110.2023.07.17.10.05.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jul 2023 10:05:25 -0700 (PDT)
Message-ID: <38793488-3785-3685-7919-814a338158a5@acm.org>
Date:   Mon, 17 Jul 2023 10:05:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v10 28/33] scsi: ufs: Have scsi-ml retry start stop errors
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        john.g.garry@oracle.com, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20230714213419.95492-1-michael.christie@oracle.com>
 <20230714213419.95492-29-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230714213419.95492-29-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/14/23 14:34, Mike Christie wrote:
> This has scsi-ml retry errors instead of driving them itself.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/ufs/core/ufshcd.c | 19 +++++++++----------
>   1 file changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 983fae84d9e8..267c24c57396 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -9291,7 +9291,14 @@ static int ufshcd_execute_start_stop(struct scsi_device *sdev,
>   				     struct scsi_sense_hdr *sshdr)
>   {
>   	const unsigned char cdb[6] = { START_STOP, 0, 0, 0, pwr_mode << 4, 0 };
> +	struct scsi_failure failures[] = {
> +		{
> +			.allowed = 2,
> +			.result = SCMD_FAILURE_RESULT_ANY,
> +		},
> +	};
>   	const struct scsi_exec_args args = {
> +		.failures = failures,
>   		.sshdr = sshdr,
>   		.req_flags = BLK_MQ_REQ_PM,
>   		.scmd_flags = SCMD_FAIL_IF_RECOVERING,
> @@ -9317,7 +9324,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
>   	struct scsi_sense_hdr sshdr;
>   	struct scsi_device *sdp;
>   	unsigned long flags;
> -	int ret, retries;
> +	int ret;
>   
>   	spin_lock_irqsave(hba->host->host_lock, flags);
>   	sdp = hba->ufs_device_wlun;
> @@ -9343,15 +9350,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
>   	 * callbacks hence set the RQF_PM flag so that it doesn't resume the
>   	 * already suspended childs.
>   	 */
> -	for (retries = 3; retries > 0; --retries) {
> -		ret = ufshcd_execute_start_stop(sdp, pwr_mode, &sshdr);
> -		/*
> -		 * scsi_execute() only returns a negative value if the request
> -		 * queue is dying.
> -		 */
> -		if (ret <= 0)
> -			break;
> -	}
> +	ret = ufshcd_execute_start_stop(sdp, pwr_mode, &sshdr);
>   	if (ret) {
>   		sdev_printk(KERN_WARNING, sdp,
>   			    "START_STOP failed for power mode: %d, result %x\n",

The original code only retries if ->result > 0. Is my understanding 
correct that the new code retries SCSI command execution whether 
->result is < 0 or > 0? If so, I think this patch introduces an 
unintended behavior change.

Thanks,

Bart.
