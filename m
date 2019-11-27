Return-Path: <SRS0=HsAm=ZT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 414ACC33C99
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 02:52:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 183CE20835
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 02:52:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AQiDMc9L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfK0CwZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Nov 2019 21:52:25 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:59522 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbfK0CwZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Nov 2019 21:52:25 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAR2iFqo039574;
        Wed, 27 Nov 2019 02:48:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=aIFj+6dOTDRVjCZTbcJq9ZupkGjcGMLz4CzfNB2ji3I=;
 b=AQiDMc9Lw2mdYzZ0Y7ZirsMjg7zxHMDaiAF8E/GuJMea6RakyKJOBo53ONPv0i1b76E/
 ONAw28fTdcgBoeq7tIto3PIe2RK91gOaCfcCJADaHuqTu3Wa0fgEn7Dcy6GX6+Q+5WzJ
 gff91NCTgh9oJCMGB/J4dCf0XQDHMgKb6xYlqkXf2AADIP+Dg5BUPmp1+KcYmiXPu5z5
 dk6K4VxGu/4f6rdv7Jz5qouH7nQoIa1sz/i3Yrm3WvYfxSbRcMZkbdRaHN3QGDDWxf4F
 1u33BnwR2GcZ5EXghIdt9O5zdXVD0h/9MqKkehOSB9f2lYSwBZaEpXhlyTn8viiIQi3K lg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2wev6uahfy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Nov 2019 02:48:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAR2iNuX176251;
        Wed, 27 Nov 2019 02:48:57 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2wh0rfj586-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Nov 2019 02:48:57 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAR2msqb001038;
        Wed, 27 Nov 2019 02:48:54 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 26 Nov 2019 18:48:53 -0800
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        lduncan@suse.com, cleech@redhat.com, jejb@linux.ibm.com,
        open-iscsi@googlegroups.com, kernel@collabora.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] iscsi: Don't send data to unbinded connection
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191116004735.16860-1-krisman@collabora.com>
        <yq136ekifn0.fsf@oracle.com> <85h82rvqza.fsf@collabora.com>
Date:   Tue, 26 Nov 2019 21:48:51 -0500
In-Reply-To: <85h82rvqza.fsf@collabora.com> (Gabriel Krisman Bertazi's message
        of "Mon, 25 Nov 2019 11:51:53 -0500")
Message-ID: <yq1d0de825o.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9453 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911270021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9453 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911270021
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Gabriel,

> Although, looks like the MAINTAINERS file doesn't list linux-scsi as
> the target for iscsi patches.  Would you take the fix below to address
> that?

Applied to 5.5/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
