From: Mark Haverkamp <markh@osdl.org>
Subject: RE: [PATCH 7/7] aacraid: sgraw command support
Date: Fri, 05 Aug 2005 07:24:40 -0700
Message-ID: <1123251881.6548.8.camel@markh1.pdx.osdl.net>
References: <60807403EABEB443939A5A7AA8A7458B017931EB@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:40619 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S263044AbVHEOZD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Aug 2005 10:25:03 -0400
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B017931EB@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <mark_salyzyn@adaptec.com>, Arjan van de Ven <arjan@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

On Thu, 2005-08-04 at 07:40 -0400, Salyzyn, Mark wrote:
> In these cases, the 'addr' is an u64, so is it necessary to perform this
> modification?

Arjan,

Do you agree with the above?  If so, is the patch OK as is?

Thanks,
Mark.

> 
> I will do a critical analysis of the remaining code in the driver for
> any values that are, or have a risk of being on some platforms, a 32 bit
> entity and undergo this kind of shift action.
> 
> Sincerely -- Mark Salyzyn
> 
> -----Original Message-----
> From: Arjan van de Ven [mailto:arjan@infradead.org] 
> Sent: Thursday, August 04, 2005 4:17 AM
> To: Mark Haverkamp
> Cc: Salyzyn, Mark; linux-scsi; James Bottomley
> Subject: Re: [PATCH 7/7] aacraid: sgraw command support
> 
> On Wed, 2005-08-03 at 15:39 -0700, Mark Haverkamp wrote:
> > +               psg->sg[0].addr[1] = cpu_to_le32((u32)(addr>>32));
> 
> this is very risky code; if addr is a 32 bit entity, then this is
> undefined behavior (which due to the vagities of x86 asm might get
> optimized out entirely). It is a lot safer to do (addr>>16)>>16
> 
> gcc will optimize that just fine, the difference is that it's still
> defined C behavior regardless of the type of addr.
> 

-- 
Mark Haverkamp <markh@osdl.org>

