From: Arjan van de Ven <arjan@infradead.org>
Subject: RE: [ANNOUNCE][PATCH 2.6.11 2/3] megaraid_sas: Announcing new mod
	ule  for LSI Logic's SAS based MegaRAID controllers
Date: Wed, 09 Mar 2005 19:19:35 +0100
Message-ID: <1110392376.6280.139.camel@laptopd505.fenrus.org>
References: <0E3FA95632D6D047BA649F95DAB60E570230CC20@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from pentafluge.infradead.org ([213.146.154.40]:51586 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262045AbVCISTn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Mar 2005 13:19:43 -0500
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E570230CC20@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, 'James Bottomley' <James.Bottomley@SteelEye.com>, "'Matt_Domsch@Dell.com'" <Matt_Domsch@Dell.com>, Andrew Morton <akpm@osdl.org>, 'Christoph Hellwig' <hch@infradead.org>

On Wed, 2005-03-09 at 12:44 -0500, Bagalkote, Sreenivas wrote:
> >> >
> >> >> . And since this is compile time
> >> >> system-wide property, I kept it as driver global.
> >> >
> >> >that step I don't understand... why is it a global 
> >*VARIABLE* if it's
> >> >compile time system-wide property...
> >> >
> >> 
> >> I see your point! Are you saying I should use 
> >if(sizeof(dma_addr_t)==8)
> >> instead of the shortcut if(is_dma64)? 
> >yep
> >well you can use a preprocessor define of something to make it slightly
> >more readable (eg shortcut) if you want, but that's what I mean yeah..
> >
> >gcc will optimize the entire unused code away this way, including the
> >actual conditional jump, so for performance and bloat-ness 
> >point of view
> >it's nice.... and of course generic design beauty ;)
> >
> 
> Great. Thanks! I will change it. If I understand you correctly, I should
> #define IS_DMA64 (sizeof(dma_addr_t)==8).

that's one way to do it yeah.
> 
> Is this better than declaring is_dma64 global variable const? (Excuse the
> oxymoron).

in C yes; in C "const" doesn't quite mean what you want it to mean with
this and as a result gcc I think can't optimize this the way it can with
the define.


