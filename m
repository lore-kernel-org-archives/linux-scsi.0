Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCFDDC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jun 2022 10:32:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233867AbiFBKcL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jun 2022 06:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233414AbiFBKb5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jun 2022 06:31:57 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63892C5DAE
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jun 2022 03:31:54 -0700 (PDT)
Date:   Thu, 2 Jun 2022 12:31:51 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1654165913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OOr4prD5pfU6EO827BzjS91bImwjZe6fbVM8gMg1P3U=;
        b=YAUSODH69uQBByhG7kO8pb5msVRdwlYyX/2g7RY/vo1dyhLewNTJO5tDuxNgmT09OEK7Oj
        +0ccd8+ExzhjZxFrZre8kPptk94WJ4+TklyjEkq39XS4UWk6lhGqmUYhPPI5QruPHEvmae
        AgSvNc4SPhXZzZLcYiSH9weOb4Kfxu899tVGVXrjY5yghez1/MTRZR3hWMdZXS5Ep/JlDk
        HAojs4XIInKcWI9bd1G5+n6g3lnacU/3tK32XRjavg/B+oCW9IY5dVzIYOHt9DoN4DxkNG
        zfotKmBV8fljZ4Zrtg9vycAirGxLVCFcCKh32sMriY6qltefbQH79JqKbrzYLw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1654165913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OOr4prD5pfU6EO827BzjS91bImwjZe6fbVM8gMg1P3U=;
        b=ReI/D+Z3Hm8M0njCVZNlEgTgk69sXNko5Hqa7qNqs31iR/+0KnN/1Uzb6DxMptnjUDRth+
        Q8L+uVZnnO/k4OCA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Davidlohr Bueso <dave@stgolabs.net>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        ejb@linux.ibm.com, tglx@linutronix.de
Subject: Re: [PATCH 04/10] scsi/aic94xx: Replace the donelist tasklet with
 threaded irq
Message-ID: <YpiRl7lDg6TJ2sLX@linutronix.de>
References: <20220530231512.9729-1-dave@stgolabs.net>
 <20220530231512.9729-5-dave@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220530231512.9729-5-dave@stgolabs.net>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022-05-30 16:15:06 [-0700], Davidlohr Bueso wrote:
> Tasklets have long been deprecated as being too heavy on the system
> by running in irq context - and this is not a performance critical
> path. If a higher priority process wants to run, it must wait for
> the tasklet to finish before doing so. A more suitable equivalent
> is to converted to threaded irq instead and deal with the processing
> of donelist entries task context.
> 
> Also rename a lot of calls removing the 'tasklet' part, which
> of course no longer applies.

The change looks okay except that I don't see where the interrupt source
is disabled. It looks like asd_disable_ints() plus the last part of
asd_enable_ints() is needed.

> Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>

Sebastian
