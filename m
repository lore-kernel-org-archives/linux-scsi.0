From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Fw: 2.6.9-rc2-mm2: 3ware card info not in /proc/scsi
Date: Fri, 24 Sep 2004 17:24:21 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4153CBA5.1050708@torque.net>
References: <20040923194322.78fb1c59.akpm@osdl.org> <1096001755.1835.1.camel@mulgrave>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:46981 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S268525AbUIXHZa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Sep 2004 03:25:30 -0400
In-Reply-To: <1096001755.1835.1.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, Adam Radford <aradford@amcc.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Thu, 2004-09-23 at 22:43, Andrew Morton wrote:
> 
>>Did this get broken?
> 
> 
> The changelog says it was deliberate:
> 
> ChangeSet 1.2212 2004/09/10 17:48:45 aradford@amcc.com
>   [PATCH] 3ware 5/6/7/8000 driver v1.26.02.000
>   
>   - Remove deprecated SCSI_IOCTL_SEND_COMMAND interface.
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

... and there goes smartmontools support until v5.34 is
released.

More generally (not just 3ware), several smartmontools
users have complained to me about the warnings sent to
their log every time smartd wakes up (30 minutes) and
checks their SCSI disks in recent 2.6 versions. One
deprecated warning should be sufficient.

>   - Remove deprecated /proc/scsi/3w-xxxx interface.
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>   - Convert entire driver to pci_driver format.
>   - Remove all mdelays, replace w/msleep to fix possible watchdog
>     timer issues.
>   - Make all register accesses macros.
>   - Remove all prototypes from header file, reorder functions to
>     eliminate all prototypes but one.
>   - Add sysfs 'queue_depth' setting attribute.
>   - Add sysfs 'stats' attribute.
>   - Fix spinlocks everywhere, remove tw_lock spinlock.
>   - Remove all bitfields, add bitmask access macros.
>   - Remove un-needed scsi_eh_abort entrypoint.  Controller does not
>     support aborting invididual IO's, scsi_eh_reset sufficient.
> 
> I presume there's an updated utility from amcc somewhere that uses the
> new sysfs interface.

 From an application maintainer's point of view sysfs is
relatively new (only in lk 2.6) and just starting to settle
down.

Doug Gilbert
