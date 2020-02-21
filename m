Return-Path: <SRS0=iCCw=4J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1730C3566F
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Feb 2020 22:57:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9C8920722
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Feb 2020 22:57:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="uOHwG2vY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728722AbgBUW5P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Feb 2020 17:57:15 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:34884 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbgBUW5O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Feb 2020 17:57:14 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01LMiJMA173951;
        Fri, 21 Feb 2020 22:57:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=mHXErjrqGneRv2hmmW4O5dP0FIgiXEVOdcSpIVObv2c=;
 b=uOHwG2vYSTHxA4n2PE+dWpoS0X6e5Jv5bK9Gh83QZfwXAWIPmG4kAV2w6AAcLVFgeZmT
 nmUcxMPKm9jR2WIMCgzxuT673R7uWsYtG2JndQAQkPI2wFXZgXo8i4DDqagwo3OytxMd
 98ENFpSMwd94UyRoKjDEfk6EhgHD/EK1Rr/JxIfQedpZDPfBKhlnqVoLh3A5a5z75v0V
 aZsMoY4NdSOJNw0JmrtKhbkW5Xuvq/Jgaaqi4+z2OeoyZSEp8cduL7/BktF6mPkz5UQW
 wPvG3uSzp4HwCnnx+lxQeULJqp1G0FDA0u3a+SwwirBDWm44ojM75hYJLaME+AnzXCUk tA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2y8ud1kaa7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 22:57:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01LMgZJH101171;
        Fri, 21 Feb 2020 22:57:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2y8udg3yuw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 22:57:06 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01LMv238008888;
        Fri, 21 Feb 2020 22:57:03 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Feb 2020 14:57:02 -0800
To:     Igor Druzhinin <igor.druzhinin@citrix.com>
Cc:     <fcoe-devel@open-fcoe.org>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <hare@suse.de>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
Subject: Re: [PATCH RESEND 1/2] scsi: libfc: free response frame from GPN_ID
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1579013000-14570-1-git-send-email-igor.druzhinin@citrix.com>
        <1579013000-14570-2-git-send-email-igor.druzhinin@citrix.com>
Date:   Fri, 21 Feb 2020 17:56:59 -0500
In-Reply-To: <1579013000-14570-2-git-send-email-igor.druzhinin@citrix.com>
        (Igor Druzhinin's message of "Tue, 14 Jan 2020 14:43:19 +0000")
Message-ID: <yq18skvsg5g.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9538 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=886 malwarescore=0 bulkscore=0 suspectscore=2 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002210170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9538 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 suspectscore=2 bulkscore=0 spamscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 mlxlogscore=960 clxscore=1015 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002210170
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Igor,

> fc_disc_gpn_id_resp() should be the last function using it so free it
> here to avoid memory leak.

Applied to 5.6/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
