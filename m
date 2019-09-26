Return-Path: <SRS0=YGqw=XV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FC2CC4360C
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Sep 2019 22:52:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14D7D207FF
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Sep 2019 22:52:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kvLY2wYN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbfIZWwI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Sep 2019 18:52:08 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38810 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728564AbfIZWwH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Sep 2019 18:52:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8QMmqAE108680;
        Thu, 26 Sep 2019 22:51:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=D2CwgQsbiGCjO4mkdfUAM40E41fLHHYcnso3Cx++n8Q=;
 b=kvLY2wYNe0sibiKZEwHz9J3YqUTBY9dzOmvqeRC8wsZFyc04Pi5I+OohcKUhZeq7pbYe
 G4QQeWAjDiSWizTbyyca02Wwtajuq7FrSBbCukzNjHJisSJqffOhKxsZkaT75TceoL1i
 aCsIP3GjRSH7+deh2MbgBJN0eKV0YZbLnCEL9MLFx+fPDQcviZvix/focMz5WFCvfH+f
 YzcT81NWRz9PwiS2XvSnfGdr6eD15GY/OAoAuVrfq9rofFw87GPbsmp/TZtkDs/zIbgQ
 61gIKj/Ulv/orSjZDky3XkdrLlVeVD17iKvyXFJm+tWK53yfuQalUv2bThLRWjeNTAuU Pg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2v5cgrenn8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Sep 2019 22:51:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8QMm9hK142397;
        Thu, 26 Sep 2019 22:51:57 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2v8yjxpqnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Sep 2019 22:51:56 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8QMpsWI030809;
        Thu, 26 Sep 2019 22:51:54 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 26 Sep 2019 15:51:53 -0700
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Denis Efremov <efremov@linux.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Andrew Murray <andrew.murray@arm.com>,
        linux-scsi@vger.kernel.org, Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v3 18/26] scsi: pm80xx: Use PCI_STD_NUM_BARS
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190916204158.6889-1-efremov@linux.com>
        <20190916204158.6889-19-efremov@linux.com>
        <yq1wody4eml.fsf@oracle.com> <20190926022933.GB238374@google.com>
Date:   Thu, 26 Sep 2019 18:51:51 -0400
In-Reply-To: <20190926022933.GB238374@google.com> (Bjorn Helgaas's message of
        "Wed, 25 Sep 2019 21:29:33 -0500")
Message-ID: <yq1lfua1xiw.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9392 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=574
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909260180
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9392 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=656 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909260180
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bjorn,

> I think this depends on a previous patch that actually adds the
> PCI_STD_NUM_BARS definition.  It will probably be easier if I apply
> the whole series via the PCI tree.

Looks like my mail about this getting dropped due to the missing
definition got lost in transit. In any case, feel free to take this
through the PCI tree.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
