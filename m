Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 303C0C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 04:56:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F245923A62
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 04:56:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbgLHEzc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 23:55:32 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44072 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbgLHEzb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 23:55:31 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B84sDr6137149;
        Tue, 8 Dec 2020 04:54:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=sfVa+IscJvNoJi8/Fojgwr6Ay1FnwfflyjmlBDhbf3Q=;
 b=fp/PFHU1989/8yIvLttjCv9JHSDXJkm/bw2SyHlWeBCvFRlkmvLHxQjp39XQ65R+lyGF
 07+MrkMrwLWmI3M1HKgs4JhJXmeRFA9gvEGtl6MXn30zWR52O22xDj+R9CW8g1pLz928
 Mg6cQC7ks2umMB58h6RDa/e6E/15aD9s8FKAkEdYfS3003/ouy9QQzkTxS3U5G4r8fHN
 MMplyEh6ZF9jnA7f7kr149tTdfDOVEx8K5La0/BwJcCoTEEcEqA6L+ovn9kbKU4tGzXd
 StsvvSKeE0RiUN/0QlqbTpaHqxeObHlOtUfAK0KG2QNK39fkAHoAwSdbOByESJDFVcGJ lw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3581mqrrsw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 08 Dec 2020 04:54:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B84ng8T145368;
        Tue, 8 Dec 2020 04:52:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 358m4x75vb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Dec 2020 04:52:12 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B84q4nb014536;
        Tue, 8 Dec 2020 04:52:05 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Dec 2020 20:52:04 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Xiaofei Tan <tanxiaofei@huawei.com>,
        Nilesh Javali <njavali@marvell.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Vikram Auradkar <auradkar@google.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        linux-m68k@vger.kernel.org,
        Manish Rangankar <mrangankar@marvell.com>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Hannes Reinecke <hare@kernel.org>,
        MPT-FusionLinux.pdl@broadcom.com,
        Xiang Chen <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 00/14] scsi: Remove in_interrupt() usage.
Date:   Mon,  7 Dec 2020 23:51:58 -0500
Message-Id: <160740299785.710.1053438510457476242.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201126132952.2287996-1-bigeasy@linutronix.de>
References: <20201126132952.2287996-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012080029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012080030
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 26 Nov 2020 14:29:38 +0100, Sebastian Andrzej Siewior wrote:

> Folks,
> 
> in the discussion about preempt count consistency across kernel
> configurations:
> 
>  https://lore.kernel.org/r/20200914204209.256266093@linutronix.de/
> 
> [...]

Applied to 5.11/scsi-queue, thanks!

[01/14] scsi: pm80xx: Do not sleep in atomic context.
        https://git.kernel.org/mkp/scsi/c/4ba9e516573e
[02/14] scsi: hisi_sas: Remove preemptible().
        https://git.kernel.org/mkp/scsi/c/18577cdcaeeb
[03/14] scsi: qla4xxx: qla4_82xx_crb_win_lock(): Remove in_interrupt().
        https://git.kernel.org/mkp/scsi/c/a93c38353198
[04/14] scsi: qla2xxx: qla82xx: Remove in_interrupt().
        https://git.kernel.org/mkp/scsi/c/8ac246bdd07a
[05/14] scsi: qla2xxx: tcm_qla2xxx: Remove BUG_ON(in_interrupt()).
        https://git.kernel.org/mkp/scsi/c/9fef41f25d60
[06/14] scsi: qla2xxx: init/os: Remove in_interrupt().
        https://git.kernel.org/mkp/scsi/c/4f6a57c23b1e
[07/14] scsi: qla4xxx: qla4_82xx_idc_lock(): Remove in_interrupt().
        https://git.kernel.org/mkp/scsi/c/3627668c2e2c
[08/14] scsi: qla4xxx: qla4_82xx_rom_lock(): Remove in_interrupt().
        https://git.kernel.org/mkp/scsi/c/014aced18aff
[09/14] scsi: mpt3sas: Remove in_interrupt().
        https://git.kernel.org/mkp/scsi/c/547c0d1aeb76
[10/14] scsi: myrb: Remove WARN_ON(in_interrupt()).
        https://git.kernel.org/mkp/scsi/c/3bc08b9545da
[11/14] scsi: myrs: Remove WARN_ON(in_interrupt()).
        https://git.kernel.org/mkp/scsi/c/ca6853693cbd
[12/14] scsi: NCR5380: Remove in_interrupt().
        (no commit info)
[13/14] scsi: message: fusion: Remove in_interrupt() usage in mpt_config().
        https://git.kernel.org/mkp/scsi/c/b8a5144370bc
[14/14] scsi: message: fusion: Remove in_interrupt() usage in mptsas_cleanup_fw_event_q().
        https://git.kernel.org/mkp/scsi/c/817a7c996786

-- 
Martin K. Petersen	Oracle Linux Engineering
