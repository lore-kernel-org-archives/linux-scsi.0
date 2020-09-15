Return-Path: <SRS0=FSVS=CZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40F39C2D0E3
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 00:26:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 099A72076B
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 00:26:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="ZDUvluzG";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="ZDUvluzG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgIPA01 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 20:26:27 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34438 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726798AbgIOOMf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Sep 2020 10:12:35 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 9BF068EE188;
        Tue, 15 Sep 2020 07:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1600179008;
        bh=+R+IKAKZQYkLR7KIiLxpuuPm5bZnjzeal3GKWrEShUo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZDUvluzGV6yKCC/nF9wrKzitsx/6M3Qz4Dv0CFUEt0vmhscavKWlYegA3t3D9AtoS
         cgl18SKCLQ6g+fOWhOlSE1rajdI6kKqsO/3XSzI9vcO6roMQjXQ+sBvii1pDKecG7Q
         7/nP62+cOOfIkefYX7rGreL2C+Tu2bzmyrkPw+GQ=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id o2D0dkS7cauB; Tue, 15 Sep 2020 07:10:08 -0700 (PDT)
Received: from [153.66.254.174] (c-73-35-198-56.hsd1.wa.comcast.net [73.35.198.56])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 329868EE107;
        Tue, 15 Sep 2020 07:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1600179008;
        bh=+R+IKAKZQYkLR7KIiLxpuuPm5bZnjzeal3GKWrEShUo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZDUvluzGV6yKCC/nF9wrKzitsx/6M3Qz4Dv0CFUEt0vmhscavKWlYegA3t3D9AtoS
         cgl18SKCLQ6g+fOWhOlSE1rajdI6kKqsO/3XSzI9vcO6roMQjXQ+sBvii1pDKecG7Q
         7/nP62+cOOfIkefYX7rGreL2C+Tu2bzmyrkPw+GQ=
Message-ID: <1600179006.5092.6.camel@HansenPartnership.com>
Subject: Re: [PATCH 07/17] 53c700: improve non-coherent DMA handling
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        iommu@lists.linux-foundation.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        nouveau@lists.freedesktop.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mm@kvack.org,
        alsa-devel@alsa-project.org
Date:   Tue, 15 Sep 2020 07:10:06 -0700
In-Reply-To: <20200915062738.GA19113@lst.de>
References: <20200914144433.1622958-1-hch@lst.de>
         <20200914144433.1622958-8-hch@lst.de>
         <1600096818.4061.7.camel@HansenPartnership.com>
         <20200915062738.GA19113@lst.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-09-15 at 08:27 +0200, Christoph Hellwig wrote:
> On Mon, Sep 14, 2020 at 08:20:18AM -0700, James Bottomley wrote:
> > If you're going to change the macros from taking a device to taking
> > a hostdata structure then the descriptive argument name needs to
> > change ... it can't be dev anymore.  I'm happy with it simply
> > becoming 'h' if hostdata is too long.
> > 
> > I already asked for this on the first go around:
> 
> And I did rename them, those hunks just accidentally slipped into
> patch 12 instead of this one.  Fixed for the next versions.

Ah, yes, found it ... thanks for doing that!

James

