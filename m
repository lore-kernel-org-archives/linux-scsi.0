Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67A1DC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 11:39:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42C3961181
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 11:39:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbhJ2Llr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Oct 2021 07:41:47 -0400
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:51862 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231807AbhJ2Llr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 29 Oct 2021 07:41:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1635507558;
        bh=l8eKkyWifkJcRVaeSzJ+LwsrAy/jA+WHQIcFrcLxLkk=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=BZSzyuBCq4bqwgsBexYweVjm7r0mdv59B46doANAAEXXwxJVmQK3V2mCKJIK03Dti
         EwcUDeNty781tm+O1vHU/92lleGeetRkz7wA6LCSAfD9BAITh8ZJGto8blPjUfKL3h
         z4umc8vKVx2VxZMFhVg+TQ4OYmeHzPQG4NecDueg=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id C4D3D128012A;
        Fri, 29 Oct 2021 07:39:18 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id hVWbNjhWUqUU; Fri, 29 Oct 2021 07:39:18 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1635507558;
        bh=l8eKkyWifkJcRVaeSzJ+LwsrAy/jA+WHQIcFrcLxLkk=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=BZSzyuBCq4bqwgsBexYweVjm7r0mdv59B46doANAAEXXwxJVmQK3V2mCKJIK03Dti
         EwcUDeNty781tm+O1vHU/92lleGeetRkz7wA6LCSAfD9BAITh8ZJGto8blPjUfKL3h
         z4umc8vKVx2VxZMFhVg+TQ4OYmeHzPQG4NecDueg=
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:c551::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 1B73F1280123;
        Fri, 29 Oct 2021 07:39:18 -0400 (EDT)
Message-ID: <a9641903818fd5e68397d9e42826640d9578c1ce.camel@HansenPartnership.com>
Subject: Re: [PATCH] scsi: ufs: mark HPB support as BROKEN
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com
Cc:     axboe@kernel.dk, alim.akhtar@samsung.com, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Date:   Fri, 29 Oct 2021 07:39:16 -0400
In-Reply-To: <20211029105353.GA25156@lst.de>
References: <20211026071204.1709318-1-hch@lst.de>
         <20211029105353.GA25156@lst.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-10-29 at 12:53 +0200, Christoph Hellwig wrote:
> Given that the discussion is now turning into bikeshedding wether the
> non-public UFS spec is mereley completly broken or utterly completely
> broken can we please add this patch or the revert before 5.15
> goes in?  I don't think this mess will be resolved in any reasonable
> time.

No.  Removing the 2.0 HPB optimization fixes all your complaints about
the block API problems, so there's no need to do a full revert.  I just
need someone to test the partial revert ASAP.  If no-one can test the
partial revert then we can consider more drastic options.

James


