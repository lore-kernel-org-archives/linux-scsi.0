Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C28A2C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Feb 2022 23:48:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239422AbiBWXtV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Feb 2022 18:49:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbiBWXtU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Feb 2022 18:49:20 -0500
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D714F5C84B;
        Wed, 23 Feb 2022 15:48:51 -0800 (PST)
Received: by mail-pg1-f182.google.com with SMTP id w37so229160pga.7;
        Wed, 23 Feb 2022 15:48:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BTduPTK94QRRZtfJtdJSsV/aZ1MdyGC3Xx3InhNMH/U=;
        b=sSvrFykxIHiW/scUIYBHvKlsKb9t6KO2UhycwDwQncnRnk3bte+yowcOOh6ibsBCKT
         42g9PYAfLGRdKerAWS6KxYIgnq5/K7KZgaW51QNuS78smsjrIChcOAbVrxMvULw0e8LQ
         N0w1ztMLWlyQu3JLzyZshAiC/fpejHc8q6d9/ixPwqcr9JfUmT7XiXaXEdO5XM/fYvUN
         B3hsCp/UhvbuKr4lTHrwGcbnXQVmnUbeFClNDAtQH5W7TTNZr5WTraqh/P2ak6bEj17P
         1nUa4MgVRniP2bSCoKqn+tGx44jbeM5zHYyCfzFHn0BbAHR3RG1ELphJAI4b7SeQES2m
         ZZFg==
X-Gm-Message-State: AOAM5303pE9POA+NcDAVPFRuSixnNQ8/o0FSLRMtUIcPF8w6yxzBtsZ7
        ++hvdodgp8e8nlm2vELJlzOkFkp7swk7IQ==
X-Google-Smtp-Source: ABdhPJxjru2uAMzAXuKb6Q8RbUtg7Y8Jva6+EkPXyyl9/8uDjC5MqNI2WpJ3kvghVvTTyOVfjwdmYg==
X-Received: by 2002:a63:4814:0:b0:36d:87fb:f1ed with SMTP id v20-20020a634814000000b0036d87fbf1edmr148584pga.594.1645660131284;
        Wed, 23 Feb 2022 15:48:51 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id q5sm614537pfu.199.2022.02.23.15.48.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Feb 2022 15:48:50 -0800 (PST)
Message-ID: <4baf268e-7788-8e40-b570-1701f82e7f6b@acm.org>
Date:   Wed, 23 Feb 2022 15:48:49 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 8/8] scsi: remove struct scsi_request
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20220222140443.589882-1-hch@lst.de>
 <20220222140443.589882-9-hch@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220222140443.589882-9-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/22/22 06:04, Christoph Hellwig wrote:
> Let submitters initialized the scmd->allowed field directly instead of
                  ^^^^^^^^^^^
                  initialize?
> indirecting through struct scsi_request and remove the now superflous
> structure.

There are two changes in this patch:
- Initialize scmd->allowed directly instead of indirectly.
- Remove the include/scsi/scsi_request.h header.

You may want to split this patch into two patches - one patch per 
change. Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
