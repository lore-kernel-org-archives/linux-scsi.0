From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 03/17] cxlflash: Reset hardware queue context via
 specified register
Date: Thu, 22 Jun 2017 14:54:40 -0500
Message-ID: <E8049A97-D0EB-4C2A-AA81-9E177E6F69C8@linux.vnet.ibm.com>
References: <1498097563-8680-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1498097642-8789-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60971 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751147AbdFVTy5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Jun 2017 15:54:57 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5MJrpKB061124
        for <linux-scsi@vger.kernel.org>; Thu, 22 Jun 2017 15:54:56 -0400
Received: from e38.co.us.ibm.com (e38.co.us.ibm.com [32.97.110.159])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2b8fu7vqhy-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 22 Jun 2017 15:54:56 -0400
Received: from localhost
        by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
        Thu, 22 Jun 2017 13:54:55 -0600
In-Reply-To: <1498097642-8789-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

> On Jun 21, 2017, at 9:14 PM, Uma Krishnan <ukrishn@linux.vnet.ibm.com> wrote:
> 
> Per the SISLite specification, context_reset() writes 0x1 to the LSB of the
> reset register. When the AFU processes this reset request, it is expected
> to clear the bit after reset is complete. The current implementation simply
> checks that the entire value read back is not 1, instead of masking off the
> LSB and evaluating it for a change to 0. Should the AFU manipulate other
> bits during the reset (reading back a value of 0xF for example), successful
> completion will be prematurely indicated given the existing logic.
> 
> Additionally, in the event that the context reset operation fails, there
> does not currently exist a way to provide feedback to the initiator of the
> reset. This poses a problem for the rare case that a context reset fails as
> the caller will proceed on the assumption that all is well.
> 
> To remedy these issues, refactor the context reset routine to only mask off
> the LSB when evaluating for success and return status to the caller. Also
> update the context reset handler parameters to pass a hardware queue
> reference instead of a single command to better reflect that the entire
> queue associated with the context is impacted by the reset.
> 
> Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>

Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
