Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCBAAC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 13:44:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3C9461165
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 13:44:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbhJ2Nqj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Oct 2021 09:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbhJ2Nqi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Oct 2021 09:46:38 -0400
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4ACAC061714;
        Fri, 29 Oct 2021 06:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1635515048;
        bh=BHapYodIdUOd5wtCD8Kwl7CJXpZuSFZSo7fcME2yZQc=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=SNlER5RvVwQDs70qW/EqcJAGuTRVbUczYAz5xoxKJRphbDkgZPP6exF7MqyKtwJnz
         W1cWrJzVfUVoHgnMouLYyxm3zJ8S0lQNHpvjMADeI7pDEuI9qfb2ZAaWeEmgkcv6Vq
         VlKz9+rDrHr5YJNB7dD8MTQXGeU7/MviKyxXSDSM=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id E427912802B5;
        Fri, 29 Oct 2021 09:44:08 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 8ois_Pnm4h6P; Fri, 29 Oct 2021 09:44:08 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1635515048;
        bh=BHapYodIdUOd5wtCD8Kwl7CJXpZuSFZSo7fcME2yZQc=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=SNlER5RvVwQDs70qW/EqcJAGuTRVbUczYAz5xoxKJRphbDkgZPP6exF7MqyKtwJnz
         W1cWrJzVfUVoHgnMouLYyxm3zJ8S0lQNHpvjMADeI7pDEuI9qfb2ZAaWeEmgkcv6Vq
         VlKz9+rDrHr5YJNB7dD8MTQXGeU7/MviKyxXSDSM=
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:c551::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 296A21280123;
        Fri, 29 Oct 2021 09:44:08 -0400 (EDT)
Message-ID: <37a994f0c9f29dc4dca35d95f76c4c886d3ba0b4.camel@HansenPartnership.com>
Subject: Re: [PATCH] scsi: ufs: mark HPB support as BROKEN
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Avri Altman <Avri.Altman@wdc.com>, Christoph Hellwig <hch@lst.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Date:   Fri, 29 Oct 2021 09:44:06 -0400
In-Reply-To: <DM6PR04MB6575BF38F8A144FD7D185E8EFC879@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20211026071204.1709318-1-hch@lst.de>
         <20211029105353.GA25156@lst.de>
         <a9641903818fd5e68397d9e42826640d9578c1ce.camel@HansenPartnership.com>
         <DM6PR04MB6575BF38F8A144FD7D185E8EFC879@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-10-29 at 13:35 +0000, Avri Altman wrote:
> > On Fri, 2021-10-29 at 12:53 +0200, Christoph Hellwig wrote:
> > > Given that the discussion is now turning into bikeshedding wether
> > > the non-public UFS spec is mereley completly broken or utterly
> > > completely broken can we please add this patch or the revert
> > > before 5.15 goes in? I don't think this mess will be resolved in
> > > any reasonable time.
> > 
> > No.  Removing the 2.0 HPB optimization fixes all your complaints
> > about the block API problems, so there's no need to do a full
> > revert.  I just need someone to test the partial revert ASAP.  If
> > no-one can test the partial revert then we can consider more
> > drastic options.
> I support Daejun's patch, but if this is your final decision, I can
> test it on Sunday. Can you refer me to exact patch needed to be
> tested?

https://lore.kernel.org/all/b2bcc13ccdc584962128a69fa5992936068e1a9b.camel@HansenPartnership.com/

Ideally before Sunday since that's when Linus will likely go final with
5.15

Thanks,

James


