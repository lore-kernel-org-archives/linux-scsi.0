Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C38F6C7EE23
	for <linux-scsi@archiver.kernel.org>; Tue, 23 May 2023 08:51:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236075AbjEWIvH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 May 2023 04:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjEWIvF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2023 04:51:05 -0400
Received: from forward500b.mail.yandex.net (forward500b.mail.yandex.net [178.154.239.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C17595
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 01:51:00 -0700 (PDT)
Received: from mail-nwsmtp-smtp-production-main-73.iva.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-73.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:160b:0:640:acd0:0])
        by forward500b.mail.yandex.net (Yandex) with ESMTP id E54FC5E7EA;
        Tue, 23 May 2023 11:50:28 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-73.iva.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id RoAHmGCDd8c0-GBgHXgL5;
        Tue, 23 May 2023 11:50:28 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=scst.dev; s=mail; t=1684831828;
        bh=UTrSO1kpLbWvsVkAHM88zQvEhk426LyZ+670n9R6rxg=;
        h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
        b=OFV3bMUPvge7lTGRFlUVBUsefq3nPtH8NArax0iyLuvzq0+h2BYdV8/WE1u1spYsS
         Vu+EnygPYvVx0AtAMYXimFvotRZ3G7+Ob399+7uUBP85xOU0ZK1FfoAwFg1ImpH3G1
         GCNFFSE7Al3SXrEaQpiD+oPXk6jq+bwBms/ecn+0=
Authentication-Results: mail-nwsmtp-smtp-production-main-73.iva.yp-c.yandex.net; dkim=pass header.i=@scst.dev
Message-ID: <c5343c08-a2db-4ce1-f603-5437f69a8f0a@scst.dev>
Date:   Tue, 23 May 2023 11:51:14 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] qla2xxx: Fix NULL pointer dereference in target mode
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <32b0bb9f-ba6a-e9f1-e779-5af2e115c67a@scst.dev>
 <yq1h6sbvjne.fsf@ca-mkp.ca.oracle.com>
 <56b416f2-4e0f-b6cf-d6d5-b7c372e3c6a2@scst.dev>
 <168479546538.1263525.11015484620208683851.b4-ty@oracle.com>
Content-Language: en-US
From:   Gleb Chesnokov <gleb.chesnokov@scst.dev>
In-Reply-To: <168479546538.1263525.11015484620208683851.b4-ty@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 5/23/23 01:45, Martin K. Petersen wrote:
> On Wed, 17 May 2023 11:22:35 +0300, Gleb Chesnokov wrote:
> 
>> When target mode is enabled, the pci_irq_get_affinity() function may return
>> a NULL value in qla_mapq_init_qp_cpu_map() due to the qla24xx_enable_msix()
>> code that handles IRQ settings for target mode. This leads to a crash due
>> to a NULL pointer dereference.
>>
>> This patch fixes the issue by adding a check for the NULL value returned
>> by pci_irq_get_affinity() and introducing a 'cpu_mapped' boolean flag to
>> the qla_qpair structure, ensuring that the qpair's CPU affinity is updated
>> when it has not been mapped to a CPU.
>>
>> [...]
> 
> Applied to 6.4/scsi-fixes. Whitespace was still mangled so I had to
> apply by hand. Please verify, thanks!
> 
> [1/1] qla2xxx: Fix NULL pointer dereference in target mode
>        https://git.kernel.org/mkp/scsi/c/d54820b22e40
> 
Sorry, I had some problems with Thunderbird; I have resolved them now.
I've reviewed the patch you applied manually, and it appears to be accurate.

Thanks,
Gleb
