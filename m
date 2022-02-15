Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ECA7C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Feb 2022 03:18:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233792AbiBODTB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Feb 2022 22:19:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233790AbiBODS7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2022 22:18:59 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8BF201BB;
        Mon, 14 Feb 2022 19:18:51 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21F0pblv032138;
        Tue, 15 Feb 2022 03:18:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=LZgJGOETrFIs8hH6Bs41IEKsYV+nbnbbxjkq/2Jtbpk=;
 b=srf5mQW9DBDR7War7uYnW8NM8TTp9eloG5GcioGXVvx3ibVhBDmZDbBdTVTSShwFm06+
 0yG6ft1XfIKLJ3AXbJw4QP7iHzg9I5z/Jsx59m15IwgoT14HciewUhsMF6xyqZDD5s5b
 TpB/iI3Pmsewfew1uqqSnlUFNJLIP1lwzCryfkEz3/V1DLZuhtzlCnvXLj5i7JQRyPp/
 GsG9R8EKiHMsISJXvlwi31pgVghuh7Do5ALhbC53EED5vTkFqkWHwtKOamiH9tGTFtN3
 vpjH4u2pfEI9r2eYS7f+k7+NeIJjeyyUh8rP2R+F+sZJcxbzceyG8518XYUTyCp23lRM MA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e820ng6ft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 03:18:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21F3GQjI093882;
        Tue, 15 Feb 2022 03:18:38 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3e62xe04g0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 03:18:38 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 21F3Ic63101135;
        Tue, 15 Feb 2022 03:18:38 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3030.oracle.com with ESMTP id 3e62xe04fq-1;
        Tue, 15 Feb 2022 03:18:38 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     ALIM AKHTAR <alim.akhtar@samsung.com>, beanhuo@micron.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        Daejun Park <daejun7.park@samsung.com>, cang@codeaurora.org,
        adrian.hunter@intel.com, linux-kernel@vger.kernel.org,
        bvanassche@acm.org, linux-scsi@vger.kernel.org,
        Jinyoung CHOI <j-young.choi@samsung.com>, avri.altman@wdc.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: Fix divide zero case in ufshcd_map_queues()
Date:   Mon, 14 Feb 2022 22:18:35 -0500
Message-Id: <164489509960.14916.804349130118004364.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <1891546521.01644873481638.JavaMail.epsvc@epcpadp4>
References: <CGME20220214103352epcms2p79697c0fcaa2755dd89af9de887ff14cd@epcms2p7> <1891546521.01644873481638.JavaMail.epsvc@epcpadp4>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: jikrS92qPaQiCk0-MzjTjdTNrao8oT-z
X-Proofpoint-GUID: jikrS92qPaQiCk0-MzjTjdTNrao8oT-z
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 14 Feb 2022 19:33:52 +0900, Jinyoung CHOI wrote:

> Before calling blk_mq_map_queues(), the mq_map and nr_queues belonging
> to "struct blk_mq_queue_map" must be a vaild value.
> 
> If nr_queues is set to 0, the system may encounter the "divide zero"
> depending on the type of architecture.
> 
>     blk_mq_map_queues() -> queue_index()
> 
> [...]

Applied to 5.17/scsi-fixes, thanks!

[1/1] scsi: ufs: Fix divide zero case in ufshcd_map_queues()
      https://git.kernel.org/mkp/scsi/c/10af11564617

-- 
Martin K. Petersen	Oracle Linux Engineering
