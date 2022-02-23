Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CEC2C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Feb 2022 23:36:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239422AbiBWXgx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Feb 2022 18:36:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235083AbiBWXgw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Feb 2022 18:36:52 -0500
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 298FE5A08E;
        Wed, 23 Feb 2022 15:36:24 -0800 (PST)
Received: by mail-pj1-f50.google.com with SMTP id b8so417942pjb.4;
        Wed, 23 Feb 2022 15:36:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xdUq7WpxzeM1lTV+rGWOFdbqmQdmOR97au1/BL2hstg=;
        b=F2pSnj54SaaoschI8lEzDHhe8LFCwMHrMhknd24coxMYvHVbb+zscdNQSuOq75cIaO
         53yVYG6+YZgy2jRGhDKKZrfVAd7mwQ3NAThplC7smLITOveUtAZBZoTMsjpEXL4HXrIy
         hEqluPshFuB/Psh2yDEq0TdYiFv12halZ3NC7BMcQJWVI7jPddSgLrHTQ8Z3Bsup0r1e
         OOyzUkOYs7t3EQx+kafMMvnkyErZhL/x95cCM1V3KIrAz6ta+Y5o2wXIo8ZgPcISefDf
         0I0IR0/LOWbbsJlp8b08A+dAAO0hIll5pC0R/vzyL0tdvd5E53frBV1/ltROjHJcmvIz
         6fTg==
X-Gm-Message-State: AOAM533RLNz0Yf/oIzNwT1Nyw3nqePv3LdHYUCi4u/5T9QAvFLKBO5+D
        rc1zUVhGKO5flsF/mxeA0Gw=
X-Google-Smtp-Source: ABdhPJzrmHfkkR6YRfEvztjLV6zRw9Un+1gNKQITpN3BFxZr76ayvGitH7h0hJt2obBcQmB0WLfAxA==
X-Received: by 2002:a17:90a:5293:b0:1bc:a544:a638 with SMTP id w19-20020a17090a529300b001bca544a638mr16493pjh.174.1645659383519;
        Wed, 23 Feb 2022 15:36:23 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id g17sm602969pfc.193.2022.02.23.15.36.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Feb 2022 15:36:22 -0800 (PST)
Message-ID: <62f768c3-4869-e798-055c-d5ea1163d4ce@acm.org>
Date:   Wed, 23 Feb 2022 15:36:21 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 4/8] scsi: remove the cmd field from struct scsi_request
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20220222140443.589882-1-hch@lst.de>
 <20220222140443.589882-5-hch@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220222140443.589882-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/22/22 06:04, Christoph Hellwig wrote:
> Now that each scsi_request is backed by a scsi_cmnd, there is no
> need indirect the CDB storage.  Change all submitters of SCSI
       ^
missing verb?
> passthrough request to store the CDB information directly in the
               ^^^^^^^
               requests?

Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
