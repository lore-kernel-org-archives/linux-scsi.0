Return-Path: <SRS0=h99Q=3K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67697C33CAA
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jan 2020 04:56:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 385B024654
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jan 2020 04:56:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kUUGFDCy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbgAUEz7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jan 2020 23:55:59 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41940 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728205AbgAUEz7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jan 2020 23:55:59 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00L4r250104829;
        Tue, 21 Jan 2020 04:55:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=Vc3oE3vQ2WH4R4B1INT6g36OXPMJ6PRHybcAtiQncWM=;
 b=kUUGFDCy86XwjkkLEJByNWr6capdUbOjYRmC1Vf9XOKZTBEwRNCA8vQ0HUJMLIrpjOL5
 k1Gsa1TkNuBvXUHQs1O1jBy/1rf8yYCGFknHxaBdJ11JFjIK8uqawYUUpslC/12BHo+w
 m6m0mfitZOzIvyzIkomMduszKj3zazajV/TgwmG9+NSA+oDEUUMOAD34czR/fF1Q9pF3
 H5wnv9CheeVA96RvrFh+/kD+OzwbBFDa2jTiZ7BJ/BzCJOM9pjDd1YeuEu+7rQNuwhfX
 +g4gOGivK1k0WBoxYmzsO9EzQBO6SbWjsLW0Mi6P634GdvsB4PRWqnZOS71rDRWd1DI2 0w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2xkseuam9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 04:55:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00L4s8M1025852;
        Tue, 21 Jan 2020 04:55:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2xnsj3tq6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 04:55:51 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00L4toug028009;
        Tue, 21 Jan 2020 04:55:50 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jan 2020 20:55:49 -0800
To:     Sumit Saxena <sumit.saxena@broadcom.com>
Cc:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] megaraid_sas: fixup MSIx interrupt setup during resume
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200113132609.69536-1-hare@suse.de>
Date:   Mon, 20 Jan 2020 23:55:47 -0500
In-Reply-To: <20200113132609.69536-1-hare@suse.de> (Hannes Reinecke's message
        of "Mon, 13 Jan 2020 14:26:09 +0100")
Message-ID: <yq1tv4pif1o.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9506 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=869
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001210042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9506 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=947 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001210042
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sumit,

> Streamline resume workflow by using the same functions for enabling
> MSIx interrupts as used during initialisation.
> Without it the driver might crash during resume with:
>
> WARNING: CPU: 2 PID: 4306 at ../drivers/pci/msi.c:1303 pci_irq_get_affinity+0x3b/0x90

Please review!

-- 
Martin K. Petersen	Oracle Linux Engineering
