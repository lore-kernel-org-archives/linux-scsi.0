Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72858C7618E
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Mar 2023 04:04:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbjCQEEd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Mar 2023 00:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjCQEEc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Mar 2023 00:04:32 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6865E5B422;
        Thu, 16 Mar 2023 21:04:30 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32H1tSr6014821;
        Fri, 17 Mar 2023 04:04:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=J3FvXjKrheGvBafNGp2Eo5EdIoNCqE+e4qK0VFRCBEc=;
 b=PTkESHcnWvJQd0opZtCtqsJ0aDzo8HZT/rreU4mtqAtT2uFGA3vXl8Hn7V5tUHH394Mv
 wMJqXn9tmcB07HQl6eotF9lmI1yf8SVyVcyBjha6s/xML5r/V2h5MdBIzbw+AdBFrTP4
 7KOkAlYLnmkeuUCEfcVqtE501cIec8/OOmhFV5Feio+xX1LX7sUkA2OkSKnaufPNLLy7
 JUNg5Q8l20Ipz6LgnnHLDL8wGTCd3AI6sVRswigCwRo+M7MdxQ2RpMTd++k4gWMoYMeO
 jqZRLvaMzQSvr3ti1ejJNmhjy4h+hf5PSAmSsGTPyvANU7SwrLn8VqvDxdP1FmqMPjHk oA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pbs262xy5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Mar 2023 04:04:26 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32H1UmhL029652;
        Fri, 17 Mar 2023 04:04:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pbqq66kh3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Mar 2023 04:04:25 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32H44Opm039895;
        Fri, 17 Mar 2023 04:04:25 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3pbqq66kg0-2;
        Fri, 17 Mar 2023 04:04:25 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     target-devel@vger.kernel.org,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, linux@yadro.com
Subject: Re: [PATCH v5 0/5] scsi: target: make RTPI an TPG identifier
Date:   Fri, 17 Mar 2023 00:04:16 -0400
Message-Id: <167902578895.2716271.7255696750003963803.b4-ty@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230301084512.21956-1-d.bogdanov@yadro.com>
References: <20230301084512.21956-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-17_01,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=641
 bulkscore=0 mlxscore=0 adultscore=0 suspectscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303170023
X-Proofpoint-ORIG-GUID: _nu0e8tP3HkJ5oNsVF8DLDxKSgvLLrOj
X-Proofpoint-GUID: _nu0e8tP3HkJ5oNsVF8DLDxKSgvLLrOj
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 01 Mar 2023 11:45:08 +0300, Dmitry Bogdanov wrote:

> The patchset based on 6.3/scsi-queue.
> 
> SAM-5 4.6.5.2 (Relative Port Identifier attribute) defines the attribute
> as unique across SCSI target ports:
>  The Relative Port Identifier attribute identifies a SCSI target port or
>  a SCSI initiator port relative to other SCSI ports in a SCSI target
>  device and any SCSI initiator devices contained within that SCSI target
>  device. A SCSI target device may assign relative port identifiers to
>  its SCSI target ports and any SCSI initiator ports. If relative port
>  identifiers are assigned, the SCSI target device shall assign each of
>  its SCSI target ports and any SCSI initiator ports a unique relative
>  port identifier from 1 to 65 535. SCSI target ports and SCSI initiator
>  ports share the same number space.
> 
> [...]

Applied to 6.4/scsi-queue, thanks!

[1/4] scsi: target: core: Add RTPI field to target port
      https://git.kernel.org/mkp/scsi/c/3f4b9cb4133a
[2/4] scsi: target: core: Use RTPI from target port
      https://git.kernel.org/mkp/scsi/c/b9e063adfb8a
[3/4] scsi: target: core: Drop device-based RTPI
      https://git.kernel.org/mkp/scsi/c/5fe99dace431
[4/4] scsi: target: core: Add RTPI attribute for target port
      https://git.kernel.org/mkp/scsi/c/31177b74790c

-- 
Martin K. Petersen	Oracle Linux Engineering
