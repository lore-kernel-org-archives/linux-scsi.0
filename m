Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FE86C47089
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Nov 2022 03:27:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbiKZD14 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Nov 2022 22:27:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiKZD1t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Nov 2022 22:27:49 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764A4EE21;
        Fri, 25 Nov 2022 19:27:48 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AQ2s0xW026859;
        Sat, 26 Nov 2022 03:27:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=Xlx7m0Sj8kgyhdQyLtI7DeOmq7iJSUePVKkR8/jQi7A=;
 b=b3WMXrNY+rLxtc66ipgk/V8rsSSwKakxPJWzpKBvUvMAz6lY2TGgT1J8WKhwKVU6Eo/i
 9lluqggrFOd9ncdBqj7VCyeOKCFETKK+GozMBpZtOSl8FGDbWjOMQ7Af7V3CWQlIvw3G
 bSACt+hbll13CrtPOPzH0vCJYw/wzpiVQUs7iUZlaa3O5K4I5prtgZJsDP6zAcg6DiBr
 Iteet6UBX35iIiihykce1dy8MKztVbuKqve5ElQUswDqFUG5S7KjjjvZMkrCe0j2raOw
 cGyJn8M80Kehm+udX+GUjUyzhc9zVcuHhlm2IYhPEosgRV+tefcEyZXygkMjk8PoEty4 ig== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m3adt00js-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Nov 2022 03:27:44 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AQ1XW7O007348;
        Sat, 26 Nov 2022 03:27:44 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3m3988b7yp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Nov 2022 03:27:44 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AQ3RhsP028327;
        Sat, 26 Nov 2022 03:27:43 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3m3988b7y9-2;
        Sat, 26 Nov 2022 03:27:43 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Hannes Reinecke <hare@suse.de>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, Colin Ian King <colin.i.king@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: libfc: remove redundant variable ev_qual
Date:   Sat, 26 Nov 2022 03:27:33 +0000
Message-Id: <166943312545.1684293.11269903246948093096.b4-ty@oracle.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221111170824.558250-1-colin.i.king@gmail.com>
References: <20221111170824.558250-1-colin.i.king@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-26_02,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 mlxlogscore=882 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211260024
X-Proofpoint-ORIG-GUID: 8xDlR1DOyBMutphI-5ue06JYf0vqurTQ
X-Proofpoint-GUID: 8xDlR1DOyBMutphI-5ue06JYf0vqurTQ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 11 Nov 2022 17:08:24 +0000, Colin Ian King wrote:

> Variable ev_qual is being assigned and modified but the end result
> is never used. The variable is redundant and can be removed.
> 
> 

Applied to 6.2/scsi-queue, thanks!

[1/1] scsi: libfc: remove redundant variable ev_qual
      https://git.kernel.org/mkp/scsi/c/0824050682ae

-- 
Martin K. Petersen	Oracle Linux Engineering
