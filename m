Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C090C38A30
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 03:54:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07C882064C
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 03:54:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Nv7/M1sx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgDVDyV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 23:54:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57296 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbgDVDyV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2020 23:54:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M3qkDh037131;
        Wed, 22 Apr 2020 03:54:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=7qWTAR8sfKxdbLme8cL34AS0KWIrg7Y89dAxre3TvLE=;
 b=Nv7/M1sxpsThx681ukPE2BsdmvmsrHMDzPjRFXa7ZZwJeS7J7rFm2dFXtnAjRqpU0tdD
 cJh3KxVfQlcmnjJD7Kd8lebJu5rWIL8YMA+bnaCe/QEqTt0CpY6Zct/NQkio7WAW6cwp
 sKJfGT4DJqlBSC7AxQwTKo2pf9sPTK8AlMVboAL/PSTbziee+VihnfpslpmGIuyXcZz8
 4blTHAC6GzWV7hNDA1auRFfADfnOGmekLtM/tT+K5hg4n81jKfeeBNlQTD+lm0pP8kqt
 6FfiU6PxANXHSq2OhLvfjs1O9pTPHC+uZx10ibATEygIODESkPgNpD+eEtshEquGBSn2 Pg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 30ft6n88xy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Apr 2020 03:54:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M3qFX1134925;
        Wed, 22 Apr 2020 03:54:11 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 30gb1hh086-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Apr 2020 03:54:11 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03M3s8Xd026692;
        Wed, 22 Apr 2020 03:54:09 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Apr 2020 20:54:08 -0700
To:     mwilck@suse.com
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arun Easi <aeasi@marvell.com>, Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Daniel Wagner <dwagner@suse.de>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v4 0/2] scsi: qla2xxx: fixes for driver unloading
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200421204621.19228-1-mwilck@suse.com>
Date:   Tue, 21 Apr 2020 23:54:05 -0400
In-Reply-To: <20200421204621.19228-1-mwilck@suse.com> (mwilck@suse.com's
        message of "Tue, 21 Apr 2020 22:46:19 +0200")
Message-ID: <yq1h7xci3aa.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=1 spamscore=0
 mlxlogscore=684 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004220029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 mlxlogscore=758 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004220029
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Martin,

> here is v4 of the little series I first submitted on Nov 29, 2019.  I
> dropped the more controversial part, hoping to get the actual fix for
> the issue merged.

Applied to 5.7/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
