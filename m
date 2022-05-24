Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E801C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 24 May 2022 18:12:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240256AbiEXSME (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 May 2022 14:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240212AbiEXSL5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 May 2022 14:11:57 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B17AD5E16C
        for <linux-scsi@vger.kernel.org>; Tue, 24 May 2022 11:11:56 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OHnrWF022454;
        Tue, 24 May 2022 18:11:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=4N3oavYm7srSSmyU7HRMbbIaGEzKYtuehG7tD0eXNQo=;
 b=SgfSu/5vxfrRMKU2NY4PFM7r0XwKsxnMD6R+uea379Um5BJ/27Nwg3yRh4a6zvzH6txS
 XvS3YmY7eUS+zsGyWWpSG2HHFku0OfrlNVadqGL8kSKW7PF8zpIjHzDshE5Z3IYXP/4s
 0Ej/9ee5kp0uvLzFndQRXp6VqvUV+aiSzfpYEzeDsNS6SuBNxGe66sBSdkl/w0xNOILC
 ZxxObr2bR1z1AT1s8Sk/0AOd5j2Bz4OGc2+L/abMmYp4QghbfkugVbXnPyqM58Z9PLip
 o+AQwP9MT7C7Bdi0qVT0ZnRWN9B2IvYqv46o0NKPCxrmZf/4opBQB3KTgGqDjkRiKkSr wA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g93tar3fv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 18:11:46 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24OHoOGZ016620;
        Tue, 24 May 2022 18:11:44 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g93x50s4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 18:11:44 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 24OIAvmu039045;
        Tue, 24 May 2022 18:11:44 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g93x50s3r-2;
        Tue, 24 May 2022 18:11:44 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>
Subject: Re: [PATCHv2] myrb: fixup null pointer access on myrb_cleanup()
Date:   Tue, 24 May 2022 14:11:34 -0400
Message-Id: <165341587531.22286.3143357087389295163.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220523120244.99515-1-hare@suse.de>
References: <20220523120244.99515-1-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 8Pwru6qVKXRPX1b3JautBAIpU3gMShBo
X-Proofpoint-ORIG-GUID: 8Pwru6qVKXRPX1b3JautBAIpU3gMShBo
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 23 May 2022 14:02:44 +0200, Hannes Reinecke wrote:

> When myrb_probe() fails the callback might not be set, so we need
> to validate the 'disable_intr' callback in myrb_cleanup() to not
> cause a null pointer exception. And while at it do not call
> myrb_cleanup() if we cannot enable the PCI device at all.
> 
> 

Applied to 5.19/scsi-queue, thanks!

[1/1] myrb: fixup null pointer access on myrb_cleanup()
      https://git.kernel.org/mkp/scsi/c/f9f0a46141e2

-- 
Martin K. Petersen	Oracle Linux Engineering
