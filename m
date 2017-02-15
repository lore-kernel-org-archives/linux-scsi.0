From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH] scsi: lpfc: Add shutdown method for kexec
Date: Wed, 15 Feb 2017 15:44:48 +1300
Message-ID: <87y3x8895r.fsf@xmission.com>
References: <20170212214920.28866-1-anton@ozlabs.org>
        <1486941294.3401.67.camel@kernel.crashing.org>
        <20170213104723.7741de0a@kryten> <87efz3hre6.fsf@xmission.com>
        <1486947669.3401.69.camel@kernel.crashing.org>
        <2fa7fc70-44d4-f536-befb-8a7849741fb7@linux.vnet.ibm.com>
        <1487037886.23576.16.camel@kernel.crashing.org>
        <39054c0e-c0f3-a62d-2c71-469798727bfd@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out01.mta.xmission.com ([166.70.13.231]:57797 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750943AbdBOCtX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Feb 2017 21:49:23 -0500
In-Reply-To: <39054c0e-c0f3-a62d-2c71-469798727bfd@linux.vnet.ibm.com> (Brian
        King's message of "Tue, 14 Feb 2017 08:56:15 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Anton Blanchard <anton@samba.org>, james.smart@broadcom.com, dick.kennedy@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, jk@ozlabs.org, linux-scsi@vger.kernel.org

Brian King <brking@linux.vnet.ibm.com> writes:

> On 02/13/2017 08:04 PM, Benjamin Herrenschmidt wrote:
>> On Mon, 2017-02-13 at 15:57 -0600, Brian King wrote:
>>> If we do transition to use remove rather than shutdown, I think we
>>> want
>>> some way for a device driver to know whether we are doing kexec or
>>> not.
>>> A RAID adapter with a write cache is going to want to flush its write
>>> cache on a PCI hotplug remove, but for a kexec, its going to want to
>>> skip
>>> that so the kexec is faster. Today, since kexec looks like a reboot,
>>> rather than a shutdown, we can skip the flush on a reboot, since its
>>> technically not needed there either.
>> 
>> What happens if a non-flushed adapter gets a PERST ?
>
> It depends on the adapter, so it really needs to be a policy in the device
> driver. For any adapter that has a non volatile write cache, data must preserved,
> otherwise the write cache is not truly non volatile. For adapters with a volatile
> write cache, then its subject to the adapter hardware. For ipr adapters
> that have a volatile cache, they do guarantee the data is preserved across
> a PERST.
>
>> I wouldn't trust that 'don't have to flush' magic ...
>
> I really don't think we want to force RAID adapters that have gigabytes of
> *non volatile* write cache to flush their cache when we are merely performing
> a kexec. This can take several minutes in the worst case scenarios.


It is very very simple.  kexec does not guarantee what comes after it.

An optimization that skips flushing because the hardware write cache can
be trusted is fine.  An optimization that skips flushing because some
later kernel will take care of it is not.

I really don't see any room in there for distinguishing between which
kind of shutdown and/or kexec we are doing.  Either the hardware handles
it or it doesn't.

If the hardware doesn't handle everything than we need to handle it in
software.

Eric
