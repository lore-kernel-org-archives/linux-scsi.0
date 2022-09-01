Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 671DAECAAD1
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Sep 2022 05:13:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232938AbiIAFNH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Sep 2022 01:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232904AbiIAFNC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Sep 2022 01:13:02 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93121122BE1
        for <linux-scsi@vger.kernel.org>; Wed, 31 Aug 2022 22:13:01 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27VNmwM6024939;
        Thu, 1 Sep 2022 05:13:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=pDa4gw1glcjZuvI/t48ojLWxijZqhYwK7YAZZSYeWK0=;
 b=0IJKqXxfevM8+s7vTjA3oEdrxe+7+0FiaM+zElbiGUSSBIk1n9DZVuARQ46fbsvtEqkt
 3b9xA+tCqiTLf6wX2XazzzE+JwJ+Fj7XA2jsJt2ZPpojRRb6bBz2Uj/0EIcpdzLDJyDe
 CJ6qxBQfIbgg/GxNN6DK5Okm9pzzwczTsg/9vVm83+0WTB8Xt3Bu5Td18xt8v1VeU/HG
 S7ncStMWESR5fQqmOGrGYH6kBskk8xE9WBIzfIyMc9J+Rce9y8NqVSR16YzSu94prcKc
 qr5mASu4/heMTaSAUUOXHEbtPLJ6ByTOyNBKJpfEFT0lGEY0NT2TRm0qpoH6ocNowX6R jA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j79pc2qa7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Sep 2022 05:13:00 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2813ZxZC033641;
        Thu, 1 Sep 2022 05:12:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ja6gr3g3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Sep 2022 05:12:59 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2815CsXV008754;
        Thu, 1 Sep 2022 05:12:59 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3ja6gr3g0k-9;
        Thu, 01 Sep 2022 05:12:59 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 00/15] mpi3mr: Added Support for SAS Transport
Date:   Thu,  1 Sep 2022 01:12:53 -0400
Message-Id: <166200877444.26143.13021831569993619314.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220804131226.16653-1-sreekanth.reddy@broadcom.com>
References: <20220804131226.16653-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_02,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxscore=0 spamscore=0 phishscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209010022
X-Proofpoint-ORIG-GUID: WtWX1Oc4ht0AMaUKhO7XR5hWBiwoL6E1
X-Proofpoint-GUID: WtWX1Oc4ht0AMaUKhO7XR5hWBiwoL6E1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 4 Aug 2022 18:42:11 +0530, Sreekanth Reddy wrote:

> - Enhanced the driver to support SAS transport layer and
>  expose SAS controller PHYs, ports, attached expander, expander PHYs,
>  expander ports and SAS/SATA end devices to the kernel through
>  SAS transport class.
> - The driver also provides call back handlers for get_linkerrors,
>  get_enclosure_identifier, get_bay_identifier, phy_reset, phy_enable,
>  set_phy_speed and smp_handler to the kernel as defined by the
>  SAS transport layer.
> - The SAS transport layer support is enabled only when the
>  controller multipath capability is not enabled.
> - The NVMe devices, VDs, vSES and PCIe Managed SES devices
>  are not exposed through SAS transport.
> 
> [...]

Applied to 6.1/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
