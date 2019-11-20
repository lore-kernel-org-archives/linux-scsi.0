Return-Path: <SRS0=SaCo=ZM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B538C432C0
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 00:09:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E2BD22440
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 00:09:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="vrbiAU1n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbfKTAJn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Nov 2019 19:09:43 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:41762 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726911AbfKTAJm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Nov 2019 19:09:42 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 9184743B0D;
        Wed, 20 Nov 2019 00:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1574208580;
         x=1576022981; bh=to4YK2jaQHz4/H+9scqkyU153Kk2jE89BgTRdn7HLAQ=; b=
        vrbiAU1nLYWAtHl8EHb4ozQFaCmr/J9ZNmKxmtql4OvEpux8P1MfDewD1W1U6Zb3
        ak3D98ENUne5EubEhjcGmPSa2hNztZjuuDlhsPV3C7yUiduEBff08Ye1OrH/RcN+
        73s8ALF0n9CGFvTa+gvxcpD0rRZZVQQ8BMaYIZWmAcI=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id yhXMURU8Y3Eq; Wed, 20 Nov 2019 03:09:40 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 02E19438D1;
        Wed, 20 Nov 2019 03:09:39 +0300 (MSK)
Received: from localhost (172.17.128.60) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Wed, 20
 Nov 2019 03:09:38 +0300
Date:   Wed, 20 Nov 2019 03:09:38 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Himanshu Madhani <hmadhani@marvell.com>
CC:     Bart Van Assche <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Quinn Tran <qutran@marvell.com>
Subject: Re: [EXT] [PATCH 0/4] scsi: qla2xxx: Bug fixes
Message-ID: <20191120000938.vy7o2znyj4lpnpan@SPB-NB-133.local>
References: <20190912003919.8488-1-r.bolshakov@yadro.com>
 <8774334a-b1e7-1a5e-0da3-82db68f963b6@acm.org>
 <20190912133605.age2zo7jxdbe4jiq@SPB-NB-133.local>
 <B39B0F4F-3439-4313-A808-578047F1B93A@marvell.com>
 <20191107190032.idvubxehqtzbe3ah@SPB-NB-133.local>
 <20191113185423.ofjxrsxazahy3gbx@SPB-NB-133.local>
 <0B40AFCA-8CB0-4F21-BDD1-DFE7A66DAA07@marvell.com>
 <20191119214656.t2rluirv5kgzl6vg@SPB-NB-133.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20191119214656.t2rluirv5kgzl6vg@SPB-NB-133.local>
X-Originating-IP: [172.17.128.60]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 20, 2019 at 12:46:56AM +0300, Roman Bolshakov wrote:
> Hi Himanshu,
> 
> I've tried the patch and it seems that LOGO doesn't succeed yet:
> [ 1079.073246] qla2xxx [0000:00:06.0]-2870:1: Async-logout - hdl=0 loop-id=0 portid=000002 21:00:00:24:ff:7f:35:c6.
> [ 1079.073333] qla2xxx [0000:00:06.0]-5837:1: Async-logout failed - 21:00:00:24:ff:7f:35:c6 hdl=12 portid=000002 comp=31 iop0=19 iop1=c.
> 
> It means that firmware detected IOCB parameter error at offset 0xc.
> I'll examine IOCB parameter dumps tomorrow.
> 

FWIW, it was an easy fix, we have to set either explicit LOGO bit or implicit
LOGO bit. Free N_Port handle is not allowed to be set alone. I corrected
the patch:
https://github.com/roolebo/linux/commit/6e86300a60552bfc0a4c49d65d89e5011dd90f10

--
Roman
