Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8C93C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Oct 2022 16:12:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbiJDQMF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Oct 2022 12:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbiJDQME (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2022 12:12:04 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC752C124;
        Tue,  4 Oct 2022 09:12:02 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id B3783400F8;
        Tue,  4 Oct 2022 16:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received:received; s=mta-01; t=
        1664899919; x=1666714320; bh=dH7lqXY01Swks/S07+FWlWZZlhTdRKPvKgr
        auZGZClU=; b=B0ZKSsBwJYdrsH0WravGkm+nbsPf6+FI0RoCEGsOxvBbxB6+SOL
        GnDS4jNKwlrb01E7wPzd6a8EYi+05DD5lkvfRvKfjBsn57RS9YTrb6BAW8+nERkn
        Qy8j0yxj6AYAYmLyaQQAplIYJhWtAiKN3KCbwO4EPm7ENYe8RyNV9Rtc=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id K9-A9XpbS_E8; Tue,  4 Oct 2022 19:11:59 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (T-EXCH-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id B7CB0400F6;
        Tue,  4 Oct 2022 19:11:58 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Tue, 4 Oct 2022 19:11:58 +0300
Received: from yadro.com (10.199.18.20) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Tue, 4 Oct 2022
 19:11:57 +0300
Date:   Tue, 4 Oct 2022 19:11:57 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH 2/7] scsi: target: core: Add RTPI field to target port
Message-ID: <20221004161157.GB10901@yadro.com>
References: <20220906154519.27487-1-d.bogdanov@yadro.com>
 <20220906154519.27487-3-d.bogdanov@yadro.com>
 <6f4dba25-33af-b268-bf6f-541febf3c939@oracle.com>
 <056b4919-e1c1-55f7-3fdb-74053ae9909e@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <056b4919-e1c1-55f7-3fdb-74053ae9909e@oracle.com>
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 29, 2022 at 06:57:03PM -0500, Mike Christie wrote:
> 
> On 9/29/22 5:26 PM, Mike Christie wrote:
> >
> > I think you could just use an ida.
> >
> 
> After seeing the other patches I guess you need a idr.
> 

idr is deprecated, I looked at xarray. Looks good, I will rewrite
the patches using it. 

Thanks!
