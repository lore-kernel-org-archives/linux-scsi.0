Return-Path: <SRS0=9eMh=27=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 172CCC33C99
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jan 2020 06:42:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB5E520721
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jan 2020 06:42:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eQPSkAEj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731620AbgAJGmK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jan 2020 01:42:10 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:54090 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731595AbgAJGmK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jan 2020 01:42:10 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00A6bqrk094593;
        Fri, 10 Jan 2020 06:41:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=fejLZAhYlyJuuGbtnbYtOxqJiKAeS4PwEC4ERPNULXY=;
 b=eQPSkAEjU8DLdRxCNTRj6ttxqf+/EroYWd4Iqi9qGOTSD5aQDp0LmXfeWg35GbZrAU/n
 RXxF66Wjon3CwFSd85+PKVo/XaSb/KYhMXBSe9MagE0z3RY4O3MhbTu+ZGWLiyuiWaFv
 1WlJIY1/nQ6kYUlGheQ1NW2rRlg2dbjXT5PpF9Z8bRJ7M73CM0N50SwA05erHpu+TIzy
 /3hYWBDB7ogovit6XV8Ksno0MAm53aFqE3KlwqfYS1Du6FCJW/RpThQi23exaKCGzBbx
 gmAqR5Lp8510eKDfUly/pthJX0PqkhIxC+o4pjEeF9ndDv0QM6YZqNmDFfb6nIR91hJA kQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xakbr7xrs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jan 2020 06:41:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00A6d7fl130567;
        Fri, 10 Jan 2020 06:39:58 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2xeh9023uf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jan 2020 06:39:58 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00A6dviF019564;
        Fri, 10 Jan 2020 06:39:57 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 Jan 2020 22:39:57 -0800
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        Luo Jiaxing <luojiaxing@huawei.com>,
        John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] enclosure: Fix stale device oops with hot replug
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1578532892.3852.10.camel@HansenPartnership.com>
Date:   Fri, 10 Jan 2020 01:39:55 -0500
In-Reply-To: <1578532892.3852.10.camel@HansenPartnership.com> (James
        Bottomley's message of "Wed, 08 Jan 2020 17:21:32 -0800")
Message-ID: <yq1pnfrvmpw.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9495 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=851
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001100055
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9495 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=911 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001100055
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> Doing an add/remove/add on a SCSI device in an enclosure leads to an
> oops caused by poisoned values in the enclosure device list pointers.
> The reason is because we are keeping the enclosure device across the
> enclosed device add/remove/add but the current code is doing a
> device_add/device_del/device_add on it.  This is the wrong thing to do
> in sysfs, so fix it by not doing a device_del on the enclosure device
> simply because of a hot remove of the drive in the slot.

Applied to 5.5/scsi-fixes...

> Fixes: 43d8eb9cfd0a ("[SCSI] ses: add support for enclosure component hot removal")
> Reported-by: Luo Jiaxing 
> Tested-by: John Garry 
> Signed-off-by: James Bottomley 

...and filled out the blanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
