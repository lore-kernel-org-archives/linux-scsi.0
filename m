From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: 24 Apr 2003 08:44:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1051188263.2010.3.camel@mulgrave>
References: <UTC200304232239.h3NMdSf07801.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:36614 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261767AbTDXMcd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Apr 2003 08:32:33 -0400
In-Reply-To: <UTC200304232239.h3NMdSf07801.aeb@smtp.cwi.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: afafc@rnl.ist.utl.pt, Alan Cox <alan@lxorguk.ukuu.org.uk>, greg@kroah.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net, mike@hingston.demon.co.uk, stelian@popies.net, torvalds@transmeta.com

On Wed, 2003-04-23 at 18:39, Andries.Brouwer@cwi.nl wrote:
> --- protocol.c~ Fri Nov 22 22:40:13 2002
> +++ protocol.c  Thu Apr 24 00:38:31 2003
> @@ -366,6 +366,8 @@
>                         srb->cmnd[2] = srb->cmnd[2];
>                         srb->cmnd[1] = srb->cmnd[1];
>                         srb->cmnd[0] = srb->cmnd[0] | 0x40;
> +                       if (srb->cmnd[8] < 8)
> +                               srb->cmnd[8] = 8;
>                         break;
>                 } /* switch (srb->cmnd[0]) */
>         } /* if (us->flags & US_FL_MODE_XLATE) */
> 
> (yes, ugly, no guarantee that the buffer is large enough).
> 
> Comments?

Yes, the buffer size thing would be my major concern too...except that
the usb layer seems to get away with doing this type of thing all over
the place.

I think I can argue that this type of thing is always safe: DMA buffers
cannot be stack allocated, and kmalloc comes in minimum units of 32
bytes, so it looks like it's ugly but should always work.

James


