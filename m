Return-Path: <SRS0=RyiH=BH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6286C433E8
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jul 2020 20:02:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0CAF20809
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jul 2020 20:02:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728980AbgG1UCp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jul 2020 16:02:45 -0400
Received: from netrider.rowland.org ([192.131.102.5]:34291 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1728849AbgG1UCp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jul 2020 16:02:45 -0400
Received: (qmail 1512022 invoked by uid 1000); 28 Jul 2020 16:02:43 -0400
Date:   Tue, 28 Jul 2020 16:02:43 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Martin Kepplinger <martin.kepplinger@puri.sm>
Cc:     Bart Van Assche <bvanassche@acm.org>, jejb@linux.ibm.com,
        Can Guo <cang@codeaurora.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@puri.sm
Subject: Re: [PATCH] scsi: sd: add runtime pm to open / release
Message-ID: <20200728200243.GA1511887@rowland.harvard.edu>
References: <20200706164135.GE704149@rowland.harvard.edu>
 <d0ed766b-88b0-5ad5-9c10-a4c3b2f994e3@puri.sm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0ed766b-88b0-5ad5-9c10-a4c3b2f994e3@puri.sm>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jul 28, 2020 at 09:02:44AM +0200, Martin Kepplinger wrote:
> Hi Alan,
> 
> Any API cleanup is of course welcome. I just wanted to remind you that
> the underlying problem: broken block device runtime pm. Your initial
> proposed fix "almost" did it and mounting works but during file access,
> it still just looks like a runtime_resume is missing somewhere.

Well, I have tested that proposed fix several times, and on my system 
it's working perfectly.  When I stop accessing a drive it autosuspends, 
and when I access it again it gets resumed and works -- as you would 
expect.

> As we need to have that working at some point, I might look into it, but
> someone who has experience in the block layer can surely do it more
> efficiently.

I suspect that any problems you still face are caused by something else.

Alan Stern
