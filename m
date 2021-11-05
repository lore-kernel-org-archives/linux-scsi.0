Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BAEBC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Nov 2021 12:44:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10A0F6125F
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Nov 2021 12:44:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233238AbhKEMrg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Nov 2021 08:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232870AbhKEMrT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Nov 2021 08:47:19 -0400
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C56AC0797B3;
        Fri,  5 Nov 2021 05:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1636116236;
        bh=qsySuMLlAEPdSK9Db72nqC7LfOtbm6Jlt5zMUv7cGWY=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=Dfuaf4NYj8SATI8nWLhVUgllNzIhXCNylrOkcW6ecHVgcuRrN3IZARNHSC0t20uki
         V5/PYzjfQr7CzZIqE0SsntQ3ABD22CgwByaHBi8b2zewVhWznRRZvb2nX0mMsco81S
         iVVG75CECNhc3Uc90FK/4PRGzJcTaM6iqP1lRRbE=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 2163C1280AD4;
        Fri,  5 Nov 2021 08:43:56 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id FFQmC8HDBcOS; Fri,  5 Nov 2021 08:43:56 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1636116236;
        bh=qsySuMLlAEPdSK9Db72nqC7LfOtbm6Jlt5zMUv7cGWY=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=Dfuaf4NYj8SATI8nWLhVUgllNzIhXCNylrOkcW6ecHVgcuRrN3IZARNHSC0t20uki
         V5/PYzjfQr7CzZIqE0SsntQ3ABD22CgwByaHBi8b2zewVhWznRRZvb2nX0mMsco81S
         iVVG75CECNhc3Uc90FK/4PRGzJcTaM6iqP1lRRbE=
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:c551::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 6F9DE12809C6;
        Fri,  5 Nov 2021 08:43:55 -0400 (EDT)
Message-ID: <1a031eaec5f867380e8aeabef57e5cecff70e701.camel@HansenPartnership.com>
Subject: Re: [GIT PULL] first round of SCSI updates for the 5.15+ merge
 window
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Steffen Maier <maier@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Fri, 05 Nov 2021 08:43:53 -0400
In-Reply-To: <f5900f54-dddd-6dd4-ce13-a8bdfa58b6ad@linux.ibm.com>
References: <b13f25e87fd8d4ed027ef64aba8ebd7273c4b8b8.camel@HansenPartnership.com>
         <f5900f54-dddd-6dd4-ce13-a8bdfa58b6ad@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-11-05 at 13:37 +0100, Steffen Maier wrote:
> Hi James,
> 
> On 11/5/21 13:14, James Bottomley wrote:
> > a move to register core sysfs files
> > earlier, which means they're available to KOBJ_ADD processing,
> > which
> > necessitates switching all drivers to using attribute groups.
> 
> I seem to be missing?:
> 
> https://lore.kernel.org/linux-scsi/163478764102.7011.9375895285870786953.b4-ty@oracle.com/t/#mab0eeb4a8d8db95c3ace0013bfef775736e124cb
> ("scsi: core: Fix early registration of sysfs attributes for
> scsi_device")
> https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?h=5.16/scsi-staging&id=3a71f0f7a51259b3cb95d79cac1e19dcc5e89ce9
> https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?h=5.16/scsi-queue&id=3a71f0f7a51259b3cb95d79cac1e19dcc5e89ce9

We have quite a list of patches that came in just before the merge
window opened.  They get incubated in linux-next for as long as
possible and then sent in the final pull request.

James


