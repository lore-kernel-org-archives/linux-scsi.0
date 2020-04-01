Return-Path: <SRS0=ctNG=5R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ABC5C43331
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Apr 2020 02:14:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B9D520675
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Apr 2020 02:14:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i/kpQdlG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731565AbgDACOW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 Mar 2020 22:14:22 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49824 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731531AbgDACOV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Mar 2020 22:14:21 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0312DYm5120087;
        Wed, 1 Apr 2020 02:14:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=WWG33d+3AVDVgX8bcK3U4yqp1mDhaJSgX6/i77qoGHQ=;
 b=i/kpQdlGJ8quAXay8ab7ry2crO0JoPo88I/5UucTOL8RdlXy7stvRmbbIt/eUVYTi4xS
 y/L3m6Ay1bhuELSYJ/kiaMRg4JCAEWki67Z6z8EXTskTiieNMeIHSJEZ2isa8A0ptFfP
 BVvKYijEo3qhFAe/g4xyBUWZHI51evBRq7v74SrgT2BCZpm0JQ3E64Coc3O0AWnq+pUw
 uHgEZfFfF1RxY5w882PUBuuQ4eXZdkVER2KiwEpJodmGz1nO3OVNdnSXlH/tpgJ6SXg6
 3jzVKGgllQ8FRfuqCgwBjQfdPmQMvkWZrdfVdCzr5/9w+vo1AtCI4zZTGUVW3LAkKIBE Ow== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 303yun5cj5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Apr 2020 02:14:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0312C2vn001381;
        Wed, 1 Apr 2020 02:14:10 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 302g9yg5p8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Apr 2020 02:14:10 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0312E45e030711;
        Wed, 1 Apr 2020 02:14:05 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Mar 2020 19:14:04 -0700
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] aacraid: do not overwrite retval in aac_reset_adapter()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200331084111.95039-1-hare@suse.de>
Date:   Tue, 31 Mar 2020 22:14:02 -0400
In-Reply-To: <20200331084111.95039-1-hare@suse.de> (Hannes Reinecke's message
        of "Tue, 31 Mar 2020 10:41:11 +0200")
Message-ID: <yq1zhbw54wl.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9577 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=805 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004010018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9577 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 mlxlogscore=881 bulkscore=0
 suspectscore=0 mlxscore=0 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004010018
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hannes,

> 'retval' got assigned a value twice, causing the original value to be
> lost.

Applied to 5.7/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
