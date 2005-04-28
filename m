From: Andrew Morton <akpm@osdl.org>
Subject: Re: latest mpt-fusion oopses
Date: Thu, 28 Apr 2005 14:43:10 -0700
Message-ID: <20050428144310.40024a82.akpm@osdl.org>
References: <91888D455306F94EBD4D168954A9457C0225D051@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:9124 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S262235AbVD1Vnp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Apr 2005 17:43:45 -0400
In-Reply-To: <91888D455306F94EBD4D168954A9457C0225D051@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com

"Moore, Eric Dean" <Eric.Moore@lsil.com> wrote:
>
> Ok - The problem is the module_init entry point for
> mptbase.ko is not being called when the driver is statically
> compiled into the kernel.

That doesn't sound right.  The kernel will call that module_init() function
for statically linked things.

This came out:

	"Fusion MPT SPI Host driver 3.03.00"

So fusion_init() is being called.  Maybe the problem is that fusion_init()
is being called at the wrong time.

That doesn't sound right either.  This:

	"SCSI subsystem initialized"

is coming out earlier on, as one would expect with a subsys_initcall().

Ho-hum.  You'll work it out ;)

> I guess I will have to have the scsi lld drivers registering the pci ids
> call mptbase.c module_init function, and maintain a flag so
> its not called more that once.

You can shuffle the ordering of these things with late_initcall(), etc.
