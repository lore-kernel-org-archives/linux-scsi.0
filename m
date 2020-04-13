Return-Path: <SRS0=9ymf=55=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6F05C2BA19
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 18:16:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C70A20692
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 18:16:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="kBqOtBsB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387685AbgDMSQm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Apr 2020 14:16:42 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:50282 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387623AbgDMSQl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Apr 2020 14:16:41 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 7692541769;
        Mon, 13 Apr 2020 18:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1586801797;
         x=1588616198; bh=tMoDmhL3i+JHsSnxxmL4pbpcyZhFnr7+NRubOgN/oYw=; b=
        kBqOtBsB7p4AO9+eUJMhrbAiwuBBgI0cPlf42jf82QSCIMHFrUdwyYyqCvEsrK8z
        05etwzak7FVrdkya0RvH5T8DenVU+baAdT4d7nm2Q41KQAsh7gcPxYXWAjmc3yQi
        b26JkWZ1n7xkwl3rrBd8slG8WzsHp2bYV7Z8DjAtunE=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id r31eKufmr7ud; Mon, 13 Apr 2020 21:16:37 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 734F7416EA;
        Mon, 13 Apr 2020 21:16:36 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Mon, 13
 Apr 2020 21:16:37 +0300
Date:   Mon, 13 Apr 2020 21:16:37 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 1/2] qla2xxx: Fix regression warnings
Message-ID: <20200413181637.GB8042@SPB-NB-133.local>
References: <20200403084018.30766-1-njavali@marvell.com>
 <20200403084018.30766-2-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200403084018.30766-2-njavali@marvell.com>
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Apr 03, 2020 at 01:40:17AM -0700, Nilesh Javali wrote:
> drivers/scsi/qla2xxx/qla_dbg.c:2542:7: warning: The scope of the variable 'pbuf'
> can be reduced. [variableScope]
> drivers/scsi/qla2xxx/qla_init.c:3615:6: warning: Variable 'rc' is assigned a
> value that is never used. [unreadVariable]
> drivers/scsi/qla2xxx/qla_isr.c:81:11-29: WARNING: dma_alloc_coherent use in
> rsp_els already zeroes out memory, so memset is not needed
> drivers/scsi/qla2xxx/qla_mbx.c:4889:15-33: WARNING: dma_alloc_coherent use in
> els_cmd_map already zeroes out memory, so memset is not needed
> 

Hi Nilesh,

It would be good to mention the errors are from cppcheck,

Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>

Thanks,
Roman
