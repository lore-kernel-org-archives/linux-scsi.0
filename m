Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82EC3C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:55:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B1EC61209
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:55:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345036AbhERR5N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245549AbhERR5N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:57:13 -0400
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 370C5C061573
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:55:55 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id D6074128085A;
        Tue, 18 May 2021 10:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1621360554;
        bh=apDhDtlHY7d2Uz2L6bA1Ig1mqsN1sJl/KfLF7DIb9tI=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=ks0+HZvNETSJhoHdkwPhS5VK/DmUhVA8oHxHCq21DyvnUESUvweA7ti9Bq9l8m5Zm
         grrRPo+zIWsscJLqITZxmx0PAAvuGavpu6Gu7YhclsSWGz9L1p29dZhe6sYo6JMziQ
         9tBNe1uepKXSqhYpDSuDqHO6VDyZsT03bcCOUNGw=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id pr1hpSwTn-Ld; Tue, 18 May 2021 10:55:54 -0700 (PDT)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 7E2C312807CC;
        Tue, 18 May 2021 10:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1621360554;
        bh=apDhDtlHY7d2Uz2L6bA1Ig1mqsN1sJl/KfLF7DIb9tI=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=ks0+HZvNETSJhoHdkwPhS5VK/DmUhVA8oHxHCq21DyvnUESUvweA7ti9Bq9l8m5Zm
         grrRPo+zIWsscJLqITZxmx0PAAvuGavpu6Gu7YhclsSWGz9L1p29dZhe6sYo6JMziQ
         9tBNe1uepKXSqhYpDSuDqHO6VDyZsT03bcCOUNGw=
Message-ID: <af39cb904e0f0450549f9fdcee3c256e61bfab93.camel@HansenPartnership.com>
Subject: Re: [PATCH v2 00/50] Remove the request pointer from struct
 scsi_cmnd
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
Date:   Tue, 18 May 2021 10:55:53 -0700
In-Reply-To: <20210518174450.20664-1-bvanassche@acm.org>
References: <20210518174450.20664-1-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-05-18 at 10:44 -0700, Bart Van Assche wrote:
> Hi Martin,
> 
> This patch series implements the following two changes for all SCSI
> drivers:
> - Use blk_mq_rq_from_pdu() instead of the request member of struct
> scsi_cmnd
>   since adding an offset to a pointer is faster than pointer
> indirection.

Are there any performance results to back up this assertion?  It's
quite a lot of churn so it would be nice to know it's worth it.

James


