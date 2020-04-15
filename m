Return-Path: <SRS0=9vL1=57=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 695A8C2BB1D
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 01:31:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 455F920737
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 01:31:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tO0zc/36"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392635AbgDOBbf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Apr 2020 21:31:35 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57964 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392620AbgDOBbd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Apr 2020 21:31:33 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03F1Nvq9062151;
        Wed, 15 Apr 2020 01:31:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=XdGmfI7njgbjgJRL04G8M2EAf5wGcoT2icyEu9Ynwo4=;
 b=tO0zc/36un74P7fSl70jZiAwiotmjwjXg4HvJdXGimH61q9P6ewHg8ulCnxFseIOfMsy
 vmR3vJ1RzdMRblxaMyjfO7DZe59mZi+ah10szx/971cDLevCVacBJTNBEt2fF7wkGkjW
 aK7mteYJRhj70QaMOjS2VJ2ZcbADBG03ZjT9WnD+z57ppdOZsPgg8gHWTVACZGbWr6rn
 nz6eiTF0QIMOzUy0bGWAunmeSpAVk6xWeHbcWkGaeexqytHrV+TfNH80G8O7MNI+9E2v
 B8XvvRo2IkEPfuc/K51+2ykl1JvOEfMBKiCBqoHznDpfQk4y6Hh4egvdsw8RTHbDBrPh yQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30dn9t8k1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Apr 2020 01:31:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03F1S0ai185857;
        Wed, 15 Apr 2020 01:31:20 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30dn9a0xgt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Apr 2020 01:31:20 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03F1VHvl017125;
        Wed, 15 Apr 2020 01:31:17 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Apr 2020 18:31:17 -0700
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH] qla2xxx: Use ARRAY_SIZE() instead of open-coding it
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200413021359.21725-1-bvanassche@acm.org>
Date:   Tue, 14 Apr 2020 21:31:14 -0400
In-Reply-To: <20200413021359.21725-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Sun, 12 Apr 2020 19:13:59 -0700")
Message-ID: <yq1lfmxr0v1.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9591 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=952 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004150007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9591 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 phishscore=0 adultscore=0 spamscore=0 impostorscore=0 mlxscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004150006
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> This patch does not change any functionality.

Applied to 5.8/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
