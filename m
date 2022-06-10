Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DA0BC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jun 2022 17:45:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350179AbiFJRpQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jun 2022 13:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349701AbiFJRpO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jun 2022 13:45:14 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D5845536B;
        Fri, 10 Jun 2022 10:45:13 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25AEOOI5006828;
        Fri, 10 Jun 2022 17:45:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=wV7zD/b7Tbx570fJL/Qx66L+LDFlSz8vhFsHJ6plOVI=;
 b=DZvK8x6kmWlsFzGvhe3HKKjm30sthrW3qPYSHEoKNYhKaoyoec2iLCJoLj8nSaqhziUK
 WcRA2CgCazZRnbftzsXjO8NG/tYqr7oog7dNMBEWF5pcAmoFucGfxuqRMa9rH2d7f6/6
 FabEAcZUbgcc8eDqh8yU5Q8xjRYIwJ9WKHO+5qKrXghFLcKHFk0dO0kwogHWZ2T01n1J
 6iiiZl1r/jN6gB58BtQ+eUAToZxoTfi8RFP6wAMPalIDCCiOT+kAL/lQtFSO/1BHnpLo
 CNEBjl8jKtUi8JK20pD/Ms8pzx/DNEDtNFrg7vhWz0lJgsCj4Z9MY/F/SH0tlgbZrxyM tA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gfyekp6wy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jun 2022 17:45:12 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25AHFKuj034773;
        Fri, 10 Jun 2022 17:45:11 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gfwudaup6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jun 2022 17:45:11 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 25AHcugh012397;
        Fri, 10 Jun 2022 17:45:11 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gfwudaunq-1;
        Fri, 10 Jun 2022 17:45:11 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        target-devel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, linux@yadro.com
Subject: Re: [PATCH v5 0/3] target: iscsi: control authentication per ACL
Date:   Fri, 10 Jun 2022 13:45:08 -0400
Message-Id: <165488292962.17199.15757562956535370580.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220523095905.26070-1-d.bogdanov@yadro.com>
References: <20220523095905.26070-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: p7FbNVWp7JnaLPY5MS94FmW4GKj1KTmS
X-Proofpoint-ORIG-GUID: p7FbNVWp7JnaLPY5MS94FmW4GKj1KTmS
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 23 May 2022 12:59:02 +0300, Dmitry Bogdanov wrote:

> Add acls/{ACL}/attrib/authentication attribute that controls authentication
> for the particular ACL. By default, this attribute inherits a value of
> authentication attribute of the target port group to keep a backward
> compatibility.
> 
> authentication attribute has 3 states:
> "0" - authentication is turned off for this ACL
> "1" - authentication is required for this ACL
> "-1" - authentication is inherited from TPG
> 
> [...]

Applied to 5.20/scsi-queue, thanks!

[1/3] scsi: target: iscsi: Add upcast helpers
      https://git.kernel.org/mkp/scsi/c/a11b80692be5
[2/3] scsi: target: iscsi: extract auth functions
      https://git.kernel.org/mkp/scsi/c/a75fcb0912a5
[3/3] target: iscsi: control authentication per ACL
      https://git.kernel.org/mkp/scsi/c/a6e0d179764c

-- 
Martin K. Petersen	Oracle Linux Engineering
