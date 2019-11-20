Return-Path: <SRS0=SaCo=ZM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE66EC432C0
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 03:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 804AC22460
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 03:12:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qdgEQWPD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbfKTDMY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Nov 2019 22:12:24 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49492 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbfKTDMX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Nov 2019 22:12:23 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAK39AwY027323;
        Wed, 20 Nov 2019 03:12:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=n47TzMhl0hfJXbdIGb/00aMwEHTOnvoFX2Zlt6geQkI=;
 b=qdgEQWPDV8wV25nm4ghKMXs6uIgxwuAg7hlMOVhwqnr+hqtvj2kCZNVyM10bNVIXLNvz
 BWGZlw06+WQpJWEzYjecloQaPifuJkr1GiHS1ee8WNBQdsgjsXtUaVTSUBiSSfsQbjXW
 FoVQpW8/syqLMfQGcHdoMUFVnWwTjKMGhPJ/j3sj/UwkHXwWBCIjkQkisTkbanPCpADk
 H7EgpW0ixvFDxLgPtmH4mHrNLcK1FJLahV1cREpEzJ9UrjUFMG5g+K2mjO4M1bMI2oPv
 apdLF+O7RvlLJBAepxpYEsI2Dj0X025WUWYtpyYCCOE/YvYm1CosBL7KTig9gyEiRZT4 HQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2wa8httve3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 03:12:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAK38fHU181642;
        Wed, 20 Nov 2019 03:10:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2wc09yfuhw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 03:10:13 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAK3A9Ce004919;
        Wed, 20 Nov 2019 03:10:12 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Nov 2019 19:10:09 -0800
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart van Assche <bvanassche@acm.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCHv3 00/52] Revamp SCSI result values
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191104090151.129140-1-hare@suse.de>
        <5fa00739-0f30-56fa-426e-1847457cc1dd@suse.de>
        <yq18socles3.fsf@oracle.com>
        <2d039a2d-d5c2-eb6c-b75a-ad1a662c5b9a@suse.de>
Date:   Tue, 19 Nov 2019 22:10:07 -0500
In-Reply-To: <2d039a2d-d5c2-eb6c-b75a-ad1a662c5b9a@suse.de> (Hannes Reinecke's
        message of "Tue, 19 Nov 2019 08:10:47 +0100")
Message-ID: <yq1h82zfdkg.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9446 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=747
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911200028
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9446 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=835 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911200028
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hannes,

> Should I do a respin for 5.5?

I suggest you rebase on top of -rc1 once it's out. If you want a bit
more eyes on the series before then, just post on top of current
scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
