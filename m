Return-Path: <SRS0=Efrx=X2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AC7FC32793
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 03:36:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF91120842
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 03:36:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ahcjE+zs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbfJADgd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Sep 2019 23:36:33 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60788 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfJADgd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Sep 2019 23:36:33 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x913YisA149006;
        Tue, 1 Oct 2019 03:36:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=7kIF+U2fEr8Xor0GAijaSJqUd6owDJUXOVGRYo8n0Mc=;
 b=ahcjE+zsWGC07ap0DkOgNg4D6S07QOV8Oo14h7yUg4QoXxQBi7drM3EbjqjFCkj/+EAj
 N2WbU7e0DpSM0qm9x+BoYeh4UYfE6G0NNX8EBvJJq3fuKox9/mxoWOzHU3dUxckUygmk
 UgxXV3uPHXYQDVBg84eW2GEFoaqv3YEPgONrAQ5kiEIIS3OmtxCIBjWRfAoS32YiWpKg
 26w9FY4RsfNy25iR9luPNL10+h2LJY73xb9SMPBYOPtQ3EbA38zDdmfh3YDUk0E/9wGv
 N/7ZS/yJJILBQqP6GtyGU4oHxtoz07E9V3FT9tJTU9YSbG0aMNWfXkjz3kbyO5Lbi8qP uQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2v9xxuk042-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 03:36:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x913XsNb099032;
        Tue, 1 Oct 2019 03:36:19 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2vbsm14x1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 03:36:19 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x913aGoW024809;
        Tue, 1 Oct 2019 03:36:16 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Sep 2019 20:36:16 -0700
To:     Oliver Neukum <oneukum@suse.com>
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        stern@rowland.harvard.edu
Subject: Re: [PATCH] scsi: ignore a failure to synchronize cache due to lack of authorization
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190903101840.16483-1-oneukum@suse.com>
Date:   Mon, 30 Sep 2019 23:36:14 -0400
In-Reply-To: <20190903101840.16483-1-oneukum@suse.com> (Oliver Neukum's
        message of "Tue, 3 Sep 2019 12:18:39 +0200")
Message-ID: <yq1lfu5w30x.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=740
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910010034
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=827 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910010034
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Oliver,

> I've got a report about a UAS drive enclosure reporting back Sense:
> Logical unit access not authorized if the drive it holds is password
> protected. While the drive is obviously unusable in that state as a
> mass storage device, it still exists as a sd device and when the
> system is asked to perform a suspend of the drive, it will be sent a
> SYNCHRONIZE CACHE. If that fails due to password protection, the error
> must be ignored.  --- drivers/scsi/sd.c | 3 ++- 1 file changed, 2
> insertions(+), 1 deletion(-)

Applied to 5.4/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
