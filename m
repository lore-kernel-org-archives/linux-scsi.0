Return-Path: <SRS0=IzRR=ZR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58BBEC432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Nov 2019 17:00:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21E1420740
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Nov 2019 17:00:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="rvc2U2J5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728970AbfKYRAz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Nov 2019 12:00:55 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:39862 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728889AbfKYRAz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 25 Nov 2019 12:00:55 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 3426F43E03;
        Mon, 25 Nov 2019 17:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1574701253;
         x=1576515654; bh=60Im1dAmsYCXgAZlPke449ofasnr+EQspzw1INso3wc=; b=
        rvc2U2J5q6QXH7LrJDmIbC9T/CLobzvCzJYmp9pVhD+q1YhiY5b1RHHwEj1wXu8D
        owC+268Xmak8XNhgqscyUlI2rfkHeMPYJAJZBEUrr9wDMFZqiHKavN5B+KH45fdI
        9ZNbLFuaZJfxDFOi8DuHeyqdERjIqPc96LBtN+m39LI=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id CzawR2BHu6vT; Mon, 25 Nov 2019 20:00:53 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 6BC7E437F8;
        Mon, 25 Nov 2019 20:00:52 +0300 (MSK)
Received: from localhost (172.17.128.60) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Mon, 25
 Nov 2019 20:00:52 +0300
Date:   Mon, 25 Nov 2019 20:00:51 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>
CC:     <linux@yadro.com>, Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 07/13] scsi: qla2xxx: Don't call qlt_async_event twice
Message-ID: <20191125170051.kxctfl7skse3gfk7@SPB-NB-133.local>
References: <20191125165702.1013-1-r.bolshakov@yadro.com>
 <20191125165702.1013-8-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20191125165702.1013-8-r.bolshakov@yadro.com>
X-Originating-IP: [172.17.128.60]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Nov 25, 2019 at 07:56:56PM +0300, Roman Bolshakov wrote:
> MBA_PORT_UPDATE generates duplicate log lines in target mode because
> qlt_async_event is called twice. Drop the calls within the case as
> the function will be called right after the switch statement.
> 
> Cc: Quinn Tran <qutran@marvell.com>
> Acked-by: Himanshu Madhani <hmadhani@marvel.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Tested-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
> ---

The Acked-by tag should contain:

Acked-by: Himanshu Madhani <hmadhani@marvell.com>
