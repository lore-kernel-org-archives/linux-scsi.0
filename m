From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/4] cxlflash: Cancel scheduled workers before stopping
 AFU
Date: Fri, 6 Jan 2017 13:12:15 -0600
Message-ID: <95DE7D28-9C40-4DD4-A901-C2C34DDE125B@linux.vnet.ibm.com>
References: <1483711379-18188-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1483711536-18341-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 10.1 \(3251\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52593 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1032907AbdAFTMX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jan 2017 14:12:23 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id v06J8oIX107320
        for <linux-scsi@vger.kernel.org>; Fri, 6 Jan 2017 14:12:23 -0500
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0a-001b2d01.pphosted.com with ESMTP id 27tb6mp897-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 06 Jan 2017 14:12:22 -0500
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
        Fri, 6 Jan 2017 12:12:22 -0700
In-Reply-To: <1483711536-18341-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org

> On Jan 6, 2017, at 8:05 AM, Uma Krishnan <ukrishn@linux.vnet.ibm.com> wrote:
> 
> When processing an AFU asynchronous interrupt, if the action results in an
> operation that requires off level processing (a link reset for example),
> the worker thread is scheduled. In the meantime a reset event (i.e.: EEH)
> could unmap the AFU to recover. This results in an Oops when the worker
> thread tries to access the AFU mapping.
> 
> [c000000f17e03b90] d000000007cd5978 cxlflash_worker_thread+0x268/0x550
> [c000000f17e03c40] c00000000011883c process_one_work+0x1dc/0x680
> [c000000f17e03ce0] c000000000118e80 worker_thread+0x1a0/0x520
> [c000000f17e03d80] c000000000126174 kthread+0xf4/0x100
> [c000000f17e03e30] c00000000000a47c ret_from_kernel_thread+0x5c/0xe0
> 
> In an effort to avoid this, a mapcount was introduced in
> commit b45cdbaf9f7f ("cxlflash: Resolve oops in wait_port_offline")
> but due to the race condition described above, this solution is incomplete.
> 
> In order to fully resolve this problem and to simplify things, this commit
> removes the mapcount solution. Instead, the scheduled worker thread is
> cancelled after interrupts have been disabled and prior to the mapping
> being freed.
> 
> Fixes: b45cdbaf9f7f ("cxlflash: Resolve oops in wait_port_offline")
> Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>

Looks good.

Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

