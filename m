Return-Path: <SRS0=9ymf=55=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AAB8C2BA19
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 18:05:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0618020731
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 18:05:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EPhP7qVm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387616AbgDMSFv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Apr 2020 14:05:51 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52956 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387498AbgDMSFt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Apr 2020 14:05:49 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03DI4hgP036435;
        Mon, 13 Apr 2020 18:05:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=fJ9aWLQi6QNKZBTxO91RaZp/poOknxk2kdmSh25aM2U=;
 b=EPhP7qVmLp3mfhRHHSv8ub8Q+QLj/+dXRBtau85oQGUJNx25550TPtsXruOPdYyakHZv
 YAhdNYqrFdYDzcb77hA8NflLDYu37oHQ6lp0Gh1Ds2A7mNQSUNzAM3ga/zV1xgwn0jKO
 HEdfLRNqMb6rSVAHAAyPpPvn+ZV6irBhLj49a2sVcIgRI2MLzczz05bKk1JoIidxouEc
 ZoPrV5YhqAgpU2cVpo+BjqhwGzHz6lGHnx7qJGei6efEJq6rakN6BLa20WVtiFseDvgF
 KqLBlrST9u8IFA6rcYln176HfmnBMEPzvQuIR64YQadfV08l9nBkd4VYayKitUTx7vGv uw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 30b5ar02x6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Apr 2020 18:05:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03DI349h008698;
        Mon, 13 Apr 2020 18:03:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 30cta7nkx8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Apr 2020 18:03:43 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03DI3g5v005828;
        Mon, 13 Apr 2020 18:03:42 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Apr 2020 11:03:42 -0700
To:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mchristi@redhat.com, martin.petersen@oracle.com
Subject: Re: [PATCH] target: tcmu: reset_ring should reset TCMU_DEV_BIT_BROKEN
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200409101026.17872-1-bstroesser@ts.fujitsu.com>
Date:   Mon, 13 Apr 2020 14:03:40 -0400
In-Reply-To: <20200409101026.17872-1-bstroesser@ts.fujitsu.com> (Bodo
        Stroesser's message of "Thu, 9 Apr 2020 12:10:26 +0200")
Message-ID: <yq1ftd7xnyb.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 adultscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004130138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 impostorscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 phishscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004130138
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bodo,

> In case command ring buffer becomes inconsistent, tcmu sets device
> flag TCMU_DEV_BIT_BROKEN.  If the bit is set, tcmu rejects new
> commands from lio core with TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE,
> and no longer processes completions from the ring.  The reset_ring
> attribute can be used to completely clean up the command ring, so
> after reset_ring the ring no longer is inconsistent.
>
> Therefore reset_ring also should reset bit TCMU_DEV_BIT_BROKEN to
> allow normal processing.

Applied to 5.7/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
