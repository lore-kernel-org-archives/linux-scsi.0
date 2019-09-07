Return-Path: <SRS0=mW7r=XC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE24FC43331
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Sep 2019 20:29:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1F0A21848
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Sep 2019 20:29:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bmve5pfR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395258AbfIGU3U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 7 Sep 2019 16:29:20 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42504 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390111AbfIGU3U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Sep 2019 16:29:20 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x87KTHng157979;
        Sat, 7 Sep 2019 20:29:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=YR8Jxv7BewZSLfkyJfLRhFhUBKxYtUa7MpZZOwtjxWI=;
 b=bmve5pfRxfDVJ9+DA/b7IthdQ5apqyQTPXsc/sBZE5+IM5JWLBfh2PwDEVbb138q60Ql
 NSdwoCA8RDfWHJeEYCyYDN2h78VaM5knktPj58u/LPn6iCtmT0sd8l2TZuIBD9mB/Lxc
 NvwmZjhKoxXO1N1WM0qmVWZGncPPDSW0pGlAXTgV8HmZSUrTrgPZBFops20B+2deyFS7
 qL147c3ZlCW2lRy/BEHm0QR1o3yMS5M85kT3gI86ZGy7D3A/7AvzxXMtv8jSi4MksEk8
 dhzzSbJXO4tB8OlyClsfFi+hBqnqoUeQo2ck5So9pu6dB2XdIXGyudvkeksm8tRLAwLj Pw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2uvkbe80ku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 07 Sep 2019 20:29:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x87KSUrF024479;
        Sat, 7 Sep 2019 20:29:16 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2uv2kxhdd8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 07 Sep 2019 20:29:16 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x87KTFWM008251;
        Sat, 7 Sep 2019 20:29:15 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 07 Sep 2019 13:29:15 -0700
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: Re: [PATCH] lpfc: Fix reset recovery paths that are not recovering
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190903215441.10490-1-jsmart2021@gmail.com>
Date:   Sat, 07 Sep 2019 16:29:13 -0400
In-Reply-To: <20190903215441.10490-1-jsmart2021@gmail.com> (James Smart's
        message of "Tue, 3 Sep 2019 14:54:41 -0700")
Message-ID: <yq1h85nkfza.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9373 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=599
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909070223
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9373 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=682 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909070223
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> A recent patch unconditionally marks the hba as in error as part of
> resetting the adapter. The driver flow that called the adapter reset
> was a recovery path, which expects the adapter to not be in an error
> state in order to finish the recovery.  Given the new error state
> being set, the recovery fails and the adapter is left in limbo.
>
> Revise the adapter reset routine so that it will only mark the adapter
> in error if it was unable to reset the adapter.

Applied to 5.4/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
