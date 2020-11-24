Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10DD4C2D0E4
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 03:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DD162085B
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 03:50:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c4nQi2pW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbgKXDuL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 22:50:11 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:33726 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbgKXDuL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Nov 2020 22:50:11 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO3nKln074368;
        Tue, 24 Nov 2020 03:50:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=7mhH8HWEwM8QG4djjmYXl21iBFuui8uZpAORahmg0Yw=;
 b=c4nQi2pWwbUdIBcYdq6P4/WKjQMBkE+h4n+5jbtfMaJzGScYKzx9l28dcbkTWWqAj+m9
 z7mixDw0+f6pIl88QgGMygV0Eq7fTZchUxyEasXei4EnAyYfQIZ1uBmIiWNLD3342wZn
 ApPrmmm3pwR2nzDTHotHhhH8c+xQwCm78dQa6x2B09z+h82Rb48bEDmxThJJEjB4YHCm
 aSK3l0Rqc+mDm+39B/O8IeGIXFYCdR7nrxlBegP/Ro0EVP78LrRGVfWEkzC+xWc9U3HF
 J9gvYFUxWZLBEgEXi3m4ZJUU9ofZh95wTnoq6Ubpr0PAmQAgPAHNrtgze724lAIkYDTb 9g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 34xtaqky5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 24 Nov 2020 03:50:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO3jeot042255;
        Tue, 24 Nov 2020 03:48:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34yx8j9w7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 03:48:06 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AO3m4hx023452;
        Tue, 24 Nov 2020 03:48:05 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Nov 2020 19:48:04 -0800
To:     Karan Tilak Kumar <kartilak@cisco.com>
Cc:     satishkh@cisco.com, sebaddel@cisco.com, arulponn@cisco.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fnic: Change shost_printk with FNIC_FCS_DBG
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ft4zmn4p.fsf@ca-mkp.ca.oracle.com>
References: <20201120220712.16708-1-kartilak@cisco.com>
Date:   Mon, 23 Nov 2020 22:48:02 -0500
In-Reply-To: <20201120220712.16708-1-kartilak@cisco.com> (Karan Tilak Kumar's
        message of "Fri, 20 Nov 2020 14:07:12 -0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=1
 bulkscore=0 mlxlogscore=911 malwarescore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=941 clxscore=1015 suspectscore=1 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240020
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Karan,

> Replacing shost_printk with FNIC_FCS_DBG so that these log messages
> are controlled by fnic_log_level flag in fnic_fip_handler_timer.

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
