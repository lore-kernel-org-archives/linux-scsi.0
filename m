Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0B71C6FA8F
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Aug 2023 01:49:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244840AbjHaBtG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Aug 2023 21:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243693AbjHaBtF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Aug 2023 21:49:05 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F20249C
        for <linux-scsi@vger.kernel.org>; Wed, 30 Aug 2023 18:49:02 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37V0EGkU011945;
        Thu, 31 Aug 2023 01:48:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=422hO9hUgHn4W7zkUiUu+u+5OPiBJzn2NXK5HsfYGu8=;
 b=UnpklJigi4YeVqUOsG0Mcx9IjQJt8hxelnSGr0nh02moQ5jWATYRSYnwrBtpXlJiTSsx
 Cf+o9qXUONlmlOMrKmwwOwgU5pVK8qTTWPr6zKFXYpXKQvevJNGGyvEfxf3fQew4KOFY
 /DhApaXygpouKIGPBBoBKCNyEG/Ab4WuEuufZEuXd59tQag4olDqrW4HWDQqV8HeHUS6
 O1nlvw69phRxrby9ONAQTcUsMpDp8g21WgdxYt4+emuDkdRSyWFqBr34Cwpt8erzxhC3
 SmX5pkUbsu0uDv8R8JYFOJdURi9F5rk5mEQITe/XEHThrDm3b/d1zNeaBokLyAuo5GqA JA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sq9xt8sm9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Aug 2023 01:48:54 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37UNfBl2032779;
        Thu, 31 Aug 2023 01:48:54 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3sr6dqtxka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Aug 2023 01:48:54 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37V1mnKn000352;
        Thu, 31 Aug 2023 01:48:53 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3sr6dqtxfw-3;
        Thu, 31 Aug 2023 01:48:53 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Mike Christie <michael.christie@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2] scsi: core: Report error list information in debugfs
Date:   Wed, 30 Aug 2023 21:48:30 -0400
Message-Id: <169344360111.1293881.4189868063590271224.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230822163811.219569-1-bvanassche@acm.org>
References: <20230822163811.219569-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-31_01,2023-08-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 adultscore=0 phishscore=0 spamscore=0 mlxlogscore=799 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308310014
X-Proofpoint-ORIG-GUID: mbaAutttskxTkLajHVjVwnvipywl5ual
X-Proofpoint-GUID: mbaAutttskxTkLajHVjVwnvipywl5ual
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 22 Aug 2023 09:38:10 -0700, Bart Van Assche wrote:

> Provide information in debugfs about SCSI error handling to make it
> easier to debug the SCSI error handler. Additionally, report the maximum
> number of retries in debugfs (.allowed).
> 
> 

Applied to 6.6/scsi-queue, thanks!

[1/1] scsi: core: Report error list information in debugfs
      https://git.kernel.org/mkp/scsi/c/90f359c1aa4a

-- 
Martin K. Petersen	Oracle Linux Engineering
