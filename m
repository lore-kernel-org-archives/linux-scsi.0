Return-Path: <SRS0=XP5+=5I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9CDBC54FCE
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Mar 2020 20:18:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD25D20663
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Mar 2020 20:18:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="N9CkLFXm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbgCWUSV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Mar 2020 16:18:21 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:42780 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725830AbgCWUSV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Mar 2020 16:18:21 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02NKFmgK018596;
        Mon, 23 Mar 2020 13:18:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0818; bh=+8LlreWiBPZMVJ76MqqI/+a7Vpor05RNf6FLgw7h/xY=;
 b=N9CkLFXmJdYGZqg0XRK/MarPhFzitIMraWTvH1ypxDqNfr825p2Ll4E5C49l8UhzUaRD
 LIzkwMp9V9tzoNR3gx1WmZr5gaGQDQMhAx+XRYIEz8gS4oItiXWiXcJx8yyRMlnCUwHm
 a8TMJUkZatsbSLqyiUN0NgE2QzBjpRSP2fswPEP8rMqhwRQCi0Xcc9Tx8zfklnufazCa
 H6CszBipWyTC3EZ2aB3s2Mb0Bd7v9v7yESzjZAJpS7eBDuH4q7fwGnmthJBY6scBifak
 dv6e+Q9nA+tW5AYWPLWq+MGHTu5hzXT2AvDEsm3uZMWSctIWDM+fMvB6nwDnXEDTWrAg TA== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ywg9nfx9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 23 Mar 2020 13:18:18 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Mar
 2020 13:18:16 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 23 Mar 2020 13:18:16 -0700
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id EC34A3F7044;
        Mon, 23 Mar 2020 13:18:16 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 02NKIG3P028035;
        Mon, 23 Mar 2020 13:18:16 -0700
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Mon, 23 Mar 2020 13:18:16 -0700
From:   Arun Easi <aeasi@marvell.com>
X-X-Sender: aeasi@irv1user01.caveonetworks.com
To:     Himanshu Madhani <himanshu.madhani@oracle.com>
CC:     Roman Bolshakov <r.bolshakov@yadro.com>,
        Nilesh Javali <njavali@marvell.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        <emilne@redhat.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH] qla2xxx: Fix I/Os being passed down when FC device is
 being deleted.
In-Reply-To: <e702fd5f-e3e1-1c76-6c49-c0ccf0b2c7ee@oracle.com>
Message-ID: <alpine.LRH.2.21.9999.2003231317040.12727@irv1user01.caveonetworks.com>
References: <20200313085001.3781-1-njavali@marvell.com>
 <20200316183856.GB4312@SPB-NB-133.local>
 <e702fd5f-e3e1-1c76-6c49-c0ccf0b2c7ee@oracle.com>
User-Agent: Alpine 2.21.9999 (LRH 334 2019-03-29)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-23_08:2020-03-23,2020-03-23 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 17 Mar 2020, 7:16am, Himanshu Madhani wrote:

> On 3/16/2020 1:38 PM, Roman Bolshakov wrote:
> > On Fri, Mar 13, 2020 at 01:50:01AM -0700, Nilesh Javali wrote:
> > > From: Arun Easi <aeasi@marvell.com>
> > > 
> > > I/Os could be passed down while the device FC SCSI device is being
> > > deleted.
> > > This would result in unnecessary delay of I/O and driver messages (when
> > > extended logging is set).
> > > 
> > > Signed-off-by: Arun Easi <aeasi@marvell.com>
> > > ---
> > >   drivers/scsi/qla2xxx/qla_os.c | 4 ++--
> > >   1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > 
> > Hi Nilesh, Arun,
> > 
> > Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
> > 
> > Thanks,
> > Roman

Thanks Roman.

> > 
> 
> Thanks Arun. FWIW, I remember this change :)

:) Yep, glad to see you back here, and thanks for the review, Himanshu.

Regards,
-Arun

> 
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> 
> 
