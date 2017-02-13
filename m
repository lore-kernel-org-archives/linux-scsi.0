From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] scsi: lpfc: Add shutdown method for kexec
Date: Mon, 13 Feb 2017 12:01:09 +1100
Message-ID: <1486947669.3401.69.camel@kernel.crashing.org>
References: <20170212214920.28866-1-anton@ozlabs.org>
         <1486941294.3401.67.camel@kernel.crashing.org>
         <20170213104723.7741de0a@kryten> <87efz3hre6.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:50436 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751000AbdBMBBi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 12 Feb 2017 20:01:38 -0500
In-Reply-To: <87efz3hre6.fsf@xmission.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>, Anton Blanchard <anton@samba.org>
Cc: james.smart@broadcom.com, dick.kennedy@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, jk@ozlabs.org, linux-scsi@vger.kernel.org

On Mon, 2017-02-13 at 13:21 +1300, Eric W. Biederman wrote:
> > Good point, at the very least we should call remove if shutdown doesn't
> > exist. Eric: could we make the changes Ben suggests?
> 
> Definitely.  That was the original design of the kexec interface
> but people were worried about calling remove during reboot might
> introduce regressions on the reboot functionality.  So shutdown was
> added to be remove without the cleaning up the kernel data structures.

Right. Part of the problem was also that remove was dependent on CONFIG_HOTPLUG
though that's no longer the case anymore.

The problem is that a bunch of drivers either don't have a shutdown or
worse, have one that actually shuts the HW down rather than "idle" it
which puts it in a state that the new kernel can't deal with.

> I am all for changing the core to call remove.  That seems to be a more
> tested code path (because remove tends to be part of the development
> path for modules) and thus much more likely to work in practice.
> 
> The challenge with changes in this area is that when the infrastructure
> is changed for everyone someone needs to baby sit it until all of the
> unexpected issues are resolved.  I was hoping a couple of years ago that
> Ben could be that person.

Correct. And I lack time. But since we are a platform that uses kexec
daily as our main booting mechanism we should probably be the ones
driving that.

I had a patch at least to fallback to remove in absence of shutdown
which I can try to dig out.

We can add a config option to make it do the other way around that
we should start testing internally. I'm sure we will find 1 or 2
regressions as drivers do weird things.

Cheers,
Ben.
