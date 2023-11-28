Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2436312E42
	for <linux-scsi@vger.kernel.org>; Tue, 28 Nov 2023 07:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KLWkGSYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BDE4C433C7;
	Tue, 28 Nov 2023 07:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701157669;
	bh=38Nk6P7m+Ikq4jxtOyRafI5IYebw+Msg4XoJm9PVrj4=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=KLWkGSYhU1wycxfGMY/GpyJ9ZCU8LIj5Se1Fr1JmPSjPuVosONcudsegUuQjZo4zH
	 /Ac2Qo7Hv6SLmYf0PbDbn4R8O88hhXjhWY8yeT7o1Mx4vGEjrMTdGfxn2vqGGLNhXT
	 DHY7Ey+DWBNA2vIp2I9I2YtIcKcgeNvAEqr/rCNUhb16jtqydfTE4HDOGbsqs64mOH
	 B5nZzPeR3YRP2pCjQLrU4tV0uHelX4v/3abM7RQJhG5Phy4NQr0A3+BxWJFWNiM711
	 AIQGcHgbUrBJ+ckUfdAlLTtqlvNXWQavZvyQPa0SBk/dhZeQKfgQS1Q4dvdmIV6sMY
	 Lf0owmtpg9H0A==
Message-ID: <e02dbbcc-7117-4c56-8a79-68620bb431db@kernel.org>
Date: Tue, 28 Nov 2023 16:47:47 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Bug 218198] New: Suspend/Resume Regression with attached ATA
 devices
To: bugzilla-daemon@kernel.org, linux-scsi@vger.kernel.org
References: <bug-218198-11613@https.bugzilla.kernel.org/>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <bug-218198-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/28/23 16:06, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=218198
> 
>             Bug ID: 218198
>            Summary: Suspend/Resume Regression with attached ATA devices
>            Product: SCSI Drivers
>            Version: 2.5
>           Hardware: Intel
>                 OS: Linux
>             Status: NEW
>           Severity: high
>           Priority: P3
>          Component: Other
>           Assignee: scsi_drivers-other@kernel-bugs.osdl.org
>           Reporter: dmummenschanz@web.de
>         Regression: No
> 
> Hello,
> 
> the following commit from Kernel 6.7-rc1:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/diff/drivers/ata/libata-core.c?id=d035e4eb38b3ea5ae9ead342f888fd3c394b0fe0
> 
> introduced a regression on my system where after successful resuming the CPU
> won't enter lower Package Sates below pc2 even after letting it sit for 15+
> minutes. Reverting this commit fixed the issue on my system with two ata
> drives. Anyone experiencing the same issue? 
> 
> I'm happy to try any troubleshooting steps or provide more details if needed.

Could you try adding this:

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 09ed67772fae..8d4871fff099 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6185,6 +6185,9 @@ void ata_pci_shutdown_one(struct pci_dev *pdev)
        for (i = 0; i < host->n_ports; i++) {
                struct ata_port *ap = host->ports[i];

+               /* Wait for EH to complete before freezing the port */
+               ata_port_wait_eh(ap);
+
                ap->pflags |= ATA_PFLAG_FROZEN;

                /* Disable port interrupts */

and see if this changes anything ? Beside that, I am at a loss seeing what is
going on. The commit you mention essentially reverted an earlier change that is
not necessary, bringing back ata_pci_shutdown_one() to the how it was for ages...

When you say "successful resuming", what exactly are you talking about ? System
resume from suspend-to-ram ? from hibernation (suspend to disk) ?

I can always revert this revert, but I would rather understand why that is
needed. Do you see any suspicious libata EH activity in dmesg ?

Also, are the lower Package Sates transitions automatic or driven by the kernel
PM core ? I do not know that. If it is the latter, does the pc2 state also
include adapters ? Isn't it limited to the CPU power state ? I ask because if it
is and libata EH is in a bad loop constantly running after resume, that would
explain why you cannot reach a lower CPU power state.

-- 
Damien Le Moal
Western Digital Research

