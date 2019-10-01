Return-Path: <SRS0=Efrx=X2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A65BFC352A9
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 03:09:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C0402087F
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 03:09:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qyq0maPk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728974AbfJADJE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Sep 2019 23:09:04 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55676 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727669AbfJADJE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Sep 2019 23:09:04 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9133nt2127679;
        Tue, 1 Oct 2019 03:08:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=FHv32y7bbTrsPVDrpok13O0EEpeIL+OjAw7lVYyy/1c=;
 b=qyq0maPklIGTS4Po/M2IpGQM/LFsNrLx3WwoniIO6kuh01Xk4vzsAuGiQLZ5rU5cJ84Q
 mu6xgw/mcjz5KJl5b33SgR7Eza73kSB+FNeCuPURJqdlMO7hSlqWq59WTZ+YgZ/w3FjH
 7U2ioQyBIakDgY5uGjq8LaxwL+aBoxJ/u5uqc94DkxBHzwGj2Cc3EzmoN3MaSAWFgzbq
 FPkNKF3pvfda4x79vkv6u9l1R5TjWshRWSuckxhJy1d1uphgrnzRyQhXi008xHOH6phB
 1MHAs/qFl83sS7tMA35tP7+ly3HU9TpVDHuu6ErdTOrvqyASxYg0kVQwkx5UYhuxF9bB ig== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2va05rjtwm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 03:08:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9138bu3132630;
        Tue, 1 Oct 2019 03:08:42 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2vbqd0211s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 03:08:42 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9137weq016042;
        Tue, 1 Oct 2019 03:07:58 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Sep 2019 20:07:57 -0700
To:     "Milan P. Gandhi" <mgandhi@redhat.com>
Cc:     bvanassche@acm.org, loberman@redhat.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Subject: Re: [PATCH v2] scsi: core: Log SCSI command age with errors
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190926052501.GA8352@machine1>
Date:   Mon, 30 Sep 2019 23:07:55 -0400
In-Reply-To: <20190926052501.GA8352@machine1> (Milan P. Gandhi's message of
        "Thu, 26 Sep 2019 10:55:02 +0530")
Message-ID: <yq1ftkdxiwk.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910010031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910010031
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Milan,

> Couple of users had requested to print the SCSI command age along with
> command failure errors. This is a small change, but allows users to
> get more important information about the command that was failed, it
> would help the users in debugging the command failures:

Applied to 5.5/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
