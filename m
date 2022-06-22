Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED052C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jun 2022 02:10:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356147AbiFVCK3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jun 2022 22:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356136AbiFVCK1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jun 2022 22:10:27 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256B33135F
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jun 2022 19:10:27 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25M0J83V011419;
        Wed, 22 Jun 2022 02:10:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=sVR8nukYIxkCZX2MI2OiQeNj49Jy0f4htE/CusE+gIY=;
 b=BVNmBtGf903T8FAHSkRDhNneFJ5LkwLAtbm2Y6XHH46Iy0OIobXDNNEVOZFqoJQ+gb/S
 4bCFrDpVIXfs1RThm/gawXRK/Qls7wrzpTbqawG4T4+FuofmT/QqkaZZ/N8xcsc3J/sI
 fslbBa+V69054qRRVhTbTkITVZkZTPp2DHV52VCXvtPj06TdlVRmoUmJfB0Q2NYO/u6E
 K/u4wIgNmDdpb6Ih+swhrVLBIfnM3K87oZnFHtMDMpbbNGB/kPwWw4+xaJrdx0Xvkr7t
 vDc17QBEsfKSWFmR2u6slmIsGNs0Z1sdqiGYPagB3kZ8VAhccElgXUtanNEX1zCrNUMx aQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gs6kf72tw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jun 2022 02:10:20 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25M26XEQ037980;
        Wed, 22 Jun 2022 02:10:18 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gtd9usx3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jun 2022 02:10:18 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 25M29Bio002724;
        Wed, 22 Jun 2022 02:10:18 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gtd9usx36-2;
        Wed, 22 Jun 2022 02:10:18 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>,
        open-iscsi@googlegroups.com, linux@yadro.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: iscsi: prefer xmit of DataOut before new cmd
Date:   Tue, 21 Jun 2022 22:10:12 -0400
Message-Id: <165586371838.21830.14886184856943048987.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220607131953.11584-1-d.bogdanov@yadro.com>
References: <20220607131953.11584-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: UjP0GGweV_k-NZy3M70bUX1UemYGdtIr
X-Proofpoint-GUID: UjP0GGweV_k-NZy3M70bUX1UemYGdtIr
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 7 Jun 2022 16:19:53 +0300, Dmitry Bogdanov wrote:

> In function iscsi_data_xmit (TX worker) there is walking through the
> queue of new SCSI commands that is replenished in parallell. And only
> after that queue got emptied the function will start sending pending
> DataOut PDUs. That lead to DataOut timer time out on target side and
> to connection reinstatment.
> 
> This patch swaps walking through the new commands queue and the pending
> DataOut queue. To make a preference to ongoing commands over new ones.
> 
> [...]

Applied to 5.20/scsi-queue, thanks!

[1/1] scsi: iscsi: prefer xmit of DataOut before new cmd
      https://git.kernel.org/mkp/scsi/c/65080c51fde4

-- 
Martin K. Petersen	Oracle Linux Engineering
