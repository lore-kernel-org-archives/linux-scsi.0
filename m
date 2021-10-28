Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7246FC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 19:12:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BCFB610FD
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 19:12:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbhJ1TPM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Oct 2021 15:15:12 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24636 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230104AbhJ1TPM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 Oct 2021 15:15:12 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19SIrgk2012944;
        Thu, 28 Oct 2021 19:12:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=ebibBSYuRWkCtxrn1KkmUUuESiFbXtwYxHn5Cd26fCA=;
 b=Uqkk9bMWM2FTB0WpV5sd41cW11Vye6fBu96JRJdpbrnxMgDIwtgWzj05e32N7Wv+RcFH
 zwyuZ3f9SnEdlUZA70GPeugXmWODoS6XhF1JYivlHMPccTzX7tm2TDvuJUm5lLHLySwY
 H4Awa5nZyORDF+IEOArEUYIqclh1OFXQdKotF3bH8IYHprLSwuCIULkofaTZp+XkVWwz
 eummuH/XCyv5iVNq9ceJer4ko7WWgZLY0hosoGC8RMPGNL65Lnc4o+1IGjxVSqBDrd5R
 vbEYzf6ZPaqPN5FgAFKgXJKpuxMHtLQeg2cK17+9vqKqzeVALeoLGP+ZylEPJaddrhqv zQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c01ht8c2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Oct 2021 19:12:34 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19SIsI5A013875;
        Thu, 28 Oct 2021 19:12:34 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c01ht8c28-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Oct 2021 19:12:34 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19SJ9tRr007690;
        Thu, 28 Oct 2021 19:12:32 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02wdc.us.ibm.com with ESMTP id 3bx4eexyxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Oct 2021 19:12:32 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19SJCVgO27722020
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Oct 2021 19:12:31 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 915C87805E;
        Thu, 28 Oct 2021 19:12:31 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 214E97805C;
        Thu, 28 Oct 2021 19:12:30 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.163.12.226])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 28 Oct 2021 19:12:29 +0000 (GMT)
Message-ID: <1d7c1faf6b6fa71599b5157ae95fc48ce479b722.camel@linux.ibm.com>
Subject: Re: [PATCH] scsi: ufs: Fix proper API to send HPB pre-request
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Bart Van Assche <bvanassche@acm.org>, daejun7.park@samsung.com,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "huobean@gmail.com" <huobean@gmail.com>,
        Keoseong Park <keosung.park@samsung.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
Date:   Thu, 28 Oct 2021 15:12:28 -0400
In-Reply-To: <0d66b6d0-26c6-573f-e2a0-022e22c47b52@acm.org>
References: <CGME20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff@epcms2p6>
         <20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff@epcms2p6>
         <0f9229c3c4c7859524411a47db96a3b53ac89c90.camel@linux.ibm.com>
         <0d66b6d0-26c6-573f-e2a0-022e22c47b52@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4B3mIsVrLwJIeGbeNInSr2oVIvBI_rTL
X-Proofpoint-ORIG-GUID: FpfuV6G84xVFFiEnWk0hP3ynd-Ezr7d6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-28_05,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 mlxscore=0 impostorscore=0 spamscore=0 malwarescore=0
 adultscore=0 suspectscore=0 lowpriorityscore=0 phishscore=0
 mlxlogscore=999 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2110280100
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2021-10-28 at 08:59 -0700, Bart Van Assche wrote:
> On 10/28/21 7:28 AM, James Bottomley wrote:
> > If the block people are happy with this, then I'm OK with it, but
> > it
> > doesn't look like you've solved the fanout deadlock problem because
> > this new mechanism is still going to allocate a new tag.
> 
> (+Jens, Christoph and linux-block)
> 
> Hi James,
> 
> My understanding is that the UFS HPB code makes ufshcd_queuecommand()
> return SCSI_MLQUEUE_HOST_BUSY if the pool with pre-allocated requests
> is exhausted. This will make the SCSI core reissue a SCSI command
> until completion of another command has freed up one of the pre-
> allocated requests. This is not the most efficient approach but
> should not trigger a deadlock.

I think the deadlock is triggered if the system is down to its last
reserved request on the memory clearing device and the next entry in
the queue for this device is one which does a fanout so we can't
service it with the single reserved request we have left for the
purposes of making forward progress.  Sending it back doesn't help,
assuming this is the only memory clearing path, because retrying it
won't help ... we have to succeed with a request on this path to move
forward with clearing memory.

I think this problem could be solved by processing the WRITE BUFFER and
the request serially by hijacking the request sent down, but we can't
solve it if we try to allocate a new request.

James


