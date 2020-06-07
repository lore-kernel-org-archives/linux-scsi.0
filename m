Return-Path: <SRS0=iUlB=7U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 126E0C433DF
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Jun 2020 20:37:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCF482074B
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Jun 2020 20:37:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NDDVoIBb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbgFGUhl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Jun 2020 16:37:41 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60204 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726993AbgFGUhk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Jun 2020 16:37:40 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 057KXdsc078670;
        Sun, 7 Jun 2020 20:37:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=90kTUCK1qC+e98zuwmkqDaBLU53z4m/bKu+7xv7WMXA=;
 b=NDDVoIBbzN4SKLTwF0KdnGlz2P5vTk0umP200UsMWkPm7bSKGOCgBUQZhRrbwGCA7tZI
 VJzlOvmDugBpOM1OYwJlC4WOD5fxhzgL90lJDjB5F/aK7Jwqf0CQVF4VKs3SLBKxDDua
 dOMFrEZTs1bn3wJTAgoCBc6plPhrSqTsb18yQwCHTifj4kGsqcbK8Zi8AlQLpfEr0o3q
 AEftyR3umHS5qrdq5+W1Ra4w2lUDRCdhxBULwH4pR/mRvWfiZCWeIQxQG6hOg2mOl2nV
 nedG6BV3dPVUT0izdWq+BNLInRU5urkQRsVkgLS/+n7boM36hod1g3vvV2u9NIpL8M+Z Eg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 31g2jqv29v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 07 Jun 2020 20:37:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 057Kbd2M027961;
        Sun, 7 Jun 2020 20:37:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 31gn2u86mw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Jun 2020 20:37:39 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 057KbcLN024630;
        Sun, 7 Jun 2020 20:37:38 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 07 Jun 2020 13:37:38 -0700
Subject: Re: [PATCH v4 0/4] target: fix NULL pointer dereference
To:     Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>,
        martin.petersen@oracle.com, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     shirley.ma@oracle.com
References: <1591559913-8388-1-git-send-email-sudhakar.panneerselvam@oracle.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <c0aab764-c787-a888-2cce-ff94f8fab949@oracle.com>
Date:   Sun, 7 Jun 2020 15:37:40 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1591559913-8388-1-git-send-email-sudhakar.panneerselvam@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9645 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006070162
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9645 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 cotscore=-2147483648 priorityscore=1501 spamscore=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006070161
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 6/7/20 2:58 PM, Sudhakar Panneerselvam wrote:
> The following set of commits address a NULL pointer dereference and some
> refactoring around this issue.
> 
> v4:
>   - initialize the LUN in transport_init_se_cmd()
> 
> v3:
>   - fix NULL pointer dereference when cdb initialization fails
> 
> v2:
>   - new helper is named as target_cmd_init_cdb()
>   - existing function, target_setup_cmd_from_cdb is renamed as
>     target_cmd_parse_cdb()
> 
> Sudhakar Panneerselvam (4):
>    target: factor out a new helper, target_cmd_init_cdb()
>    target: initialize LUN in transport_init_se_cmd().
>    target: fix NULL pointer dereference
>    target: rename target_setup_cmd_from_cdb() to target_cmd_parse_cdb()
> 
>   drivers/target/iscsi/iscsi_target.c    | 29 ++++++++++--------
>   drivers/target/target_core_device.c    | 19 +++++-------
>   drivers/target/target_core_tmr.c       |  4 +--
>   drivers/target/target_core_transport.c | 55 ++++++++++++++++++++++++++--------
>   drivers/target/target_core_xcopy.c     |  9 ++++--
>   drivers/usb/gadget/function/f_tcm.c    |  6 ++--
>   include/target/target_core_fabric.h    |  9 +++---
>   7 files changed, 83 insertions(+), 48 deletions(-)
> 

Reviewed-by: Mike Christie <michael.christie@oracle.com>
