Return-Path: <SRS0=cHy8=5B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B705CC3F2CE
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 18:39:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 901F6206E2
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 18:39:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="eKT7Ix2I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732391AbgCPSjA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Mar 2020 14:39:00 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:45746 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731967AbgCPSjA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Mar 2020 14:39:00 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id A5BB84127E;
        Mon, 16 Mar 2020 18:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1584383937;
         x=1586198338; bh=IDlh78HUmjLpYI7/EBcvo7skTYYErY5ATOZCfcmy26k=; b=
        eKT7Ix2IkPcuBX2lU4fW/lW8C/LmfIEjMEYdQO90PXLvuLLHTu+84Srd2ugyrydW
        O5zm06m7M1VTsevbICeAHwpY3CELu6LKBRjQ8gNtW/WXM23MjQ9OqMVpD9Q9Jf7N
        xfTEbcHZ/n9P4WrhKf2FZ/e4XXEDoDfQnk3CyhENAMI=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id H9cZQgHcMfVv; Mon, 16 Mar 2020 21:38:57 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 41CFC41259;
        Mon, 16 Mar 2020 21:38:56 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Mon, 16
 Mar 2020 21:38:56 +0300
Date:   Mon, 16 Mar 2020 21:38:56 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     <martin.petersen@oracle.com>, <emilne@redhat.com>,
        <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH] qla2xxx: Fix I/Os being passed down when FC device is
 being deleted.
Message-ID: <20200316183856.GB4312@SPB-NB-133.local>
References: <20200313085001.3781-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200313085001.3781-1-njavali@marvell.com>
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Mar 13, 2020 at 01:50:01AM -0700, Nilesh Javali wrote:
> From: Arun Easi <aeasi@marvell.com>
> 
> I/Os could be passed down while the device FC SCSI device is being deleted.
> This would result in unnecessary delay of I/O and driver messages (when
> extended logging is set).
> 
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> ---
>  drivers/scsi/qla2xxx/qla_os.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

Hi Nilesh, Arun,

Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>

Thanks,
Roman
