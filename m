From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 17/19] qla2xxx: prevent bounds-check bypass via
 speculative execution
Date: Thu, 11 Jan 2018 17:19:16 -0800
Message-ID: <1515719956.3056.37.camel@linux.vnet.ibm.com>
References: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
         <151571807774.27429.7382333750792304971.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51682 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754125AbeALBT1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Jan 2018 20:19:27 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w0C1JPCU022539
        for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2018 20:19:26 -0500
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2feghv6umk-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2018 20:19:26 -0500
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Thu, 11 Jan 2018 20:19:24 -0500
In-Reply-To: <151571807774.27429.7382333750792304971.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-hardening@lists.openwall.com, qla2xxx-upstream@qlogic.com, tglx@linutronix.de, torvalds@linux-foundation.org, akpm@linux-foundation.org, Elena Reshetova <elena.reshetova@intel.com>, alan@linux.intel.com

On Thu, 2018-01-11 at 16:47 -0800, Dan Williams wrote:
> Static analysis reports that 'handle' may be a user controlled value
> that is used as a data dependency to read 'sp' from the
> 'req->outstanding_cmds' array.

Greg already told you it comes from hardware, specifically the hardware
response queue.  If you don't believe him, I can confirm it's quite
definitely all copied from the iomem where the mailbox response is, so
it can't be a user controlled value (well, unless the user has some
influence over the firmware of the qla2xxx  controller, which probably
means you have other things to worry about than speculative information
leaks).

I think what it actually is is a handle returned in the mailbox that's
used to find other mailbox entries in different queues (the packet
handle actually contains an entry in the lower 16 bits and a queue
designation in the upper).  Perhaps the qla2xxx people should comment
on this because the code seems to check and print an error if there's a
problem with the handle being too big, but we don't check the que value
and use it blindly to read into the req_q_map: if handle could be
wrong, couldn't que?

James
