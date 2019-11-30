Return-Path: <SRS0=mhd7=ZW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EA70C432C0
	for <linux-scsi@archiver.kernel.org>; Sat, 30 Nov 2019 09:57:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D74162075C
	for <linux-scsi@archiver.kernel.org>; Sat, 30 Nov 2019 09:57:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="KoMICk4J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbfK3J5W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 30 Nov 2019 04:57:22 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:51888 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725792AbfK3J5W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 30 Nov 2019 04:57:22 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id D982F43E08;
        Sat, 30 Nov 2019 09:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1575107840;
         x=1576922241; bh=iOMeOzgtkRjMah+k9vlQ+9zeLqyGz3BxynIGOosgJmo=; b=
        KoMICk4JTc4abjfu/HtU2IjCUbI8HrTfHrUj1OMhVXQnZv5tOJVb8gyaAWY6tzjJ
        YZHjULLlQJgeeDMPI5K9ep6w+DVCW+sVLnUf+hDg36LM3DGP6zatzMlveWR+NmcJ
        4EdWI/7yq2HZb6tZGCriLAKZLpKUeH94a2CNOa1QNZI=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 9qnokDLOaz2Y; Sat, 30 Nov 2019 12:57:20 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 9BE73437F6;
        Sat, 30 Nov 2019 12:57:18 +0300 (MSK)
Received: from localhost (172.17.128.60) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Sat, 30
 Nov 2019 12:57:17 +0300
Date:   Sat, 30 Nov 2019 12:57:17 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Martin Wilck <Martin.Wilck@suse.com>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/2] scsi: qla2xxx: avoid sending mailbox commands if
 firmware is stopped
Message-ID: <20191130095717.fzklgdpelcxtoksy@SPB-NB-133.local>
References: <20191129202627.19624-1-martin.wilck@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20191129202627.19624-1-martin.wilck@suse.com>
X-Originating-IP: [172.17.128.60]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Nov 29, 2019 at 08:26:34PM +0000, Martin Wilck wrote:
> After commit 45235022da99 ("scsi: qla2xxx: Fix driver unload by shutting
> down chip"), it is possible that FC commands are scheduled after the
> adapter firmware has been shut down. IO sent to the firmware in this
> situation hangs indefinitely. Avoid this for the LOGO code path that is
> typically taken when adapters are shut down.
> 

Hi Martin,

Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>

Thanks,
Roman
