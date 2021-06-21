Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC9F2C4743C
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Jun 2021 17:38:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F51D61164
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Jun 2021 17:38:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbhFURko (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Jun 2021 13:40:44 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:39616 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbhFURkn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Jun 2021 13:40:43 -0400
Received: by mail-pf1-f180.google.com with SMTP id g192so6538938pfb.6
        for <linux-scsi@vger.kernel.org>; Mon, 21 Jun 2021 10:38:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MpjA8FtIdT2XLGo++5VCqj6J3VwxYGuyTO95u8yP58U=;
        b=MRIJVze+QvJkiuAky01VSD5s3OhM4IbPSFOfSdnhTpTn5h+2VueeHYnh9Mv2GVtxnt
         tzO5zO6MPi/fqaccwknT/b4unFkocNFgKFkOlU5mrSnXcaTmdur5YKzDwPgBHwKbBGVg
         azw7RmO9JtDFi9E/1iaRb94skRxoOsNaYo8cpCqsz7qn3NDwuW9TruwSGwIt9/ExtkIc
         z0+Q0GCozqjSRJFKNOADafu1zSQp3iOsMGQ70xTp1Cj/sw9pdqG5dwvcfWB6fWOZ05U3
         BsbvQWrWmeEBQHF3GlixoN4YsG+nNapCgW1r3zyCekJrWQfkX/PTm7mRFSFhUMRunUMk
         Kj2w==
X-Gm-Message-State: AOAM533JkXDFU8RAGTE40a808ysBEnIH7VG0dL/b74CbUse3RBumrmIB
        IA7sdL0E5VL/3js61X2gREc=
X-Google-Smtp-Source: ABdhPJz6+xvd79ieIv+meCDvgqmmQtnq1Y9z6r4MUwecHauezg8HL2I3g1SbsKpkdksOQH+thADNVg==
X-Received: by 2002:a63:1141:: with SMTP id 1mr17895527pgr.217.1624297109187;
        Mon, 21 Jun 2021 10:38:29 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id p26sm6762123pgc.53.2021.06.21.10.38.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 10:38:28 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH RFC 4/4] ufs: Make host controller state change handling
 more systematic
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Can Guo <cang@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20210619005228.28569-1-bvanassche@acm.org>
 <20210619005228.28569-5-bvanassche@acm.org>
 <DM6PR04MB65756FC4B5BA216BB72FF22BFC0A9@DM6PR04MB6575.namprd04.prod.outlook.com>
Message-ID: <d2585c1a-8af9-409b-597e-54e94de581dc@acm.org>
Date:   Mon, 21 Jun 2021 10:38:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <DM6PR04MB65756FC4B5BA216BB72FF22BFC0A9@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/21/21 1:55 AM, Avri Altman wrote:
>> +static bool ufshcd_set_state(struct ufs_hba *hba, enum ufshcd_state
>> new_state)
>> +{
>> +       lockdep_assert_held(hba->host->host_lock);
>> +
>> +       if (old_state != UFSHCD_STATE_ERROR || new_state ==
>> UFSHCD_STATE_ERROR)
>
> old_state ?

Thanks for having taken a look. This function should look as follows:

static bool ufshcd_set_state(struct ufs_hba *hba, enum ufshcd_state new_state)
{
	lockdep_assert_held(hba->host->host_lock);

	if (hba->ufshcd_state != UFSHCD_STATE_ERROR ||
	    new_state == UFSHCD_STATE_ERROR) {
		hba->ufshcd_state = new_state;
		return true;
	}
	return false;
}
