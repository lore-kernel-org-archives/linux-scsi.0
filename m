From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] scsi: lpfc: Add shutdown method for kexec
Date: Tue, 14 Feb 2017 13:04:46 +1100
Message-ID: <1487037886.23576.16.camel@kernel.crashing.org>
References: <20170212214920.28866-1-anton@ozlabs.org>
         <1486941294.3401.67.camel@kernel.crashing.org>
         <20170213104723.7741de0a@kryten> <87efz3hre6.fsf@xmission.com>
         <1486947669.3401.69.camel@kernel.crashing.org>
         <2fa7fc70-44d4-f536-befb-8a7849741fb7@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:39279 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750946AbdBND2h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Feb 2017 22:28:37 -0500
In-Reply-To: <2fa7fc70-44d4-f536-befb-8a7849741fb7@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Anton Blanchard <anton@samba.org>
Cc: james.smart@broadcom.com, dick.kennedy@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, jk@ozlabs.org, linux-scsi@vger.kernel.org

On Mon, 2017-02-13 at 15:57 -0600, Brian King wrote:
> If we do transition to use remove rather than shutdown, I think we
> want
> some way for a device driver to know whether we are doing kexec or
> not.
> A RAID adapter with a write cache is going to want to flush its write
> cache on a PCI hotplug remove, but for a kexec, its going to want to
> skip
> that so the kexec is faster. Today, since kexec looks like a reboot,
> rather than a shutdown, we can skip the flush on a reboot, since its
> technically not needed there either.

What happens if a non-flushed adapter gets a PERST ?

I wouldn't trust that 'don't have to flush' magic ...

Cheers,
Ben.
