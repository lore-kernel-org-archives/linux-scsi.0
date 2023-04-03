Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28B74C76196
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Apr 2023 02:20:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbjDCCUl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Apr 2023 22:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbjDCCUk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Apr 2023 22:20:40 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF13B75C
        for <linux-scsi@vger.kernel.org>; Sun,  2 Apr 2023 19:20:40 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 332Mslil031744;
        Mon, 3 Apr 2023 02:20:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=BYW/soGWxP3uVq+eKIh4xlUbDheLKnD80vCH63aqoVY=;
 b=3apM5baQhP3Qj1Ilq0z1DFSKmjXj9bDDqS+hB4RVbujXPhKX1aEDpIh+lm/ZuhlL4bT+
 Kpk2Qmxb5l8hJcK5NytgD8eqZL2dBL7OB96xfflzHX7E8wcu2T1zt7Ds6iOCo8ek9yJF
 aXv+EqkP5kRahzYgq7IVfPmomJjiSnVivnj3BJGY2Rt3HwqPXDPN9WdpiiIbSDE5Jqkl
 fi7ZgYuoyemti2jjKFNDgY66BnuR0PRSxoiU5wl5mEA/cq3hc+OsR0buRZ2JVYrEfwlv
 GUTlTJ4prg7eScvAeu03fU2EQAM43PUK5BpNLqOb58gKt5lN3e3oO98Y06xYV35EOD1G YA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppb71j2bh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Apr 2023 02:20:20 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 332Lum48017517;
        Mon, 3 Apr 2023 02:20:19 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pptp4n16f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Apr 2023 02:20:19 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3332COOp008162;
        Mon, 3 Apr 2023 02:20:18 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3pptp4n164-1;
        Mon, 03 Apr 2023 02:20:18 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Stanley Chu <chu.stanley@gmail.com>, peter.wang@mediatek.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Adrien Thierry <athierry@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] Revert "scsi: ufs: core: Initialize devfreq synchronously"
Date:   Sun,  2 Apr 2023 22:20:12 -0400
Message-Id: <168048838483.1036111.6599517072297235004.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230329205426.46393-1-athierry@redhat.com>
References: <20230329205426.46393-1-athierry@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-31_07,2023-03-31_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=807 bulkscore=0 malwarescore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304030015
X-Proofpoint-ORIG-GUID: jXcd3s-8fOenT280Hsmgom_DtySkIKx_
X-Proofpoint-GUID: jXcd3s-8fOenT280Hsmgom_DtySkIKx_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 29 Mar 2023 16:54:25 -0400, Adrien Thierry wrote:

> This reverts commit 7dafc3e007918384c8693ff8d70381b5c1e9c247.
> 
> This patch introduced a regression [1] where hba->pwr_info is used
> before being initialized, which could create issues in
> ufshcd_scale_gear(). Revert it until a better solution is found.
> 
> [1] https://lore.kernel.org/all/CAGaU9a_PMZhqv+YJ0r3w-hJMsR922oxW6Kg59vw+oen-NZ6Otw@mail.gmail.com
> 
> [...]

Applied to 6.3/scsi-fixes, thanks!

[1/1] Revert "scsi: ufs: core: Initialize devfreq synchronously"
      https://git.kernel.org/mkp/scsi/c/86eb94bf8006

-- 
Martin K. Petersen	Oracle Linux Engineering
