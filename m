Return-Path: <SRS0=1zSt=BV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F7FFC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Aug 2020 13:48:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75D4320771
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Aug 2020 13:48:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728742AbgHKNsy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Aug 2020 09:48:54 -0400
Received: from netrider.rowland.org ([192.131.102.5]:57121 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1728532AbgHKNsw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2020 09:48:52 -0400
Received: (qmail 332045 invoked by uid 1000); 11 Aug 2020 09:48:51 -0400
Date:   Tue, 11 Aug 2020 09:48:51 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Martin Kepplinger <martin.kepplinger@puri.sm>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@puri.sm
Subject: Re: [PATCH] scsi: sd: add runtime pm to open / release
Message-ID: <20200811134851.GB331864@rowland.harvard.edu>
References: <9b80ca7c-39f8-e52d-2535-8b0baf93c7d1@puri.sm>
 <425990b3-4b0b-4dcf-24dc-4e7e60d5869d@puri.sm>
 <20200807143002.GE226516@rowland.harvard.edu>
 <b0abab28-880e-4b88-eb3c-9ffd927d1ed9@puri.sm>
 <20200808150542.GB256751@rowland.harvard.edu>
 <d3b6f7b8-5345-1ae1-4f79-5dde226e74f1@puri.sm>
 <20200809152643.GA277165@rowland.harvard.edu>
 <60150284-be13-d373-5448-651b72a7c4c9@puri.sm>
 <20200810141343.GA299045@rowland.harvard.edu>
 <6f0c530f-4309-ab1e-393b-83bf8367f59e@puri.sm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f0c530f-4309-ab1e-393b-83bf8367f59e@puri.sm>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 11, 2020 at 09:55:54AM +0200, Martin Kepplinger wrote:
> On 10.08.20 16:13, Alan Stern wrote:
> > This may not matter...  but it's worth pointing out that 
> > expecting_media_change doesn't get cleared if ++scmd->retries > 
> > scmd->allowed.
> 
> absolutely worth pointing out and I'm not yet sure about that one.
> 
> > 
> > It also doesn't get cleared in cases where the device _doesn't_ 
> > report a Unit Attention.
> 
> true. but don't we set the flag for a future UA we don't yet know of? If
> we would want to clear it outside of a UA, I think we'd need to keep
> track of a suspend/resume cycle and if we see that we *had* successfully
> "done requests" after resuming, we could clear it...

The point is that expecting_media_change should apply only to the _next_ 
command.  It should be cleared after _every_ command.  You do not want 
to leave it hanging around -- if you do then you will miss real media 
changes.

There's a potential issue when a bunch of commands get sent and 
completed all at once, but hopefully it won't matter here.

Alan Stern
