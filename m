From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: Fw: gdth SCSI driver(?) fails with more than 4GB of memory
Date: Tue, 18 Jul 2006 08:40:11 +0200
Message-ID: <200607180840.11877.eike-kernel@sf-tec.de>
References: <20060717184659.04ae83e7.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:17811 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S932071AbWGRGjN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jul 2006 02:39:13 -0400
In-Reply-To: <20060717184659.04ae83e7.akpm@osdl.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org, Andreas Barth <aba@not.so.argh.org>

Andreas Barth wrote:

> [please Cc me, I'm currently not subscribed.]

> I have noticed that one of my boxes stopped to boot correctly after
> adding more memory (in total 6 GB) and loading an adjusted kernel for
> that.  After some testing around, we noticed that it is enough for the
> kernel to boot correctly if we limit the kernel to use 4GB of memory.
>
> If the kernel has 6GB, I directly get error messages like:
> SCSI device sda: 143299800 512-byte hdwr sectors (73369 MB)
> sda: Write Protect is off
> sda: got wrong page
> sda: assuming drive cache: write through
> SCSI device sda: 143299800 512-byte hdwr sectors (73369 MB)
> sda: Write Protect is off
> sda: got wrong page

This is from sd.c::sd_read_cache_type

> Any hints for me how I can use the full 6 GB of memory (and/or what I
> should try out to find the bug)?

Please change the printk in sd.c around 1482 that is

printk(KERN_ERR "%s: got wrong page\n", diskname);

to

printk(KERN_ERR "%s: got wrong page (expect: 0x%x, got 0x%x)\n",
diskname, modepage, buffer[offset]);

so we can see at least the reason that made it finally fail.

Eike
