Return-Path: <SRS0=zQak=BE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B320C433EA
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 02:51:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37D512074B
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 02:51:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AmeZWt67"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbgGYCvJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jul 2020 22:51:09 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46994 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726764AbgGYCvH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jul 2020 22:51:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P2lRC6049043;
        Sat, 25 Jul 2020 02:51:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=D2rDfeIXXv3l9qvrv6Yr7KJlDQJ4s1csqMVoZwUGpdc=;
 b=AmeZWt671G1c11mLV6Jv6pG0O4+Fw+pOfMcLV9OTucrxx04F9ciXL1u3sXByL1Eo68sV
 Ctj99zNNhK89DYHwwe0dAI/XKdptlVw8EQFW3oqXky/mqJnwZa+Nk3aC6ZFhWqgaHxdH
 w3phbqRTEavf/GxT+gQIeE2lqe12vgxOzZCivYwe62+8ncvMpW9JQlwK2MhPWZXuuYWW
 kIlNyIMM5ps2Ga0ZC8Wcm1874gzYAgfTmHNOutFOAT87Y2tv1gseMN+BoP/KX0yV2PWr
 QaPaclaW49wZCIAm8l9oYVuLR7mcDnGXK+47BLrIqXogmA435fAlIoKHu5wTUcXu5JlP gw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32d6kt641u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 25 Jul 2020 02:50:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P2mEvc001199;
        Sat, 25 Jul 2020 02:50:59 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 32gam27gmd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Jul 2020 02:50:59 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06P2op1r004122;
        Sat, 25 Jul 2020 02:50:51 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 25 Jul 2020 02:50:50 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Finn Thain <fthain@telegraphics.com.au>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi/mesh: Fix panic after host or bus reset
Date:   Fri, 24 Jul 2020 22:50:35 -0400
Message-Id: <159564519423.31464.15591259959982994104.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <3952bc691e150a7128b29120999b6092071b039a.1595460351.git.fthain@telegraphics.com.au>
References: <3952bc691e150a7128b29120999b6092071b039a.1595460351.git.fthain@telegraphics.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=991 adultscore=0
 malwarescore=0 spamscore=0 bulkscore=0 phishscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007250020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=992 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 spamscore=0 adultscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007250020
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 23 Jul 2020 09:25:51 +1000, Finn Thain wrote:

> Booting Linux with a Conner CP3200 drive attached to the MESH SCSI bus
> results in EH measures and a panic:
> 
> [   25.499838] mesh: configured for synchronous 5 MB/s
> [   25.787154] mesh: performing initial bus reset...
> [   29.867115] scsi host0: MESH
> [   29.929527] mesh: target 0 synchronous at 3.6 MB/s
> [   29.998763] scsi 0:0:0:0: Direct-Access     CONNER   CP3200-200mb-3.5 4040 PQ: 0 ANSI: 1 CCS
> [   31.989975] sd 0:0:0:0: [sda] 415872 512-byte logical blocks: (213 MB/203 MiB)
> [   32.070975] sd 0:0:0:0: [sda] Write Protect is off
> [   32.137197] sd 0:0:0:0: [sda] Mode Sense: 5b 00 00 08
> [   32.209661] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [   32.332708]  sda: [mac] sda1 sda2 sda3
> [   32.417733] sd 0:0:0:0: [sda] Attached SCSI disk
> ... snip ...
> [   76.687067] mesh_abort((ptrval))
> [   76.743606] mesh: state at (ptrval), regs at (ptrval), dma at (ptrval)
> [   76.810798]     ct=6000 seq=86 bs=4017 fc= 0 exc= 0 err= 0 im= 7 int= 0 sp=85
> [   76.880720]     dma stat=84e0 cmdptr=1f73d000
> [   76.941387]     phase=4 msgphase=0 conn_tgt=0 data_ptr=24576
> [   77.005567]     dma_st=1 dma_ct=0 n_msgout=0
> [   77.065456]     target 0: req=(ptrval) goes_out=0 saved_ptr=0
> [   77.130512] mesh_abort((ptrval))
> [   77.187670] mesh: state at (ptrval), regs at (ptrval), dma at (ptrval)
> [   77.255594]     ct=6000 seq=86 bs=4017 fc= 0 exc= 0 err= 0 im= 7 int= 0 sp=85
> [   77.325778]     dma stat=84e0 cmdptr=1f73d000
> [   77.387239]     phase=4 msgphase=0 conn_tgt=0 data_ptr=24576
> [   77.453665]     dma_st=1 dma_ct=0 n_msgout=0
> [   77.515900]     target 0: req=(ptrval) goes_out=0 saved_ptr=0
> [   77.582902] mesh_host_reset
> [   88.187083] Kernel panic - not syncing: mesh: double DMA start !
> [   88.254510] CPU: 0 PID: 358 Comm: scsi_eh_0 Not tainted 5.6.13-pmac #1
> [   88.323302] Call Trace:
> [   88.378854] [e16ddc58] [c0027080] panic+0x13c/0x308 (unreliable)
> [   88.446221] [e16ddcb8] [c02b2478] mesh_start.part.12+0x130/0x414
> [   88.513298] [e16ddcf8] [c02b2fc8] mesh_queue+0x54/0x70
> [   88.577097] [e16ddd18] [c02a1848] scsi_send_eh_cmnd+0x374/0x384
> [   88.643476] [e16dddc8] [c02a1938] scsi_eh_tur+0x5c/0xb8
> [   88.707878] [e16dddf8] [c02a1ab8] scsi_eh_test_devices+0x124/0x178
> [   88.775663] [e16dde28] [c02a2094] scsi_eh_ready_devs+0x588/0x8a8
> [   88.843124] [e16dde98] [c02a31d8] scsi_error_handler+0x344/0x520
> [   88.910697] [e16ddf08] [c00409c8] kthread+0xe4/0xe8
> [   88.975166] [e16ddf38] [c000f234] ret_from_kernel_thread+0x14/0x1c
> [   89.044112] Rebooting in 180 seconds..
> 
> [...]

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: mesh: Fix panic after host or bus reset
      https://git.kernel.org/mkp/scsi/c/edd7dd2292ab

-- 
Martin K. Petersen	Oracle Linux Engineering
