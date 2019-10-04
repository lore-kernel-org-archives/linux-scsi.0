Return-Path: <SRS0=tG2Y=X5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C156C10F14
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Oct 2019 01:58:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B0DD208E3
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Oct 2019 01:58:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EyKINnPG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730604AbfJDB62 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Oct 2019 21:58:28 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47570 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729252AbfJDB62 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Oct 2019 21:58:28 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x941shv3046504;
        Fri, 4 Oct 2019 01:57:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=6znlr5c1063Ew1PFbZJNSzq7ph/g2Rir9v8kLDPMgaQ=;
 b=EyKINnPGmWlnDzQJiDqZiNjo7X5F++QWW5fhbJvWLbWYxkREzu7WHeKU7lvvbEOC+Hzc
 yMXI3ODwroCje23KPqxeRMeUthckRD2Sp0rLh/hF2THJxS1Lj0RBa3JR2e3N5M760jO1
 0fNvp3aC4CY5nAj0QFEjkqMOiymoOGeXH6k6XM4qv5tjUwnIo6+LG+goepY4PDpG4WQ4
 oZ0uNu4wXWKnKWggxjgzIuu2wJCOQ4Lg3nyoTsNQFmntLH5ZnGLZGY0X7ZRba9lhGlsA
 bynv8SRug6mUbNjs9H9+h2D2EVTLPcv1CilOD8bt/iyA7cLd/Bd82U9TxJONlEz9I0zV 9A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2va05s82qt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Oct 2019 01:57:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x941r263118083;
        Fri, 4 Oct 2019 01:57:56 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2vdn18ky8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Oct 2019 01:57:56 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x941vsTJ020656;
        Fri, 4 Oct 2019 01:57:54 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Oct 2019 18:57:53 -0700
To:     Himanshu Madhani <hmadhani@marvell.com>
Cc:     Martin Wilck <Martin.Wilck@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        "linux-scsi\@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        Daniel Wagner <dwagner@suse.de>
Subject: Re: [PATCH v2] fixup "qla2xxx: Optimize NPIV tear down process"
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191002154126.30847-1-martin.wilck@suse.com>
Date:   Thu, 03 Oct 2019 21:57:51 -0400
In-Reply-To: <20191002154126.30847-1-martin.wilck@suse.com> (Martin Wilck's
        message of "Wed, 2 Oct 2019 15:41:56 +0000")
Message-ID: <yq1d0fds25c.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9399 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=617
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910040012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9399 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=699 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910040013
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> this patch fixes two issues in patch 02/14 in Himanshu's latest
> qla2xxx series ("qla2xxx: Bug fixes for the driver") from Sept. 12th,
> which you applied onto 5.4/scsi-fixes already.  See
> https://marc.info/?l=linux-scsi&m=156951704106671&w=2
>
> I'm assuming that Himanshu and Quinn are working on another
> series of fixes, in which case that should take precedence
> over this patch. I just wanted to provide this so that the
> already known problems are fixed in your tree.

Himanshu: Please review. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
