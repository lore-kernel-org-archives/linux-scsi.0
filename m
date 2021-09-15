Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86075C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 14:44:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68007611CA
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 14:44:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237929AbhIOOpS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Sep 2021 10:45:18 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25320 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233745AbhIOOpR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Sep 2021 10:45:17 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18FE5HbC004203;
        Wed, 15 Sep 2021 10:43:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=l+meP3L7Ql8c7cvN0ZfGxY0u5WK20CC0RpmhP7EEcKg=;
 b=VDOoq8tA3RPP0GvXh1SpOYq2DBmu5CvHtD2FAW86QQ0Xg+z22Rb88ZJWQl9hk8/EJI4X
 5bikarRpemDfV+WUShgznvoNX9hzerI0CO9gBR0GIXw9pD3KzFrfXnzyCb2mUGOV3zab
 zEpMssHF6vtu9I5tRx8+EuyuIkwr8CxoFN0KutHq0Q5I7W2YN4IAzVMMdrKFitbfw1SW
 bnLNlnG1eHXSrtQFoXfurIXwJEUvIKrI2iGXU1GBBTm50jRZjc/uuHEWplg1r1Lkx4U7
 2Rlc6kOv3axSBFI3O+egbXnq4q7v+FFya191KNOd0rlIF5TaCjTufa5SMMtMSof59OAm nA== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b3j9p1706-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Sep 2021 10:43:56 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18FEXnLW013088;
        Wed, 15 Sep 2021 14:43:55 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03dal.us.ibm.com with ESMTP id 3b0m3c01f0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Sep 2021 14:43:55 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18FEhsja40698316
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Sep 2021 14:43:54 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 70D937806E;
        Wed, 15 Sep 2021 14:43:54 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B44527805F;
        Wed, 15 Sep 2021 14:43:53 +0000 (GMT)
Received: from jarvis.lan (unknown [9.211.54.195])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 15 Sep 2021 14:43:53 +0000 (GMT)
Message-ID: <0912982133a254770a27b780cd2c5771739ced3b.camel@linux.ibm.com>
Subject: Re: [PATCH V3 1/1] scsi/ses: Saw "Failed to get diagnostic page 0x1"
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     wenxiong@linux.vnet.ibm.com
Cc:     linux-scsi@vger.kernel.org, brking1@linux.vnet.ibm.com,
        martin.petersen@oracle.com, wenxiong@us.ibm.com
Date:   Wed, 15 Sep 2021 10:43:52 -0400
In-Reply-To: <1631711048-6177-1-git-send-email-wenxiong@linux.vnet.ibm.com>
References: <1631711048-6177-1-git-send-email-wenxiong@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: P4c8GCf1shIcklWC6Oz-K4EdfeHHREP-
X-Proofpoint-ORIG-GUID: P4c8GCf1shIcklWC6Oz-K4EdfeHHREP-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 impostorscore=0 clxscore=1015 priorityscore=1501 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109150087
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-09-15 at 08:04 -0500, wenxiong@linux.vnet.ibm.com wrote:
> From: Wen Xiong <wenxiong@linux.vnet.ibm.com>
> 
> Setting scsi logging level with error=3, we saw some errors from
> enclosues:
> 
> [108017.360833] ses 0:0:9:0: tag#641 Done: NEEDS_RETRY Result:
> hostbyte=DID_ERROR driverbyte=DRIVER_OK cmd_age=0s
> [108017.360838] ses 0:0:9:0: tag#641 CDB: Receive Diagnostic 1c 01 01
> 00 20 00
> [108017.427778] ses 0:0:9:0: Power-on or device reset occurred
> [108017.427784] ses 0:0:9:0: tag#641 Done: SUCCESS Result:
> hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
> [108017.427788] ses 0:0:9:0: tag#641 CDB: Receive Diagnostic 1c 01 01
> 00 20 00
> [108017.427791] ses 0:0:9:0: tag#641 Sense Key : Unit Attention
> [current]
> [108017.427793] ses 0:0:9:0: tag#641 Add. Sense: Bus device reset
> function occurred
> [108017.427801] ses 0:0:9:0: Failed to get diagnostic page 0x1
> [108017.427804] ses 0:0:9:0: Failed to bind enclosure -19
> [108017.427895] ses 0:0:10:0: Attached Enclosure device
> [108017.427942] ses 0:0:10:0: Attached scsi generic sg18 type 13
> 
> As Martin's suggestion, the patch checks to retry on NOT_READY as
> well as
> UNIT_ATTENTION with ASC 0x29.

This looks fine to me.  I think the reason expecting_cc_ua doesn't work
for you is that you're getting > 1 reset per command.  expecting_cc_ua
automatically resets after eating the first unit attention.

Reviewed-by: James Bottomley <jejb@linux.ibm.com>

James


