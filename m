Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEB6FCCA487
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jul 2022 04:22:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233317AbiGNEWZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jul 2022 00:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232089AbiGNEWW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jul 2022 00:22:22 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2596252A8;
        Wed, 13 Jul 2022 21:22:21 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26E3mtTN014131;
        Thu, 14 Jul 2022 04:22:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=gEUw90tZk1r6yssH4yKKHaYEgG74IVVFYSQOQADC5Ow=;
 b=MXdmOyY5wgDj50uWlKf1qopBWQoEEAgNrzs19qJg1WNs+QLJ4BTuWJsLUV4/N67UE2PV
 jU+wEmpT3n0rPOXoGAe3WzUjbmCrCYpBcD+D0XaqfzwTOzpTEODG+t59dDF2Ssma/fOX
 nEJit07qlKA9wLEGkAb6iVaV6NyxkyOGLZVept0ue1pvriXLQ47jC2sp7+VqDsJmpP6f
 x3H8jtIa3apiUh4a5rQdWj5LZ+OVBUEJCgF+PUpObFWgM0SXEEjniPIOO6/o22hQJTSX
 1B+W3vteQi3rTOeXGqN6mu8IVpwyMxoQy6sBMMZj6qGIPCui1kgFyEwDPZUZvjBsd1Lg dA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h71scc27p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 04:22:16 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 26E4Ap8l000933;
        Thu, 14 Jul 2022 04:22:16 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h7045au2m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 04:22:16 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 26E4MD5J024736;
        Thu, 14 Jul 2022 04:22:15 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h7045au20-4;
        Thu, 14 Jul 2022 04:22:15 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        sumit.saxena@broadcom.com, linux-block@vger.kernel.org,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Guangwu Zhang <guazhang@redhat.com>,
        Hannes Reinecke <hare@suse.de>, chandrakanth.patil@broadcom.com
Subject: Re: [PATCH] scsi: megaraid: clear READ queue map's nr_queues
Date:   Thu, 14 Jul 2022 00:22:11 -0400
Message-Id: <165777180151.4401.1027468101338336442.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220706125942.528533-1-ming.lei@redhat.com>
References: <20220706125942.528533-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: DQZd2I2Wc-0psZdV_7XDZMr5kYFsUBkL
X-Proofpoint-ORIG-GUID: DQZd2I2Wc-0psZdV_7XDZMr5kYFsUBkL
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 6 Jul 2022 20:59:42 +0800, Ming Lei wrote:

> megaraid scsi driver sets set->nr_maps as 3 if poll_queues is > 0, and
> blk-mq actually initializes each map's nr_queues as nr_hw_queues, so
> megaraid driver has to clear READ queue map's nr_queues, otherwise queue
> map becomes broken if poll_queues is set as non-zero.
> 
> 

Applied to 5.19/scsi-fixes, thanks!

[1/1] scsi: megaraid: clear READ queue map's nr_queues
      https://git.kernel.org/mkp/scsi/c/8312cd3a7b83

-- 
Martin K. Petersen	Oracle Linux Engineering
