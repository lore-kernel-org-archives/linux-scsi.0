Return-Path: <SRS0=mW7r=XC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B335C43331
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Sep 2019 19:30:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A3BA21835
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Sep 2019 19:30:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ojHeOzaG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404866AbfIGTaX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 7 Sep 2019 15:30:23 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55576 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391629AbfIGTaX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Sep 2019 15:30:23 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x87JSS7I121482;
        Sat, 7 Sep 2019 19:30:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=5xWOBkddbQXEcV/bKXHuWWqhc0SJIjKWDdj+79h7/RE=;
 b=ojHeOzaG5NVbCglLznXeDKdc5A08TnN+ZWGM1gJPG5Je9a8/A6etGAewk/l1ZougE246
 k0qo1cWQVXGiKYaJGppbRquHOAypfnD2ocDdETk5JD8iQLvB8jmTvYg85UD21f8noNXh
 3nROIYPFL1irrQ15X/2nfIfkREbrkCsyILXAtsaH+lxX4lOawORdGxyz2fDwFGb2QnDJ
 23Ru/AoZzc3mQ+7vYnesQe2hLU9UEbHOp+n9OrS6WlOdrwvItetJs1bQpRkQk0lhx+zA
 c5kH4f24KjH3/t3VDAP1WQwrAXx2k5+1CM0ZtgxDNv9mqWOuz2DdTJaoSv1rjYM9qGNC QQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2uvjqc006p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 07 Sep 2019 19:30:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x87JSaDe182707;
        Sat, 7 Sep 2019 19:30:20 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2uve9b62eu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 07 Sep 2019 19:30:19 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x87JUJlR015373;
        Sat, 7 Sep 2019 19:30:19 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 07 Sep 2019 12:30:18 -0700
To:     Govindarajulu Varadarajan <gvaradar@cisco.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.ibm.com, Satish Kharat <satishkh@cisco.com>
Subject: Re: [PATCH] scsi: fnic: fix msix interrupt allocation
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190827211340.1095-1-gvaradar@cisco.com>
Date:   Sat, 07 Sep 2019 15:30:16 -0400
In-Reply-To: <20190827211340.1095-1-gvaradar@cisco.com> (Govindarajulu
        Varadarajan's message of "Tue, 27 Aug 2019 14:13:40 -0700")
Message-ID: <yq136h7lx9z.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9373 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=859
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909070210
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9373 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=920 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909070211
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Govindarajulu,

> pci_alloc_irq_vectors() returns number of vectors allocated.
> Fix the check for error condition.

Applied to 5.4/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
