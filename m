Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71E7BC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Mar 2022 00:39:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbiCCAk1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 19:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbiCCAk0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 19:40:26 -0500
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E8333EBA
        for <linux-scsi@vger.kernel.org>; Wed,  2 Mar 2022 16:39:42 -0800 (PST)
Received: by mail-pl1-f171.google.com with SMTP id q11so3045062pln.11
        for <linux-scsi@vger.kernel.org>; Wed, 02 Mar 2022 16:39:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Y5V731gl710l7arGiU17wtF70xvi9CRS0CHeoyQHTFo=;
        b=SVvQ3CMSgs+kBFvNLcqzKimhdiUgxuz6+/Ewzp8pV37BfcWfuM5bybDs7X8nnGECQG
         cTXjv8UY9o7bsY/lEUpPzXIZaZ/ET7eN0vsg2PTrEO7kH0YuvAbJFQKBDQUuV+9z24BW
         tdMe0RpDYqk7dzm1IIicVIcT78R9/0KOJ6+3CvWTUHjjccbMVGEAN8+3j7+H1k5eLhKA
         +1erIaStb6jTys/dFZnxjNLLe7g7NeAsYR3kkYFAu8qqSQ/b+YlCLjD4DYmtVuHoIvUX
         PApiyLgVExd8YMT/SyV2xz0iEVeD/DarTiJwnZUhCuNViT7kQChfT7ZPfJU1DS6fHfBK
         yPjA==
X-Gm-Message-State: AOAM530/VJh0kANy50SKl8B5ntb9w0nMc/qwF3FRN6y2utUoI12qk6Kj
        56Fqsahn/4oudn3SfKx7ONA7v2Psgco=
X-Google-Smtp-Source: ABdhPJxSVH7fsYw7L4JRFOlLaSI5FYWDnnWGM2E6JQR0Puk/fEtLMpOsSy3652pT3Ue3+Ua1vJlBFA==
X-Received: by 2002:a17:90b:240e:b0:1b9:2963:d5a1 with SMTP id nr14-20020a17090b240e00b001b92963d5a1mr2463511pjb.227.1646267982220;
        Wed, 02 Mar 2022 16:39:42 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id s137-20020a63778f000000b0037c4e125decsm291117pgc.40.2022.03.02.16.39.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 16:39:41 -0800 (PST)
Message-ID: <75063cde-b12b-4c51-33d8-fe5574d80e7b@acm.org>
Date:   Wed, 2 Mar 2022 16:39:40 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 04/14] scsi: core: Pick suitable allocation length in
 scsi_report_opcode()
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-5-martin.petersen@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220302053559.32147-5-martin.petersen@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/1/22 21:35, Martin K. Petersen wrote:
> Some devices hang when a buffer size larger than expected is passed in
> the ALLOCATION LENGTH field. For REPORT SUPPORTED OPERATION CODES we
> currently only request a single command descriptor at a time and
> therefore the actual size of the command is known ahead of time. Limit
> the ALLOCATION LENGTH to the header size plus the command length of
> the opcode we are asking about.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
