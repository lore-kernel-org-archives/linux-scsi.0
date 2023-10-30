Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45CD4C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Oct 2023 15:35:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233663AbjJ3PfN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Oct 2023 11:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233639AbjJ3PfK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Oct 2023 11:35:10 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8346AE9
        for <linux-scsi@vger.kernel.org>; Mon, 30 Oct 2023 08:35:07 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39UDFXIn020886;
        Mon, 30 Oct 2023 15:35:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=OAtQpwbw8EJlEX/0wDFMUC6r/eNm5JEKy1/q6qTAYLg=;
 b=RHHTd6Q2hgdLXzDgyMyJtk/99+VHm3ume9plSsmAUvx8yLdixZhEdzcZPxEkVvu3Ji5g
 zoKo7Q8h6tKlb4IA2AxvNuMwT6cucDz2rMRPlBKldJ7g18uIbjzTQylBVLLextVPJiVf
 pXm8SkXqEJAASmZZyjXUs3hApZcsyacNQkIkkjEzArWjJkRF2dxPNOur5nsU1OJg388Y
 ZpWisWBMyeuDx4R76RC0z32W3COZL8J0pn9A4BEo3+LCUeupA4arQh8MPsfN5n12AQuc
 NklxZ+5nU6D66KFQlIBkylr2ZqUIc7GkOhKbZgeh4f2KUgQMHz5kdwMcQwLBq7f9KSwG VQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u0swtk33w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Oct 2023 15:35:01 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39UE43cE038319;
        Mon, 30 Oct 2023 15:35:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u0rran8xj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Oct 2023 15:35:00 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39UFVkmI023458;
        Mon, 30 Oct 2023 15:35:00 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3u0rran8wc-5;
        Mon, 30 Oct 2023 15:35:00 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] pmcraid: add missing scsi_device_put() in pmcraid_eh_target_reset_handler()
Date:   Mon, 30 Oct 2023 11:34:49 -0400
Message-Id: <169868005485.2933713.7516546313897211487.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231023072957.20191-1-hare@suse.de>
References: <20231023072957.20191-1-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-30_10,2023-10-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 adultscore=0 mlxlogscore=744 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2310300120
X-Proofpoint-ORIG-GUID: J4Ko_-X0TzwdZWkW-l-0zz3GbtUW4cTY
X-Proofpoint-GUID: J4Ko_-X0TzwdZWkW-l-0zz3GbtUW4cTY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 23 Oct 2023 09:29:57 +0200, Hannes Reinecke wrote:

> When breaking out of a shost_for_each_device() loop one need to do
> an explicit scsi_device_put().
> 
> 

Applied to 6.7/scsi-queue, thanks!

[1/1] pmcraid: add missing scsi_device_put() in pmcraid_eh_target_reset_handler()
      https://git.kernel.org/mkp/scsi/c/0b1b4b04444f

-- 
Martin K. Petersen	Oracle Linux Engineering
