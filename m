Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C56C7C77B7E
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jun 2023 21:12:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbjFAVMI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Jun 2023 17:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjFAVMH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jun 2023 17:12:07 -0400
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 982BD12C
        for <linux-scsi@vger.kernel.org>; Thu,  1 Jun 2023 14:12:06 -0700 (PDT)
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-64d18d772bdso1588753b3a.3
        for <linux-scsi@vger.kernel.org>; Thu, 01 Jun 2023 14:12:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685653926; x=1688245926;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3NiZALMm6J4tmcomcvMQcO3EC6PCDMYo+ZshTCWUhiY=;
        b=JdLo7ToXxHG5Ft/Q6AgCZ05CPX+Uk83TePfjb4HN8EUa5I+Z8HsFXzsdaPQ+2+HFL0
         VlMAQKouCb7VdUDhmV+EPr/3YMFWNCGMiKm0RvZ7VZqmn4aEuQoUyEAbhziFLt/GBg2Z
         hHGEdrKC67KEUgwcZ+ooRi6sFRZ6ElIKgOXGnsnTvub7eqP80O8SUi/+ulrx8A2vFH6Q
         R8OeC1ww97rJq7ztBWZzMie9O+G0OmLUFXrywCehJZJgDopc9dJljfCG6STFoi5Qnqps
         nxugkQHRSl6+E66ON0KiT8jsVSxywfh/styUoukyCQIbHhqqMrCyTKdwGb2l/imOgoL1
         AEjA==
X-Gm-Message-State: AC+VfDyPdC6/f48upuZ2gm/ddHSQzf5RiMDaqXUdKS8+ebVVSLIVJ8TQ
        Qka3QQK//Vf1EarRoNtb/84=
X-Google-Smtp-Source: ACHHUZ4YbVLjEG/s87+vF6JaUZmN7z8m/g7ndJKv3gSkhKYsMMXuPr0yCqKQhqhhfdd+FT3mjV3W/Q==
X-Received: by 2002:a05:6a00:9a5:b0:641:39cb:1716 with SMTP id u37-20020a056a0009a500b0064139cb1716mr13548973pfg.20.1685653925977;
        Thu, 01 Jun 2023 14:12:05 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id e26-20020a62aa1a000000b0063f0068cf6csm5427087pff.198.2023.06.01.14.12.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jun 2023 14:12:05 -0700 (PDT)
Message-ID: <2490926f-d8cc-3ce4-7a00-b8db58c89848@acm.org>
Date:   Thu, 1 Jun 2023 14:12:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] scsi: ufs: Include major and minor number in command
 tracing output
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        Ziqi Chen <quic_ziqichen@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Adrien Thierry <athierry@redhat.com>
References: <20230531223924.25341-1-bvanassche@acm.org>
 <ZHgrYgDmvhs7Iw/d@infradead.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ZHgrYgDmvhs7Iw/d@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/31/23 22:23, Christoph Hellwig wrote:
> On Wed, May 31, 2023 at 03:39:20PM -0700, Bart Van Assche wrote:
>> UFS devices are typically configured with multiple logical units.
>> The device name, e.g. 13200000.ufs, does not include logical unit
>> information. Hence this patch that replaces the device name with
>> the disk major and minor number in the tracing output, e.g. 8,0,
>> just like the block layer tracing information.
> 
> Please also drop the never used group_id value while you're at it.

Hi Christoph,

I will look into removing the GROUP ID information from the UFS tracing 
output. Do you agree with adding the GROUP ID information in the SCSI 
tracing output after data temperature support has been added in the 
block layer and SCSI core? As you probably know the T10 committee 
recently approved Ralph Weber's Constrained Streams proposal.

Thanks,

Bart.


