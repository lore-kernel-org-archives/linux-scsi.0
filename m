Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6ABDC77B75
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Apr 2023 20:14:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbjDRUOm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Apr 2023 16:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbjDRUOl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2023 16:14:41 -0400
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503887A88
        for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2023 13:14:40 -0700 (PDT)
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-63b5fca48bcso2121748b3a.0
        for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2023 13:14:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681848880; x=1684440880;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PO26aIVYr56RP1WoTPkD3r6HfLHrFEBjrs0coF7j8gQ=;
        b=V6OgyhcFxNzheRYeJbcpCSs5UkAgn3I1WSubwcFLnlW04/PG2QIlbFpNphxuwuZtD4
         IX9Osxdqsd8B93rFLvDI3M0DmF3zAWF638yP6an5NNQMUCKD6peqZCVQIDwI2glmuJDk
         dzPitPcKnd0+b7Zuri4Rk3yKH7zC+6NLhCDX4FNDMUU4urw6nllqLECHzTGo1a6ZCjbk
         DsYbOjCPhij58p3732qKmw5Fq5Euwxafpp6163KcircEtFHsTjoYkiqmWlcm3TNo7S1l
         EEpMOFECKszxE/+9CMbDOp5sW09Nl5lXb/+wBZUlpiQ1azhzETgEf8lptVEchQyiCF6D
         uGvA==
X-Gm-Message-State: AAQBX9fBe9/bu+r+1Qbu+c1IXH88PRyqsODFIMgsuimI6Fn49Gmt1R2B
        JCpygRtoPPiQznhlHQu06BA=
X-Google-Smtp-Source: AKy350bZmhJr438lOJ4ecKv7ZLw3xV/BT615jL/mOKU4AlLwKK3r73VgX9JdDdr5J4IERc95W/8W+w==
X-Received: by 2002:a05:6a00:2487:b0:63a:cefa:9d44 with SMTP id c7-20020a056a00248700b0063acefa9d44mr1123068pfv.14.1681848879644;
        Tue, 18 Apr 2023 13:14:39 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:5d9b:263d:206c:895a? ([2620:15c:211:201:5d9b:263d:206c:895a])
        by smtp.gmail.com with ESMTPSA id q24-20020a62e118000000b0063d2bb0d10asm3181026pfh.113.2023.04.18.13.14.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 13:14:39 -0700 (PDT)
Message-ID: <be06f246-a69e-ade7-0318-5a99d2d36216@acm.org>
Date:   Tue, 18 Apr 2023 13:14:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v2 2/4] scsi: ufs: Simplify ufshcd_wl_shutdown()
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org,
        Asutosh Das <asutoshd@codeaurora.org>,
        Tomas Henzl <thenzl@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bart Van Assche <bvanassche@google.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>
References: <20230417230656.523826-1-bvanassche@acm.org>
 <20230417230656.523826-3-bvanassche@acm.org>
 <74088d26-ac26-15ba-86a0-65d74a426a9c@intel.com>
 <0a2af553-9b37-d7b4-2fc2-6185c64e8663@acm.org>
 <4568ba8b-2dd8-b88c-fbfb-1b0a561e0b15@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <4568ba8b-2dd8-b88c-fbfb-1b0a561e0b15@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/18/23 07:13, Adrian Hunter wrote:
> On 18/04/23 17:06, Bart Van Assche wrote:
>> On 4/18/23 06:45, Adrian Hunter wrote:
>>> On 18/04/23 02:06, Bart Van Assche wrote:
>>>> Now that sd_shutdown() fails future I/O the code for quiescing LUNs in
>>>> ufshcd_wl_shutdown() is superfluous. Remove the code for quiescing LUNs.
>>>> Also remove the ufshcd_rpm_get_sync() call because it is not necessary
>>>> to resume a UFS device before submitting a START STOP UNIT command.
>>>
>>> What about the host controller hba->dev?
>>
>> The above question is not clear to me. Please elaborate.
> 
> Does hba->dev need to be runtime resumed?

Hi Adrian,

I don't think so. Shutdown callback functions are expected to quiesce 
hardware activity. To me runtime resuming a device seems to contradict 
the goal of quiescing hardware activity.

Thanks,

Bart.
