Return-Path: <SRS0=VRpU=44=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01008C10DCE
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 02:37:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C407920637
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 02:37:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hZHsc3ko"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727591AbgCKChD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 22:37:03 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39372 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727307AbgCKChD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Mar 2020 22:37:03 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02B2YVc1056160;
        Wed, 11 Mar 2020 02:37:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=c903uHK1692DnCut5vv87WJHOh9H5u//ELtM0NCRv4I=;
 b=hZHsc3koWJSFtwgASmmY3e+TTrlXqHSNdyC/vHXu7Fs9QymBzLzgQEX4HyGS6WE2JkHT
 fGQrT3VYkavb6H+Q6a3SOuJnuorqL2STdBkLjiC6xkbIWh8TwS7K8t9/STfgB7UV1tPb
 wgZAk7NXwvzRtlRNbKyoI5wm4Hs5oZgAo7ERP4VG63wzpdyBQhOIlsTfiOQEyUT8knm+
 pSzxhV1gcGcLhMdSlHhHGXOdPvBjAXCbie6atuWoVXZcOM0DLzFaBnYxDw3wJbXOJ703
 5/dGYVR7lUKKNh42RR92q3GrOUjl5bQ6t6nUvtY+zkmcU/1UXBgCEc4zcJZiYN9+R8u/ Sw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2ym31ugy1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Mar 2020 02:36:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02B2WZpe081614;
        Wed, 11 Mar 2020 02:34:59 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2yp8nxqv4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Mar 2020 02:34:59 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02B2YvL1026511;
        Wed, 11 Mar 2020 02:34:57 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Mar 2020 19:34:56 -0700
To:     wenxiong@linux.vnet.ibm.com
Cc:     linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com,
        martin.petersen@oracle.com, brking@linux.vnet.ibm.com,
        wenxiong@us.ibm.com
Subject: Re: [PATCH] ipr: Kernel panic - not syncing:softlockup when rescan devices in petitboot shell
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1583510248-23672-1-git-send-email-wenxiong@linux.vnet.ibm.com>
Date:   Tue, 10 Mar 2020 22:34:54 -0400
In-Reply-To: <1583510248-23672-1-git-send-email-wenxiong@linux.vnet.ibm.com>
        (wenxiong@linux.vnet.ibm.com's message of "Fri, 6 Mar 2020 09:57:28
        -0600")
Message-ID: <yq1sgifr54h.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 malwarescore=0 adultscore=0 suspectscore=1 mlxlogscore=970
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003110014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 suspectscore=1
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003110014
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Wen,

> When trying to rescan disks in petitboot shell, hitting the following
> softlockup stacktrace:

Applied to 5.6/scsi-fixes, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
