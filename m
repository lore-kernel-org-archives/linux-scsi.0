Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8157C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Oct 2022 22:55:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiJDWzV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Oct 2022 18:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiJDWzT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2022 18:55:19 -0400
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6653C19036
        for <linux-scsi@vger.kernel.org>; Tue,  4 Oct 2022 15:55:15 -0700 (PDT)
Received: by mail-pl1-f182.google.com with SMTP id z20so7385106plb.10
        for <linux-scsi@vger.kernel.org>; Tue, 04 Oct 2022 15:55:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=CLQAvHLRujw5kyMFoSb5HExBUjkLENQ9VdvLffzuuls=;
        b=5GUwJIQdHrRh1DKsqDPn9uCVxWVL4xLYxANM1xNrhAizZAQDbtqkmruRSh2EH1q+Fd
         CjhFSAC5Qc4xY1p2o/J46xLYMk4GNPkLMlKcM9yrEaN5HzqPEsO7ePn25pmCZ/QPT+1p
         qRutupkc5PfeE2zFn1FkHlW+W5nOAd07zmaBvaotKUZsPMPpj22FEA7a3ICYe57ukhpu
         wdvUW7u5SqY5tYmB6BcBR72DvE6704Pu+A+l95NHg8Vgtr9zfbZM4NekpH/xlCy6dI5Q
         0KTcJqk7cC/SAb3oKhCluRn5rHe3gugk8hi7SQPSIY7MqUTAv0kCtpApaSq5S3FjivN3
         SJXA==
X-Gm-Message-State: ACrzQf0QIrpBP9w0zdcW3E0yuq0V5ZkMghS16ybls3wuC/usCFJ1eFtU
        /f7rw2E8PS5/qg9iP3tsIx0=
X-Google-Smtp-Source: AMsMyM5rLihvC6neyhM0JjCQZ180L748lFeEdys7bbsOO0pwxropYQw3rVYtQG9CMbGFWdDZKAYeCQ==
X-Received: by 2002:a17:902:e750:b0:17f:71fa:d695 with SMTP id p16-20020a170902e75000b0017f71fad695mr6138459plf.105.1664924114828;
        Tue, 04 Oct 2022 15:55:14 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:b6b5:f763:ff03:8283? ([2620:15c:211:201:b6b5:f763:ff03:8283])
        by smtp.gmail.com with ESMTPSA id x5-20020a17090a388500b0020adf65cebbsm83192pjb.8.2022.10.04.15.55.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Oct 2022 15:55:14 -0700 (PDT)
Message-ID: <b7e8270b-3979-67b6-10ce-5cea0558d912@acm.org>
Date:   Tue, 4 Oct 2022 15:55:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v3 02/35] scsi: Allow passthrough to override what errors
 to retry
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221003175321.8040-1-michael.christie@oracle.com>
 <20221003175321.8040-3-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221003175321.8040-3-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/3/22 10:52, Mike Christie wrote:
> +static enum scsi_disposition scsi_check_passthrough(struct scsi_cmnd *scmd)
> +{
> +	struct scsi_failure *failure;
> +	struct scsi_sense_hdr sshdr;
> +	enum scsi_disposition ret;
> +	u8 status;
> +	int i;
> +
> +
> +	if (!scmd->result || !scmd->failures)
> +		return SCSI_RETURN_NOT_HANDLED;
> +
> +	for (i = 0, failure = &scmd->failures[i]; failure->result;
> +	     failure = &scmd->failures[++i]) {
> +		if (failure->result == SCMD_FAILURE_ANY)
> +			goto maybe_retry;
> +
> +		if (host_byte(scmd->result) &&
> +		    host_byte(scmd->result) == host_byte(failure->result))
> +			goto maybe_retry;
> +
> +		status = get_status_byte(scmd);
> +		if (!status)
> +			continue;
> +
> +		if (failure->result == SCMD_FAILURE_STAT_ANY &&
> +		    !scsi_status_is_good(scmd->result))
> +			goto maybe_retry;
> +
> +		if (status != __get_status_byte(failure->result))
> +			continue;
> +
> +		if (((__get_status_byte(failure->result)) !=
> +		    SAM_STAT_CHECK_CONDITION) ||
> +		    (failure->sense == SCMD_FAILURE_SENSE_ANY))
> +			goto maybe_retry;
> +
> +		ret = scsi_start_sense_processing(scmd, &sshdr);
> +		if (ret == NEEDS_RETRY)
> +			goto maybe_retry;
> +		else if (ret != SUCCESS)
> +			return ret;
> +
> +		if (failure->sense != sshdr.sense_key)
> +			continue;
> +
> +		if (failure->asc == SCMD_FAILURE_ASC_ANY)
> +			goto maybe_retry;
> +
> +		if (failure->asc != sshdr.asc)
> +			continue;
> +
> +		if (failure->ascq == SCMD_FAILURE_ASCQ_ANY ||
> +		    failure->ascq == sshdr.ascq)
> +			goto maybe_retry;
> +	}
> +
> +	return SCSI_RETURN_NOT_HANDLED;
> +
> +maybe_retry:
> +	if (failure->allowed == SCMD_FAILURE_NO_LIMIT ||
> +	    ++failure->retries <= failure->allowed)
> +		return NEEDS_RETRY;
> +
> +	return SUCCESS;
> +}

Since the logic in the above function is nontrivial and since injecting
errors may also be nontrivial, please add unit tests for this function. An
example is available in commit addbeea6f50b ("testing/selftests: Add tests
for the is_signed_type() macro").

Thanks,

Bart.
