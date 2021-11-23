Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09500C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Nov 2021 03:45:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232983AbhKWDsZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 22:48:25 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:16832 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231868AbhKWDsW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Nov 2021 22:48:22 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AN23i9U016041;
        Tue, 23 Nov 2021 03:45:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=8J3rQR8yfPXeujlx0z8jAckRtVdIqQ2Jcd33TI2xpsg=;
 b=XNKORNwSTvUfUcGN06DvQn5YUVEgsBaiJ+QvKykwPcMoxMMSfGdODRB9/cVYq0q2XpM2
 ddLAWwfMnT23pCP9XV2TgRCGusSfOHCrupVauKAitE0Nej02pQus6KK+tlGgH3r8aHdI
 DmkX4EITxeFgmwbTvi7RBuSIBLF7BHX3FMTq29ZFFrIpkyqAWcmbN5DVqQ+gdBgbXKG4
 yEeE5DhXV/qvMumDGysPbG3G/D0qiEqA/5VycXZXGyiHR4FwGivdk6THvjAl7vLtVZIx
 bqWvopDT6Rh6Dqt/T/1MEIQ0P9sbo7Omoy05i1vgrYlVZp638Xs9jZ1FaYKkop7rDkhQ iQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cg55fxp3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 03:45:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AN3akLK044292;
        Tue, 23 Nov 2021 03:45:12 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3ceq2djd42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 03:45:12 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1AN3jATt070854;
        Tue, 23 Nov 2021 03:45:12 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3030.oracle.com with ESMTP id 3ceq2djd2x-3;
        Tue, 23 Nov 2021 03:45:11 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v2] scsi: scsi_debug: Zero clear zones at reset write pointer
Date:   Mon, 22 Nov 2021 22:45:09 -0500
Message-Id: <163763907100.20472.10813642121382131816.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211122061223.298890-1-shinichiro.kawasaki@wdc.com>
References: <20211122061223.298890-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: 9D3bInT0LDzyzw3vaMv0PPh0czYJmwAs
X-Proofpoint-GUID: 9D3bInT0LDzyzw3vaMv0PPh0czYJmwAs
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 22 Nov 2021 15:12:23 +0900, Shin'ichiro Kawasaki wrote:

> When reset write pointer is requested to scsi_debug devices with zoned
> model, positions of write pointers are reset, but the data in the target
> zones are not cleared. Read to the zones returns data written before the
> reset write pointer. This unexpected left data is confusing and does not
> allow using scsi_debug for stale page cache test of the BLKRESETZONE
> ioctl. Hence, zero clear the written data in the zones at reset write
> pointer.
> 
> [...]

Applied to 5.16/scsi-fixes, thanks!

[1/1] scsi: scsi_debug: Zero clear zones at reset write pointer
      https://git.kernel.org/mkp/scsi/c/2d62253eb1b6

-- 
Martin K. Petersen	Oracle Linux Engineering
