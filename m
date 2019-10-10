Return-Path: <SRS0=UT6l=YD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15E58ECE58D
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Oct 2019 03:40:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF48620B7C
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Oct 2019 03:40:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BefK9p8d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732858AbfJJDk5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Oct 2019 23:40:57 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41736 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726823AbfJJDkz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Oct 2019 23:40:55 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9A3URs3086893;
        Thu, 10 Oct 2019 03:40:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=rOzUSONeDV81oLc9GIPlFqdjJahMsRpOb2XTtkJaKQw=;
 b=BefK9p8dWi88hfb5QFn9qQGSODn6qphmInRJZ0dgMdv4Id1obcwn0qu9navgCcqppvuy
 aAR4G3aCNBiMQjuHRd1M+Lq7ANVw+kUxreIxqVyP9O6l+NF9ahYeVdAkgRZIToYGEhbM
 wV1sVqlpYwKZ8t5MgCiMVHEEjUdUEa6Iy+GcXA4SlK1/WoWI/Pj7BGsB5iOLDu7cjIwb
 CPzxDSk69AnH3LMIQj7TqxnpG9d71Y/n5xzvDjqSe6IhJdAGwRcOFy+jMv4U2mfoPheQ
 YqSPr06uDgi0MfbnpOanveXD+cglSKWE86yj2SbPR3hs65GexHYPpUimGXobuXxe/6Tz rA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2vek4qrchw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Oct 2019 03:40:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9A3TEMC141019;
        Thu, 10 Oct 2019 03:40:38 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2vhrxcp3fb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Oct 2019 03:40:38 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9A3eZsa029205;
        Thu, 10 Oct 2019 03:40:35 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Oct 2019 20:40:35 -0700
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Rob Turk <robtu@rtist.nl>, Hannes Reinecke <hare@suse.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH] ch: Make it again possible to open a ch device two or more times
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191009173536.247889-1-bvanassche@acm.org>
Date:   Wed, 09 Oct 2019 23:40:32 -0400
In-Reply-To: <20191009173536.247889-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Wed, 9 Oct 2019 10:35:36 -0700")
Message-ID: <yq1d0f5i7yn.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=770
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910100031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=873 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910100031
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> Clearing ch->device in ch_release() is wrong because that pointer must
> remain valid until ch_remove() is called. This patch fixes the
> following crash the second time a ch device is opened:

Applied to 5.4/scsi-fixes, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
