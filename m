Return-Path: <SRS0=T7Zk=4G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B74A1C34033
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Feb 2020 05:39:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9130520836
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Feb 2020 05:39:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nIlZXEpu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbgBRFjf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Feb 2020 00:39:35 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:60400 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbgBRFje (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2020 00:39:34 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01I5dTVK167552;
        Tue, 18 Feb 2020 05:39:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=sRkEL1S2F+mzfOQhEzrZU5GvyiQ1qIuq49HJHV2pwLY=;
 b=nIlZXEpuRQgrZi5uZmn0/D3a71j4lyAeunu2cmcpPgTBLTMfwPsZ2ioMLsZDh83bQngB
 3waqcSPokCAiggxHb900ctRXVLM1vdKauaxMTuC+GTGjPLx2/LOBQ9eFFncH7iENxw38
 gFnnxZeMCUIFaoldyjxqlFQi2qZh4MsCfy62Pap7nTSrRp8hv4AgdRtTh7zV+SOE6N66
 fgalCvCBBSfbDONaQ2z6v0k/iB91joGfkWTNf4OTJqN2zNjIXL283Q3pgle7ygjEygXc
 Z2M9nJbAk6KTmhpSSDbMj14Pyx398YDWIewZ1Ebc9pNGKf/uKNpE9k0agXbNFeu70lOn lg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2y7aq5pcq6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Feb 2020 05:39:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01I5bfWE067464;
        Tue, 18 Feb 2020 05:39:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2y6t4hessw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Feb 2020 05:39:29 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01I5dPnR012937;
        Tue, 18 Feb 2020 05:39:26 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Feb 2020 21:39:25 -0800
To:     Merlijn Wajer <merlijn@wizzup.org>
Cc:     linux-scsi@vger.kernel.org, Merlijn Wajer <merlijn@archive.org>,
        Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: sr: get rid of sr global mutex
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200214135433.29448-1-merlijn@wizzup.org>
        <yq1a75gmpsv.fsf@oracle.com>
Date:   Tue, 18 Feb 2020 00:39:23 -0500
In-Reply-To: <yq1a75gmpsv.fsf@oracle.com> (Martin K. Petersen's message of
        "Tue, 18 Feb 2020 00:23:44 -0500")
Message-ID: <yq11rqsmp2s.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9534 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=950 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002180045
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9534 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0 adultscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 clxscore=1015 bulkscore=0
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002180045
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Merlijn,

>> When replacing the Big Kernel Lock in commit
>> 2a48fc0ab24241755dc93bfd4f01d68efab47f5a ("block: autoconvert trivial
>> BKL users to private mutex"), the lock was replaced with a sr-wide
>> lock.
>
> Applied to 5.7/scsi-queue, thanks!

Doesn't build. Please rebase on top of 5.7/scsi-queue and
resubmit. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
