Return-Path: <SRS0=SSlb=ED=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FB28C388F9
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Oct 2020 01:47:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AB2322281
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Oct 2020 01:47:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="M+1C+LC5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgJ1Bin (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Oct 2020 21:38:43 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:46032 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1833054AbgJ0Xqp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Oct 2020 19:46:45 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 1A39C412F3;
        Tue, 27 Oct 2020 23:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1603842400;
         x=1605656801; bh=z1lAivyAWMVrhdFLfzNfi3hY5tnKbWtUjtmUI3M2EjE=; b=
        M+1C+LC5dSvta1Qn1oUT0HmPktvDQ8OSsYzA1UBUZfQZW2huYII2kN8EcK+Eqrmn
        Oaa6d9vxUO8STh2NQzF8CP0wrkb/D1kFfVzvGrjb9YAi9+tHOoJ+oFDz5V3OSw9T
        dFSyre3QPSeW1iqYnsqgnVBchqPzzA73VtDM7KkvZ04=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id wbYx8PcnIBIm; Wed, 28 Oct 2020 02:46:40 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id B1E6841279;
        Wed, 28 Oct 2020 02:46:40 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-04.corp.yadro.com
 (172.17.100.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Wed, 28
 Oct 2020 02:46:39 +0300
Date:   Wed, 28 Oct 2020 02:46:39 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Anastasia Kovaleva <a.kovaleva@yadro.com>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>
Subject: Re: [PATCH 3/3] scsi: target: core: Change ASCQ for residual write
Message-ID: <20201027234639.GB88490@SPB-NB-133.local>
References: <20201022172011.42367-1-a.kovaleva@yadro.com>
 <20201022172011.42367-4-a.kovaleva@yadro.com>
 <e2b215ca-0aa8-bdae-e5bd-292a09d8282e@acm.org>
 <20201024121315.GA35317@SPB-NB-133.local>
 <b831a7db-1da2-c293-a8f6-d9c62f68c224@acm.org>
 <20201026131226.GA88490@SPB-NB-133.local>
 <270e2edf-49c9-942f-ac3d-b6dfa0aca8f7@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <270e2edf-49c9-942f-ac3d-b6dfa0aca8f7@acm.org>
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 26, 2020 at 07:42:55PM -0700, Bart Van Assche wrote:
> On 10/26/20 6:12 AM, Roman Bolshakov wrote:
> > Note, that if we talk about SSC over FCP, then "9.4.2 FCP_DATA IUs for
> > read and write operations" does additionally apply. Perhaps a) from
> > "9.4.2 FCP_DATA IUs for read and write operations" works well for SSC:
> > 
> >   a) process the command normally except that data beyond the FCP_DL count
> >   shall not be requested or transferred;
> > 
> > The clause allows to accomodate variable-block tranfers from SSC.
> > 
> > So, what if we return CHECK CONDITION only for SBC WRITEs with
> > residuals?  Then it has no impact on SSC and other device types. In
> > future, we might also add a patch that would fail SBC READs with
> > residuals for sake of consistency. That behaviour would be beneficial
> > for SBC devices as no host could corrupt data or itself by forming,
> > requesting invalid data buffer.
> 
> Maybe I'm overly concerned. I do not know for sure which applications
> rely on the current behavior of residual handling. All I know about
> these applications is based on what others wrote about these
> applications. An example from
> https://www.t10.org/pipermail/t10/2003-November/009317.html: "We have
> customers who also use overlength and underlength transfers as a normal
> mode of operation."
> 

Hi Bart,

Thanks for raising the point about overlength/underlength. If you wish
we can add an extra check that fails DMA_TO_DEVICE && DATA with
residuals only for SBC devices but note that before the series,
underflow/overflow for WRITE didn't return GOOD status. The particular
patch only changes sense code to more meaningful from the former INVALID
FIELD IN CDB.

Theoretically, it could be good to have a configurable switch how LIO
handles overflows/underflows for a LUN. Then it'd be possible to
configure desired behaviour on a per-LUN basis. But there should be a
clear need & demand for the feature to avoid maintenance of dead code.

> An additional question is what behavior other operating systems than
> Linux expect? There are probably setups in which another operating
> system than Linux communicates with a LIO SCSI target?
> 

TBH I don't know any hosts that do SBC WRITE with residuals as normal
course of operation. They wouldn't be able to work with LIO because it
never returns GOOD status on WRITE with residuals. I can send an update
later if the series works fine with modern hosts (~1 month, after a few
cycles of system testing).

Fun fact, ~60 years ago WRITE overflows were used to achieve behaviour
similar to disk zeroing/WRITE SAME [1].

1. https://mailarchive.ietf.org/arch/msg/ips/135ycRlgwUg1sb3gRrUQ3-lSXg0/

Thanks,
Roman
