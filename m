Return-Path: <SRS0=+pba=Z2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D23EC43603
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Dec 2019 12:07:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D206020803
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Dec 2019 12:07:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="sMBn4FtE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbfLDMHT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Dec 2019 07:07:19 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:34034 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727445AbfLDMHT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 4 Dec 2019 07:07:19 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 1BC49439EC;
        Wed,  4 Dec 2019 12:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1575461236;
         x=1577275637; bh=oDwI7/KbktXqyroHAQEgk4iRwnK5ayog4DCgaHlwp5Q=; b=
        sMBn4FtELEBgf62bjn3U2ijsnPuU+UIUatovvaC8juX1jJGxwZ0J+fbLPt54KiJ6
        KzL/Psx8Jguqsf5Y9meclO3rbw+/2V6uVAsjCKZwjPBiEO2dpThHYa3hJS3MJgJO
        9Msq1JU3+OLTTS6SJSrkGfIPWBrZyZERhkkNYnzheDs=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id nA3IOX8cKVCL; Wed,  4 Dec 2019 15:07:16 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 120FF411FD;
        Wed,  4 Dec 2019 15:07:16 +0300 (MSK)
Received: from localhost (172.17.128.60) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Wed, 4 Dec
 2019 15:07:15 +0300
Date:   Wed, 4 Dec 2019 15:07:15 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>, Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: Re: [PATCH] Revert "qla2xxx: Fix Nport ID display value"
Message-ID: <20191204120715.dgpr6xcdcckkae4q@SPB-NB-133.local>
References: <20191109042135.12125-1-bvanassche@acm.org>
 <20191111112804.nycfzaddewlz6yzl@SPB-NB-133.local>
 <af903206-ce02-ef50-567f-d647efe0476a@acm.org>
 <20191202205554.5p77fyot6bc2ij6t@SPB-NB-133.local>
 <10e0c0c1-f3ad-7233-995d-59f1b748e39f@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <10e0c0c1-f3ad-7233-995d-59f1b748e39f@acm.org>
X-Originating-IP: [172.17.128.60]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Dec 02, 2019 at 06:34:43PM -0800, Bart Van Assche wrote:
> On 2019-12-02 12:55, Roman Bolshakov wrote:
> > On Mon, Dec 02, 2019 at 08:40:17AM -0800, Bart Van Assche wrote:
> >> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
> >> index b25f87ff8cde..e2e91b3f2e65 100644
> >> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> >> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> >> @@ -2656,10 +2656,16 @@ qla24xx_els_logo_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
> >>  	els_iocb->port_id[0] = sp->fcport->d_id.b.al_pa;
> >>  	els_iocb->port_id[1] = sp->fcport->d_id.b.area;
> >>  	els_iocb->port_id[2] = sp->fcport->d_id.b.domain;
> >> -	/* For SID the byte order is different than DID */
> >> -	els_iocb->s_id[1] = vha->d_id.b.al_pa;
> >> -	els_iocb->s_id[2] = vha->d_id.b.area;
> >> -	els_iocb->s_id[0] = vha->d_id.b.domain;
> >> +	if (IS_QLA23XX(vha->hw) || IS_QLA24XX(vha->hw) || IS_QLA25XX(vha->hw)) {
> >> +		els_iocb->s_id[0] = vha->d_id.b.al_pa;
> >> +		els_iocb->s_id[1] = vha->d_id.b.area;
> >> +		els_iocb->s_id[2] = vha->d_id.b.domain;
> >> +	} else {
> >> +		/* For SID the byte order is different than DID */
> >> +		els_iocb->s_id[1] = vha->d_id.b.al_pa;
> >> +		els_iocb->s_id[2] = vha->d_id.b.area;
> >> +		els_iocb->s_id[0] = vha->d_id.b.domain;
> >> +	}
> >>
> >>  	if (elsio->u.els_logo.els_cmd == ELS_DCMD_PLOGI) {
> >>  		els_iocb->control_flags = 0;
> > 
> > Hi Bart,
> > 
> > I'm fine as long as it works for old and new HBAs. I don't have docs to
> > 2300/2400 series and the HBAs. Are you sure it follows the same S_ID
> > order as 2500?
> > 
> > Regardless of that, it should work for the last 4 series of the HBAs,
> > Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
> 
> Hi Roman,
> 
> Thanks for the review. In my copy of the 25xx firmware manual the s_id[]
> field has been marked as RESERVED. I have tried not to write into s_id[]
> but that was not sufficient to restore point-to-point mode.
> 

Hi Bart,

IMO that means the field is undocumented rather than RESERVED on 2500
series chips.

> Older versions of the qla2xxx driver did not initialize s_id[]. I think
> that commit edd05de19759 ("scsi: qla2xxx: Changes to support N2N
> logins") is the commit that introduced initialization of s_id[]. Is that
> value passed to the target port? Did that commit perhaps introduce code
> that checks the value received by the target?
> 

Firmware can do implicit login, and this is how it worked for a while.

Then explicit login was introduced in the commit you referenced by
setting bit 8 in IFCB fimwrare options 3 for 2600/2700 series and
issuing ELS IOCB. However, for 2500 series, bit 7 should be set to
disable implicit logins.

The latest commits that touches the bit is 8777e4314d397 ("scsi: qla2xxx:
Migrate NVME N2N handling into state machine"). It sets the bit in
qla24xx_nvram_config regadless of chip.

Does it help to set bit 7 in IFCB, firmware options 3 for 2500 series
and leave the RESERVED S_ID field untouched?

Thanks,
Roman
