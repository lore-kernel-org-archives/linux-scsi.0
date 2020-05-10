Return-Path: <SRS0=m8SI=6Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDCDFC38A2A
	for <linux-scsi@archiver.kernel.org>; Sun, 10 May 2020 18:52:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF568208DB
	for <linux-scsi@archiver.kernel.org>; Sun, 10 May 2020 18:52:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="nm+ODXUe";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="nm+ODXUe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729183AbgEJSwm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 May 2020 14:52:42 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41576 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728123AbgEJSwm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 10 May 2020 14:52:42 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 99E5F8EE25D;
        Sun, 10 May 2020 11:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1589136761;
        bh=sLpu0wHOTCWG3KdSdAW6JSiP8XsJYEcNfsFkt8yoONk=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=nm+ODXUe7jKYqF56dEIBJRv0+Z2+GatWKRhGv7ii3aou5Eg7RuOSvQTtc+PNW+R9p
         wj7q/5Ksm54H9gfWn9uuWq19FltxRecinmIwaIbVoZG1XEoqDncjGTYBy8TJ4oV4hc
         YOd3qy+q3OX1ltEabYQ/Ndf6GRssBkPvbfi1nTpQ=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id wd70HzhIYAgi; Sun, 10 May 2020 11:52:41 -0700 (PDT)
Received: from [153.66.254.194] (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 083DA8EE268;
        Sun, 10 May 2020 11:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1589136761;
        bh=sLpu0wHOTCWG3KdSdAW6JSiP8XsJYEcNfsFkt8yoONk=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=nm+ODXUe7jKYqF56dEIBJRv0+Z2+GatWKRhGv7ii3aou5Eg7RuOSvQTtc+PNW+R9p
         wj7q/5Ksm54H9gfWn9uuWq19FltxRecinmIwaIbVoZG1XEoqDncjGTYBy8TJ4oV4hc
         YOd3qy+q3OX1ltEabYQ/Ndf6GRssBkPvbfi1nTpQ=
Message-ID: <1589136759.9701.25.camel@HansenPartnership.com>
Subject: Re: scsi_alloc_target: parent of the target (need not be a scsi
 host)
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     dgilbert@interlog.com,
        SCSI development list <linux-scsi@vger.kernel.org>
Date:   Sun, 10 May 2020 11:52:39 -0700
In-Reply-To: <59d462c4-ceab-041a-bbb5-5b509f13a123@interlog.com>
References: <59d462c4-ceab-041a-bbb5-5b509f13a123@interlog.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 2020-05-10 at 14:32 -0400, Douglas Gilbert wrote:
> This gem is in scsi_scan.c in the documentation of that function's
> first argument. "need not be a scsi host" should read "it damn well
> better be a scsi host" otherwise that function will crash and burn!

It shouldn't: several transport classes, like SAS and FC have
intermediate devices between the host and the target and they all work
just fine using the non-host parent.  Since you don't give the error
this is just guesswork, but the host has to be somewhere in the parent
chain otherwise dev_to_shost(parent) will return NULL ... is that your
problem?

> I'm trying to work out why the function: starget_for_each_device() in
> scsi.c does _not_ use that collection right in front of it (i.e.
> scsi_target::devices). Instead, it step up to the host level, and
> iterates over all devices (LUs) on that host and only calls the given
> function for those devices that match the channel and target numbers.
> That is bizarrely wasteful if scsi_target::devices could be iterated
> over instead.
> 
> Anyone know why this is?

Best guess would be it wasn't converted over when the target list was
introduced.

James

