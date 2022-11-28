Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E711FC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Nov 2022 18:24:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234132AbiK1SYG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Nov 2022 13:24:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234097AbiK1SXt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Nov 2022 13:23:49 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF0E1DDE0
        for <linux-scsi@vger.kernel.org>; Mon, 28 Nov 2022 10:12:58 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ASI2gvm022800;
        Mon, 28 Nov 2022 18:12:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=5fdan+F/Hvm2pvmsr2ausx+UDaSYsIyQN4upDfRfWmI=;
 b=e3YwUfO2hu6ZT0hN6oX3q9x2j7IVFYwBdiZCK8DZnXaiQdOgCJ9/W/W0Qsu/uZRVWLR1
 yTS0+QoC2lSdd4hGbt7VaJryHduZAGP0h4rR9XxgzBTORUOkDSwh/SLFhJss1sAmEppR
 Pd18IxbMnTuWcdO/CNsXzuYqlbSu6WBFg2EwA/DNU3+xF5gE8ZnBZIju8JuIPtNPXr8A
 tFIxXzYxQZ62B411eZFdXRvz9AKlzjG1VA57mAh1mTUzdEYfo7aFGRRq3h2o0ZeXv+Bc
 k+vc/ufG4vZ4gg/kNcI/LktkjV+Mz4eMEQf/80tViMioP/iOiVmuSACQxwpRB3UVipjS /Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m4xaqxuh9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 18:12:45 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2ASHVO44007782;
        Mon, 28 Nov 2022 18:12:44 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m4xaqxugx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 18:12:44 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ASI61hp001794;
        Mon, 28 Nov 2022 18:12:44 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma02dal.us.ibm.com with ESMTP id 3m3ae9axmd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 18:12:44 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ASICetu46203630
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Nov 2022 18:12:40 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CCDEB7805E;
        Mon, 28 Nov 2022 19:19:57 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4918E7805C;
        Mon, 28 Nov 2022 19:19:56 +0000 (GMT)
Received: from lingrow.int.hansenpartnership.com (unknown [9.211.83.181])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 28 Nov 2022 19:19:55 +0000 (GMT)
Message-ID: <f2e3c4dc0bfad6b05f40d716738e56f2cbb80810.camel@linux.ibm.com>
Subject: Re: [QUESTION]: Why did we clear the lowest bit of SCSI command's
 status in scsi_status_is_good
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Wenchao Hao <haowenchao22@gmail.com>
Cc:     Wenchao Hao <haowenchao@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, linfeilong@huawei.com,
        yanaijie@huawei.com, xuhujie@huawei.com, lijinlin3@huawei.com
Date:   Mon, 28 Nov 2022 13:12:39 -0500
In-Reply-To: <CAOptpSPfswNrmYe4rnKFM3zWXY7P0JuWY94p=mfp7tV9ghFQ2w@mail.gmail.com>
References: <6e9ea80e-d4e0-6d52-47c1-8939c13d60a8@huawei.com>
         <ca7e2aba5db5bd6e15182070f26e0c2c77c70927.camel@linux.ibm.com>
         <ada12c1d-b732-59a9-8dba-1662673b6a5d@huawei.com>
         <70f4d744d64bc075138128a7a98b7186375170d8.camel@linux.ibm.com>
         <CAOptpSPfswNrmYe4rnKFM3zWXY7P0JuWY94p=mfp7tV9ghFQ2w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: mYKYFql_RDbLEvK1KEMV5c7qLXDfdaJt
X-Proofpoint-GUID: Eqmz0ubOY8KCdzVR2qDibRl-0H3McAqf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-28_15,2022-11-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 clxscore=1015 suspectscore=0
 adultscore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211280132
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2022-11-29 at 01:38 +0800, Wenchao Hao wrote:
> On Mon, Nov 28, 2022 at 11:24 PM James Bottomley <jejb@linux.ibm.com>
> wrote:
> > 
> > On Mon, 2022-11-28 at 22:41 +0800, Wenchao Hao wrote:
> > > On 2022/11/28 20:52, James Bottomley wrote:
> > > > On Mon, 2022-11-28 at 11:58 +0800, Wenchao Hao wrote:
> > [...]
> > > > > We found some firmware or drivers would return status which
> > > > > did not defined in SAM. Now SCSI middle level do not have an
> > > > > uniform behavior for these undefined status. I want to change
> > > > > the logic to return error for all status which did not
> > > > > defined in SAM or define a method in host template to let
> > > > > drivers to judge what to do in this condition.
> > > > 
> > > > Why? The general rule of thumb is be strict in what you emit
> > > > and generous in what you receive (which is why reserved bits
> > > > are ignored). Is the drive you refer to above not working in
> > > > some way, in which case detail it so people can understand the
> > > > actual problem.
> > > > 
> > > > James
> > > > 
> > > > .
> > > 
> > > 
> > > We come with an issue with megaraid_sas driver. Where scsi_cmnd
> > > is completed with result's status byte set to 1,
> > 
> > Megaraid_sas is an emulation driver for the most part, so it sounds
> > like this is in the RAID emulation firmware, correct?  The driver
> > can correct for emulation failures, if you can figure out what it's
> > trying to signal and convert it to the correct SAM error code.
> > There's no need to change anything in the layers above.  If you
> > can't figure out the translation and you want the transfer to
> > error, then add DID_ERROR, which is a nice catch all.  If this is
> > transient and could be fixed by a retry, then do DID_SOFT_ERROR
> > instead.
> > 
> > James
> > 
> 
> Thanks for your answer, Of curse we can recognize these undefined
> status and map to an error which can be handled by SCSI middle level
> now. But I still confused why shouldn't we change the
> scsi_status_is_good() to respect to SAM?

Because it wouldn't be backwards compatible and something might break.
Under SCSI-1, devices were allowed to set this bit to signal vendor
unique status and a lot of manufacturers continued doing this for SCSI-
2, even though it was flagged as reserved instead of vendor specific in
that standard, hence the mask.  Since this was over 20 years ago, it is
possible there is no remaining functional device that does this, but if
it's not causing a problem, why take the risk?

James

