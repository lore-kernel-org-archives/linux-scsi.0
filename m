Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 708DFC4361B
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 17:16:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4331423C90
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 17:16:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732706AbgLIRPz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 12:15:55 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:53948 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732465AbgLIRPz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 12:15:55 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9H9t8e029294;
        Wed, 9 Dec 2020 17:15:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=GQzgVddlfJObRit2YhIKh68Sp3ASwM4cNjH+dHYmMHU=;
 b=OAUo0kRaFa1VpvjYtoMgZKKhtJu/v1YtY75hZ7nE1xruv1AmIDkxOIBnkplwG4amzks/
 81s8Hgtv1XxkGMaKcicTfrZEel3ERhgSzbBUeil7dZsDcZhuRb5BDwBqTy/f9UCU73IB
 DyCmHtMqUs8GsHeVvUsSy9kQ+7wBoVRdKYVTGgDH5vnjx+d1boNDI7wCFUruFVURfjC9
 +9QIE326Ej9iRQvzYfr7eiQLQxs5LafbeRlkREC9a3+CWaaHPEA25UdqPfobNxfiX+Q/
 /r3tK1jcpVi+iMTQ/tuBDau336KF1gSDAs8yPIimAOnTfKbd4DVcwyKzHuMTDQDBFL/X 4w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 357yqc1eap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Dec 2020 17:15:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9HAxx4071029;
        Wed, 9 Dec 2020 17:15:02 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 358ksqd7tt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Dec 2020 17:15:01 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B9HF0Bs017545;
        Wed, 9 Dec 2020 17:15:00 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Dec 2020 09:14:59 -0800
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, Karen Xie <kxie@chelsio.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] SCSI: cxgb4i: fix TLS dependency
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15z5arjec.fsf@ca-mkp.ca.oracle.com>
References: <20201208220505.24488-1-rdunlap@infradead.org>
Date:   Wed, 09 Dec 2020 12:14:58 -0500
In-Reply-To: <20201208220505.24488-1-rdunlap@infradead.org> (Randy Dunlap's
        message of "Tue, 8 Dec 2020 14:05:05 -0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=1
 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=999
 clxscore=1011 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090121
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Randy,

> SCSI_CXGB4_ISCSI selects CHELSIO_T4. The latter depends on
> TLS || TLS=n, so since 'select' does not check dependencies of
> the selected symbol, SCSI_CXGB4_ISCSI should also depend on
> TLS || TLS=n.
>
> This prevents the following kconfig warning and restricts
> SCSI_CXGB4_ISCSI to 'm' whenever TLS=m.

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
