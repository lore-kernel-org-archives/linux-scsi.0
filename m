Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A140EC64E7A
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 09:54:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54E55206CA
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 09:54:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387840AbgLAJyW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 04:54:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:57460 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387811AbgLAJyW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 1 Dec 2020 04:54:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7F5A1AC65;
        Tue,  1 Dec 2020 09:53:41 +0000 (UTC)
Date:   Tue, 1 Dec 2020 10:53:41 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Saurav Kashyap <skashyap@marvell.com>
Cc:     Nilesh Javali <njavali@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 05/15] qla2xxx: Don't check for fw_started while posting
 nvme command
Message-ID: <20201201095341.lrckuwzmy22iwg2h@beryllium.lan>
References: <20201201082730.24158-1-njavali@marvell.com>
 <20201201082730.24158-6-njavali@marvell.com>
 <20201201090151.bdyeliawhpps7wd7@beryllium.lan>
 <DM6PR18MB303409D3CEC61DBF206FD257D2F40@DM6PR18MB3034.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR18MB303409D3CEC61DBF206FD257D2F40@DM6PR18MB3034.namprd18.prod.outlook.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Saurav

On Tue, Dec 01, 2020 at 09:39:05AM +0000, Saurav Kashyap wrote:
> > > --- a/drivers/scsi/qla2xxx/qla_nvme.c
> > > +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> > > @@ -554,19 +554,15 @@ static int qla_nvme_post_cmd(struct
> > nvme_fc_local_port *lport,
> > >
> > >  	fcport = qla_rport->fcport;
> > >
> > > -	if (!qpair || !fcport)
> > > -		return -ENODEV;
> > > -
> > > -	if (!qpair->fw_started || fcport->deleted)
> > > +	if (unlikely(!qpair || !fcport || fcport->deleted))
> > >  		return -EBUSY;
> > 
> > This reverts the fix from patch #1 in this series. What's the reasoning
> > that needs to return EBUSY when !qpair || !fcport is true?
>
> Ideally driver should not hit (!qpair || !fcport) case.  The patch was
> to remove fw_started flag and consolidate other checks.

Looking again on the patch I think I got confused.

> We want IO to retry until remote port is deleted and below condition is hit.

The result of this patch is that in EBUSY will be returned in all the
cases, not just for the case of fcport->deleted. So all is good from my
point of view. Thanks for explaining.

Sorry for the noise.

Thanks,
Daniel
