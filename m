Return-Path: <SRS0=EtEA=ZU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1671BC432C0
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Nov 2019 12:18:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D80AC217D7
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Nov 2019 12:18:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="K2bY8ZVF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbfK1MSs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Nov 2019 07:18:48 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:58346 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726252AbfK1MSs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Nov 2019 07:18:48 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xASCETNu045604;
        Thu, 28 Nov 2019 12:18:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=A4+gfrkGLehQEJ8iiAgk5al4WroGNymL2XXB++ZaMZQ=;
 b=K2bY8ZVFkntAPcUK2KN+icNnPt6jTR7PMi+CehbeuG+JEA5Az7O4M+HCdR892f+/wY3s
 VibzJHoGUxGd/PSupdI/DgUBo/2hGDmEoSwUU0pk5tmNANBhfubR+ZpPUfwt2fH3riou
 A6ajJBbvu5k0st3tZaJSzk3Jpy+AmQV34z7bhKZAiNw3vm8UjdRnwC4lz+hVJdehvLiE
 fc6W/Y6UyHHVubditfDzZCstT7oQui9gwPDgJbclpDYaG3J9uCjxQVFKka4PLTnzIVzz
 GTXNDf0ZhhzqmvWn1SsQYUrWQ2TWcsdwwOaQxMCGMwRc+YODfyY45m9PlrOgQy3kjr5M bg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2wev6ukbt2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Nov 2019 12:18:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xASCEMXe100603;
        Thu, 28 Nov 2019 12:18:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2why49yrcn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Nov 2019 12:18:44 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xASCIh7o011962;
        Thu, 28 Nov 2019 12:18:43 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 28 Nov 2019 04:18:42 -0800
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Roman Bolshakov <r.bolshakov@yadro.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux@yadro.com
Subject: Re: [PATCH v3 00/13] scsi: qla2xxx: Bug fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191125165702.1013-1-r.bolshakov@yadro.com>
        <347fd571-89d7-2b7e-fd88-1711002c3fb9@acm.org>
        <20191127172427.jpqfopou7y6kyrev@SPB-NB-133.local>
        <d9366987-ab6a-9124-39e1-d70887c88757@acm.org>
Date:   Thu, 28 Nov 2019 07:18:40 -0500
In-Reply-To: <d9366987-ab6a-9124-39e1-d70887c88757@acm.org> (Bart Van Assche's
        message of "Wed, 27 Nov 2019 09:34:31 -0800")
Message-ID: <yq1r21s6vof.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9454 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911280108
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9454 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911280108
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> What happens with patches posted during the merge window depends on
> the maintainer (Martin Petersen). Sometimes patches posted during the
> merge window are ignored. Sometimes such patches are queued after the
> merge window has closed. Sometimes contributors are asked after the
> merge window has closed to rebase their patch series, to retest it and
> to repost it.

Bug fixes are OK at any time, as far as I'm concerned. Although this
series is a bit big to deal with given that we're now in the merge
window.

As a rule of thumb, I won't look closely at anything resembling new
feature series until -rc1 is out.

-- 
Martin K. Petersen	Oracle Linux Engineering
