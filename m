Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05DD0C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Dec 2021 17:43:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233430AbhLNRnQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Dec 2021 12:43:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbhLNRnQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Dec 2021 12:43:16 -0500
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D76C8C061574
        for <linux-scsi@vger.kernel.org>; Tue, 14 Dec 2021 09:43:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1639503795;
        bh=fiKmaZivaOnSYfhFJ/FhePzsLNDwtK2zUROpdIjytkk=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=gygOuLfMzuwOTWr07orQiQvjhAe+ZkW6a6ezvzEELYkBZiuLWtVTpz8FpkMMssHU1
         rZqt3O00VfeeJLjbLokmhDmFPrnhyGaQ8H9n4OLqYB6BSFHaoYhtkknpxzeIfzQdHC
         ZiUvE6oppNtKD1zcwYl6Nl+iJmAljH8GcuKJBZKY=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 86DC91280585;
        Tue, 14 Dec 2021 12:43:15 -0500 (EST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id VivJq3xtRqGF; Tue, 14 Dec 2021 12:43:15 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1639503795;
        bh=fiKmaZivaOnSYfhFJ/FhePzsLNDwtK2zUROpdIjytkk=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=gygOuLfMzuwOTWr07orQiQvjhAe+ZkW6a6ezvzEELYkBZiuLWtVTpz8FpkMMssHU1
         rZqt3O00VfeeJLjbLokmhDmFPrnhyGaQ8H9n4OLqYB6BSFHaoYhtkknpxzeIfzQdHC
         ZiUvE6oppNtKD1zcwYl6Nl+iJmAljH8GcuKJBZKY=
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:c551::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id DD61E12804EE;
        Tue, 14 Dec 2021 12:43:13 -0500 (EST)
Message-ID: <acf65d27c844695118146aa34bc995780fd35b68.camel@HansenPartnership.com>
Subject: Re: [PATCH] scsi: ufs: Improve SCSI abort handling
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Santosh Yaraganavi <santoshsy@gmail.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Vishak G <vishak.g@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Girish K S <girish.shivananjappa@linaro.org>,
        linux-scsi@vger.kernel.org, Asutosh Das <asutoshd@codeaurora.org>,
        Vinayak Holikatti <vinholikatti@gmail.com>
Date:   Tue, 14 Dec 2021 12:43:12 -0500
In-Reply-To: <1fed2928-a021-dcb9-18bb-3167fe23420a@acm.org>
References: <20211104181059.4129537-1-bvanassche@acm.org>
         <163729506335.21244.1193812894951616835.b4-ty@oracle.com>
         <5a5cd1dde61e656e15df3767e1a6d2cc362d280d.camel@HansenPartnership.com>
         <1fed2928-a021-dcb9-18bb-3167fe23420a@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-12-14 at 09:37 -0800, Bart Van Assche wrote:
> On 12/14/21 8:35 AM, James Bottomley wrote:
> > On Thu, 2021-11-18 at 23:16 -0500, Martin K. Petersen wrote:
> > > Applied to 5.16/scsi-fixes, thanks!
> > > 
> > > [1/1] scsi: ufs: Improve SCSI abort handling
> > >        https://git.kernel.org/mkp/scsi/c/3ff1f6b6ba6f
> > 
> > OK, so now we have a conflict between fixes and queue.  My
> > impression
> > is that the patch causing the conflict:
> > 
> > https://lore.kernel.org/all/20211203231950.193369-14-bvanassche@acm.org/
> > 
> > Actually supersedes this one, so I can simply drop the entirety of
> > this patch in fixes, is that correct?
> 
> Hi James,
> 
> Commit 1fbaa02dfd05 ("scsi: ufs: Improve SCSI abort handling
> further") is intended as an improvement for commit 3ff1f6b6ba6f
> ("scsi: ufs: core: Improve SCSI abort handling"). Since commit
> 3ff1f6b6ba6f is already in Linus' tree I don't think that it can be
> dropped? A possible approach is to revert commit 3ff1f6b6ba6f before
> merging the mkp-scsi/for-next branch.

I meant the effect of the fixes patch can be dropped in the merge
commit.  So the sole surviving code is from the misc tree.  Like what I
did at the top of the for-next branch:

https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/commit/?h=for-next&id=014adbc9a838772b265834a55cd7b13eb2665d7e

James


