Return-Path: <SRS0=0yur=EJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9C77C00A89
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 02:02:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 783D62225E
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 02:02:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cwUBOMlx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbgKCCCG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 21:02:06 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:46758 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbgKCCCF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 21:02:05 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A31xWXA069636;
        Tue, 3 Nov 2020 02:02:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=JDuw8TVH8RHKX901+omhSDhKGGyNUZOv8iQ1ysjmPtI=;
 b=cwUBOMlxbq4NqDn83FY+AorrggBOAjGa5+HFz0s32Lrn79OyFro4N26kbrN590w0iLvy
 ji2EHwKSxXykUj9QUIKhpKzNky4/06Ma/pVO9Ca9UkWhw+L5s/MXI1oPSF1RVZPQqxII
 Z3j5l0KB1FiXqteZuHN6WJh9kg/4RXRQ+7rOLvD2TYqbBUa1/DCpK+qwhE2qPksSny5v
 BWqeq27ESVFeSvt15gHbLLnpcayBJi1kOegbXcDNzUBaxJASlDHUrTkaurq7k3XglhmJ
 AQB3jlWHyD/tJK8GaNvcFI3CK9caG6YQL03rSGimbrWntCSOCFsdkgtGCtKHYakuojOE Hw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34hhb1xxya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 03 Nov 2020 02:02:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A320dT4176157;
        Tue, 3 Nov 2020 02:02:00 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 34hw0cpvaw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Nov 2020 02:02:00 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A321xAi004361;
        Tue, 3 Nov 2020 02:01:59 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Nov 2020 18:01:59 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        thenzl@redhat.com, linux-scsi@vger.kernel.org,
        sathya.prakash@broadcom.com, suganath-prabu.subramani@broadcom.com
Subject: Re: [PATCH] mpt3sas: Fix timeouts observed while reenabling IRQ
Date:   Mon,  2 Nov 2020 21:01:57 -0500
Message-Id: <160436888615.27492.1378107365559358809.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102072746.27410-1-sreekanth.reddy@broadcom.com>
References: <20201102072746.27410-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9793 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=791
 phishscore=0 bulkscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011030011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9793 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 clxscore=1011 mlxlogscore=803 impostorscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011030011
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2 Nov 2020 12:57:46 +0530, Sreekanth Reddy wrote:

> While reenabling the IRQ after irq poll there may be small time
> window where HBA firmware has posted some replies and raise the
> interrupts but driver has not received the interrupts. So we may
> observe IO timeouts as the driver has not processed the replies
> as interrupts got missed while reenabling the IRQ.
> 
> So, to fix this issue, the driver has to go for one more
> round of processing the reply descriptors from reply descriptor
> post queue after enabling the IRQ.

Applied to 5.10/scsi-fixes, thanks!

[1/1] scsi: mpt3sas: Fix timeouts observed while reenabling IRQ
      https://git.kernel.org/mkp/scsi/c/5feed64f9199

-- 
Martin K. Petersen	Oracle Linux Engineering
