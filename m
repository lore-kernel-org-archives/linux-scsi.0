Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 385CBC4167B
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Oct 2023 15:35:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233706AbjJ3PfR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Oct 2023 11:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233641AbjJ3PfM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Oct 2023 11:35:12 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF82DB
        for <linux-scsi@vger.kernel.org>; Mon, 30 Oct 2023 08:35:10 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39UDLC8Z011809;
        Mon, 30 Oct 2023 15:35:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=gNT1LyTvXhBRxmQjoVYxIRmG5CnxU1x/ee5NhxtwNP0=;
 b=g5F9OzrzNftdbX2V1vE/zrLQ3XwM58FJkMwnnxAcIeMth78hdBEChlEFFsyxs68Myf4v
 sGmek2JMkmueWur8Vhpj05lhgoncO9YxorHCjUXD4AiHsgEYVF9bPlfJX/wjimKfDHvQ
 su0+YOO3iLXCFsqoJk/Dv1sxqYFhwrygpJFi4TITbaO3+0106IIGMhMiKuGQhOQKdvwT
 7tCsf5YsVEULPOkXbkGVc9NMoB4RgTBVryFgQkOrT0hyltunw72xjNfDdJ2Ahg3Ib2Vj
 iaRki74aEsMLj08C44bYn9qhYQlz5Nm+IWwfWCjHmubioWB/MGSvL52isfkL92Jtv+SQ jA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u0s33u5ph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Oct 2023 15:35:00 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39UE3sv1037973;
        Mon, 30 Oct 2023 15:34:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u0rran8wv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Oct 2023 15:34:59 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39UFVkmC023458;
        Mon, 30 Oct 2023 15:34:59 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3u0rran8wc-2;
        Mon, 30 Oct 2023 15:34:59 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [PATCH] aic79xx: fix up NULL command in ahd_done()
Date:   Mon, 30 Oct 2023 11:34:46 -0400
Message-Id: <169868005495.2933713.17268942500537985675.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231023073014.21438-1-hare@suse.de>
References: <20231023073014.21438-1-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-30_10,2023-10-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 adultscore=0 mlxlogscore=800 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2310300120
X-Proofpoint-GUID: B21PIybdk6ewozgDl9vDkRruBMv7MUGv
X-Proofpoint-ORIG-GUID: B21PIybdk6ewozgDl9vDkRruBMv7MUGv
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 23 Oct 2023 09:30:14 +0200, Hannes Reinecke wrote:

> Found by smatch.
> 
> 

Applied to 6.7/scsi-queue, thanks!

[1/1] aic79xx: fix up NULL command in ahd_done()
      https://git.kernel.org/mkp/scsi/c/c7f4c5dec651

-- 
Martin K. Petersen	Oracle Linux Engineering
