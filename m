From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: lpfc: Add shutdown method for kexec
Date: Mon, 13 Feb 2017 15:57:22 -0600
Message-ID: <2fa7fc70-44d4-f536-befb-8a7849741fb7@linux.vnet.ibm.com>
References: <20170212214920.28866-1-anton@ozlabs.org>
 <1486941294.3401.67.camel@kernel.crashing.org>
 <20170213104723.7741de0a@kryten> <87efz3hre6.fsf@xmission.com>
 <1486947669.3401.69.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34168 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752127AbdBMV53 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Feb 2017 16:57:29 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v1DLrcdK071376
        for <linux-scsi@vger.kernel.org>; Mon, 13 Feb 2017 16:57:28 -0500
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
        by mx0a-001b2d01.pphosted.com with ESMTP id 28kk8mv4t1-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 13 Feb 2017 16:57:28 -0500
Received: from localhost
        by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
        Mon, 13 Feb 2017 16:57:27 -0500
In-Reply-To: <1486947669.3401.69.camel@kernel.crashing.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Anton Blanchard <anton@samba.org>
Cc: james.smart@broadcom.com, dick.kennedy@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, jk@ozlabs.org, linux-scsi@vger.kernel.org

On 02/12/2017 07:01 PM, Benjamin Herrenschmidt wrote:
> On Mon, 2017-02-13 at 13:21 +1300, Eric W. Biederman wrote:
>>> Good point, at the very least we should call remove if shutdown doesn't
>>> exist. Eric: could we make the changes Ben suggests?
>>
>> Definitely.  That was the original design of the kexec interface
>> but people were worried about calling remove during reboot might
>> introduce regressions on the reboot functionality.  So shutdown was
>> added to be remove without the cleaning up the kernel data structures.
> 
> Right. Part of the problem was also that remove was dependent on CONFIG_HOTPLUG
> though that's no longer the case anymore.
> 
> The problem is that a bunch of drivers either don't have a shutdown or
> worse, have one that actually shuts the HW down rather than "idle" it
> which puts it in a state that the new kernel can't deal with.

If we do transition to use remove rather than shutdown, I think we want
some way for a device driver to know whether we are doing kexec or not.
A RAID adapter with a write cache is going to want to flush its write
cache on a PCI hotplug remove, but for a kexec, its going to want to skip
that so the kexec is faster. Today, since kexec looks like a reboot,
rather than a shutdown, we can skip the flush on a reboot, since its
technically not needed there either.

-Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center
