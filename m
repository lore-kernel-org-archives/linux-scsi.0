Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1933C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Jan 2022 17:57:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233163AbiATR5Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Jan 2022 12:57:25 -0500
Received: from mail-pg1-f180.google.com ([209.85.215.180]:44861 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232955AbiATR5X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Jan 2022 12:57:23 -0500
Received: by mail-pg1-f180.google.com with SMTP id h23so5908404pgk.11
        for <linux-scsi@vger.kernel.org>; Thu, 20 Jan 2022 09:57:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oeBPR4x52Of7BnYyAIppMpv6TJ8VY84+EN9xyBRZwjQ=;
        b=YfMbzqHMVsZLvdvIgaCUjsL22L13TSs+SXyiHk2MOqWnmjxC5GzNv00JJQ2DGX5tOO
         Pom1VZsr67n1neM4SLOViljh4t1hb488bxs+/cEBqSzidOsRi6W1k6P+i3CdN8ECT6WU
         Nk2XDiR0sPy8pkVKUfmICr1gLrobzSL1Y4a8VahtSBKwURh5j4bZJYWaTGtgWWhTMqFn
         zJv8I8jWVIxZU6Sx3BkrUk7sG13kCtoreq1lvI4bqeGqZzjvf04o9/gIxy5+2QPyVTGa
         aKTEjUVbo9RzO9HwTQnMvfgfeOfUWB1wIJk3kBT3b7vV4DY3UxStuQFdUrACrRaWQ2j1
         4ERA==
X-Gm-Message-State: AOAM531hUU+m78HnbFipNKYe/Q7i80knBV29ppFrxPSIaGE7N9lH6gmF
        xy09DlmLaKZowFgysFBwKWEdZoitUZc=
X-Google-Smtp-Source: ABdhPJyYj4s0Ec80EpsyaXNjWr2ubxM7q2v34ABgitJZs3qBSBlCsjnAo1n4bN/KZf7QaBiHD1LyrQ==
X-Received: by 2002:a05:6a00:174f:b0:4c2:3cc8:d7c2 with SMTP id j15-20020a056a00174f00b004c23cc8d7c2mr33659613pfc.81.1642701442548;
        Thu, 20 Jan 2022 09:57:22 -0800 (PST)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id m15sm2985188pgs.32.2022.01.20.09.57.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jan 2022 09:57:21 -0800 (PST)
Message-ID: <cbd41ae3-2b31-381a-6f07-58603a318961@acm.org>
Date:   Thu, 20 Jan 2022 09:57:20 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v1] scsi: ufs: use an generic error code in
 ufshcd_set_dev_pwr_mode
Content-Language: en-US
To:     Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org,
        sc.suh@samsung.com, hy50.seo@samsung.com, sh425.lee@samsung.com,
        bhoon95.kim@samsung.com, vkumar.1997@samsung.com
References: <CGME20220117103107epcas2p3d7223ff63f6cb575316695cc8fb155a4@epcas2p3.samsung.com>
 <1642415361-140388-1-git-send-email-kwmad.kim@samsung.com>
 <3bb0f5ad-2cea-2509-a9e1-d8ed159bd875@acm.org>
 <000001d80da8$9e987cd0$dbc97670$@samsung.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <000001d80da8$9e987cd0$dbc97670$@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/19/22 18:51, Kiwoong Kim wrote:
>>> @@ -8669,6 +8669,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba
>> *hba,
>>>    			    pwr_mode, ret);
>>>    		if (ret > 0 && scsi_sense_valid(&sshdr))
>>>    			scsi_print_sense_hdr(sdp, NULL, &sshdr);
>>> +		ret = -EIO;
>>>    	}
>>>
>>>    	if (!ret)
>>
>> Shouldn't "ret = -EIO" only be executed if ret > 0? Additionally, please
>> update the documentation of ufshcd_set_dev_pwr_mode(). I'm referring to
>> the following comment: "Returns non-zero if failed to set the requested
>> power mode".
>>
>> Thanks,
>>
>> Bart.
> 
> scsi_execute returns cmd->result(int type) but I think there is no case that the valaue is negative
> because all values defined for its most significant byte, i.e. driver byte, are smaller than 0x80.
> And I understand the 'ret > 0' presents that something wrong happens during the process.
> 
> So I'm not sure if 'ret = -EIO;' should be executed under 'ret > 0'.

I think that scsi_execute() can return a negative value. From 
__scsi_execute():

	req = scsi_alloc_request(sdev->request_queue,
			data_direction == DMA_TO_DEVICE ?
			REQ_OP_DRV_OUT : REQ_OP_DRV_IN,
			rq_flags & RQF_PM ? BLK_MQ_REQ_PM : 0);
	if (IS_ERR(req))
		return PTR_ERR(req);

As you probably know PTR_ERR() returns a negative error code if IS_ERR() 
returns true.

Thanks,

Bart.
