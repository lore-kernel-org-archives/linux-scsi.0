Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE7F1EB64DC
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jun 2023 17:04:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbjFVRET (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Jun 2023 13:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbjFVRES (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jun 2023 13:04:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065DE171C;
        Thu, 22 Jun 2023 10:04:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 936146184D;
        Thu, 22 Jun 2023 17:04:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95FE4C433C8;
        Thu, 22 Jun 2023 17:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1687453457;
        bh=CUb1r77sczHHVHY+vTbaAic4qViP8MYNo43Ytj7EWx8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qM2kRM/69kq0xhfMOUvvb3O1Rda7qKqphuH7ylZX6NOhj06plX5jNG+uApBdF7wdl
         HDdeey6Eh0IMdUxCA+/eFzGOfPfUmISegMOWPJubII1z5aM8Py3ovEWv4hXplrS4LK
         6pJ9vEeMacXHBUv41riVO6BJcCIPxJ817CRQ2wgg=
Date:   Thu, 22 Jun 2023 19:04:13 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Cc:     Ranjan Kumar <ranjan.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        sreekanth.reddy@broadcom.com, stable@vger.kernel.org
Subject: Re: [PATCH] mpt3sas: Perform additional retries if Doorbell read
 returns 0
Message-ID: <2023062228-circus-deed-7c9e@gregkh>
References: <20230615083010.45837-1-ranjan.kumar@broadcom.com>
 <2023061538-dizzy-amiable-9ec7@gregkh>
 <CAFdVvOwjQZZnViCYbJqPC81ZJPsZdqjNuQE=dH4bHWD4Pyu7Ew@mail.gmail.com>
 <2023062207-plywood-vindicate-c271@gregkh>
 <CAFdVvOyMdoE8Nwg82uj0HRw=MuAsxgKprTjb0p9bxL6efNPSOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFdVvOyMdoE8Nwg82uj0HRw=MuAsxgKprTjb0p9bxL6efNPSOw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jun 22, 2023 at 10:15:58AM -0600, Sathya Prakash Veerichetty wrote:
> On Thu, Jun 22, 2023 at 10:08 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Thu, Jun 22, 2023 at 09:26:50AM -0600, Sathya Prakash Veerichetty wrote:
> > > --
> > > This electronic communication and the information and any files transmitted
> > > with it, or attached to it, are confidential and are intended solely for
> > > the use of the individual or entity to whom it is addressed and may contain
> > > information that is confidential, legally privileged, protected by privacy
> > > laws, or otherwise restricted from disclosure to anyone else. If you are
> > > not the intended recipient or the person responsible for delivering the
> > > e-mail to the intended recipient, you are hereby notified that any use,
> > > copying, distributing, dissemination, forwarding, printing, or copying of
> > > this e-mail is strictly prohibited. If you received this e-mail in error,
> > > please return the e-mail to the sender, delete it from your computer, and
> > > destroy any printed copy of it.
> >
> > Now deleted.
> you didn't receive this in error, so you can keep it,

No I can not, as this obviously is confidential, and as such, I need to
delete it because that is incompatible with kernel development.

> not sure from
> when this footer is getting added, I will check on the options to
> remove it :(
> 
> -- 
> This electronic communication and the information and any files transmitted 
> with it, or attached to it, are confidential and are intended solely for 
> the use of the individual or entity to whom it is addressed and may contain 
> information that is confidential, legally privileged, protected by privacy 
> laws, or otherwise restricted from disclosure to anyone else. If you are 
> not the intended recipient or the person responsible for delivering the 
> e-mail to the intended recipient, you are hereby notified that any use, 
> copying, distributing, dissemination, forwarding, printing, or copying of 
> this e-mail is strictly prohibited. If you received this e-mail in error, 
> please return the e-mail to the sender, delete it from your computer, and 
> destroy any printed copy of it.


I'll go delete this as well.

