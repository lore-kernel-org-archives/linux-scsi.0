Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD540C433E6
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 20:49:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8632664DE5
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 20:49:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbhA1Usw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jan 2021 15:48:52 -0500
Received: from mail-pl1-f179.google.com ([209.85.214.179]:33562 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbhA1Usm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2021 15:48:42 -0500
Received: by mail-pl1-f179.google.com with SMTP id d13so4036374plg.0;
        Thu, 28 Jan 2021 12:48:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bBzN1ISsTvCs+9iYTKnodflWkRsa4cqN3KQynPDNXAE=;
        b=TQmlT4R1JXL2k8Y3zdP73im9iMB2u3dUCssCzNnWQAmlFWrleQ5wr59ekj6kPL3s26
         Y3sPTjlJLqyHHjwoR0Pca/M001/FGlO1WBr6Oo15YcPt18k7VbleiAjhmupC8gzT+woj
         13cRZaEjzS7ByF5XgMdfcIsxwT6QS1tYupSTMICnnq5lTrt0UQZJ48JFfXpD5EGmcWt0
         Exk8/cCdOAyxHJw4uDOIG1kPunBq2fhiGIdc2u0cRKOqPECR8AWy3qTzMRrL0E0MA8fF
         zDaePHj/FPSFIRyMONOBOiyOmZjcbtd/pBGHqU31Q127Y770bOqgBcjm+niRCTtEBvE7
         SZSQ==
X-Gm-Message-State: AOAM533JHj5/2F+UKfypSSCHYW8Y8qBrSPGt28mTswOFCGo8bxSOMchw
        MlR07/Ao53/Vh8tr8ZWWdObMeKiJH7s=
X-Google-Smtp-Source: ABdhPJwEc2BkQPZJACKFiXv1W1leEcLMI1hmIlsAeDwZRyLgr+7ABrplwZGxoYftG2PBmOQrk/0Hig==
X-Received: by 2002:a17:90a:f010:: with SMTP id bt16mr1159552pjb.165.1611866880889;
        Thu, 28 Jan 2021 12:48:00 -0800 (PST)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id d22sm5802781pjv.11.2021.01.28.12.47.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 12:48:00 -0800 (PST)
Subject: Re: [PATCH v2] scsi: target: core: check SR field in REPORT LUNS
To:     Dmitriy Bogdanov <d.bogdanov@yadro.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux@yadro.com" <linux@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20210120102700.5514-1-d.bogdanov@yadro.com>
 <yq1tur3knh1.fsf@ca-mkp.ca.oracle.com>
 <83b96eded14d4722883836daebbe40dd@yadro.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <9a3c59aa-2f4d-c022-c573-afdbc00ca08f@acm.org>
Date:   Thu, 28 Jan 2021 12:47:58 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <83b96eded14d4722883836daebbe40dd@yadro.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/27/21 6:45 AM, Dmitriy Bogdanov wrote:
> Hi Martin,
> 
>>> +	switch (sr) {
>>> +	case SCSI_SELECT_WELLKNOWN:
>>> +	case SCSI_SELECT_ADMINISTRATIVE:
>>> +	case SCSI_SELECT_SUBSIDIARY:
>>> +		/* report empty lun list */
>>> +		goto out;
> 
>> I'm a bit concerned about things inadvertently breaking if we return an empty list for the well known LUNs.
 >
> According to SPC we shall report an empty list if there is no well-known LUNS.
> FreeBSD has the same logic in REPORT LUNS handling. SCST does not support SELECT_WELLKNOWN case at all.
> 
> I don't know the history of the existing behaviour to send always LUN0 instead of empty list. Probably it was
> for the SCSI_SELECT_ALL_ACCESSIBLE(0x02) case, where SPC allows LUN0. My patch keeps it for the 0x00, 0x02, 0x11 cases.
> Thus, I believe it does not break the backward compatibility.

Will this change require users to update their LUN configuration? Some 
initiator operating systems require presence of a dummy LUN 0. Although 
I agree that it is cleaner not to provide a hardcoded LUN 0, I think 
Martin is concerned about this patch potentially breaking existing 
configurations and causing frustration among LIO users.

Bart.

