Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1746CC4361B
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 17:25:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD14023A5A
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 17:25:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732239AbgLIRYu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 12:24:50 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:34574 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732339AbgLIRYt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 12:24:49 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9HJYaH058918;
        Wed, 9 Dec 2020 17:24:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=kE/b0mJZ9EG/F69/zuR7c03nnH3LgMIIybQnaH0QV60=;
 b=stnTnBSi6rV7YOPpP8fEzTVqistLyhHGEz/Yfhxpf/xOfKxMbfkSafxAsJvIvVThLfYP
 pBIQ+Iv8kOsmlF1xcTAJC7Oh8jjNkp1eEND/FXJ3s2uQjP4uX2XqqeLvV66FyXycExOj
 Oxs5phWs3Au0izBXnfqGNrpDbzaS3fl78oEU0N60NnfJxQEJ4lTqRIeRiDSlVOuBc14R
 plpJTtHaD2YOFCyNEvZMGarbrw40Tx3HSgFF7XRzXq81S5t/etFrGMhFy1GwZqEByXNM
 u4FN/2HA1Dm5ZCe6uF3szh2Xqr5fmiVztFw1ngKN3tvQHmCjxG56F7oMkzn9EfO55z30 IA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 357yqc1fpf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Dec 2020 17:24:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9HJlfD075706;
        Wed, 9 Dec 2020 17:24:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 358m50wh7b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Dec 2020 17:24:06 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B9HO57b023162;
        Wed, 9 Dec 2020 17:24:05 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Dec 2020 09:24:03 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com
Subject: Re: [PATCH v1 0/8] mpt3sas: Features to enhance driver debugging.
Date:   Wed,  9 Dec 2020 12:23:24 -0500
Message-Id: <160753457756.14816.7339704621303199255.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201126094311.8686-1-suganath-prabu.subramani@broadcom.com>
References: <20201126094311.8686-1-suganath-prabu.subramani@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012090122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090122
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 26 Nov 2020 15:13:03 +0530, Suganath Prabu S wrote:

> 1. Periodic Time Sync b/w driver and FW.
> Periodic time sync sets the time of the FW to be the same as
> the time of the Driver (HOST). With Existing driver, time stamp
> synchronization occurs only during Driver load and controller
> reset. With Patch1 - Period time sync implementation facilitates
> driver to sync time stamp periodically with IO_UNIT_CONTROL
> request.
> 
> [...]

Applied to 5.11/scsi-queue, thanks!

[1/8] mpt3sas: Sync time stamp periodically between Driver and FW
      https://git.kernel.org/mkp/scsi/c/f98790c00375
[2/8] mpt3sas: Add persistent trigger pages support
      https://git.kernel.org/mkp/scsi/c/aec93e8e2385
[3/8] mpt3sas: Add master triggers persistent Trigger Page
      https://git.kernel.org/mkp/scsi/c/bb855f2a5d7e
[4/8] mpt3sas: Add Event triggers persistent Trigger Page2
      https://git.kernel.org/mkp/scsi/c/71b3fb8fe6dd
[5/8] mpt3sas: Add SCSI sense triggers persistent Trigger
      https://git.kernel.org/mkp/scsi/c/2a5c3a35c156
[6/8] mpt3sas: Add MPI triggers persistent Trigger Page4
      https://git.kernel.org/mkp/scsi/c/0e17a87c5950
[7/8] mpt3sas: Handle trigger page support after reset.
      https://git.kernel.org/mkp/scsi/c/9b271c69128b
[8/8] mpt3sas: Update driver version to 36.100.00.00
      https://git.kernel.org/mkp/scsi/c/be1b50021254

-- 
Martin K. Petersen	Oracle Linux Engineering
