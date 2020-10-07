Return-Path: <SRS0=2LRe=DO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED2E0C47095
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 17:05:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 934622087D
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 17:05:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="cqdVnGSG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbgJGRFM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Oct 2020 13:05:12 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:55700 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726041AbgJGRFL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2020 13:05:11 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 097H07H6028709;
        Wed, 7 Oct 2020 10:05:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0220; bh=rrKteRViA4vxSNBUsWnAhe7ROJCIJod5xGAgtVlXXL0=;
 b=cqdVnGSG46S22OXunmVF839Tq+QCBTA4dyAkQT//o++COb2Ly6Tl1bBjlmSom1hnom0x
 OThMdm1S+jfpBnGJIHqwMMh8jxyXIE3caQ4sUpzdF8YXIn3Hz5ImX0BcJJbr3VxB/qoO
 RDVyhMo7mLePIMErsb4jet8u+sa7R7EfPc1tne5Y6d5Ol24vTmsvdZHKA7nWzmIjyBPi
 GZOWoPfBSJpsM4+JiJdgf+jmQCwcRsu4l3cwEYGtaVqrbJiUiHGjbwdsQzVPgQ3uNZXB
 DyCUPRWhmX3jwgICdTGYX9JNXnsbPEGiuOFGFbJhL6HjkFLUOTtavu6RoDp6bTlIUopL 5w== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 33xrtnmy0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 07 Oct 2020 10:05:07 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 7 Oct
 2020 10:05:05 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 7 Oct
 2020 10:05:05 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 7 Oct 2020 10:05:06 -0700
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id D7A303F703F;
        Wed,  7 Oct 2020 10:05:05 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 097H556M023986;
        Wed, 7 Oct 2020 10:05:05 -0700
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Wed, 7 Oct 2020 10:05:05 -0700
From:   Arun Easi <aeasi@marvell.com>
X-X-Sender: aeasi@irv1user01.caveonetworks.com
To:     Daniel Wagner <dwagner@suse.de>
CC:     Nilesh Javali <njavali@marvell.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] qla2xxx: Do not consume srb greedily
In-Reply-To: <20200929073802.18770-1-dwagner@suse.de>
Message-ID: <alpine.LRH.2.21.9999.2010071001520.28578@irv1user01.caveonetworks.com>
References: <20200929073802.18770-1-dwagner@suse.de>
User-Agent: Alpine 2.21.9999 (LRH 334 2019-03-29)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-07_10:2020-10-07,2020-10-07 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 29 Sep 2020, 12:38am, Daniel Wagner wrote:

> qla2xx_process_get_sp_from_handle() will clear the slot which the
> current srb is stored. So this function has a side effect. Therefore,
> we can't use it in qla24xx_process_mbx_iocb_response() to check
> for consistency and later again in qla24xx_mbx_iocb_entry().
> 
> Let's move the consistency check directly into
> qla24xx_mbx_iocb_entry() and avoid the double call or any open coding
> of the qla2xx_process_get_sp_from_handle() functionality.
> 
> Fixes: 31a3271ff11b ("scsi: qla2xxx: Handle incorrect entry_type entries")
> Signed-off-by: Daniel Wagner <dwagner@suse.de>

That was a nasty one, good that you caught it soon.

Reviewed-by: Arun Easi <aeasi@marvell.com>

Regards,
-Arun
