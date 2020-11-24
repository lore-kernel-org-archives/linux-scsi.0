Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BD73C6379D
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 03:48:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34E902085B
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 03:48:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hNnAokx5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbgKXDsh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 22:48:37 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:44032 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbgKXDsg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Nov 2020 22:48:36 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO3mY6B086696;
        Tue, 24 Nov 2020 03:48:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=9672tCTyQMoHgX1fdsPHITmY4JEKBQTQfLxvYDBVmug=;
 b=hNnAokx5eeIGEskgplkcQblCFGeLT/XqpZVsHFXgeYRXDGMkdNjVzPuCDGlaSaPv3SCG
 pnQoz8//4nvACX57M+0zXPqvSg/Pf37Fs0fAB0gIw078RSZ2o0Q5btQ+MNJ89rfu37bO
 ieBoP0wiR/ubfqfg1j8JIKcYy7wJlZz4WaB8TNGRX25eM57bo1epfBbagmITPhkbJ5Oy
 wzv2fDXZBnX6ow6pFNWP/aPWHSURGg+7Tp6BzswZAvaQ+s7/r0DLFxkYXgU1wIgLQiL2
 8rQCEZEKOKPUZMuI7m3X8kf89REmj0/tnMb2PuxIgNYY4izPareYzX0qxvISkxg9KlkS gw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 34xrdarkrq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 24 Nov 2020 03:48:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO3ited090825;
        Tue, 24 Nov 2020 03:48:31 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 34yctvts6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 03:48:31 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AO3mUEd005852;
        Tue, 24 Nov 2020 03:48:31 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Nov 2020 19:48:30 -0800
To:     Karan Tilak Kumar <kartilak@cisco.com>
Cc:     satishkh@cisco.com, sebaddel@cisco.com, arulponn@cisco.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fnic: Change shost_printk to FNIC_MAIN_DBG
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14klfmn3t.fsf@ca-mkp.ca.oracle.com>
References: <20201121013739.18701-1-kartilak@cisco.com>
Date:   Mon, 23 Nov 2020 22:48:28 -0500
In-Reply-To: <20201121013739.18701-1-kartilak@cisco.com> (Karan Tilak Kumar's
        message of "Fri, 20 Nov 2020 17:37:39 -0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=1
 malwarescore=0 spamscore=0 phishscore=0 mlxlogscore=999 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 adultscore=0 suspectscore=1 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240020
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Karan,

> Replacing shost_printk with FNIC_MAIN_DBG so that these log messages
> are controlled by fnic_log_level flag in fnic_handle_link.

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
