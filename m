Return-Path: <SRS0=kvmt=4R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0923C3F2D4
	for <linux-scsi@archiver.kernel.org>; Sat, 29 Feb 2020 05:31:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6823D246AF
	for <linux-scsi@archiver.kernel.org>; Sat, 29 Feb 2020 05:31:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VIvqEfRs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725817AbgB2Fb2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 29 Feb 2020 00:31:28 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:54358 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgB2Fb2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Feb 2020 00:31:28 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01T5MoK3111936;
        Sat, 29 Feb 2020 05:31:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=AtspBA7ejZrwML6xNPXF3e0QcDG5Lp35lGbKilAuNTE=;
 b=VIvqEfRs+yGhabmxLx2Mr5bbc4NeFrzM5xhiuh5ZlICbvgRkef+BQy+iwUvtpBEcb5ON
 I6qAYKsWnVrODb3cfZLW+6rGYOAewxykwcIgKajq4/AuH8X1J6Hr/e0bIR2naSAQj0bA
 hhutLmpP+4MxSkmZB9CZpJqjlaTPZw47kCIaf4GgUiA3u7npxqUhKVd5Tbh+Ajb/P7ru
 2FB1W1xyVtE11usIVNPjBF1BfTlD0gChtjMuAdNoMPkBpQiAzcUnvyD3LAy7bOkPncvG
 cNYI8Y+8WgZZsEG4vauBAwQNvS619wdN3JivEzVP08WFtkF9jgdnz8hWLloMBnLOyu8I Ww== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2yfgkr83kh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 29 Feb 2020 05:31:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01T5SCOC164011;
        Sat, 29 Feb 2020 05:31:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2yff9nh5ac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 29 Feb 2020 05:31:10 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01T5V7xY031146;
        Sat, 29 Feb 2020 05:31:07 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 21:31:07 -0800
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
Cc:     lduncan@suse.com, cleech@redhat.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org, Frank Mayhar <fmayhar@google.com>,
        kernel@collabora.com, Khazhismel Kumykov <khazhy@google.com>
Subject: Re: [PATCH RESEND v2] iscsi: Add support for asynchronous iSCSI session destruction
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200227195945.761719-1-krisman@collabora.com>
Date:   Sat, 29 Feb 2020 00:31:04 -0500
In-Reply-To: <20200227195945.761719-1-krisman@collabora.com> (Gabriel Krisman
        Bertazi's message of "Thu, 27 Feb 2020 14:59:45 -0500")
Message-ID: <yq1o8ti3qp3.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002290038
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 malwarescore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 clxscore=1011 bulkscore=0
 adultscore=0 lowpriorityscore=0 phishscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002290037
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Gabriel,

> iSCSI session destruction can be arbitrarily slow, since it might
> require network operations and serialization inside the scsi layer.
> This patch adds a new user event to trigger the destruction work
> asynchronously, releasing the rx_queue_mutex as soon as the operation
> is queued and before it is performed.  This change allow other
> operations to run in other sessions in the meantime, removing one of
> the major iSCSI bottlenecks for us.

Applied to 5.7/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
