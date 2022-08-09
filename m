Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74C8FC25B06
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 19:33:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245538AbiHITdS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Aug 2022 15:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245720AbiHITdF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2022 15:33:05 -0400
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B9D12250A;
        Tue,  9 Aug 2022 12:33:04 -0700 (PDT)
Received: by mail-pj1-f46.google.com with SMTP id c19-20020a17090ae11300b001f2f94ed5c6so1798715pjz.1;
        Tue, 09 Aug 2022 12:33:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=f+0qvG5LpZ/YCrirnG9rg8hMNbrBXBa71sPfrtvKm9k=;
        b=ql8K1a0GRsOwdjQmw3bqWsqTlaoDUeSjApF2nBtg+B8lwg3xfu3+AUKfKCo0HeMKcg
         DZAL4gCnSsU82o1XlWjwKih7cw3Rkx31p/99YipROZaXyXQJ8y9udNy6oCWEOPmGWxob
         GmiaoP1YbWAv4qPnKoiSWdgzIYgFDZx4+yCrsiRu7/qmLqMgZHOEA9K5dYKsnQZ9Eksp
         +4ELWxyGColWXG20dnpSf/iivMJVBHgl3qcQKXRYvyvoy3AQmpeMzEGJDM+A/VNSi2ee
         Sm3jukwtxAsc33CbfhsPX2gEIrTNK3565WA3K4kVSRcv6WMwyqSe0m4GZeCKF7TSljYb
         ubfA==
X-Gm-Message-State: ACgBeo2cqEmDcr0Ch1SDhhrO9w5jbBFMfLgQu+0P6e2C5tKJn9I+AO3i
        ciD2OtgGSHERpkQNDJOWwHiytlX3RT0=
X-Google-Smtp-Source: AA6agR5b3k6/3uuXU2uCikVcoZWIFTOMmR2vQDrfIljSBaQQd1XN66Nj9Fx1iPA0NtYy8Ovw7IMVMA==
X-Received: by 2002:a17:902:e891:b0:16f:a8:9b9c with SMTP id w17-20020a170902e89100b0016f00a89b9cmr24397129plg.8.1660073583617;
        Tue, 09 Aug 2022 12:33:03 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:61e9:2f41:c2d4:73d? ([2620:15c:211:201:61e9:2f41:c2d4:73d])
        by smtp.gmail.com with ESMTPSA id d14-20020a170902654e00b0016d12adc282sm11204466pln.147.2022.08.09.12.33.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 12:33:03 -0700 (PDT)
Message-ID: <4768d11e-06c6-1b74-9822-b2421a3f59bb@acm.org>
Date:   Tue, 9 Aug 2022 12:33:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 12/20] block,nvme,scsi,dm: Add blk_status to pr_ops
 callouts.
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20220809000419.10674-1-michael.christie@oracle.com>
 <20220809000419.10674-13-michael.christie@oracle.com>
 <20220809072155.GF11161@lst.de>
 <4af2a4d3-04d1-966a-5fd5-5e443b593c8b@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <4af2a4d3-04d1-966a-5fd5-5e443b593c8b@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/9/22 11:08, Mike Christie wrote:
> On 8/9/22 2:21 AM, Christoph Hellwig wrote:
>> On Mon, Aug 08, 2022 at 07:04:11PM -0500, Mike Christie wrote:
>>> To handle both cases, this patch adds a blk_status_t arg to the pr_ops
>>> callouts. The lower levels will convert their device specific error to
>>> the blk_status_t then the upper levels can easily check that code
>>> without knowing the device type. It also allows us to keep userspace
>>> compat where it expects a negative -Exyz error code if the command fails
>>> before it's sent to the device or a device/tranport specific value if the
>>> error is > 0.
>>
>> Why do we need two return values here?
> 
> I know the 2 return values are gross :) I can do it in one, but I wasn't sure
> what's worse. See below for the other possible solutions. I think they are all
> bad.
> 
> 
> 0. Convert device specific conflict error to -EBADE then back:
> 
> sd_pr_command()
> 
> .....
> 
> /* would add similar check for NVME_SC_RESERVATION_CONFLICT in nvme */
> if (result == SAM_STAT_CHECK_CONDITION)
> 	return -EBADE;
> else
> 	return result;
> 
> 
> LIO then just checks for -EBADE but when going to userspace we have to
> convert:
> 
> 
> blkdev_pr_register()
> 
> ...
> 	result = ops->pr_register()
> 	if (result < 0) {
> 		/* For compat we must convert back to the nvme/scsi code */
> 		if (result == -EBADE) {
> 			/* need some helper for this that calls down the stack */
> 			if (bdev == SCSI)
> 				return SAM_STAT_RESERVATION_CONFLICT
> 			else
> 				return NVME_SC_RESERVATION_CONFLICT
> 		} else
> 			return blk_status_to_str(result)
> 	} else
> 		return result;
> 
> 
> The conversion is kind of gross and I was thinking in the future it's going
> to get worse. I'm going to want to have more advanced error handling in LIO
> and dm-multipath. Like dm-multipath wants to know if an pr_op failed because
> of a path failure, so it can retry another one, or a hard device/target error.
> It would be nice for LIO if an PGR had bad/illegal values and the device
> returned an error than I could detect that.
> 
> 
> 1. Drop the -Exyz error type and use blk_status_t in the kernel:
> 
> sd_pr_command()
> 
> .....
> if (result < 0)
> 	return -errno_to_blk_status(result);
> else if (result == SAM_STAT_CHECK_CONDITION)
> 	return -BLK_STS_NEXUS;
> else
> 	return result;
> 
> blkdev_pr_register()
> 
> ...
> 	result = ops->pr_register()
> 	if (result < 0) {
> 		/* For compat we must convert back to the nvme/scsi code */
> 		if (result == -BLK_STS_NEXUS) {
> 			/* need some helper for this that calls down the stack */
> 			if (bdev == SCSI)
> 				return SAM_STAT_RESERVATION_CONFLICT
> 			else
> 				return NVME_SC_RESERVATION_CONFLICT
> 		} else
> 			return blk_status_to_str(result)
> 	} else
> 		return result;
> 
> This has similar issues as #0 where we have to convert before returning to
> userspace.
> 
> 
> Note: In this case, if the block layer uses an -Exyz error code there's not
> BLK_STS for then we would return -EIO to userspace now. I was thinking
> that might not be ok but I could also just add a BLK_STS error code
> for errors like EINVAL, EWOULDBLOCK, ENOMEM, etc so that doesn't happen.
> 
> 
> 2. We could do something like below where the low levels are not changed but the
> caller converts:
> 
> sd_pr_command()
> 	/* no changes */
> 
> lio()
> 	result = ops->pr_register()
> 	if (result > 0) {
> 		/* add some stacked helper again that goes through dm and
> 		 * to the low level device
> 		 */
> 		if (bdev == SCSI) {
> 			result = scsi_result_to_blk_status(result)
> 		else
> 			result = nvme_error_status(result)
> 
> 
> This looks simple, but it felt wrong having upper layers having to
> know the device type and calling conversion functions.

Has it been considered to introduce a new enumeration type instead of 
choosing (0), (1) or (2)?

Thanks,

Bart.
