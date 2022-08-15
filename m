Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19737C00140
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Aug 2022 06:35:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbiHOGfH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Aug 2022 02:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbiHOGfF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Aug 2022 02:35:05 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A69D1A822;
        Sun, 14 Aug 2022 23:35:04 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id D5E5C4127D;
        Mon, 15 Aug 2022 06:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received:received; s=mta-01; t=
        1660545301; x=1662359702; bh=eZTYwPRzpPiVcOU8/cFujCyEj6trT6pPH9k
        6SlhkRrc=; b=cTVaOuMDcEb2CKT8z3mwuWlaeyKZ2pw9bmr7SO8fHtWTvc0cBey
        m/MPxitWokJ8q/HfpYD709BfLg8jrjOfX9b6iF3Mzn5X6ocp2b2curW5JXB6h5zk
        RA0LMOzEC6rGlArodrkAJTMEyTK/gEULMS4oiDcD4AdC55/Aov3Vubtc=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 94OwcPfhzfGK; Mon, 15 Aug 2022 09:35:01 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id C92B44125E;
        Mon, 15 Aug 2022 09:35:00 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Mon, 15 Aug 2022 09:35:00 +0300
Received: from yadro.com (10.178.114.42) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Mon, 15 Aug
 2022 09:35:00 +0300
Date:   Mon, 15 Aug 2022 09:35:04 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     <michael.christie@oracle.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH 4/6] scsi: target: core: add emulate_rsoc attribute
Message-ID: <20220815063504.GA17595@yadro.com>
References: <20220718120117.4435-1-d.bogdanov@yadro.com>
 <20220718120117.4435-5-d.bogdanov@yadro.com>
 <479fd36d-7084-f37b-a2ab-f82105278cad@oracle.com>
 <20220812113441.GB32459@yadro.com>
 <7a21db22-5729-70d2-4f3b-f5f01a98cf77@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7a21db22-5729-70d2-4f3b-f5f01a98cf77@oracle.com>
X-Originating-IP: [10.178.114.42]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Aug 12, 2022 at 01:12:12PM -0500, michael.christie@oracle.com wrote:
> 
> On 8/12/22 6:34 AM, Dmitry Bogdanov wrote:
> > On Thu, Aug 11, 2022 at 10:43:24PM -0500, Mike Christie wrote:
> >>
> >> On 7/18/22 7:01 AM, Dmitry Bogdanov wrote:
> >>> Make support of RSOC turned off by emulate_rsoc attibute.
> >>>
> >>
> >> What was the reason for this?
> > Looks like, it was by analogue to other emulate_* attibutes. But
> > actually RSOC itself is independent to a backstore device, so better to
> > drop this patch :)
> 
> I was actually ok with it in general. It seemed nice for testing.
> 
> I was asking because I thought you hit some regressions when it was
> on and just wanted you add that info to the git commit.
No, there was no regression.
So, better to keep this patch but to add to a commit message, that it
is just for testing purposes?
