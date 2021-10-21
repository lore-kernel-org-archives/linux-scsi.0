Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87231C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 08:56:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6919C60EFE
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 08:56:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbhJUI6W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Oct 2021 04:58:22 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:37718 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230269AbhJUI6V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Oct 2021 04:58:21 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 130CC42F73;
        Thu, 21 Oct 2021 08:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1634806564;
         x=1636620965; bh=eZngF4CFWTReaLuT2g7MGpj+YO4CVMh9/JhILGSLnTg=; b=
        KCocJb/cP84SlD5JaUPcGQGopidAAYjWyryi496wNPIuKTvA+7hXbOQS0vuslKyy
        5frdnI9R7A5/tDthu/2NhheatHLIwVzehmN6nqx1Zbk07Pc+Z4gsGvR6lvBWXatA
        CmPZ0m/nPjX8p3AEbcyNR5k5kTykW3RMUl2VAGAymYI=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id hIPMLCNUCjQH; Thu, 21 Oct 2021 11:56:04 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id EAC2D430BF;
        Thu, 21 Oct 2021 11:55:54 +0300 (MSK)
Received: from yadro.com (10.199.9.171) by T-EXCH-04.corp.yadro.com
 (172.17.100.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 21
 Oct 2021 11:55:53 +0300
Date:   Thu, 21 Oct 2021 11:55:53 +0300
From:   Konstantin Shelekhin <k.shelekhin@yadro.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Mike Christie <michael.christie@oracle.com>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: Re: [PATCH 1/2] scsi: target: core: Add sense reason for space
 allocation errors
Message-ID: <YXErGb3f2H4a39cD@yadro.com>
References: <20211020184319.588002-1-k.shelekhin@yadro.com>
 <20211020184319.588002-2-k.shelekhin@yadro.com>
 <yq1pmrz6pbl.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <yq1pmrz6pbl.fsf@ca-mkp.ca.oracle.com>
X-Originating-IP: [10.199.9.171]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Oct 20, 2021 at 11:21:54PM -0400, Martin K. Petersen wrote:
> 
> Konstantin,
> 
> > According to SBC-3 4.7.3.6 this sense reason shall be used in situations
> > where thin provisioned logical unit cannot satisfy the write request due
> > to the lack of free blocks.
> 
> > +	[TCM_SPACE_ALLOCATION_FAILED] = {
> > +		.key = DATA_PROTECT,
> > +		.asc = 0x27,
> > +		.ascq = 0x07, /* SPACE ALLOCATION FAILED WRITE PROTECT */
> > +	},
> 
> How do we know this is a permanent condition and not a temporary space
> exhaustion?

By permanent condition SBC-3 means that an initiator should not resend
the command immediately as it will fail again. Kernel tries hard not to
fail with BLK_STS_NOSPC:

  /*
   * We're holding onto IO to allow userland time to react.  After the
   * timeout either the pool will have been resized (and thus back in
   * PM_WRITE mode), or we degrade to PM_OUT_OF_DATA_SPACE w/ error_if_no_space.
   */
  static void do_no_space_timeout(struct work_struct *ws)

So BLK_STS_NOSPC means that we are stuck with this condition and some
out-of-scope actions (like running fs-trim on the initiator) are
required.
