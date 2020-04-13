Return-Path: <SRS0=9ymf=55=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB380C2BA2B
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 22:53:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B23E220735
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 22:53:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qmGXlyVJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389787AbgDMWxK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Apr 2020 18:53:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50204 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389783AbgDMWxJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Apr 2020 18:53:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03DMnGiI035580;
        Mon, 13 Apr 2020 22:53:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=uVtIGo5y3HkvM3QDU95CDGeeaxMg/IJpSYVUmagqn/0=;
 b=qmGXlyVJB8bW+sPB1d5L93KkEAs2oWj6L3h65yuph+550AAMGo+oLk/AIos3ZSf8D/WA
 bxSdZi8S7BAIajF2SIK/zdlpLXZQh0kckpPq1vhhjxAWMm64zI+LxgEN5u3Nkws9pVcG
 E1G+Rcd/Qd8FaESZbkVEL6HLMvD/+SCIVI65v0XvrlUOpf/bujOVxTqQyP/ZQYkZ1f9N
 1fA695Mv/rPVLma7XR/YOhuZRBEZr95jbtgMIv3Fy/0AKAXFVsBFNTZgDi647xQnE3OR
 3NoOF0I5B0J5uBMxkwJ8Y9+yANuoA+yQ1N7UxOnxEwDmtNorsj2QbsQWas/DEegBePwO 3g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30b6hph8eh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Apr 2020 22:53:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03DMhBwQ189016;
        Mon, 13 Apr 2020 22:51:03 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 30cta8a50d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Apr 2020 22:51:03 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03DMp1j6012472;
        Mon, 13 Apr 2020 22:51:01 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Apr 2020 15:51:01 -0700
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de, Damien.LeMoal@wdc.com
Subject: Re: [PATCH v4 05/14] scsi_debug: improve command duration calculation
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200225062351.21267-1-dgilbert@interlog.com>
        <20200225062351.21267-6-dgilbert@interlog.com>
Date:   Mon, 13 Apr 2020 18:50:59 -0400
In-Reply-To: <20200225062351.21267-6-dgilbert@interlog.com> (Douglas Gilbert's
        message of "Tue, 25 Feb 2020 01:23:42 -0500")
Message-ID: <yq1imi3vw30.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 adultscore=0 mlxscore=0 phishscore=0 mlxlogscore=867
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004130165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=944 clxscore=1015 mlxscore=0 phishscore=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004130165
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Doug,

> The action prior to this patch was to always do the timer based
> delay. After this patch, for ndelay values less than 1
> millisecond, this driver will complete the command immediately.
> And in the case where the user specified delay was 7
> microseconds, a timer delay of 600 nanoseconds will be set
> ((7 - 6.4) * 1000).

Looks OK.

-- 
Martin K. Petersen	Oracle Linux Engineering
