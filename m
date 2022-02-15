Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B06B9C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Feb 2022 03:21:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiBODV7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Feb 2022 22:21:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiBODV6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2022 22:21:58 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D08031D32E
        for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2022 19:21:49 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21F2Ql24001593;
        Tue, 15 Feb 2022 03:19:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=NIZTnGfIVD7+m/ScAt1dOLdUCboWAED9akYW6rIFDl8=;
 b=sxCupk5lWkly4XpcPEbeutfEjLLoMMg6wx1wzCNdOYc0kJEsdz/ZCwn2ej02kX6N0BbC
 UZLMTVb/gT63MO9DW6esUSD0cS6N/uHV3bff4HIOD4VfeWxjgE6oVE0npG85fMkQiP2u
 PPKm3E9qTEdbTSY5+6Efa7iPJuUaP9/iemTQWRrpLC16clXrCIWCJRYII0th0rDNqJ/S
 IgPxuHEdloP9gx2ND5QTIrSXtMT0ITqZ9K8LFhaOagK0q796lBrjpIhBT/y8UyiqsgLa
 EEggTTRRJXUFFFBGcmAkDn0/AMJwznzjwpuONJ1/nKq1WYUZ/izSJZvHOpKFrS1ec8rB mw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e63p26hch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 03:19:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21F3GmXd057526;
        Tue, 15 Feb 2022 03:19:24 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 3e620wpgr3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 03:19:24 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 21F3JMP4064243;
        Tue, 15 Feb 2022 03:19:23 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3030.oracle.com with ESMTP id 3e620wpgqq-2;
        Tue, 15 Feb 2022 03:19:23 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Chesnokov Gleb <Chesnokov.G@raidix.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] qla2xxx: Remove unused qla_sess_op_cmd_list from scsi_qla_host_t
Date:   Mon, 14 Feb 2022 22:19:14 -0500
Message-Id: <164489513314.15031.16564796657450806528.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <AS8PR10MB49524AAB4C8016E4AFF17FFB9D2D9@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
References: <AS8PR10MB49524AAB4C8016E4AFF17FFB9D2D9@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: VFi3l2pXNICxuWacv2NmrVNjHFAoC8ar
X-Proofpoint-GUID: VFi3l2pXNICxuWacv2NmrVNjHFAoC8ar
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 8 Feb 2022 15:18:38 +0000, Chesnokov Gleb wrote:

> The qla_sess_op_cmd_list was introduced in 8b2f5ff3d05c
> ("qla2xxx: cleanup cmd in qla workqueue before processing TMR").
> 
> Then the usage of this list was dropped in fb35265b12bb
> ("scsi: qla2xxx: Remove session creation redundant code").
> 
> Thus, remove this list since it is no longer used.
> 
> [...]

Applied to 5.18/scsi-queue, thanks!

[1/1] qla2xxx: Remove unused qla_sess_op_cmd_list from scsi_qla_host_t
      https://git.kernel.org/mkp/scsi/c/fa1d43f396f7

-- 
Martin K. Petersen	Oracle Linux Engineering
