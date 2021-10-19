Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 855CEC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 03:43:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AEF061354
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 03:43:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbhJSDqD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 23:46:03 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:23392 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229692AbhJSDqD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Oct 2021 23:46:03 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19J2wvMO015245;
        Tue, 19 Oct 2021 03:43:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=Zq1PD1e4FCwlXZoMPR+nLKMAkWRmz+TdEWFb+ef6plQ=;
 b=oRBXqc3/HwT/TxqSYZQ8MtUjH9UVG+wLUkGNZaWlHSjjY1rrKcT3j7KkJ8uMnTqBv9ZH
 jncmzQgHUu/19+cmUeEMKKDpa420KAQneE7LKN7eNqnyziPIHXnFCig6G3nWFPj9exKV
 TpTTLa3tuMC3oSQkyflEwmMt7+1sCSAeSJSTuB/H0rK55l9uxZSfWFEp+j/HEeXeOTqu
 dNmxzS2Ou4ljATKso2lsLfss+bU5ANfoL7F0TI+caEV8rECjlgh0QtIFEh4Lj+5J2P8u
 /ZfkEFaIiR+HSHfdW0Vug4ayxY43gwbMdY+U2Rpc1cG8arElhPkTHkBtQhSygLvHIcZ1 Cg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3brnfhqskk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Oct 2021 03:43:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19J3ZT88077083;
        Tue, 19 Oct 2021 03:43:47 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 3br8grmmtv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Oct 2021 03:43:47 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19J3hhHh101685;
        Tue, 19 Oct 2021 03:43:47 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3020.oracle.com with ESMTP id 3br8grmmrp-5;
        Tue, 19 Oct 2021 03:43:47 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        sathya.prakash@broadcom.com, thenzl@redhat.com
Subject: Re: [PATCH RESEND] mpi3mr:Fix duplicate device entries when scan through sysfs
Date:   Mon, 18 Oct 2021 23:43:41 -0400
Message-Id: <163461411520.13664.5517769413519204966.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211014055425.30719-1-sreekanth.reddy@broadcom.com>
References: <20211014055425.30719-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: axi3l8bIGFimL7SlAXeDItF00d4bYDgh
X-Proofpoint-GUID: axi3l8bIGFimL7SlAXeDItF00d4bYDgh
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 14 Oct 2021 11:24:25 +0530, Sreekanth Reddy wrote:

> When the user scans the devices through 'scan' sysfs using below
> command then the user will observe duplicate device entries
> in lsscsi command output.
> echo "- - -" > /sys/class/scsi_host/host0/scan
> 
> Fix is to set the shost's max_channel to zero.
> 
> [...]

Applied to 5.15/scsi-fixes, thanks!

[1/1] mpi3mr:Fix duplicate device entries when scan through sysfs
      https://git.kernel.org/mkp/scsi/c/97e6ea6d7806

-- 
Martin K. Petersen	Oracle Linux Engineering
