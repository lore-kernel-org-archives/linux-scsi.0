Return-Path: <SRS0=mSyi=4B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1F6EC352A4
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 00:15:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86C3C206DB
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 00:15:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AUToGZgv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729119AbgBMAPb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Feb 2020 19:15:31 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45238 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727032AbgBMAPa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Feb 2020 19:15:30 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01D09YXl187442;
        Thu, 13 Feb 2020 00:15:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=0/wAiVs5rIqYMtN2Y8pQBb7RROimmiBeLoaZ/+BRUck=;
 b=AUToGZgv1vZodxK/jkK2tbS58OpWoQZp3Rbt50oMtwwrYte1WX24dw1JhUjj8835xRCs
 oxvyaSYimpxElp1GWgo0AdbB4dBa3vjbciGEHJqmAUZ/m+84i7nPCR7X5Nk2ZJedP6+J
 Tz4Wpisr3tN+tS/Nm29L2e6h6bkNsOsWOSI9vzs5Upxe4XnSi1krGDxdX7ROTaGnJr5o
 R1krdao+PuUPZLLCXLnv3q0/Q9XcnCbxIuxCNQWbkHJf9m4BiELmAmHZ4mpU2hqDEluC
 8ZARXHDSgd9GzhJ0R415/lTgFfUxTmtIys5S++My2BewEbAcnDXvtKSpEeIcfW2PajaJ +A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2y2p3sp6uw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 13 Feb 2020 00:15:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01D0786O086806;
        Thu, 13 Feb 2020 00:15:23 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2y4k331h8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Feb 2020 00:15:23 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01D0FKWH008703;
        Thu, 13 Feb 2020 00:15:21 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 12 Feb 2020 16:15:20 -0800
To:     Tomas Henzl <thenzl@redhat.com>
Cc:     linux-scsi@vger.kernel.org, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, lduncan@suse.com
Subject: Re: [PATCH V2] megaraid_sas: silence a warning
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200204152413.7107-1-thenzl@redhat.com>
Date:   Wed, 12 Feb 2020 19:15:18 -0500
In-Reply-To: <20200204152413.7107-1-thenzl@redhat.com> (Tomas Henzl's message
        of "Tue, 4 Feb 2020 16:24:13 +0100")
Message-ID: <yq1sgjfs5pl.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9529 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=766 adultscore=0
 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002120168
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9529 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=831 priorityscore=1501 clxscore=1011
 impostorscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002120168
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Tomas,

> Add a flag to dma mem allocation to silence a warning.

Applied to 5.6/scsi-fixes, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
