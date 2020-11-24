Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12193C6379D
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 03:58:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B56AD20866
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 03:58:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I1gPh6Ct"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728495AbgKXD6e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 22:58:34 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:50708 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbgKXD6e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Nov 2020 22:58:34 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO3sfqN090566;
        Tue, 24 Nov 2020 03:58:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=xZNJjBo/JFIO0hTtFUTzpSzrcGoSQ3D2fS62KAWXM1k=;
 b=I1gPh6Ctr/ve/2mN5GSjM/L6m8ijtgx3g8tgbG5QqU3gAQTOfNZDR8U5iudYnPBLgOxB
 9UYefgV79/m6R65mYc15n9K770enyzhnB1+uyr3PzMDq3ccJ+Kyy2H0L+GRiHGjYiUuC
 veuGM0uOYeMrcir116zAiTuMQo9sDPn108cg1I8JNwgzT0IuYiWkUXMmTivxOR1tdgpX
 eCp2n9QIJmzfJnbANKcZ2QCWC5KU9xLbMnJJZHWYPxE2SYwaAJNv/8iNJ+HOVi6/I/aD
 /aewCL9kV3hpRZl3n91eAPjjkEURiXXxBRuNaJAYKh46ejnt4P/uOOJErlD2Kgt/I0dk fg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34xrdarmc9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 24 Nov 2020 03:58:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO3toJQ080995;
        Tue, 24 Nov 2020 03:58:24 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 34ycnrw033-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 03:58:24 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AO3wJva006678;
        Tue, 24 Nov 2020 03:58:19 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Nov 2020 19:58:19 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     james.bottomley@hansenpartnership.com,
        Tyrel Datwyler <tyreld@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        brking@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 1/3] ibmvfc: byte swap login_buf.resp values in attribute show functions
Date:   Mon, 23 Nov 2020 22:58:08 -0500
Message-Id: <160618683551.24173.15203691222166023615.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117185031.129939-1-tyreld@linux.ibm.com>
References: <20201117185031.129939-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 17 Nov 2020 12:50:29 -0600, Tyrel Datwyler wrote:

> Both ibmvfc_show_host_(capabilities|npiv_version) functions retrieve
> values from vhost->login_buf.resp buffer. This is the MAD response
> buffer from the VIOS and as such any multi-byte non-string values are in
> big endian format.
> 
> Byte swap these values to host cpu endian format for better human
> readability.

Applied to 5.11/scsi-queue, thanks!

[1/3] scsi: ibmvfc: Byte swap login_buf.resp values in attribute show functions
      https://git.kernel.org/mkp/scsi/c/61bdb4eec8d1
[2/3] scsi: ibmvfc: Remove trailing semicolon
      https://git.kernel.org/mkp/scsi/c/4e0716199ab6
[3/3] scsi: ibmvfc: Use correlation token to tag commands
      https://git.kernel.org/mkp/scsi/c/2aa0102c6688

-- 
Martin K. Petersen	Oracle Linux Engineering
