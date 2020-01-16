Return-Path: <SRS0=K2E6=3F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E620C33CAF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 03:56:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 457BC24656
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 03:56:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TfowinsV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730142AbgAPD4r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jan 2020 22:56:47 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:50692 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729110AbgAPD4r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jan 2020 22:56:47 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G3rAlM120822;
        Thu, 16 Jan 2020 03:56:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=EegwV6a5lz3yvmDbFo0iIcaUYbRPgSupJsICVj3Wnhg=;
 b=TfowinsVPUtiC7k/wv4kDF73oREAGt8teppif1E9miGkcDpSECFvL7HSvDwJTwaU3res
 7P1JMTdA7tKXikNye+EmnmTQZE1EHEQijUiWYPCMp0G4+P/g0z4OYK1YuhdkzPu8LRhy
 8/xofZiKvgS1HB1k11+qB9XAxqJWHcrGnFF2O3gQRgbBiaxTFxtrqqaX+8eUZxJltqQl
 1iQH1grufMdAHNRw1K8AGFyGVxSR5nF+G43OyZtO0JwSOYNtBZL0Nb42XnQbvFVIzIIY
 P1RHUcNVi4A69kv1mB6LFBmPzGrZmWOEhEwvaNMtd88hpNM3c9Wxb7tcEwXCWSSR70dp Cg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2xf73yr1bm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 03:56:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G3rQOo168380;
        Thu, 16 Jan 2020 03:56:33 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2xj61kukqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 03:56:33 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00G3uVgQ019776;
        Thu, 16 Jan 2020 03:56:31 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 19:56:30 -0800
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
Cc:     gregkh@linuxfoundation.org, rafael@kernel.org, lduncan@suse.com,
        cleech@redhat.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        open-iscsi@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, kernel@collabora.com
Subject: Re: [PATCH 0/3] drivers base: transport component error propagation
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200106185817.640331-1-krisman@collabora.com>
Date:   Wed, 15 Jan 2020 22:56:28 -0500
In-Reply-To: <20200106185817.640331-1-krisman@collabora.com> (Gabriel Krisman
        Bertazi's message of "Mon, 6 Jan 2020 13:58:14 -0500")
Message-ID: <yq1pnfknjf7.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160030
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Gabriel,

> This small series improves error propagation on the transport
> component to prevent an inconsistent state in the iscsi module.  The
> bug that motivated this patch results in a hanging iscsi connection
> that cannot be used or removed by userspace, since the session is in
> an inconsistent state.
>
> That said, I tested it using the TCP iscsi transport (and forcing
> errors on the triggered function), which doesn't require a
> particularly complex container structure, so it is not the best test
> for finding corner cases on the atomic attribute_container_device
> trigger version.

Applied to 5.6/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
