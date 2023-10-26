Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E2BFC25B6F
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Oct 2023 12:01:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbjJZMBL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Oct 2023 08:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbjJZMBJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Oct 2023 08:01:09 -0400
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97AA19C;
        Thu, 26 Oct 2023 05:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1698321665;
        bh=kF2UFLghMNovt0IBC7kLh7kUmS4+nkpCLYwbQ9dsJiA=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=lV7NZD2fJHZo0NrqX8ukxBz4jkiyAgmnalqoz7xA2aBfK8pHvkTkaRWujeOCgjtDB
         FjC9iHO5QJjFISJq7j/Q34cT5bUTz3WsZfSkiW8ToPsSFzTb2zR3cnWD6ekCtT/hQ2
         +ryZiLaYTtuKZLem2b0jMHp2MPbq3Ps2rrFukPXI=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 5222512867B6;
        Thu, 26 Oct 2023 08:01:05 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id o-y0OTZ32oB1; Thu, 26 Oct 2023 08:01:05 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1698321665;
        bh=kF2UFLghMNovt0IBC7kLh7kUmS4+nkpCLYwbQ9dsJiA=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=lV7NZD2fJHZo0NrqX8ukxBz4jkiyAgmnalqoz7xA2aBfK8pHvkTkaRWujeOCgjtDB
         FjC9iHO5QJjFISJq7j/Q34cT5bUTz3WsZfSkiW8ToPsSFzTb2zR3cnWD6ekCtT/hQ2
         +ryZiLaYTtuKZLem2b0jMHp2MPbq3Ps2rrFukPXI=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::c14])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id B194A1281C67;
        Thu, 26 Oct 2023 08:01:04 -0400 (EDT)
Message-ID: <c3dfca871ddddfeef004fdb74432630a148300f2.camel@HansenPartnership.com>
Subject: Re: [PATCH] scsi: sd: Introduce manage_shutdown device flag
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Damien Le Moal <dlemoal@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Date:   Thu, 26 Oct 2023 08:01:03 -0400
In-Reply-To: <bf780d7a-30f3-4744-adde-73b4c2723d6b@kernel.org>
References: <20231025070117.464903-1-dlemoal@kernel.org>
         <39fef5f8e090d50eb22d73d6bb39b21edf62b565.camel@HansenPartnership.com>
         <bf780d7a-30f3-4744-adde-73b4c2723d6b@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2023-10-26 at 06:30 +0900, Damien Le Moal wrote:
> On 10/25/23 20:57, James Bottomley wrote:
> > On Wed, 2023-10-25 at 16:01 +0900, Damien Le Moal wrote:
> > > +++ b/include/scsi/scsi_device.h
> > > @@ -164,6 +164,7 @@ struct scsi_device {
> > >  
> > >         bool manage_system_start_stop; /* Let HLD (sd) manage
> > > system
> > > start/stop */
> > >         bool manage_runtime_start_stop; /* Let HLD (sd) manage
> > > runtime start/stop */
> > > +       bool manage_shutdown;   /* Let HLD (sd) manage shutdown
> > > */
> > >  
> > 
> > I think at least 85% of the world gets confused about the
> > difference
> > between runtime/system start/stop and shutdown.  Could we at least
> > point to a doc explaining it in a comment here?
> 
> Would improving the comments here be enough ? E.g. something like:
> 
>         /* Let the HLD (sd) manage system suspend (start) and resume
> (stop).
>          * This applies to both suspend to RAM and suspend to disk
>          * (hybernation).
>          */
>         bool manage_system_start_stop;
> 
>         /*
>          * Let the HLD (sd) manage device runtime suspend (stop) and
>          * resume (start).
>          */
>         bool manage_runtime_start_stop;
> 
>         /* Let the HLD (sd) manage system power-off (shutdown) */
>         bool manage_shutdown;

Heh, well, I was going to say we should still point to the doc, but I
simply can't find it, so the above is perhaps the best we can do,
thanks!

James

