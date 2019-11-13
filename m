Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CFF2C43331
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 01:38:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7294222D0
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 01:38:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gHFWHkKm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727338AbfKMBiy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 20:38:54 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:38452 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727041AbfKMBix (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2019 20:38:53 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAD1YNRM001889;
        Wed, 13 Nov 2019 01:37:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=nBEVt/y9CIbMxIiZwK0x8Vgf1UghyXUE7rZHgMKFOkI=;
 b=gHFWHkKmteGiPHt8Q2AnfXoA/gc79ee+q2VElCvQBq2gz2vqpEv72tZyhzpwOsLKx+Pz
 8Xq4hNrXWTQiYDzHVm5TEd/mcNETQyvup3T2v7BFiLbjVDpdJFdGGnD6njWQ+9Z1uFto
 9v8UFv8vhSNzJI/ByC5+l5Tp9u4Y68yFdppMngOFTDqbnZpEPzBA3A21zJmmBWoRCt0f
 mgc+2SaU58k4Yoa0QzkE7BC+yx7hQi9jiC7r5t4Ywnf09gp+UBcuaacd1GvPpLqfeq6W
 PpabvpZeaiNuQRfsArkzxa0bSonp7QeF6AvbhaJpXEtEEu0YPBwuLfiBK9Wh2ZwhiCUo mg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2w5p3qrpjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 01:37:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAD1YJqY091498;
        Wed, 13 Nov 2019 01:37:16 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2w7khmdhh3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 01:37:16 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAD1b9IQ007575;
        Wed, 13 Nov 2019 01:37:09 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 13 Nov 2019 01:37:08 +0000
To:     "wubo \(T\)" <wubo40@huawei.com>
Cc:     "lduncan\@suse.com" <lduncan@suse.com>,
        "cleech\@redhat.com" <cleech@redhat.com>,
        "jejb\@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen\@oracle.com" <martin.petersen@oracle.com>,
        "open-iscsi\@googlegroups.com" <open-iscsi@googlegroups.com>,
        "linux-scsi\@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>,
        Mingfangsen <mingfangsen@huawei.com>,
        "liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: Re: [PATCH v3] scsi: avoid potential deadloop in iscsi_if_rx func
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <EDBAAA0BBBA2AC4E9C8B6B81DEEE1D6915DFB0ED@dggeml505-mbs.china.huawei.com>
Date:   Tue, 12 Nov 2019 20:37:05 -0500
In-Reply-To: <EDBAAA0BBBA2AC4E9C8B6B81DEEE1D6915DFB0ED@dggeml505-mbs.china.huawei.com>
        (wubo's message of "Thu, 31 Oct 2019 06:17:01 +0000")
Message-ID: <yq18soksgji.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=957
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911130008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911130008
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> In iscsi_if_rx func, after receiving one request through
> iscsi_if_recv_msg func, iscsi_if_send_reply will be called to try to
> reply the request in do-loop. If the return of iscsi_if_send_reply
> func return -EAGAIN all the time, one deadloop will occur.
>  
> For example, a client only send msg without calling recvmsg func, 
> then it will result in the watchdog soft lockup. 
> The details are given as follows,

Lee/Chris/Ulrich: Please review!

-- 
Martin K. Petersen	Oracle Linux Engineering
