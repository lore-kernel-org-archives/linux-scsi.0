From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/6] cxlflash: Remove the device cleanly in the system shutdown path
Date: Wed, 7 Sep 2016 18:46:35 -0500
Message-ID: <64F2AAD6-ADF0-4940-A4F1-7541177639EC@linux.vnet.ibm.com>
References: <1472848612-64888-1-git-send-email-ukrishn@linux.vnet.ibm.com> <1472848756-64998-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43578 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752481AbcIGXqp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Sep 2016 19:46:45 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u87NgtIm011911
        for <linux-scsi@vger.kernel.org>; Wed, 7 Sep 2016 19:46:44 -0400
Received: from e19.ny.us.ibm.com (e19.ny.us.ibm.com [129.33.205.209])
        by mx0a-001b2d01.pphosted.com with ESMTP id 25au8ru0un-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 07 Sep 2016 19:46:44 -0400
Received: from localhost
        by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
        Wed, 7 Sep 2016 19:46:43 -0400
In-Reply-To: <1472848756-64998-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

> On Sep 2, 2016, at 3:39 PM, Uma Krishnan <ukrishn@linux.vnet.ibm.com> wrote:
> 
> Commit 704c4b0ddc03 ("cxlflash: Shutdown notify support for CXL Flash
> cards") was recently introduced to notify the AFU when a system is going
> down. Due to the position of the cxlflash driver in the device stack,
> cxlflash devices are _always_ removed during a reboot/shutdown. This can
> lead to a crash if the cxlflash shutdown hook is invoked _after_ the
> shutdown hook for the owning virtual PHB. Furthermore, the current
> implementation of shutdown/remove hooks for cxlflash are not tolerant to
> being invoked when the device is not enabled. This can also lead to a
> crash in situations where the remove hook is invoked after the device has
> been removed via the vPHBs shutdown hook. An example of this scenario
> would be an EEH reset failure while a reboot/shutdown is in progress.
> 
> To solve both problems, the shutdown hook for cxlflash is updated to
> simply remove the device. This path already includes the AFU notification
> and thus this solution will continue to perform the original intent. At
> the same time, the remove hook is updated to protect against being
> called when the device is not enabled.
> 
> Fixes: 704c4b0ddc03 ("cxlflash: Shutdown notify support for CXL Flash
> cards")
> Signed-off-by: Uma Krishna <ukrishn@linux.vnet.ibm.com>

Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

