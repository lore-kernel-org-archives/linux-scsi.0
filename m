Return-Path: <SRS0=Yi3m=46=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38DE4C10DCE
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 15:36:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0741F206B7
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 15:36:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="ojazE4xK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgCMPg5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Mar 2020 11:36:57 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:55256 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726475AbgCMPg5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 13 Mar 2020 11:36:57 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id CC5DE4128A;
        Fri, 13 Mar 2020 15:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1584113814;
         x=1585928215; bh=gP7ojruYoiAL+Yk42QW6bWroZK1gTrJhbb4XV8iCKWM=; b=
        ojazE4xK3HEocyrXpQgJ2ywxbQSWMsCoPlm9WtPmKBebnmJZK4adcNSPhyhMYQzQ
        Q40/4D+MjMINFed9SepOwdwaI+UyR8MWiT6qr9Y9PwZqkOmorNRRfFXCwgfpYefv
        8D3X6x53hOk9cEV8nzFt20yTG0Wi+Dee7lgip6OoEpk=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id W_IyDtFbsZmG; Fri, 13 Mar 2020 18:36:54 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id B5DD74128F;
        Fri, 13 Mar 2020 18:36:52 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Fri, 13
 Mar 2020 18:36:52 +0300
Date:   Fri, 13 Mar 2020 18:36:52 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <mwilck@suse.com>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        Daniel Wagner <dwagner@suse.de>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] scsi: qla2xxx: set UNLOADING before waiting for
 session deletion
Message-ID: <20200313153652.GB42639@SPB-NB-133.local>
References: <20200205214422.3657-1-mwilck@suse.com>
 <20200205214422.3657-4-mwilck@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200205214422.3657-4-mwilck@suse.com>
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Feb 05, 2020 at 10:44:22PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> The purpose of the UNLOADING flag is to avoid port login procedures
> to continue when a controller is in the process of shutting down.
> It makes sense to set this flag before starting session teardown.
> The only operations that must be able to continue are LOGO, PRLO,
> and the like.
> 
> Furthermore, use atomic test_and_set_bit() to avoid the shutdown
> being run multiple times in parallel. In qla2x00_disable_board_on_pci_error(),
> the test for UNLOADING is postponed until after the check for an already
> disabled PCI board.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  drivers/scsi/qla2xxx/qla_os.c | 25 +++++++++++--------------
>  1 file changed, 11 insertions(+), 14 deletions(-)
> 

Hi Martin,

Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>

Thanks,
Roman
