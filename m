From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] [SCSI] sd: fix crash when UA received on DIF enabled device
Date: Tue, 06 Nov 2012 17:48:55 -0500
Message-ID: <yq1liee4aaw.fsf@sermon.lab.mkp.net>
References: <1351863514-12745-1-git-send-email-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42211 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219Ab2KFWs6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Nov 2012 17:48:58 -0500
In-Reply-To: <1351863514-12745-1-git-send-email-emilne@redhat.com> (Ewan
	D. Milne's message of "Fri, 2 Nov 2012 09:38:34 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org

>>>>> "Ewan" == Ewan D Milne <emilne@redhat.com> writes:

Ewan> sd_prep_fn will allocate a larger CDB for the command via
Ewan> mempool_alloc for devices using DIF type 2 protection.  This CDB
Ewan> was being freed in sd_done, which results in a kernel crash if the
Ewan> command is retried due to a UNIT ATTENTION.  This change moves the
Ewan> code to free the larger CDB into sd_unprep_fn instead, which is
Ewan> invoked after the request is complete.

The 32-byte CDB support predates unprep. This fix is obviously the
correct approach.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
