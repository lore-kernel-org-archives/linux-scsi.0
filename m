Return-Path: <SRS0=9ymf=55=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC530C2BA2B
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 23:00:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F22F20739
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 23:00:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="wMVfsKne"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389816AbgDMXAD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Apr 2020 19:00:03 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57552 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728050AbgDMXAA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Apr 2020 19:00:00 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03DMmbHX186888;
        Mon, 13 Apr 2020 22:59:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=DW0a2ib7coI9d+ysr13ixCmPaadlmvTxaylaCDc7ezg=;
 b=wMVfsKnewosVmTOB0ZFdjlZ229pe6QpBiRCe1w50Z0vb1SfBCPXSyxHJ/OxMJnEG04yX
 i8MzzHDfPTeAIQlyiaDHuZMuTICE4Td+p+Y5fPdLm8MhIYttt4zYepxbPZkmEGIktRnr
 ZORriOgSVxKF5XWdNLP5wqs697gxAXcFTWCC93MI7h+LvH4ejnsnjD7iwZA/J9T7EEJ5
 t0qb8cQECnigT5gb0S3Uft+6wEiytpyzXUaqGO1kkX4FypNdSeIyseBfeZeSdAOXBooP
 6u42wIrt5JA48kebyv8dwAnkBD4agovHhMamoPXJ0/eR1LP+rq5Mi61eacrOI29214e/ lA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 30b5ar1a3k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Apr 2020 22:59:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03DMh4uH188683;
        Mon, 13 Apr 2020 22:57:54 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 30cta8amb7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Apr 2020 22:57:54 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03DMvrUx020829;
        Mon, 13 Apr 2020 22:57:53 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Apr 2020 15:57:53 -0700
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de, Damien.LeMoal@wdc.com
Subject: Re: [PATCH v4 06/14] scsi_debug: implement pre-fetch commands
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200225062351.21267-1-dgilbert@interlog.com>
        <20200225062351.21267-7-dgilbert@interlog.com>
Date:   Mon, 13 Apr 2020 18:57:51 -0400
In-Reply-To: <20200225062351.21267-7-dgilbert@interlog.com> (Douglas Gilbert's
        message of "Tue, 25 Feb 2020 01:23:43 -0500")
Message-ID: <yq1eesrvvrk.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 adultscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004130165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 impostorscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 phishscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004130165
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Doug,

> Many disks implement the SCSI PRE-FETCH commands. One use case might
> be a disk-to-disk compare, say between disks A and B.  Then this
> sequence of commands might be used: PRE-FETCH(from B, IMMED),
> READ(from A), VERIFY (BYTCHK=1 on B with data returned from READ). The
> PRE-FETCH (which returns quickly due to the IMMED) fetches the data
> from the media into B's cache which should speed the trailing VERIFY
> command.  The next chunk of the compare might be done in parallel,
> with A and B reversed.

Minor nit: I agree with the code and the use case. But the commit
description should reflect what the code actually does (not much in the
absence of cache, etc.)

-- 
Martin K. Petersen	Oracle Linux Engineering
