Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CFE8C2D0EC
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 02:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEB6B2074D
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 02:50:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="z3LeB4Ob"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbgC0Cuc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Mar 2020 22:50:32 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51992 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbgC0Cuc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2020 22:50:32 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02R2nuQ2110950;
        Fri, 27 Mar 2020 02:50:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=KXjmN+364jiyCzv1gWGc+e6yHZaiF4mXo9ppkls1CVs=;
 b=z3LeB4Obxsuu4+rII4Lhn6K8jr7JXn79EzVEMgPSUm+giNGJytfnmB2fr3o7E01swRTL
 e7MHHk2qY7c2r6mwfs+G04HhU4Umfy7BLhnmGcN3cmMI3HCTe6LIITwyhinavsyRx/SD
 WRkFqX1+GITU9AoSeKzCeoDKQAp74r3IdRgCZEmbFBxD8mSi0vKbcgHf8LWls5nU1cMN
 TXY4qs0XSwpy8WTJdmnlBMRoWqvbgF93JR4DXoM1YyMh0u2EjE6Hq1y6s8iEtGmCAas1
 vjwGDdgWOop03mopSLxU3x4mhNy/vvigCzqyoeShauSfDic3yHwsRo/W4BsgHHTDSxh7 6g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3014598qx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 02:50:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02R2nncF122492;
        Fri, 27 Mar 2020 02:50:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3003gn1ghw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 02:50:12 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02R2oAAL023461;
        Fri, 27 Mar 2020 02:50:11 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 26 Mar 2020 19:50:10 -0700
To:     "wubo \(T\)" <wubo40@huawei.com>
Cc:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi\@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "open-iscsi\@googlegroups.com" <open-iscsi@googlegroups.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linfeilong <linfeilong@huawei.com>,
        "liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: Re: [PATCH] scsi:libiscsi:Fix an error count for active session
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <EDBAAA0BBBA2AC4E9C8B6B81DEEE1D6916A28542@DGGEML525-MBS.china.huawei.com>
Date:   Thu, 26 Mar 2020 22:50:07 -0400
In-Reply-To: <EDBAAA0BBBA2AC4E9C8B6B81DEEE1D6916A28542@DGGEML525-MBS.china.huawei.com>
        (wubo's message of "Wed, 25 Mar 2020 06:53:25 +0000")
Message-ID: <yq1tv2acy00.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 adultscore=0 spamscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003270022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 adultscore=0 suspectscore=0 impostorscore=0 mlxscore=0 spamscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003270022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


wubo,

> Fix an error count for active session if the total_cmds is invalid on
> the function iscsi_session_setup().  decrement the number of active
> sessions before the func return.

Applied to 5.7/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
