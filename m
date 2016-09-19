From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] ibmvfc: Fix I/O hang when port is not mapped
Date: Mon, 19 Sep 2016 16:54:41 -0400
Message-ID: <yq1oa3j8vam.fsf@sermon.lab.mkp.net>
References: <20160919135919.689C528041@b01ledav001.gho.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50098 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751029AbcISUyt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Sep 2016 16:54:49 -0400
In-Reply-To: <20160919135919.689C528041@b01ledav001.gho.pok.ibm.com> (Brian
        King's message of "Mon, 19 Sep 2016 08:59:19 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, tyreld@linux.vnet.ibm.com

>>>>> "Brian" == Brian King <brking@linux.vnet.ibm.com> writes:

Brian> If a VFC port gets unmapped in the VIOS, it may not respond with
Brian> a CRQ init complete following H_REG_CRQ. If this occurs, we can
Brian> end up having called scsi_block_requests and not a resulting
Brian> unblock until the init complete happens, which may never occur,
Brian> and we end up hanging I/O requests.  This patch ensures the host
Brian> action stay set to IBMVFC_HOST_ACTION_TGT_DEL so we move all
Brian> rports into devloss state and unblock unless we receive an init
Brian> complete.

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
