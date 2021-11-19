Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78B1AC43217
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 04:16:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6112161B04
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 04:16:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233817AbhKSET7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Nov 2021 23:19:59 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:15118 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233654AbhKSET6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Nov 2021 23:19:58 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ2a3O5019268;
        Fri, 19 Nov 2021 04:16:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=xGIYxpUTcqd44l4cddjGFzaFeC+u5jZwifG54YTAuDM=;
 b=ABJopUiJ1vjfVz0wrPyklcKvfZAZlAZqLAzvV2zrv+CCzxsigqey+4ktClRn5/C0olDc
 yFmY6RGX2PbD7o0rHHVKV1j4mU7KoFcIqjdLHdGGTC/AbkHQ1E41icojp5iGiP7iDi/P
 0rB7xt8bPcwVJP8Q58BJOrR6gW4yL5WPQv356iKvQ18D7lHxBov6mNwSGPsf90Sf7r3H
 1WmxuozZRtBrXxde4QeX/UwH3HaG1iKXoO5vpHkmfik9KJJ9RTetmBM8kQsvw5mkTNfB
 GxP8S9EL3FSY2D3F15ZxPatL/MfhSkPTtOGKjNFGTr/MrTwJ54QmoqDAygXgNSk0MryK OA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cd2w93kbp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 04:16:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ4FBmt020355;
        Fri, 19 Nov 2021 04:16:54 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 3caq4x7c3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 04:16:54 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1AJ4Giwc024731;
        Fri, 19 Nov 2021 04:16:54 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3020.oracle.com with ESMTP id 3caq4x7bx2-12;
        Fri, 19 Nov 2021 04:16:54 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] mpt3sas:Fix kernel panic during drive powercycle test
Date:   Thu, 18 Nov 2021 23:16:41 -0500
Message-Id: <163729506337.21244.2229003917376159521.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211117104909.2069-1-sreekanth.reddy@broadcom.com>
References: <20211117104909.2069-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: l5EKrMnNr4aSteTyp1lcjZaHy-ciXJZy
X-Proofpoint-ORIG-GUID: l5EKrMnNr4aSteTyp1lcjZaHy-ciXJZy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 17 Nov 2021 16:19:09 +0530, Sreekanth Reddy wrote:

> While looping over shost's sdev list it is possible that one
> of the drive is getting removed and it's sas_target object is
> freed but it's sdev object is still intact with the sdev list.
> So, kernel panic occurred while driver trying to access the sas_address
> field of sas_target object without checking the sas_target object
> for NULL pointer.
> 
> [...]

Applied to 5.16/scsi-fixes, thanks!

[1/1] mpt3sas:Fix kernel panic during drive powercycle test
      https://git.kernel.org/mkp/scsi/c/0ee4ba13e09c

-- 
Martin K. Petersen	Oracle Linux Engineering
