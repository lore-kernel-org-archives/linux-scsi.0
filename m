Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE0B3C433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 06:07:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC46D20786
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 06:07:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UBy/rH/Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729726AbgGHGHW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 02:07:22 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34244 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729724AbgGHGHW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 02:07:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06861jbO187560;
        Wed, 8 Jul 2020 06:07:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=hFmU+hgx0qJsgKKKq8PILrLRDYWhZb7FIclgPaTfWjM=;
 b=UBy/rH/QYvSEwC9JsAH/CDMUNJ5Yj0mm+T9rlGhPh/MLLujCvjzwDyaybP6lDnh2uXzk
 swky0/wnE4o1Vpjs2wa5r+jjUOs+dgyldIU0YJp+B273bw9ByRj4Hpe6Dfj7XxJ/SJVl
 MKoErzBaG+GnFIPK9zBojpAx8o/HaOKdmUJ29EB0P2PYEwPmiSdIJuv8Ps0otk9XrfRg
 FMcz4fw2Zox1wlvJgYGYFeKVbgUDcOLQIi5kOIpIgyFev3lu4tZMtNv1hcnpND5fT7Ko
 U8yBb+2Lo7ZprzAUb5EBzH6lgIO1EAXwMIzJavi7++FxoVTz4M0uHPtCcuyvf92JBusz uw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 323wacm8sh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 08 Jul 2020 06:07:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0685xAjG063736;
        Wed, 8 Jul 2020 06:07:16 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 3233p4k2xj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jul 2020 06:07:15 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06867E5G024914;
        Wed, 8 Jul 2020 06:07:14 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jul 2020 23:07:14 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Satya Tangirala <satyat@google.com>, linux-scsi@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kim Boojin <boojin.kim@samsung.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>
Subject: Re: [PATCH v4 0/3] Inline Encryption Support for UFS
Date:   Wed,  8 Jul 2020 02:06:55 -0400
Message-Id: <159418828150.5152.155875546934168462.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200706200414.2027450-1-satyat@google.com>
References: <20200706200414.2027450-1-satyat@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9675 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=934
 mlxscore=0 spamscore=0 bulkscore=0 malwarescore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007080041
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9675 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 spamscore=0 mlxlogscore=923 adultscore=0 cotscore=-2147483648
 suspectscore=0 impostorscore=0 bulkscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007080041
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 6 Jul 2020 20:04:11 +0000, Satya Tangirala wrote:

> This patch series adds support for inline encryption to UFS using
> the inline encryption support in the block layer. It follows the JEDEC
> UFSHCI v2.1 specification, which defines inline encryption for UFS.
> 
> This patch series previously went through a number of iterations as
> part of the "Inline Encryption Support" patchset (last version was v13:
> https://lkml.kernel.org/r/20200514003727.69001-1-satyat@google.com).
> This patch series is rebased on v5.8-rc4.
> 
> [...]

Applied to 5.9/scsi-queue, thanks!

[1/3] scsi: ufs: UFS driver v2.1 spec crypto additions
      https://git.kernel.org/mkp/scsi/c/5e7341e1f9ec
[2/3] scsi: ufs: UFS crypto API
      https://git.kernel.org/mkp/scsi/c/70297a8ac7a7
[3/3] scsi: ufs: Add inline encryption support to UFS
      https://git.kernel.org/mkp/scsi/c/df043c745ea1

-- 
Martin K. Petersen	Oracle Linux Engineering
