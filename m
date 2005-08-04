From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH 7/7] aacraid: sgraw command support
Date: Thu, 4 Aug 2005 07:40:58 -0400
Message-ID: <60807403EABEB443939A5A7AA8A7458B017931EB@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:37823 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262484AbVHDLnA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2005 07:43:00 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>, Mark Haverkamp <markh@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

In these cases, the 'addr' is an u64, so is it necessary to perform this
modification?

I will do a critical analysis of the remaining code in the driver for
any values that are, or have a risk of being on some platforms, a 32 bit
entity and undergo this kind of shift action.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: Arjan van de Ven [mailto:arjan@infradead.org] 
Sent: Thursday, August 04, 2005 4:17 AM
To: Mark Haverkamp
Cc: Salyzyn, Mark; linux-scsi; James Bottomley
Subject: Re: [PATCH 7/7] aacraid: sgraw command support

On Wed, 2005-08-03 at 15:39 -0700, Mark Haverkamp wrote:
> +               psg->sg[0].addr[1] = cpu_to_le32((u32)(addr>>32));

this is very risky code; if addr is a 32 bit entity, then this is
undefined behavior (which due to the vagities of x86 asm might get
optimized out entirely). It is a lot safer to do (addr>>16)>>16

gcc will optimize that just fine, the difference is that it's still
defined C behavior regardless of the type of addr.


