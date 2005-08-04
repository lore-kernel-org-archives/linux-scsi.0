From: Arjan van de Ven <arjan@infradead.org>
Subject: RE: [PATCH 6/7] aacraid: unlock around kfree
Date: Thu, 04 Aug 2005 14:34:39 +0200
Message-ID: <1123158880.3318.18.camel@laptopd505.fenrus.org>
References: <60807403EABEB443939A5A7AA8A7458B017931F1@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:54416 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262493AbVHDMew (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2005 08:34:52 -0400
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B017931F1@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Haverkamp <markh@osdl.org>, James Bottomley <James.Bottomley@SteelEye.com>

On Thu, 2005-08-04 at 08:04 -0400, Salyzyn, Mark wrote:
> Cool! Thanks for the information! Sounds like the patch will be
> necessary. However, I have never seen the issue bite us, but who knows,
> it may be the contributor to a system lockup after 8000 hours of uptime
> ... I'd prefer the paranoid delusion and a stable system!
> 
> As for the GFP_ATOMIC, the intent is to move the kmalloc w/GFP_ATOMIC
> from inside the loop to outside the loop and perform a guestimate+ on
> the possible pool requirements of the loop. 

the big gain is if you can get rid of the atomic. Anything else is
pointless really... atomic allocations are *really* bad for the vm and
should be avoided if at all possible.



