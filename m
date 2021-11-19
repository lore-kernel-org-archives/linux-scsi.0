Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03A62C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 20:43:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC31B61AD0
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 20:43:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235536AbhKSUqG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Nov 2021 15:46:06 -0500
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:46710 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235655AbhKSUp6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Nov 2021 15:45:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1637354560;
        bh=FVtTtXwTrPFBMPA0G3eTCexqCnJ2kv+U4R0sIpmaeFw=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=g56DC5exLkfegsybvLwsGhJi8QBUFBKlSNY+ERrq7Ab/aLc0S8LXOZrIj5apYmacw
         H3l3UF4CwJ8u+UBhgXsCGecjcRuyHvJ7ZG7/lKKR9tUgdSpv5jEmYD9CGC2rvvqJxA
         Bnvy/XszaKaS1jUWQAvyEyyTpLlN/HWoDGpPEBe8=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id CBA8C12805A8;
        Fri, 19 Nov 2021 15:42:40 -0500 (EST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ib8k2oZzhkrh; Fri, 19 Nov 2021 15:42:40 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1637354560;
        bh=FVtTtXwTrPFBMPA0G3eTCexqCnJ2kv+U4R0sIpmaeFw=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=g56DC5exLkfegsybvLwsGhJi8QBUFBKlSNY+ERrq7Ab/aLc0S8LXOZrIj5apYmacw
         H3l3UF4CwJ8u+UBhgXsCGecjcRuyHvJ7ZG7/lKKR9tUgdSpv5jEmYD9CGC2rvvqJxA
         Bnvy/XszaKaS1jUWQAvyEyyTpLlN/HWoDGpPEBe8=
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:c551::c447])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 4D5951280597;
        Fri, 19 Nov 2021 15:42:40 -0500 (EST)
Message-ID: <ef1a4924d085d4a4bd646358947e5cf7ed690cc4.camel@HansenPartnership.com>
Subject: Re: [GIT PULL] SCSI fixes for 5.16-rc1
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Fri, 19 Nov 2021 15:42:39 -0500
In-Reply-To: <CAHk-=whgVp3m-HDiAPDAXAN0nTs+Fx3onnHE1XRg8cxPnmPw9Q@mail.gmail.com>
References: <0a508ff31bbfa9cd73c24713c54a29ac459e3254.camel@HansenPartnership.com>
         <CAHk-=wjiTXOy3EJ4Eb++umuCgiDufJxrNZ9Z17_NhdORKZGbSA@mail.gmail.com>
         <af4fd590c7b90e5b3eef13f2fcd0bbb500192d2a.camel@HansenPartnership.com>
         <CAHk-=whgVp3m-HDiAPDAXAN0nTs+Fx3onnHE1XRg8cxPnmPw9Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-11-19 at 12:41 -0800, Linus Torvalds wrote:
> On Fri, Nov 19, 2021 at 12:07 PM James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > I can certainly relate to the need to be clear and unambiguous, but
> > this is the thin end of the wedge: you'll be telling me I can't use
> > the subjunctive mood next just because Americans don't understand
> > what it is ...
> 
> Please do strive to keep it to monosyllabic words, with the
> occasional grunt for emphasis.

Ugh.

James


