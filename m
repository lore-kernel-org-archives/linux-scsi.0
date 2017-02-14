From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH] scsi: lpfc: Add shutdown method for kexec
Date: Tue, 14 Feb 2017 15:45:30 +1300
Message-ID: <874lzx32yd.fsf@xmission.com>
References: <20170212214920.28866-1-anton@ozlabs.org>
        <1486941294.3401.67.camel@kernel.crashing.org>
        <20170213104723.7741de0a@kryten> <87efz3hre6.fsf@xmission.com>
        <1486947669.3401.69.camel@kernel.crashing.org>
        <2fa7fc70-44d4-f536-befb-8a7849741fb7@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out02.mta.xmission.com ([166.70.13.232]:54804 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751324AbdBNCuE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Feb 2017 21:50:04 -0500
In-Reply-To: <2fa7fc70-44d4-f536-befb-8a7849741fb7@linux.vnet.ibm.com> (Brian
        King's message of "Mon, 13 Feb 2017 15:57:22 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Anton Blanchard <anton@samba.org>, james.smart@broadcom.com, dick.kennedy@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, jk@ozlabs.org, linux-scsi@vger.kernel.org

Brian King <brking@linux.vnet.ibm.com> writes:

> On 02/12/2017 07:01 PM, Benjamin Herrenschmidt wrote:
>> On Mon, 2017-02-13 at 13:21 +1300, Eric W. Biederman wrote:
>>>> Good point, at the very least we should call remove if shutdown doesn't
>>>> exist. Eric: could we make the changes Ben suggests?
>>>
>>> Definitely.  That was the original design of the kexec interface
>>> but people were worried about calling remove during reboot might
>>> introduce regressions on the reboot functionality.  So shutdown was
>>> added to be remove without the cleaning up the kernel data structures.
>> 
>> Right. Part of the problem was also that remove was dependent on CONFIG_HOTPLUG
>> though that's no longer the case anymore.
>> 
>> The problem is that a bunch of drivers either don't have a shutdown or
>> worse, have one that actually shuts the HW down rather than "idle" it
>> which puts it in a state that the new kernel can't deal with.
>
> If we do transition to use remove rather than shutdown, I think we want
> some way for a device driver to know whether we are doing kexec or not.
> A RAID adapter with a write cache is going to want to flush its write
> cache on a PCI hotplug remove, but for a kexec, its going to want to skip
> that so the kexec is faster. Today, since kexec looks like a reboot,
> rather than a shutdown, we can skip the flush on a reboot, since its
> technically not needed there either.

This doesn't make any sense.

With a PCI hotplug remove you can't do anything because by the time you
get the event the hardware is gone.  I think there are optional
interlocks but nothing as good as the old 3.5" floppy disk button, or
the button on CD drives.

The only difference ever that should exist between shutdown and remove
is do you clean up kernel data structures.  The shutdown method is
allowed to skip the cleanup up kernel data structures that the remove
method needs to make.

Assuming the kernel does not have corrupted data structures I don't see
any practical reason for distinguishing between the two.  There may be
some real world gotchas we have to deal with but semantically I don't
see any concerns.

Eric
