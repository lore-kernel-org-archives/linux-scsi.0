Return-Path: <SRS0=8UCH=7J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 882FEC433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 01:09:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66883207CB
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 01:09:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NmN5S/cr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728148AbgE0BJM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 May 2020 21:09:12 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44396 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728137AbgE0BJK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2020 21:09:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04R18I8q001652;
        Wed, 27 May 2020 01:08:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=TE1U6kmBDIx0P+TEG5r2eqfZg1hODVX9MWfuH0SoAVw=;
 b=NmN5S/crAypezw7f1yeWTBv8ioDprtOvDR02eBk+n5Bospz3rW9iZBv4P7PMlnpGM/pU
 ShNFcFX08pL0XUEvB912BSq3+OwCZQ/VV3BLsDT1Oin1+yjKzlAHryvgE7EXOX1cj76q
 r2taUlpCoeFjn2cYGkGOjlxd3fzfxYjhN/vytbpGPdRm5pptMSpJNGRrnYuHzl6brqWo
 sLTp4fHVKmmQSe3TMg7ea59XcmXByJha7Ez4EyyJyp1mku+Eiy+Cgt14o4qrrD5hs1iH
 v37oMnVkvbeVBXJNrn1mnRRo8luzlXUylVvl/+taVy+RB3WC27O7XgwcR9s1YRmEwpZ6 GQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 316u8qvsmg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 27 May 2020 01:08:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04R17XAf102198;
        Wed, 27 May 2020 01:08:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 317j5q510t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 May 2020 01:08:52 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04R18oNx023797;
        Wed, 27 May 2020 01:08:50 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 26 May 2020 18:08:50 -0700
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Souptick Joarder <jrdr.linux@gmail.com>,
        =?utf-8?Q?Kai_M=C3=A4kisara_=28Kolumbus=29?= 
        <kai.makisara@kolumbus.fi>, Bart Van Assche <bvanassche@acm.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2] scsi: st: convert convert get_user_pages() -->
 pin_user_pages()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mu5ukwx4.fsf@ca-mkp.ca.oracle.com>
References: <20200526182709.99599-1-jhubbard@nvidia.com>
        <98b7f283-b208-d222-1d65-8a2e34d0a1af@nvidia.com>
Date:   Tue, 26 May 2020 21:08:47 -0400
In-Reply-To: <98b7f283-b208-d222-1d65-8a2e34d0a1af@nvidia.com> (John Hubbard's
        message of "Tue, 26 May 2020 18:05:01 -0700")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 suspectscore=1
 mlxlogscore=999 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005270003
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 spamscore=0 cotscore=-2147483648 suspectscore=1
 phishscore=0 clxscore=1011 mlxlogscore=999 bulkscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005270003
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


John,

> For some reason, the "convert convert" subject line is really hard to
> get rid of from my scsi st patch. In this case, I'd dropped the patch
> entirely, and recreated it with the old subject line somehow. Sorry
> about that persistent typo!
>
> I'll send a v3 if necessary, to correct that.

I'll fix it up when I apply.

-- 
Martin K. Petersen	Oracle Linux Engineering
