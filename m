Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3CB5C5519F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 03:32:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAE5322256
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 03:32:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cDMyQFau"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgKTDcA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Nov 2020 22:32:00 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35074 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726117AbgKTDb7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Nov 2020 22:31:59 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AK3P93c096209;
        Fri, 20 Nov 2020 03:31:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=HOktsKXowXKgE5Rdo7Jz7/6bE4/H8eDV16MFF9zC9wI=;
 b=cDMyQFaukTJfGEW794XQZ/CrArXGzINYCUSTMZ89E3n7yGOvfA7QGa8eq+ouf2j7PKRS
 bT2G8v6LRMME3YeOU3kHRYJmj9G1tFTPe3PtIpJ90uIQcUgNVP2KHtATrnQsbqF+kY0h
 HG2Nnp1hN0lq7Mwy/fgx2utnzanNovluJElzFTJGj/BNPYq79VIIy0HEe5rrnePe3gZO
 iS+li20OeRk3URGvKsEGHurvQWTVURHaDK6daF4IV9vxpWq714AY52A3gUHnSIGwdl/g
 93N7IOItnha/eYRDB89/iFo6lwfzdveXpimZUvW5z+x8Vkq9a85lc+PlHLCyKQsDJiHM Sw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 34t76m8qxr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 20 Nov 2020 03:31:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AK3PPMn032584;
        Fri, 20 Nov 2020 03:31:52 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34umd2w0u6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 03:31:51 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AK3Vn6B017500;
        Fri, 20 Nov 2020 03:31:49 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Nov 2020 19:31:49 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Hannes Reinecke <hare@suse.de>, "mwilck@suse.com" <mwilck@suse.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/2] scsi: scsi_vpd_lun_id(): fix designator priorities
Date:   Thu, 19 Nov 2020 22:31:42 -0500
Message-Id: <160584262847.7157.1062685450059754796.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201029170846.14786-1-mwilck@suse.com>
References: <20201029170846.14786-1-mwilck@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011200023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011200023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 29 Oct 2020 18:08:45 +0100, mwilck@suse.com wrote:

> The current implementation of scsi_vpd_lun_id() uses the designator
> length as an implicit measure of priority. This works most of the
> time, but not always. For example, some Hitachi storage arrays return
> this in VPD 0x83:
> 
> VPD INQUIRY: Device Identification page
>   Designation descriptor number 1, descriptor length: 24
>     designator_type: T10 vendor identification,  code_set: ASCII
>     associated with the Addressed logical unit
>       vendor id: HITACHI
>       vendor specific: 5030C3502025
>   Designation descriptor number 2, descriptor length: 6
>     designator_type: vendor specific [0x0],  code_set: Binary
>     associated with the Target port
>       vendor specific: 08 03
>   Designation descriptor number 3, descriptor length: 20
>     designator_type: NAA,  code_set: Binary
>     associated with the Addressed logical unit
>       NAA 6, IEEE Company_id: 0x60e8
>       Vendor Specific Identifier: 0x7c35000
>       Vendor Specific Identifier Extension: 0x30c35000002025
>       [0x60060e8007c350000030c35000002025]
> 
> [...]

Applied to 5.11/scsi-queue, thanks!

[1/2] scsi: core: Fix VPD LUN ID designator priorities
      https://git.kernel.org/mkp/scsi/c/2e4209b3806c
[2/2] scsi: core: Replace while-loop by for-loop in scsi_vpd_lun_id()
      https://git.kernel.org/mkp/scsi/c/16d6317ea438

-- 
Martin K. Petersen	Oracle Linux Engineering
