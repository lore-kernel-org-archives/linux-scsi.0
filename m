From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH]: megaraid 2.20.4: Fixes a data corruption bug
Date: 01 Oct 2004 16:58:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096664298.1766.103.camel@mulgrave>
References: <0E3FA95632D6D047BA649F95DAB60E570230C985@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:27319 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266324AbUJAU6c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Oct 2004 16:58:32 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E570230C985@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Cc: "Mukker, Atul" <Atulm@lsil.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'bunk@fs.tum.de'" <bunk@fs.tum.de>, 'Andrew Morton' <akpm@osdl.org>, "'Matt_Domsch@dell.com'" <Matt_Domsch@dell.com>, "Ju, Seokmann" <sju@lsil.com>

On Fri, 2004-10-01 at 16:08, Bagalkote, Sreenivas wrote:
> The submitted previous version of megaraid (2.20.3.1) had 
> register_ioctl32_conversion & unregister_ioctl32_conversion 
> defined to empty statements if CONFIG_COMPAT was _not_
> defined.

I know that.  However, when the empty statements were added to
ioctl32.h, those had to be taken out of the megaraid driver.  That's
this patch in the scsi-misc-2.6 tree:

 [PATCH] megaraid warning fix
  
  The ioctl32 conversion registration stubs are in ioctl32.h now.
  
  Signed-off-by: Andrew Morton <akpm@osdl.org>

> But I think the preferred way was to have the occurances of 
> (un)register_ioctl32_conversion in the code surrounded by 
> #ifdef CONFIG_COMPAT ... #endif directly. In the kernel source
> only register_ioctl32_conversion has these #ifdef .. #endif. The
> unregister_ioctl32_conversion doesn't.

The current preferred way is to use the empty definitions in
linux/ioctl32.h which means there's no necessity for adding the #ifdef
CONFIG_COMPAT.  The correct thing is to remove the #ifdef CONFIG_COMPAT
from around the register_ioctl32... part.

James


