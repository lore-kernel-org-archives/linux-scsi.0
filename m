Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BADEC25B6B
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Oct 2023 00:37:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232306AbjJ0Ah6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Oct 2023 20:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjJ0Ah5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Oct 2023 20:37:57 -0400
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B821B5;
        Thu, 26 Oct 2023 17:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1698367073;
        bh=poSglx/GxnnT0f+slxnQ33XAXayg5ZBzBxFV1dHQU/U=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=mx8euzjtzypm5WNzpNOvu+2kMiGgckb2uLKD6qjXemhcXYXdnECrlSE6CdWPXrvXs
         Q8L6jlp9pWo1/eis7sAtH0juLUeLxGqUDSBSoSvonMUCIAfm/Rv0JjD2hVXj2CebGq
         91gOrj8F4Degzqj5IovR3Dd5EknPr1BAfPAB2Uf0=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 7523E1287169;
        Thu, 26 Oct 2023 20:37:53 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id nsIYUxNFVftR; Thu, 26 Oct 2023 20:37:53 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1698367073;
        bh=poSglx/GxnnT0f+slxnQ33XAXayg5ZBzBxFV1dHQU/U=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=mx8euzjtzypm5WNzpNOvu+2kMiGgckb2uLKD6qjXemhcXYXdnECrlSE6CdWPXrvXs
         Q8L6jlp9pWo1/eis7sAtH0juLUeLxGqUDSBSoSvonMUCIAfm/Rv0JjD2hVXj2CebGq
         91gOrj8F4Degzqj5IovR3Dd5EknPr1BAfPAB2Uf0=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::c14])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id B8D89128706F;
        Thu, 26 Oct 2023 20:37:52 -0400 (EDT)
Message-ID: <3f06c6abe447569a2111c54e56737b5e62d53f1a.camel@HansenPartnership.com>
Subject: Re: [PATCH] scsi: sd: Introduce manage_shutdown device flag
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Damien Le Moal <dlemoal@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Date:   Thu, 26 Oct 2023 20:37:47 -0400
In-Reply-To: <84139e3b-15d4-4368-a6d6-77bba5555aac@kernel.org>
References: <20231025070117.464903-1-dlemoal@kernel.org>
         <39fef5f8e090d50eb22d73d6bb39b21edf62b565.camel@HansenPartnership.com>
         <bf780d7a-30f3-4744-adde-73b4c2723d6b@kernel.org>
         <c3dfca871ddddfeef004fdb74432630a148300f2.camel@HansenPartnership.com>
         <23f25e02-a451-4ad4-bb04-e3449a1e6dea@acm.org>
         <84139e3b-15d4-4368-a6d6-77bba5555aac@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2023-10-27 at 09:26 +0900, Damien Le Moal wrote:
> On 10/27/23 06:36, Bart Van Assche wrote:
> > On 10/26/23 05:01, James Bottomley wrote:
> > > Heh, well, I was going to say we should still point to the doc,
> > > but I simply can't find it, so the above is perhaps the best we
> > > can do, thanks!
> > 
> > I think this should be documented in the Documentation/power
> > directory. After having taken another look at that directory, I see
> > that there is only detailed documentation and no overview
> > documentation. Maybe I overlooked something but I couldn't find an
> > explanation of the system suspend/resume nor of the runtime power
> > management concepts in that directory. My understanding is that
> > system suspend/resume is about system-wide power state changes
> > (hibernation and suspend-to-RAM) and also that runtime power
> > management is about changing the power state of a single device or
> > bus if no activity has happened within a certain time.
> 
> I actually thought that James wanted a reference to scsi sysfs
> attributes documentation, which is also not in the best of shape, to
> say the least...
> 
> In any case, I would like to push this fix for 6.6-final as this is a
> tracked regression. Martin, James, are you OK with this patch ?

Yes, works for me, you can add my Reviewed-by.

James

