Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D46B5CA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 13:43:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A836E20663
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 13:43:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aH9LMwCi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392519AbfJRNnv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 09:43:51 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42750 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388989AbfJRNnv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Oct 2019 09:43:51 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9IDcx4K079781;
        Fri, 18 Oct 2019 13:43:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=S2//Nj9T/UUz33P0N+oc2pKk3MEIVLp6Jo3OifT2Ifc=;
 b=aH9LMwCiIUWCiZTpLhJBfvhXSdztcjRni7hju6lA6J0uo9XqRV6AAWqKeeVRozrKvinI
 P1XWwE7ShPVf1ggsyHwc3pbSfTPvmlE+1gkGZWwfABjWbahYqqB61nMHsIPYZxH7FBlq
 njboO3ZwtyT424KuU2G8ecgRupleeeFMY9587hRjdTV9fC3vq3hQXbGXT76Npu4FaVu3
 wiH/EAs+L3x124A2xjJVXZ03/WVNZTehqlOsf55Z0Mh7waxs+6ApbR+kMsFHI0DtHUoe
 fRPMKMMJT/Pty62oTRXHBSGPOhabNUHQdciMItPRhnltCqi8KZPMiWCunEwAZ8hx79wK +w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2vq0q43yhy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Oct 2019 13:43:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9IDc1qO076675;
        Fri, 18 Oct 2019 13:43:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2vq0dxv0yd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Oct 2019 13:43:39 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9IDhaIF008775;
        Fri, 18 Oct 2019 13:43:36 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Oct 2019 13:43:36 +0000
To:     Hannes Reinecke <hare@suse.de>
Cc:     zhengbin <zhengbin13@huawei.com>, bvanassche@acm.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, yi.zhang@huawei.com,
        yanaijie@huawei.com, Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v5 00/13] scsi: core: fix uninit-value access of variable sshdr
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1571387071-28853-1-git-send-email-zhengbin13@huawei.com>
        <f9c663fe-6359-fc7b-e9f5-cf173f6fafbe@suse.de>
Date:   Fri, 18 Oct 2019 09:43:33 -0400
In-Reply-To: <f9c663fe-6359-fc7b-e9f5-cf173f6fafbe@suse.de> (Hannes Reinecke's
        message of "Fri, 18 Oct 2019 11:41:30 +0200")
Message-ID: <yq1lftii2yi.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9413 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=552
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910180129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9413 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=631 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910180129
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hannes,

> The one thing which I patently don't like is the ambivalence between
> DRIVER_SENSE and scsi_sense_valid().  What shall we do if only _one_
> of them is set?  IE what would be the correct way of action if
> DRIVER_SENSE is not set, but we have a valid sense code?  Or the other
> way around?

I agree, it's a mess.

(Sorry, zhengbin, you opened a can of worms. This is some of our oldest
and most arcane code in SCSI)

> But more important, from a quick glance not all drivers set the
> DRIVER_SENSE bit; so for things like hpsa or smartpqi the sense code is
> never evaluated after this patchset.

And yet we appear to have several code paths where sense evaluation is
contingent on DRIVER_SENSE. So no matter what, behavior might
change if we enforce consistent semantics. *sigh*

> I _really_ would prefer to ditch the 'DRIVER_SENSE' bit, and rely on
> scsi_sense_valid() only.

I would really like to get rid of DRIVER_* completely. Except for
DRIVER_SENSE, few are actually in use:

DRIVER_OK: 	0
DRIVER_BUSY:	0
DRIVER_SOFT:	0
DRIVER_MEDIA:	0
DRIVER_ERROR:	6
DRIVER_INVALID:	4
DRIVER_TIMEOUT:	1
DRIVER_SENSE:	58

Johannes: Whatever happened to your efforts at cleaning all this up? Do
you have a patch series or a working tree we could use as starting
point?

-- 
Martin K. Petersen	Oracle Linux Engineering
