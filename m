From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [BUG?] 2.5.71 removed request_module("scsi_hostadapter")
Date: Thu, 17 Jul 2003 11:31:58 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030717113158.B18620@infradead.org>
References: <200307161145.h6GBjaSi025681@harpo.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200307161145.h6GBjaSi025681@harpo.it.uu.se>; from mikpe@csd.uu.se on Wed, Jul 16, 2003 at 01:45:36PM +0200
To: Mikael Pettersson <mikpe@csd.uu.se>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 16, 2003 at 01:45:36PM +0200, Mikael Pettersson wrote:
> While trying to figure out why my SCSI modules don't autoload
> properly in 2.6.0-test1 and late 2.5 kernels, I found that
> patch-2.5.71 removed scsi.c's request_module("scsi_hostadapter").
> It seems that some driver model conversion changed scsi_register_device()
> to scsi_register_{driver,interface}(), but the latter don't do
> anything wrt autoloading the host adapter.
> 
> Is this an oversight or is it intensional?

It's intentional.

> I can probably work around this through "install" command
> kludgery in /etc/modprobe.conf, but that's (a) is ugly, and
> (b) probably won't work for configs with built-in SCSI core
> but modular host adapter.

builtin scsi core doesn't matter for this at all, the question
is whether the highlevel drivers are compiled in or not.

modular highlevel driver(s)

	simples postinst in old-style modules.conf (or some rusty equivalent)

builtin highlevel driver(s)

	the request_module is useless anyway as it happens before root is
	mounted.
