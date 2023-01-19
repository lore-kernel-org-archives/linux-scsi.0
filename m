Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06F92C38159
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Jan 2023 00:30:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjASAaP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Jan 2023 19:30:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjASAaO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2023 19:30:14 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98DE15FD72
        for <linux-scsi@vger.kernel.org>; Wed, 18 Jan 2023 16:30:13 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30ILmja2006391;
        Thu, 19 Jan 2023 00:21:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=t77aBzxSMH4KCpgSGEHktj+qXI4T7eae+gvXnwxz2xw=;
 b=mLZ9kdg/Pa6XLTXZ8Hh4hfN69wnCowR0gQx4gzJfCxOgR6BQqN2JYlxQ9AruaIxWFnKf
 C2UIHEL34az7zFUQhR1NOsVwoJcXhaa00P75ejAj07Hd89cCSACzM/MLiLjykMyLAcyw
 bWPS0KEYHCu3uJQXSZ2yL5Y4gPH3QkoNJcH94TLbbSfsDC2Flr0A2eAwlP/hOZDmcp3f
 vvOg7BAxjKluaGYhcPFX00A41A78a6/bx+bkx2Iv7QGLSPIb1CDt/BNeSum26JRj+sWA
 J7uZXx9nZNfdEyd/pRTMA2V6YicIuddxcqm2SPNLd07CquZ3ek9yp7kX3oL8Wjm3KTmr Zw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n3mxt90a8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 00:21:35 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30IMGfuu030120;
        Thu, 19 Jan 2023 00:21:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n6quaxw6y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 00:21:35 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30J0LYOw007137;
        Thu, 19 Jan 2023 00:21:34 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3n6quaxw6c-1;
        Thu, 19 Jan 2023 00:21:34 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Alexey V. Vissarionov" <gremlin@altlinux.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        storagedev@microchip.com, Don Brace <don.brace@microchip.com>,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH] scsi: hpsa: fix allocation size for scsi_host_alloc()
Date:   Wed, 18 Jan 2023 19:21:27 -0500
Message-Id: <167408762163.3511288.15375211470460588388.b4-ty@oracle.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230118031255.GE15213@altlinux.org>
References: <20230116133140.GB8107@altlinux.org> <39006233-ff6f-82ad-b772-e00e789375a5@acm.org> <20230117095644.GA12547@altlinux.org> <30d3e555-4fb0-23df-abeb-e1c3dc41543e@ispras.ru> <20230117211201.GD15213@altlinux.org> <531f3f82-712c-eb0b-d22d-710e8a36b3c2@acm.org> <20230118031255.GE15213@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_05,2023-01-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 spamscore=0 malwarescore=0 mlxscore=0 mlxlogscore=903 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301190000
X-Proofpoint-GUID: oTWeqShnIXp94XDq4-ax4wMBDB5lJhCF
X-Proofpoint-ORIG-GUID: oTWeqShnIXp94XDq4-ax4wMBDB5lJhCF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 18 Jan 2023 06:12:55 +0300, Alexey V. Vissarionov wrote:

> On 2023-01-17 13:23:19 -0800, Bart Van Assche wrote:
> 
>  > My understanding is that you used an incorrect commit hash.
>  > Hence, it is up to you to fix the commit hash.
> 
> ACK. Resending:
> 
> [...]

Applied to 6.2/scsi-fixes, thanks!

[1/1] scsi: hpsa: fix allocation size for scsi_host_alloc()
      https://git.kernel.org/mkp/scsi/c/bbbd25499100

-- 
Martin K. Petersen	Oracle Linux Engineering
