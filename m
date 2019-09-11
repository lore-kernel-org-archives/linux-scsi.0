Return-Path: <SRS0=uqxd=XG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E41E4C49ED9
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Sep 2019 02:14:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB6E3208E4
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Sep 2019 02:14:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Js7LEog6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbfIKCOw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Sep 2019 22:14:52 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51262 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbfIKCOv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Sep 2019 22:14:51 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8B2EMOe182060;
        Wed, 11 Sep 2019 02:14:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=tYlswYMGfc9rDFq0KLhl5hLmx6KYuv+guMDS5/fpoEM=;
 b=Js7LEog6OC6M0+Kt81FP53drVJPYFhEbEt1MjWP2AC4EIj/6hLxavD/qeZDeZaY1uAvE
 pg+bF0Yi1KEnm/Z1fs4PtIglkdLmTkNmZBVIWA/I8LBcW1KF6OnKDxSP267bDVczZSfY
 Dde4aVbD0BHlmXBPXnGh5IBHrt1h2rChQZIQfFdYc59hTGAPJLYVUqiMp02kYDa5byTx
 tLYgEBAWPQUC2EGvFvBC2eSb5b3wdwLPHUdy9Ksuqr4tLeudZxDD5trYiNiniCZ5AAyG
 8WfBK9v90pVF0xBWuVPhTXz4Eh2i3qmx4SEL8tbHgLJ5FtTNJubs1a69KUpzsf/P9aYe 5A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2uw1m8xyrf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Sep 2019 02:14:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8B2DY7L114730;
        Wed, 11 Sep 2019 02:14:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2uxj3hw7yt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Sep 2019 02:14:18 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8B2EF4i026967;
        Wed, 11 Sep 2019 02:14:15 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Sep 2019 19:14:15 -0700
To:     Matt Lupfer <mlupfer@ddn.com>
Cc:     "mst\@redhat.com" <mst@redhat.com>,
        "jasowang\@redhat.com" <jasowang@redhat.com>,
        "pbonzini\@redhat.com" <pbonzini@redhat.com>,
        "stefanha\@redhat.com" <stefanha@redhat.com>,
        "jejb\@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen\@oracle.com" <martin.petersen@oracle.com>,
        "virtualization\@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-scsi\@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] scsi: virtio_scsi: unplug LUNs when events missed
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190905181903.29756-1-mlupfer@ddn.com>
Date:   Tue, 10 Sep 2019 22:14:12 -0400
In-Reply-To: <20190905181903.29756-1-mlupfer@ddn.com> (Matt Lupfer's message
        of "Thu, 5 Sep 2019 18:19:28 +0000")
Message-ID: <yq17e6ffukr.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9376 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=997
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909110016
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9376 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909110016
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Matt,

> The event handler calls scsi_scan_host() when events are missed, which
> will hotplug new LUNs.  However, this function won't remove any
> unplugged LUNs.  The result is that hotunplug doesn't work properly
> when the number of unplugged LUNs exceeds the event queue size
> (currently 8).
>
> Scan existing LUNs when events are missed to check if they are still
> present.  If not, remove them.

Applied to 5.4/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
