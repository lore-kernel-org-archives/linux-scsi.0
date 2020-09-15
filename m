Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2120EC43461
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 22:38:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D836D20872
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 22:38:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kGv72gr3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727748AbgIOWiM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 18:38:12 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44850 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727564AbgIOWhz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2020 18:37:55 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08FMYv2O012411;
        Tue, 15 Sep 2020 22:37:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=Y4Ukr16DpgeuVGcqtXSnL45aFEcldKHlCDwTVyDstOY=;
 b=kGv72gr36J6yaqDrCSoh+dOKJkuzqVbPYYiP1S83b1Tl5bXTlfeyJZqI8PJEYq0Mn/pC
 knUDD8dLPMJjM8+Aq2qBdr4RT2Rfwarvjmrt5HSfBSTooOSi6uxKtE9b7rInvhdYyOt5
 f+5Dd+O7aOLvnsYOjcLlmGjcD3Mctpe8GsVwOjLe9F72Q+QQ17Xun64ONgWVw4YcCdv0
 7P60ZhbTug+Lqa0H61jk4GrOuisSLJjEVZKMlDPK6rb+eRkZMvDYMPySQ4qYjfy1EdIf
 7OI/flP8Uu7bALuvkoplBTUM9A7gS9JPIbw2rLh/tQq5Nz4uVGyl6W6nHXk0Xgcn9zDs 2w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33gp9m7vw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 22:37:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08FMZrQU140423;
        Tue, 15 Sep 2020 22:37:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 33hm31dffv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 22:37:52 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08FMbpx4015609;
        Tue, 15 Sep 2020 22:37:52 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 22:37:51 +0000
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Subject: Re: [PATCH v1] mpt3sas: Add support for Non-secure Aero and Sea PCI
 IDs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1y2la3bv4.fsf@ca-mkp.ca.oracle.com>
References: <20200814130426.2741171-1-sreekanth.reddy@broadcom.com>
        <yq1a6yoviti.fsf@ca-mkp.ca.oracle.com>
        <CAK=zhgq-5CNQObiwDutLPGG3CbmpAbj+RbDGX-xGu6mVP_WZYw@mail.gmail.com>
        <yq1r1rvqxqe.fsf@ca-mkp.ca.oracle.com>
        <CAK=zhgpg754D6J6k3s+xmyxH+2MGWjuNb44Tfccq2z+gFuLPRA@mail.gmail.com>
        <yq1d02v4pxt.fsf@ca-mkp.ca.oracle.com>
        <CAK=zhgqXMLL1YJ0-0CAv0dSCyczgp34sac986-oORwUU5r-pZg@mail.gmail.com>
Date:   Tue, 15 Sep 2020 18:37:48 -0400
In-Reply-To: <CAK=zhgqXMLL1YJ0-0CAv0dSCyczgp34sac986-oORwUU5r-pZg@mail.gmail.com>
        (Sreekanth Reddy's message of "Fri, 11 Sep 2020 17:09:01 +0530")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150176
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=1 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150176
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sreekanth,

> If the executing firmware continues to run, then that means that the
> physical attack has somehow succeeded and allowed the firmware to
> bypass some part of the signature check, since authentic firmware
> would have halted. In this case, the driver should reject the
> controller/firmware combination

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
