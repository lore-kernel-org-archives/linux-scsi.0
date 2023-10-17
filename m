Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46939C41513
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Oct 2023 01:12:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234333AbjJQBMW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Oct 2023 21:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234338AbjJQBMU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2023 21:12:20 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A724EEB
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2023 18:12:16 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39GKO3O9017528;
        Tue, 17 Oct 2023 01:12:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=o1tR7SaRc9rs32XWFb66ncetHrgy1FXWzuvgn9uNY6s=;
 b=wPz/6EpnJ/xSQkUH1CeyNY66xE/X0wz2LmhEfygG3waiDhkf37wsyczN++XBsp20r0la
 YaZvdfLz5Jc9JnnwTfW7BD1hT67J0khloTyK8oZbH+C1JkqOvaWG3TgljuptX5Ui3IEq
 lDBldjVfWqq3yzyamSae4W6MafkIjPnopSHFB3DCxIYapslNxaotLosmGEw8VRbghz3c
 9rZIsTmhgZPmdDTXgNOfMZsW55Z470Ts4wpMW42rs57ZuEHJXM75MgCcO+N3fe7JPlnd
 xbKn/XFiBVB/oQuvCGRapmZ25tB8PkjrBMeKw5+MeQMceMFbTv+WSTWlSKQYLhH+5u5l uw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk1cv0pa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 01:12:09 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39GNAZV9027111;
        Tue, 17 Oct 2023 01:12:08 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3trg5366qf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 01:12:08 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39H1C3sq039761;
        Tue, 17 Oct 2023 01:12:08 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3trg5366mf-6;
        Tue, 17 Oct 2023 01:12:08 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com,
        Mike Christie <michael.christie@oracle.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 00/12] scsi: sshdr and retry fixes
Date:   Mon, 16 Oct 2023 21:11:53 -0400
Message-Id: <169750286923.2183937.14258541279680152081.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231004210013.5601-1-michael.christie@oracle.com>
References: <20231004210013.5601-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-16_13,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310170008
X-Proofpoint-GUID: Wz4hHsOsTVcpMzpp9QlkbslEMs_t1AUj
X-Proofpoint-ORIG-GUID: Wz4hHsOsTVcpMzpp9QlkbslEMs_t1AUj
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 04 Oct 2023 16:00:01 -0500, Mike Christie wrote:

> The following patches were made over Linus tree (Martin's 6.7
> branch was missing some changes to sd.c). They only contain the
> sshdr and rdac retry fixes from the "Allow scsi_execute users to
> control retries" patchset.
> 
> The patches in this set are reviewed and tested but the changes to
> how we do retries will take a little longer and require more testing,
> so I broke up the series to make them easier to review.
> 
> [...]

Applied to 6.7/scsi-queue, thanks!

[01/12] scsi: sd: Fix sshdr use in read_capacity_16
        https://git.kernel.org/mkp/scsi/c/bd593bd2c1e6
[02/12] scsi: sd: Fix sshdr use in sd_spinup_disk
        https://git.kernel.org/mkp/scsi/c/b4d0c33a32c3
[03/12] scsi: hp_sw: Fix sshdr use
        https://git.kernel.org/mkp/scsi/c/5759a5650d45
[04/12] scsi: rdac: Fix send_mode_select retry handling
        https://git.kernel.org/mkp/scsi/c/2274bd5e3a2c
[05/12] scsi: rdac: Fix sshdr use
        https://git.kernel.org/mkp/scsi/c/87e145a29363
[06/12] scsi: spi: Fix sshdr use
        https://git.kernel.org/mkp/scsi/c/0b149cee836a
[07/12] scsi: sd: Fix sshdr use in sd_suspend_common
        (no commit info)
[08/12] scsi: sd: Fix scsi_mode_sense caller's sshdr use
        https://git.kernel.org/mkp/scsi/c/add2c24d32a3
[09/12] scsi: Fix sshdr use in scsi_test_unit_ready
        https://git.kernel.org/mkp/scsi/c/f43158eefd65
[10/12] scsi: Fix sshdr use in scsi_cdl_enable
        https://git.kernel.org/mkp/scsi/c/8f0017694c54
[11/12] scsi: sd: Fix sshdr use in cache_type_store
        https://git.kernel.org/mkp/scsi/c/c8b7ef36da03
[12/12] scsi: sr: Fix sshdr use in sr_get_events
        https://git.kernel.org/mkp/scsi/c/f7d7129c6c24

-- 
Martin K. Petersen	Oracle Linux Engineering
