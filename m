From: "Bagalkote, Sreenivas" <Sreenivas.Bagalkote@engenio.com>
Subject: RE: ioctls, etc. (was Re: [PATCH 1/4] sas: add flag for locally a
	ttached PHYs)
Date: Fri, 21 Oct 2005 08:32:25 -0400
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57060CD291@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:39162 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S964915AbVJUMcu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Oct 2005 08:32:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Jeff Garzik' <jgarzik@pobox.com>, dougg@torque.net
Cc: andrew.patterson@hp.com, Luben Tuikov <luben_tuikov@adaptec.com>, Christoph Hellwig <hch@lst.de>, "Moore, Eric Dean" <Eric.Moore@lsil.com>, jejb@steeleye.com, linux-scsi@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>

>Jeff Garzik wrote:
>> Do you know where there are some clear guidelines on the use of 
>> pointers in a structure passed to an ioctl to lessen (or bypass) 
>> 32<->64 compat ioctl thunking?
>
>Its impossible.  If you pass pointers, you need to thunk.  
>(Not even passing pointers via sysfs can avoid this.)  
>Consider running a 32-bit app (with 32-bit pointers and 32-bit 
>ABI) on a 64-bit kernel.

The drivers/scsi/megaraid/megaraid_mm.c simply calls regular ioctl
from within the compat_ioctl, though it does copy to and from the
userland pointers. This is done by adding appropriate padding.

Sincerely,
Sreenivas
