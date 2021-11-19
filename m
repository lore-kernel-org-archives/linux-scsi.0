Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E93FC433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 04:16:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8572B61AED
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 04:16:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233565AbhKSETy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Nov 2021 23:19:54 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:10024 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229812AbhKSETx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Nov 2021 23:19:53 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ1ti89020985;
        Fri, 19 Nov 2021 04:16:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=9Eu44hnETw+Fqcy1GlNFLqt/UYZxFr1YDuew9+fEO8s=;
 b=vZY1ir8bKIb6Lnfc23BPwA6QHoV+QW9BpOXyTHCTI2qBwJEv3RvxvIspXcK9UaMK347U
 wv8V7tCV/XmHwgaSeq7qruLW/Fmq7E3fCHHJLOJhIILO1Fb9bQOqlUZx3ihPeILCefa8
 JqQhDp4D6dokmkmTSBzqB7xiy9jrXCkt7iJDrl4fYuaciF0AnlCXOljsRKZ3/3ExHbpd
 jqqnf2OYmoS6sejdezGdpXdQnpW5F/t7px/5kTMYvOdCjxXyC/dgIKaRQgVLoA4a8/fZ
 maYcxdJAhnkB1Ztwjf/EqqVuV4i5lwIPSvEGYOBNUjsW9rUwklWiJLK4Jjc1Z2Pwj2Ig 6g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cd4qyucj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 04:16:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ4FBBI020315;
        Fri, 19 Nov 2021 04:16:48 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 3caq4x7c0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 04:16:48 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1AJ4GiwM024731;
        Fri, 19 Nov 2021 04:16:47 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3020.oracle.com with ESMTP id 3caq4x7bx2-4;
        Fri, 19 Nov 2021 04:16:47 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        kernel-janitors@vger.kernel.org,
        Larry Wisneski <Larry.Wisneski@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: edif: fix off by one bug in qla_edif_app_getfcinfo()
Date:   Thu, 18 Nov 2021 23:16:33 -0500
Message-Id: <163729506337.21244.1075922687448615071.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211109115219.GE16587@kili>
References: <20211109115219.GE16587@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: InXFH-9KKTK-CwkeyVOF-swlzDILyET4
X-Proofpoint-GUID: InXFH-9KKTK-CwkeyVOF-swlzDILyET4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 9 Nov 2021 14:52:19 +0300, Dan Carpenter wrote:

> The > comparison needs to be >= to prevent accessing one element beyond
> the end of the app_reply->ports[] array.
> 
> 

Applied to 5.16/scsi-fixes, thanks!

[1/1] scsi: qla2xxx: edif: fix off by one bug in qla_edif_app_getfcinfo()
      https://git.kernel.org/mkp/scsi/c/e11e285b9cd1

-- 
Martin K. Petersen	Oracle Linux Engineering
