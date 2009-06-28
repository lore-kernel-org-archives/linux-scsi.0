From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] SCSI: userspace cannot use scsi_command_size_tbl, COMMAND_SIZE
 and scsi_device_type
Date: Sun, 28 Jun 2009 17:09:35 +0300
Message-ID: <4A47799F.5050007@panasas.com>
References: <1246122359.32198.7.camel@hpdv5.satnam>	 <1246123628.3990.19.camel@mulgrave.site>	 <1246125388.32198.14.camel@hpdv5.satnam>	 <20090627182821.GC5480@parisc-linux.org>	 <1246128039.32198.17.camel@hpdv5.satnam> <1246197124.4190.5.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:4676
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751102AbZF1OJg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Jun 2009 10:09:36 -0400
In-Reply-To: <1246197124.4190.5.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, Matthew Wilcox <matthew@wil.cx>, Sam Ravnborg <sam@ravnborg.org>, Benny Halevy <bhalevy@panasas.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Smart <James.Smart@Emulex.Com>, Andrew Morton <akpm@linux-foundation.org>, Randy Dunlap <rdunlap@xenotime.net>

On 06/28/2009 04:52 PM, James Bottomley wrote:
> On Sun, 2009-06-28 at 00:10 +0530, Jaswinder Singh Rajput wrote:
>> On Sat, 2009-06-27 at 12:28 -0600, Matthew Wilcox wrote:
>>> On Sat, Jun 27, 2009 at 11:26:28PM +0530, Jaswinder Singh Rajput wrote:
>>>>> On Sat, 2009-06-27 at 22:35 +0530, Jaswinder Singh Rajput wrote:
>>>>>> userspace cannot use scsi_command_size_tbl, COMMAND_SIZE
>>>>>> and scsi_device_type defined in kernel
>>> When did we start exporting include/scsi to userspace?  I thought glibc
>>> had its own separate definitions.
>>>
>> commit 9e4f5e29610162fd426366f3b29e3cc6e575b858
>> Author: James Smart <James.Smart@Emulex.Com>
>> Date:   Thu Mar 26 13:33:19 2009 -0400
>>
>>     [SCSI] FC Pass Thru support
> 
> That's what you get from a simplistic view.
> 
> If you look at the full history, scsi.h and sg.h were exported in 2006
> by the initial commit by David Woodhouse
> 
> commit 8555255f0b426858d8648c6206b70eb906cf4ec7
> Author: David Woodhouse <dwmw2@infradead.org>
> Date:   Sun Jun 18 12:14:01 2006 +0100
> 
>     Add generic Kbuild files for 'make headers_install'
> 
> They were unexported again a year later, apparently on grounds of
> clashing with /usr/include/scsi from glibc:
> 
> commit e629a7ddc0188e1bb9e956e698a9bd00c19c9854
> Author: Olaf Hering <olh@suse.de>
> Date:   Tue Oct 16 23:27:01 2007 -0700
> 
>     do not export /usr/include/scsi in make headers_install
> 
> So perhaps the meta question is how are we supposed to resolve this?
> Glibc ceded it's copy of /usr/include/linux to the kernel headers
> package, so it looks to be an oversight that it still
> retains /usr/include/scsi (there's nothing extra in there in glibc
> beyond what SCSI exports).
> 
> James
> 
> 

Right! so a good strategy might be to first fix up the header for proper
user-mode consumption. And then just let glibc eventually drop their scsi.h
header once enough complains register.

Though out of courtesy someone might send a patch to the glibc maintainers to
remove that header. Andrew do you have any passed experience with this project?

I agree that Kernel should get back control of this header.

Boaz
