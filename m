From: Arjan van de Ven <arjan@fenrus.demon.nl>
Subject: Re: Help: strange messages from kernel on IA64 platform
Date: Wed, 12 Jul 2006 15:07:11 +0200
Message-ID: <1152709632.3217.39.camel@laptopd505.fenrus.org>
References: <20060712081614.765261C013@mail2-sv.soft.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from a222036.upc-a.chello.nl ([62.163.222.36]:59300 "EHLO
	laptopd505.fenrus.org") by vger.kernel.org with ESMTP
	id S1750799AbWGLNHS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jul 2006 09:07:18 -0400
In-Reply-To: <20060712081614.765261C013@mail2-sv.soft.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sakurai Hiroomi <sakurai_hiro@soft.fujitsu.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 2006-07-12 at 17:19 +0900, Sakurai Hiroomi wrote:
> Hi,
> 
> I saw same message.
> 
> When GAM(Global Array Manager) is started, The following message output.
> kernel: kernel unaligned access to 0xe0000001fe1080d4, ip=0xa000000200053371

first of all you should file a bug against this kernel; the kernel
should not printk about unaligned accesses by default!

> 
> The uioc structure used by ioctl is defined by packed,
> the allignment of each member are disturbed.
> In a 64 bit structure, the allignment of member doesn't fit 64 bit
> boundary. this causes this messages.
> In a 32 bit structure, we don't see the message because the allinment
> of member fit 32 bit boundary even if packed is specified. 
> 
> patch
> I Add 32 bit dummy member to fit 64 bit boundary. I tested.
> We confirmed this patch fix the problem by IA64 server.


this changes the calling convention of this structure!
If there is no strict calling convention, then the packed can be
removed, but if there is your patch changes the ABI!!
(and you could then fix it by using get_unaligned() in the places that
use this field)
