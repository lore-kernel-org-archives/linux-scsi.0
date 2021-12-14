Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08B9CC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Dec 2021 16:35:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235928AbhLNQfs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Dec 2021 11:35:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235914AbhLNQfs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Dec 2021 11:35:48 -0500
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0259C06173E
        for <linux-scsi@vger.kernel.org>; Tue, 14 Dec 2021 08:35:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1639499746;
        bh=W7wAuzkO0c9+jsnIHNsUv9u3cMgGL8C2Mwum9HXQ+QA=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=jCgR5MKqeRvIfv6eprQo/eR6kwelW0dFJ0VHffcLm9S7hIZosnRYCF7uU/KkXUiqm
         VichTOxQcHfyV1JiHCv+eR+pZxAAAhXcRHWs7a3lqTjoeRBqtyQdgqSRINrYjYDbeZ
         8AGWOQPtSZlROSQtdXFyOyAgCVoeuMMIgpOz626I=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 88AD8128088B;
        Tue, 14 Dec 2021 11:35:46 -0500 (EST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 44ZBMOe_-vlz; Tue, 14 Dec 2021 11:35:46 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1639499746;
        bh=W7wAuzkO0c9+jsnIHNsUv9u3cMgGL8C2Mwum9HXQ+QA=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=jCgR5MKqeRvIfv6eprQo/eR6kwelW0dFJ0VHffcLm9S7hIZosnRYCF7uU/KkXUiqm
         VichTOxQcHfyV1JiHCv+eR+pZxAAAhXcRHWs7a3lqTjoeRBqtyQdgqSRINrYjYDbeZ
         8AGWOQPtSZlROSQtdXFyOyAgCVoeuMMIgpOz626I=
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:c551::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 5DB9012806A6;
        Tue, 14 Dec 2021 11:35:45 -0500 (EST)
Message-ID: <5a5cd1dde61e656e15df3767e1a6d2cc362d280d.camel@HansenPartnership.com>
Subject: Re: [PATCH] scsi: ufs: Improve SCSI abort handling
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     Santosh Yaraganavi <santoshsy@gmail.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Vishak G <vishak.g@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Girish K S <girish.shivananjappa@linaro.org>,
        linux-scsi@vger.kernel.org, Asutosh Das <asutoshd@codeaurora.org>,
        Vinayak Holikatti <vinholikatti@gmail.com>
Date:   Tue, 14 Dec 2021 11:35:43 -0500
In-Reply-To: <163729506335.21244.1193812894951616835.b4-ty@oracle.com>
References: <20211104181059.4129537-1-bvanassche@acm.org>
         <163729506335.21244.1193812894951616835.b4-ty@oracle.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2021-11-18 at 23:16 -0500, Martin K. Petersen wrote:
> On Thu, 4 Nov 2021 11:10:53 -0700, Bart Van Assche wrote:
> 
> > The following has been observed on a test setup:
> > 
> > WARNING: CPU: 4 PID: 250 at drivers/scsi/ufs/ufshcd.c:2737
> > ufshcd_queuecommand+0x468/0x65c
> > Call trace:
> >  ufshcd_queuecommand+0x468/0x65c
> >  scsi_send_eh_cmnd+0x224/0x6a0
> >  scsi_eh_test_devices+0x248/0x418
> >  scsi_eh_ready_devs+0xc34/0xe58
> >  scsi_error_handler+0x204/0x80c
> >  kthread+0x150/0x1b4
> >  ret_from_fork+0x10/0x30
> > 
> > [...]
> 
> Applied to 5.16/scsi-fixes, thanks!
> 
> [1/1] scsi: ufs: Improve SCSI abort handling
>       https://git.kernel.org/mkp/scsi/c/3ff1f6b6ba6f

OK, so now we have a conflict between fixes and queue.  My impression
is that the patch causing the conflict:

https://lore.kernel.org/all/20211203231950.193369-14-bvanassche@acm.org/

Actually supersedes this one, so I can simply drop the entirety of this
patch in fixes, is that correct?

James


