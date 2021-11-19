Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B712FC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 04:17:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A54C261AED
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 04:17:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233654AbhKSEUC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Nov 2021 23:20:02 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:16234 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233955AbhKSET7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Nov 2021 23:19:59 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ2rQj8000706;
        Fri, 19 Nov 2021 04:16:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=IHfGt8eh+rvCFJHdFKHm/8lhgOwSzbQZPUDsh+4qbFs=;
 b=U9H8D8xy+ZXbsnLD+Xw5gQN2tI4PZ0CMKbPEJDmW6oXYhr0RQgkeQE4NDpYI5vSR12UD
 2uU67YfsnDGSj75Lbs3+Ufz6zhqeZeh0V+2HI0NiYuA5hZyOUhQi2XRFPVoP7pmtLvUd
 c5V1NYtfAnpxc8AZCUBdlZLBfzjHWqqGtV0HEsrVXaIPhbZOFSzD503XyBACYZWuCLSW
 plYNfzW0+aHTjMW/j2+JIIQFh5xd99HFi0yIyOZ8B//La/qSq6i3pKzRsJ0sawv+1Fh8
 ngkKKGSokE0Nm42hMv4RDK65bQaZzwodVt89Xc59ZqC+okvFitxFTU58hi167UuIPrFQ XQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cd205mjq6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 04:16:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ4FBYK020342;
        Fri, 19 Nov 2021 04:16:54 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 3caq4x7c32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 04:16:54 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1AJ4Giwa024731;
        Fri, 19 Nov 2021 04:16:53 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3020.oracle.com with ESMTP id 3caq4x7bx2-11;
        Fri, 19 Nov 2021 04:16:53 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        suganath-prabu.subramani@broadcom.com
Subject: Re: [PATCH] mpt3sas: Fix incorrect system timestamp showed in IOC FW
Date:   Thu, 18 Nov 2021 23:16:40 -0500
Message-Id: <163729506338.21244.1122459564536370667.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211117123215.25487-1-sreekanth.reddy@broadcom.com>
References: <20211117123215.25487-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: o2M5Jta0Rm2wOOwpWbg-3yrh4aDF9kwC
X-Proofpoint-GUID: o2M5Jta0Rm2wOOwpWbg-3yrh4aDF9kwC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 17 Nov 2021 18:02:15 +0530, Sreekanth Reddy wrote:

> For updating the IOC Fimrware's timestamp with
> system timestamp, driver issues the Mpi26IoUnitControlRequest
> message. While framing the Mpi26IoUnitControlRequest
> driver should copy the current timestamp value's lower 32 bits in
> IOCParameterValue field and higher 32 bits in Reserved7 field.
> 
> 
> [...]

Applied to 5.16/scsi-fixes, thanks!

[1/1] mpt3sas: Fix incorrect system timestamp showed in IOC FW
      https://git.kernel.org/mkp/scsi/c/5ecae9f8c705

-- 
Martin K. Petersen	Oracle Linux Engineering
