Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B78AC636D3
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Feb 2023 15:12:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbjBLPMD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Feb 2023 10:12:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjBLPMD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Feb 2023 10:12:03 -0500
Received: from mail2-relais-roc.national.inria.fr (mail2-relais-roc.national.inria.fr [192.134.164.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B271206B;
        Sun, 12 Feb 2023 07:12:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=TRBsEcj+bcndYS2aps87v+puDogttJYSq5q3V0BYYFE=;
  b=eKZm10UlcYbP8lqWGf1PzGxe9WMgexdv0BkVAldG9jbKEYecoq51JHRg
   1tkj7qcrFM50rnaOOwBNph8Jo/j3u5WwRJ3dOlRZjrGBjPqjST7psW1dh
   qkMpd9PZq8sx/xJ4MuRCbqeDXHgryy47DfJmTUk3EHdsHyno4tUR1C7Ct
   8=;
Authentication-Results: mail2-relais-roc.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=julia.lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.97,291,1669071600"; 
   d="scan'208";a="92317009"
Received: from 231.85.89.92.rev.sfr.net (HELO hadrien) ([92.89.85.231])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2023 16:11:58 +0100
Date:   Sun, 12 Feb 2023 16:11:58 +0100 (CET)
From:   Julia Lawall <julia.lawall@inria.fr>
X-X-Sender: jll@hadrien
To:     Deepak R Varma <drv@mailo.com>
cc:     Bart Van Assche <bvanassche@acm.org>, Michael Reed <mdr@sgi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Saurabh Singh Sengar <ssengar@microsoft.com>,
        Praveen Kumar <kumarpraveen@linux.microsoft.com>
Subject: Re: [PATCH] scsi: qla1280: Replace arithmetic addition by bitwise
 OR
In-Reply-To: <Y+kA1j10JCsLG9mN@ubun2204.myguest.virtualbox.org>
Message-ID: <alpine.DEB.2.22.394.2302121611010.9268@hadrien>
References: <Y+I7/QpQYjBXutLf@ubun2204.myguest.virtualbox.org> <aed35866-507c-870c-7e8a-c1868bcaa084@acm.org> <Y+kA1j10JCsLG9mN@ubun2204.myguest.virtualbox.org>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On Sun, 12 Feb 2023, Deepak R Varma wrote:

> On Sat, Feb 11, 2023 at 03:25:03PM -0800, Bart Van Assche wrote:
> > On 2/7/23 03:54, Deepak R Varma wrote:
> > > When adding two bit-field mask values, an OR operation offers higher
> > > performance over an arithmetic operation. So, convert such addition to
> > > an OR based expression.
> >
> > Where is the evidence that supports this claim? On the following page I read
> > that there is no performance difference when using a modern CPU: https://cs.stackexchange.com/questions/75811/why-is-addition-as-fast-as-bit-wise-operations-in-modern-processors
> >
>
> Hello Bart,
> You are correct. Modern CPU designs have improved addition and the performance
> is at par with the bitwise operation. The document I had read earlier mentioned
> a performance improvement for old CPUs and microprocessors, which today is not
> the case. Thank you for sharing the link.
>
> > > Issue identified using orplus.cocci semantic patch script.
> >
> > Where is that script located? Can it be deleted such that submission of
> > patches similar to this patch stops?
>
> I have added Julia to this email to understand how to best use this semantic
> patch. I already discussed with her on improving the Semantic patch such that it
> doesn't suggest making change when constants are involved.

FWIW, the semantic patch was never motivated by efficiency, but rather
with the goal of making the code more understandable.

julia
