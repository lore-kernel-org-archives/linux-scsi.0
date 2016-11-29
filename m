From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 04/14] cxlflash: Avoid command room violation
Date: Tue, 29 Nov 2016 11:04:44 -0600
Message-ID: <ABD4055E-FAA8-431D-A162-0702729A52A6@linux.vnet.ibm.com>
References: <1480379984-60114-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1480380105-60310-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 10.1 \(3251\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55618 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755287AbcK2RE5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Nov 2016 12:04:57 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uATH3sNv115831
        for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2016 12:04:50 -0500
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158])
        by mx0b-001b2d01.pphosted.com with ESMTP id 271a7vp82p-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2016 12:04:50 -0500
Received: from localhost
        by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
        Tue, 29 Nov 2016 10:04:50 -0700
In-Reply-To: <1480380105-60310-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

Uma,

This looks better, thanks for reworking.


-matt

> On Nov 28, 2016, at 6:41 PM, Uma Krishnan <ukrishn@linux.vnet.ibm.com> wrote:
> 
> During test, a command room violation interrupt is occasionally seen
> for the master context when the CXL flash devices are stressed.
> 
> After studying the code, there could be gaps in the way command room
> value is being cached in cxlflash. When the cached command room is zero
> the thread attempting to send becomes burdened with updating the cached
> value with the actual value from the AFU. Today, this is handled with an
> atomic set operation of the raw value read. Following the atomic update,
> the thread proceeds to send.
> 
> This behavior is incorrect on two counts:
> 
>   - The update fails to take into account the current thread and its
>     consumption of one of the hardware commands.
> 
>   - The update does not take into account other threads also atomically
>     updating. Per design, a worker thread updates the cached value when a
>     send thread times out. By not protecting the update with a lock, the
>     cached value can be incorrectly clobbered.
> 
> To correct these issues, the update of the cached command room has been
> simplified and also protected using a spin lock which is held until the
> MMIO is complete. This ensures the command room is properly consumed by
> the same thread. Update of cached value also takes into account the
> current thread consuming a hardware command.
> 
> Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>

Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

