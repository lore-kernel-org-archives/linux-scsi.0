Return-Path: <SRS0=+Znx=2C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B472EC00454
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Dec 2019 16:02:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76BF52173E
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Dec 2019 16:02:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="DiDRMAfI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729681AbfLLQCC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Dec 2019 11:02:02 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:50476 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729247AbfLLQCC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Dec 2019 11:02:02 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id C4DBB41207;
        Thu, 12 Dec 2019 16:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1576166519;
         x=1577980920; bh=evKapeN/xlZRI8s3j4FFPslz+UcCMm53EuXaIn4eqos=; b=
        DiDRMAfI2kE2pXJt1GTH5j1iUL/DAIpnfr8nHcDdCiFy/fl1P3wAGPt0jMbuS5Ut
        /1BLcmNnjY57djb9IjlKhNqdcPjRGLG/1bzqFKSvA6d4vtHm+KDdG3J2AzdPpvX5
        vW1EXq0CwxQePvrDyeWBT95DkCq3Tu22U666Gpkci0c=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id tD2hi9vyTMGK; Thu, 12 Dec 2019 19:01:59 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 7495C411FF;
        Thu, 12 Dec 2019 19:01:58 +0300 (MSK)
Received: from localhost (172.17.128.60) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 12
 Dec 2019 19:01:58 +0300
Date:   Thu, 12 Dec 2019 19:01:57 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Martin Wilck <mwilck@suse.de>
CC:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        <linux-scsi@vger.kernel.org>, Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>
Subject: Re: [PATCH 2/4] qla2xxx: Simplify the code for aborting SCSI commands
Message-ID: <20191212160157.6tira3qfhtfnxld3@SPB-NB-133.local>
References: <20191209180223.194959-1-bvanassche@acm.org>
 <20191209180223.194959-3-bvanassche@acm.org>
 <f7a05e5696b1942b3303e20fe0e6891bc9a61090.camel@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f7a05e5696b1942b3303e20fe0e6891bc9a61090.camel@suse.de>
X-Originating-IP: [172.17.128.60]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Dec 10, 2019 at 12:47:57PM +0100, Martin Wilck wrote:
> Hi Bart,
> 
> On Mon, 2019-12-09 at 10:02 -0800, Bart Van Assche wrote:
> > Since the SCSI core does not reuse the tag of the SCSI command that
> > is
> > being aborted by .eh_abort() before .eh_abort() has finished it is
> > not
> > necessary to check from inside that callback whether or not the SCSI
> > command
> > has already completed. Instead, rely on the firmware to return an
> > error code
> > when attempting to abort a command that has already completed.
> > Additionally,
> > rely on the firmware to return an error code when attempting to abort
> > an
> > already aborted command.
> 
> Do we have evidence that the firmware can truly be relied upon in this
> respect? It's at least not impossible that the FW (or some version of
> it) relies on the driver not trying to abort commands that have been
> aborted or completed already, and crashes if that assumption is
> violated.
> 

Hi Martin,

IMO yes, FW spec defines the behavior mentioned by Bart in the commit
message. So an Abort IOCB is going to be completed by FW (including an
error if the command was already aborted) or timed out if FW is down.

Thanks,
Roman
