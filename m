Return-Path: <SRS0=HsAm=ZT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 190F7C432C0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 17:24:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF4B1206E0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 17:24:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="HQXPAeki"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbfK0RYe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Nov 2019 12:24:34 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:58550 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726292AbfK0RYe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Nov 2019 12:24:34 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 1F75941908;
        Wed, 27 Nov 2019 17:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1574875471;
         x=1576689872; bh=AhReUaPK4yzFFhByAiDOHhPyhZ6Oy4WFZuybvftsJl8=; b=
        HQXPAekij1T6OIxiYaLtnpBOLp8p0EOhOYLR+lk9BIdBJKY3e5dpF91YIdrNNGIQ
        9LVaF9OF/4E5F7PHSBfAhoQp9tAmNOlBMVhzmmcngziE02uqTMLG0d6JJcEYctL/
        2EbYy6mPVDpJ8baaEjHjdLs5ARGehWkDzTYgG8LJUcI=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id xFRllGOoIWWR; Wed, 27 Nov 2019 20:24:31 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 3A863412D2;
        Wed, 27 Nov 2019 20:24:31 +0300 (MSK)
Received: from localhost (172.17.128.60) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Wed, 27
 Nov 2019 20:24:30 +0300
Date:   Wed, 27 Nov 2019 20:24:27 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
        <linux@yadro.com>
Subject: Re: [PATCH v3 00/13] scsi: qla2xxx: Bug fixes
Message-ID: <20191127172427.jpqfopou7y6kyrev@SPB-NB-133.local>
References: <20191125165702.1013-1-r.bolshakov@yadro.com>
 <347fd571-89d7-2b7e-fd88-1711002c3fb9@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <347fd571-89d7-2b7e-fd88-1711002c3fb9@acm.org>
X-Originating-IP: [172.17.128.60]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 26, 2019 at 12:56:51PM -0800, Bart Van Assche wrote:
> On 11/25/19 8:56 AM, Roman Bolshakov wrote:
> > The patch series contains fixes for qla2xxx and solves two visible
> > issues: [ ... ]
> 
> As explained in Documentation/process/2.Process.rst, please post patches
> outside the merge window.
> 
> Thanks,
> 
> Bart.

Hi Bart,

Thank you for the reference. Could you please assess if my understanding
of the document is correct:
	The fixes might go into 5.5-rc2 after the release of rc1 which
	closes the merge window.

	No patches except critical for -rc1 should be posted when the
	merge window is opened.

Best regards,
Roman
