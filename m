Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CA14C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Nov 2022 18:57:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242452AbiKRS5J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Nov 2022 13:57:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242938AbiKRS4u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Nov 2022 13:56:50 -0500
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA9B970BA
        for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2022 10:54:23 -0800 (PST)
Received: by mail-pl1-f182.google.com with SMTP id y4so5354105plb.2
        for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2022 10:54:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qagw4hukceMVnRzLBud5bodNdwEx+gWxKhr90538o3w=;
        b=roCrtGF+ezhSnPEa9E6nCOrLu7IeH2SRlioP649dCJlUkZ3OuIrQdTwM2dqyrFvoJu
         EvJDt6AHyBKW0qFtq4B73rq4B3HmYYoqOr3Y1PHKB5h7iQCEvNgAfUQWoLQC/KllL2BK
         48Ki/1hl260PEdK6G6zNp4Z5r6pglRcsVcQbDdnGB2mSpbQkABagsRCrNOSguQyUKzHX
         GN4xnEE+ay6Vlk8wDjnEHAwFlLO9uc76QHsr/xhFkstpVQbP9bbJtEl4ndB0Gws/juOC
         3U/fxfFRwCTXwdKiTPQO38KMgosVM+xzsnTDq9qAujfwChHsDTeH4XpsIxnNTx9FcoTi
         o2kg==
X-Gm-Message-State: ANoB5pkXyn4RiyhlJlFDYUysr19Jyjw3fkFC5cfxIIEmyzeMQVxfKypY
        BZmT4GZqQB263t+w6E8HVBp+bylz5D0=
X-Google-Smtp-Source: AA0mqf6tVtWmXxgk2EUG5GsEuqzNjcO09V7gWgiePDrDytR76ExpdzcX2Cl4cM40UIxH4QfNcFSH+w==
X-Received: by 2002:a17:90b:2811:b0:213:971d:51b4 with SMTP id qb17-20020a17090b281100b00213971d51b4mr14367571pjb.180.1668797662677;
        Fri, 18 Nov 2022 10:54:22 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:5392:f94c:13ff:af1a? ([2620:15c:211:201:5392:f94c:13ff:af1a])
        by smtp.gmail.com with ESMTPSA id u11-20020a17090a1d4b00b0020aacde1964sm5627375pju.32.2022.11.18.10.54.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Nov 2022 10:54:21 -0800 (PST)
Message-ID: <2f822744-e137-4aa4-396b-a82348d5d84a@acm.org>
Date:   Fri, 18 Nov 2022 10:54:20 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH 1/2] scsi: alua: Revert "Move a scsi_device_put() call out
 of alua_check_vpd()"
Content-Language: en-US
To:     Sachin Sant <sachinp@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Martin Wilck <mwilck@suse.com>,
        Benjamin Block <bblock@linux.ibm.com>
References: <20221117183626.2656196-1-bvanassche@acm.org>
 <20221117183626.2656196-2-bvanassche@acm.org>
 <621BAA12-689E-4420-9D63-CC53E77370D5@linux.ibm.com>
 <2cb6d6aa-965c-e716-6110-5b90b634f59a@acm.org>
 <AB48CAF8-B327-4A35-9807-89372F73E8D3@linux.ibm.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <AB48CAF8-B327-4A35-9807-89372F73E8D3@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/18/22 08:03, Sachin Sant wrote:
>> On 18-Nov-2022, at 8:37 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>> Can you also test patch 2/2 from this series (https://lore.kernel.org/all/20221117183626.2656196-3-bvanassche@acm.org/)?
> 
> I tested with both the patches applied on top of next-20221117.

Thank you Sachin for having confirmed this. In the future when testing an
entire patch series, consider replying with "Tested-by:" to the cover letter
instead of the first patch. I think that is the conventional way to indicate
that a patch series has been tested in its entirety instead of a single
patch from a series.

Bart.

