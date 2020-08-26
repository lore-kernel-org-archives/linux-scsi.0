Return-Path: <SRS0=243Y=CE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FF91C433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Aug 2020 16:35:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 467C32080C
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Aug 2020 16:35:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="YypZ4VZY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbgHZQfF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Aug 2020 12:35:05 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:31156 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726772AbgHZQe7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Aug 2020 12:34:59 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07QGUOTL026509;
        Wed, 26 Aug 2020 09:34:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0220; bh=H9QKRsn3Hoq2NW5w/2vX6w6Cdab5FAgIDXygM4SSaM4=;
 b=YypZ4VZY5KIiioCIigwXPjpWp+cFlIem+jvkWUnsne0l+0Ysg25KsrRKroFDTUXQVLwt
 PleAzdORW+g5IexUwvGkaabvhcp8J0QW3jS+7tbACJuNxVH2r6Mo0zJqcHu5mLdAUGpl
 c+9lKf9NSCKjy2wSIurZPbiWF3ySU5HY20Nj/EuH49kHtMfK912RncTmy8byBq3WBbig
 jp8wEmSWbQIj+Iv+q8OrdHfTBXoX6YeE22Dh5iDIyuJNWg2xtB2BtqL3WI+CwCj30b8g
 fDIJmvfTcr80x2NjwNIeukF+/JYcfmrU21ccs1OyYeygKiD945pTU2Z/fKBm9JXOVph2 pA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3332vn1md5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 26 Aug 2020 09:34:56 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 Aug
 2020 09:34:54 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 Aug 2020 09:34:54 -0700
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id 620893F703F;
        Wed, 26 Aug 2020 09:34:54 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 07QGYrZa029186;
        Wed, 26 Aug 2020 09:34:53 -0700
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Wed, 26 Aug 2020 09:34:53 -0700
From:   Arun Easi <aeasi@marvell.com>
X-X-Sender: aeasi@irv1user01.caveonetworks.com
To:     Alex Dewar <alex.dewar90@gmail.com>
CC:     Nilesh Javali <njavali@marvell.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: qla2xxx: Remove unnecessary call to memset
In-Reply-To: <c6f52893-6fa4-f5f8-42a8-9a2482f16c45@gmail.com>
Message-ID: <alpine.LRH.2.21.9999.2008260934420.31539@irv1user01.caveonetworks.com>
References: <20200820185149.932178-1-alex.dewar90@gmail.com>
 <c6f52893-6fa4-f5f8-42a8-9a2482f16c45@gmail.com>
User-Agent: Alpine 2.21.9999 (LRH 334 2019-03-29)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-26_10:2020-08-26,2020-08-26 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 24 Aug 2020, 2:42pm, Alex Dewar wrote:

> 
> On 2020-08-20 19:51, Alex Dewar wrote:
> > In qla25xx_set_els_cmds_supported(), a call is made to
> > dma_alloc_coherent() followed by zeroing the memory with memset. This is
> > unnecessary as dma_alloc_coherent() already zeros memory. Remove.
> > 
> > Issue identified with Coccinelle.
> > 
> > Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
> Gentle ping?
> > ---
> >   drivers/scsi/qla2xxx/qla_mbx.c | 2 --
> >   1 file changed, 2 deletions(-)
> > 
> > diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
> > index 226f1428d3e5..e00f604bbf7a 100644
> > --- a/drivers/scsi/qla2xxx/qla_mbx.c
> > +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> > @@ -4925,8 +4925,6 @@ qla25xx_set_els_cmds_supported(scsi_qla_host_t *vha)
> >   		return QLA_MEMORY_ALLOC_FAILED;
> >   	}
> >   -	memset(els_cmd_map, 0, ELS_CMD_MAP_SIZE);
> > -
> >   	/* List of Purex ELS */
> >   	cmd_opcode[0] = ELS_FPIN;
> >   	cmd_opcode[1] = ELS_RDP;
> 
> 

Looks good.

Regards,
-Arun
