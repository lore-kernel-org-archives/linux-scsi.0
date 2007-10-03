From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 21/21] advansys: Changes to work on parisc
Date: Tue, 02 Oct 2007 22:28:29 -0400
Message-ID: <4702FE4D.4030603@garzik.org>
References: <11913765421743-git-send-email-matthew@wil.cx> <11913765432770-git-send-email-matthew@wil.cx> <4702F7B2.7080600@garzik.org> <20071003021545.GD12049@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:34975 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753433AbXJCC2a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Oct 2007 22:28:30 -0400
In-Reply-To: <20071003021545.GD12049@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

Matthew Wilcox wrote:
> On Tue, Oct 02, 2007 at 10:00:18PM -0400, Jeff Garzik wrote:
>> Matthew Wilcox wrote:
>>> -#define PortAddr                 unsigned short	/* port address size 
>>> */
>>> +#define PortAddr                 unsigned int	/* port address size 
>>> */
>>> #define inp(port)                inb(port)
>>> #define outp(port, byte)         outb((byte), (port))
>> everybody just uses unsigned long these days...  any reason using 
>> unsigned long would be harmful?
> 
> inb/outb use signed int for port addresses ...

Incorrect.  That is highly platform specific, with many using unsigned 
long, since the [non-x86] platform is generally pointing to a special 
memory region rather than directly using an x86-like instruction.

unsigned long is the portable size to use, because it is guaranteed to 
work on all platforms.

unsigned int means you exclude powerpc[64], alpha, sparc64, sh, ... 
it's not portable, unlike unsigned long.

	Jeff


