Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7186FC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 03:01:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50116207DD
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 03:01:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I7bxTayP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgGUDBi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 23:01:38 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:58360 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgGUDBh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jul 2020 23:01:37 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L2xuZO034873;
        Tue, 21 Jul 2020 03:01:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=BfyDp+A4E+pt+CPpx+ryDFjwpPWwrUNlImTb2ITcdHQ=;
 b=I7bxTayP/atAFI3lf31TS9/Hw0kIctQrUAP6pVg70KaR1cdEDmEA1dB01i22qDKl6sHb
 tb1czF/RyWkcgTJ/8F47rOTGFwNMTJQBAR5KCPqmfMeIjJmwdj/dSUFVGUY26N1GuITG
 ZlJW5Hf33jnVTF5/9s1hBvKhLaXJfY3Ls+a0gruk9Ueu/H1MFZOFiFQWYf2GzZmpkAuU
 UfjXTAdr6+SeuHRp8mH1lXVtA8rMtiavak+aRLDg4oUXr5Gi0LfJh/G2gmjfa9ybkv2h
 iPGjN4USk02+UBbvi7kJq6bEDpdoJh3S+GP861ev7pcfKPWeQPebmZYObVnzGX3zyHCL EQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 32bpkb2j92-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 21 Jul 2020 03:01:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L2vwoa153714;
        Tue, 21 Jul 2020 03:01:33 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 32dnae66bm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jul 2020 03:01:33 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06L31Vb5030934;
        Tue, 21 Jul 2020 03:01:31 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jul 2020 20:01:31 -0700
To:     Can Guo <cang@codeaurora.org>
Cc:     Alan Stern <stern@rowland.harvard.edu>, martin.petersen@oracle.com,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH v3] SCSI and block: Simplify resume handling
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k0yxinet.fsf@ca-mkp.ca.oracle.com>
References: <20200701183718.GA507293@rowland.harvard.edu>
        <9e824700-dfd1-5d71-5e91-833c35ea55eb@acm.org>
        <20200706151436.GA702867@rowland.harvard.edu>
        <269bdaab-797e-f54c-11af-46561220b448@acm.org>
Date:   Mon, 20 Jul 2020 23:01:28 -0400
In-Reply-To: <269bdaab-797e-f54c-11af-46561220b448@acm.org> (Bart Van Assche's
        message of "Wed, 8 Jul 2020 20:29:43 -0700")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 adultscore=0 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007210019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007210019
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> This patch looks good to me. Can, since this patch modifies code in
> which you recently fixed a bug, would it be possible to test this
> patch?

Can: Please verify Alan's patch:

	https://patchwork.kernel.org/patch/11646029/
        
Bart: A proper review tag would be appreciated.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
