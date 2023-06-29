Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E458EB64D9
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jun 2023 14:20:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbjF2OUC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Jun 2023 10:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232195AbjF2OTy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jun 2023 10:19:54 -0400
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F0A713D
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jun 2023 07:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1688048384;
        bh=p3/zMsJz9/MOEJMrJcFKQAr2Z2U/KBHD6GodCMDf3Rc=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=UYkI72s76ieX1IczXl5kVyPfNwQYATew4TDsZHIQ9V0Wxc69eRFEz3+I30tpj0rvg
         Ev+U1bmGISNiofmqBXyxFErQ+GMBSCIZ16SAUiO9TUWmkpTbY6ZJ7KqlXMnCIkTyoZ
         QPOpSNKkF7T4sBuzfEXcEUKOgf3DdbgEhbbDUe4s=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 3F8251281B30;
        Thu, 29 Jun 2023 10:19:44 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id j0soRNoqv0QJ; Thu, 29 Jun 2023 10:19:44 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1688048382;
        bh=p3/zMsJz9/MOEJMrJcFKQAr2Z2U/KBHD6GodCMDf3Rc=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=NpsKlfLfyVfjsfZiX4JBGbp5ahsSM/5DvfmZmXqe9GZAHtyVH0XSI5qAIEYgQa2T3
         5TXaJ3HYPLCxxDCKXzs+VUzB/0g+KRTrkoicOMSKC/Zz2pCAsDqygoKp8yx1jbWx9F
         AENTsfWvvk41hgh5PpZ53rqYEpqOl50r771NbhmY=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::c14])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id CD6F61281804;
        Thu, 29 Jun 2023 10:19:41 -0400 (EDT)
Message-ID: <ba539717e990e2997add02184acea7e29939516c.camel@HansenPartnership.com>
Subject: Re: [RFC] Support for Write-and-Verify only drives
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <dlemoal@kernel.org>
Cc:     Daniel =?ISO-8859-1?Q?Rozsny=F3?= <daniel@rozsnyo.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
Date:   Thu, 29 Jun 2023 10:19:40 -0400
In-Reply-To: <yq1mt0jnhnu.fsf@ca-mkp.ca.oracle.com>
References: <c6499ed7-d049-5714-f827-734cff3f6305@rozsnyo.com>
         <eca63b83-1cf4-40ac-114d-f23acc7cadea@acm.org>
         <97f19b02-045a-825c-6a30-18fc3dcb35cd@rozsnyo.com>
         <f6e5e9d2-3446-ef52-a090-4eef1bd2daa3@kernel.org>
         <yq1mt0jnhnu.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2023-06-28 at 22:19 -0400, Martin K. Petersen wrote:
> 
> Damien,
> 
> > When scanning the drive, you need to poke it using
> > scsi_report_opcode() to determine which write operation is
> > supported. Then sd.c need to be modified to generate the proper
> > write command if the regular WRITE 10/16/32 are not supported. You
> > will also need to make sure that this does not break ATA drives
> > managed with libata, so check libata-scsi translation.
> > 
> > Not saying this can all be accepted though. But that is what is
> > needed.
> > 
> > Martin ?
> 
> This is clearly a rare and special case, I have never come across a
> drive that couldn't handle a regular WRITE command.
> 
> I don't see any reason to burden our stack with workarounds for
> drives that use custom firmware.

I would also add that this seems to be arse backwards.  If the
intention is to have a high fidelity drive that always verifies writes,
why not simply add a verify after every write in the firmware before
completing the write?  Even if you send a MISCOMPARE sense code back,
we'll simply take it as write failure.  If you do this in Firmware, the
drive does what you want and is automatically supported by every
current SCSI stack without modification (well there might be some where
you'll have to give a failure sense code that WRITE would expect
instead of MISCOMPARE).

Regards,

James

