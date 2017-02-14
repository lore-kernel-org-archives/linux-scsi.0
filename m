From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: lpfc: Add shutdown method for kexec
Date: Tue, 14 Feb 2017 08:56:15 -0600
Message-ID: <39054c0e-c0f3-a62d-2c71-469798727bfd@linux.vnet.ibm.com>
References: <20170212214920.28866-1-anton@ozlabs.org>
 <1486941294.3401.67.camel@kernel.crashing.org>
 <20170213104723.7741de0a@kryten> <87efz3hre6.fsf@xmission.com>
 <1486947669.3401.69.camel@kernel.crashing.org>
 <2fa7fc70-44d4-f536-befb-8a7849741fb7@linux.vnet.ibm.com>
 <1487037886.23576.16.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42736 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751376AbdBNO4V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Feb 2017 09:56:21 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v1EEsmRD044291
        for <linux-scsi@vger.kernel.org>; Tue, 14 Feb 2017 09:56:20 -0500
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
        by mx0b-001b2d01.pphosted.com with ESMTP id 28m24pngv6-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 14 Feb 2017 09:56:20 -0500
Received: from localhost
        by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
        Tue, 14 Feb 2017 07:56:19 -0700
In-Reply-To: <1487037886.23576.16.camel@kernel.crashing.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Anton Blanchard <anton@samba.org>
Cc: james.smart@broadcom.com, dick.kennedy@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, jk@ozlabs.org, linux-scsi@vger.kernel.org

On 02/13/2017 08:04 PM, Benjamin Herrenschmidt wrote:
> On Mon, 2017-02-13 at 15:57 -0600, Brian King wrote:
>> If we do transition to use remove rather than shutdown, I think we
>> want
>> some way for a device driver to know whether we are doing kexec or
>> not.
>> A RAID adapter with a write cache is going to want to flush its write
>> cache on a PCI hotplug remove, but for a kexec, its going to want to
>> skip
>> that so the kexec is faster. Today, since kexec looks like a reboot,
>> rather than a shutdown, we can skip the flush on a reboot, since its
>> technically not needed there either.
> 
> What happens if a non-flushed adapter gets a PERST ?

It depends on the adapter, so it really needs to be a policy in the device
driver. For any adapter that has a non volatile write cache, data must preserved,
otherwise the write cache is not truly non volatile. For adapters with a volatile
write cache, then its subject to the adapter hardware. For ipr adapters
that have a volatile cache, they do guarantee the data is preserved across
a PERST.

> I wouldn't trust that 'don't have to flush' magic ...

I really don't think we want to force RAID adapters that have gigabytes of
*non volatile* write cache to flush their cache when we are merely performing
a kexec. This can take several minutes in the worst case scenarios.

-Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center
