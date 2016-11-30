From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 10/14] cxlflash: Remove AFU command lock
Date: Wed, 30 Nov 2016 16:12:28 -0600
Message-ID: <8d9dd4f3-ff12-8a0c-16ee-da2a28b9f275@linux.vnet.ibm.com>
References: <1480379984-60114-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1480380162-60533-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37678 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752112AbcK3WLz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Nov 2016 17:11:55 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uAUM8uRd122358
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2016 17:11:44 -0500
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2723d7ku54-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2016 17:11:44 -0500
Received: from localhost
        by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Wed, 30 Nov 2016 15:11:43 -0700
In-Reply-To: <1480380162-60533-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

> From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
>
> The original design of the cxlflash driver required AFU commands
> to convey state information across multiple threads. The IOASA
> "host use" byte was used to track if a command was done, errored,
> or timed out. A per-command spin lock was used to serialize access
> to this byte. As this is no longer required with the introduction
> of completions and various refactoring over time, the spin lock,
> state tracking, and associated code can be removed. To support the
> simplification, the wait_resp() routine is refactored to return a
> success or failure. Additionally, as the simplification to the
> AFU internal command routine, explicit assignments of AFU command
> fields to zero are removed as the memory is zeroed upon allocation.
>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

Acked-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>

