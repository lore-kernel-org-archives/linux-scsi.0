Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B970C55181
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 03:45:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 388C120747
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 03:45:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KQPhED0T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgDVDpX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 23:45:23 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50438 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbgDVDpX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2020 23:45:23 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M3huv4118421;
        Wed, 22 Apr 2020 03:45:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=mLgnlQplhq2XV43NF0tRQ/qHr3g2MI1dyzlJt0Z02dM=;
 b=KQPhED0Ti6Qylcb8yTYFnYZieQijukojqiqEO/TTuN2gVtH1fAiZYOr7smA2gt61tKsn
 wJWHeWGd9b1fkTgylcG68JMsASYXOrqR1b8fk15zmnqaWPOq7RQGRhDNl+hBGDSzBjNb
 rw8PEVC6JajezJ+VTs+vMpaF4HGhR6PX9P5I+zXIpgco0osfQofpVXmEmpemor6/dNTq
 zfDvgeIRnrrEPYQo/om7cXk/G7wNT1ZmnTKenOCnbgPsvyzVrBm0HSM48ntCDLjlPCP9
 up0dsonhzfHs/Bpbd3syX9vPvFNrDoOGWJa8CdTwcLxRvgFR24iksC4Y6uJRm28+9Vnf 1g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 30grpgmrhc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Apr 2020 03:45:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M3faX3096490;
        Wed, 22 Apr 2020 03:45:04 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 30gb3t76xw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Apr 2020 03:45:04 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03M3j26i023490;
        Wed, 22 Apr 2020 03:45:02 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Apr 2020 20:45:02 -0700
To:     Dexuan Cui <decui@microsoft.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@lst.de, bvanassche@acm.org, hare@suse.de,
        mikelley@microsoft.com, longli@microsoft.com, ming.lei@redhat.com
Subject: Re: [PATCH] scsi: core: Allow the state change from SDEV_QUIESCE to SDEV_BLOCK
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1587170445-50013-1-git-send-email-decui@microsoft.com>
Date:   Tue, 21 Apr 2020 23:44:57 -0400
In-Reply-To: <1587170445-50013-1-git-send-email-decui@microsoft.com> (Dexuan
        Cui's message of "Fri, 17 Apr 2020 17:40:45 -0700")
Message-ID: <yq1lfmoi3pi.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004220028
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 bulkscore=0 clxscore=1011
 malwarescore=0 phishscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004220028
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dexuan,

> However, from reading the code, I think the APIs don't really work for
> aacraid, because, in the resume path of hibernation, when
> aac_suspend() -> scsi_host_block() is called, scsi_device_quiesce()
> has set the state to SDEV_QUIESCE, so aac_suspend() ->
> scsi_host_block() returns -EINVAL.
>
> Fix the issue by allowing the state change.

Applied to 5.7/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
