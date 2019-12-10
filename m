Return-Path: <SRS0=c8H+=2A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 989B5C43603
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 01:40:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FEE72073D
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 01:40:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h12ow5T7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfLJBkT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Dec 2019 20:40:19 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:38626 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726538AbfLJBkT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2019 20:40:19 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBA1YOVS103590;
        Tue, 10 Dec 2019 01:39:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=oyUzKzdeM0sxcJ7Rn8NSTTlnn7CO7NRM2Vib/efPBPs=;
 b=h12ow5T7teHpqRI6Npdj7UzbVXmJKU77i1ypMi9Q13tfEXzCbqI/8nxxi6U+KvUVY7tg
 5u974DQR736kYxbORtmpntRzpITG2VW8T/xIATmTkLpECXRahq8fsSqlj6NDa9GNnL+z
 QOcm4B4pBSCTDN4QRl3JSzDcdj1LZPRgJuthK/7FF38rAaPzY2D4x/mzkpEirmOuVL7Z
 Ik+fMuiUOkm8A5SfjeL50aQctQmBliPGjCUEq3AjC5pDRwI4SpjB7GVtM29M65dLrAl9
 suwIc07TDWl91LASdYvApd275xT6bt1yJgwmosLvJUPIh/pmn0jLRAEAxuPd0TQgG/7Y rA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2wrw4myy6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Dec 2019 01:39:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBA1cvni170721;
        Tue, 10 Dec 2019 01:39:55 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2wsv8awr0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Dec 2019 01:39:55 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBA1dqKd019213;
        Tue, 10 Dec 2019 01:39:52 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 09 Dec 2019 17:39:51 -0800
To:     Lee Duncan <LDuncan@suse.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "wubo \(T\)" <wubo40@huawei.com>,
        "cleech\@redhat.com" <cleech@redhat.com>,
        "jejb\@linux.ibm.com" <jejb@linux.ibm.com>,
        "open-iscsi\@googlegroups.com" <open-iscsi@googlegroups.com>,
        "linux-scsi\@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>,
        Mingfangsen <mingfangsen@huawei.com>,
        "liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: Re: [PATCH V4] scsi: avoid potential deadlock in iscsi_if_rx func
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <EDBAAA0BBBA2AC4E9C8B6B81DEEE1D6915E3D4D2@dggeml505-mbx.china.huawei.com>
        <yq1o8whqem3.fsf@oracle.com>
        <ccda52ac-2ea7-b0d2-e36e-08f162569c7c@suse.com>
Date:   Mon, 09 Dec 2019 20:39:49 -0500
In-Reply-To: <ccda52ac-2ea7-b0d2-e36e-08f162569c7c@suse.com> (Lee Duncan's
        message of "Tue, 10 Dec 2019 00:40:59 +0000")
Message-ID: <yq18snlnel6.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9466 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=797
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912100013
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9466 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=860 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912100013
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Lee,

> My sincere apologies. I told wubo I had already reviewed the patch, so
> he didn't need another Reviewed-by from me. I see I was wrong.

OK.

The patch was all mangled so I had to apply the changes by hand. Can't
say that I'm a big fan of retries going negative but I guess that's just
personal taste.

Applied to 5.5/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
