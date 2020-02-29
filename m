Return-Path: <SRS0=kvmt=4R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40258C3F2D3
	for <linux-scsi@archiver.kernel.org>; Sat, 29 Feb 2020 01:10:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0343124672
	for <linux-scsi@archiver.kernel.org>; Sat, 29 Feb 2020 01:10:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L+uQeF42"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgB2BKj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Feb 2020 20:10:39 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:38296 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgB2BKi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Feb 2020 20:10:38 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01T0wvGq131043;
        Sat, 29 Feb 2020 01:10:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=IfTe2xicfn5DQjI6TrgbUbkD62QKMdeFyT7STZTeh+E=;
 b=L+uQeF425bcygXTAHj4dt26PAFQrvBsteLRBJbzFmx2Z0mPYBw/XQyCnzjO5xM0o7M56
 PX+3ywo5Z2QTaqqKvlX8fK95V+OllpA53mfq2zq4ODfMFtFIgPTdqrkuK5XQyPz/uiEc
 r4JlwNS/JZGC+c8ORJITu6c1GOedCCEOK59MrzUAeTdPEJgXd+yZd0QehnZgNxq6qh9a
 IQYtW1J5XL5Y/uygxKnrQllQpWAaCRymMEyteD7EmaAnEOspFeBLVdXa68gdavTPJIvu
 xLOE/dxJRYpEowOz3GcBWv6xQ1wlb4ZIqAAEkI/u/COkP2gGvGZnWG5T2YgHowQAu7L4 ug== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2ydct3p0c8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 29 Feb 2020 01:10:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01T0wCoA031309;
        Sat, 29 Feb 2020 01:10:33 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2ydj4s9vw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 29 Feb 2020 01:10:33 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01T1AWJo003021;
        Sat, 29 Feb 2020 01:10:33 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 17:10:32 -0800
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 0/5] qla2xxx patches for kernel v5.7
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200220043441.20504-1-bvanassche@acm.org>
Date:   Fri, 28 Feb 2020 20:10:30 -0500
In-Reply-To: <20200220043441.20504-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Wed, 19 Feb 2020 20:34:36 -0800")
Message-ID: <yq17e068agp.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002290004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002290004
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> Please consider these five qla2xxx patches for kernel v5.7.

Applied 1-4 to 5.7/scsi-queue. Patch 5 doesn't apply on top of the
latest driver update so please rebase.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
