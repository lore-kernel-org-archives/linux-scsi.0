Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDDD7C76196
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Mar 2023 21:07:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbjCXVHU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Mar 2023 17:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231875AbjCXVHS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Mar 2023 17:07:18 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D80E8A5A
        for <linux-scsi@vger.kernel.org>; Fri, 24 Mar 2023 14:07:17 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32OKxvUE005332;
        Fri, 24 Mar 2023 21:07:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=yfdu95TqijfSnzEZeTt/kGKjK6QVK1mgb5pH56Mp+DM=;
 b=qOPXi+hePnx8igWguWECVj2U5VT2X1cHSRgOfWRiW4UTJ6Uu0YS7jAFGfRpC1MR5ePq6
 nhXHXq0NZn5pJ5PQDOe8Q75cPLTgLtXT/9tkOhzqvi7w5GqqIGIeu/kLLaRim2NVgQNP
 gPjpKSz8Heh3o/IUlw8E+TT/ymAZynyN2MU6efh9iY6hkzOq+PeyzO7GMRe3BpnHbNBD
 ynV6ubHh0Ccp6d2qXaIZay5TAORubGUgn8FRybT1x/ioeChSzqu9td1yBWzMW9nBwC5C
 0dg1mV5MSS6OpOUSfM+zrv7wKGrrQosWmh2jqoAIBC3RZRQslWnA7tLaOYpxi6La1G34 nA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3phkcn00mu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 21:07:07 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32OL5RMA027694;
        Fri, 24 Mar 2023 21:07:07 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pgxk4se3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 21:07:07 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32OL76f4017159;
        Fri, 24 Mar 2023 21:07:06 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3pgxk4se2p-2;
        Fri, 24 Mar 2023 21:07:06 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>
Subject: Re: [PATCH 1/2] scsi: ufs: core: Disable the reset settle delay
Date:   Fri, 24 Mar 2023 17:06:53 -0400
Message-Id: <167969123961.59527.11003937087212932580.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230314205822.313447-1-bvanassche@acm.org>
References: <20230314205822.313447-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxlogscore=617 adultscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303240160
X-Proofpoint-GUID: AVnong-xcgMl5nYeVk-LQ3e5HD_R-vor
X-Proofpoint-ORIG-GUID: AVnong-xcgMl5nYeVk-LQ3e5HD_R-vor
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 14 Mar 2023 13:58:12 -0700, Bart Van Assche wrote:

> Neither UFS host controllers nor UFS devices require a ten second delay
> after a host reset or after a bus reset. Hence this patch.
> 
> 

Applied to 6.4/scsi-queue, thanks!

[1/2] scsi: ufs: core: Disable the reset settle delay
      https://git.kernel.org/mkp/scsi/c/fb5ea4f5202b

-- 
Martin K. Petersen	Oracle Linux Engineering
