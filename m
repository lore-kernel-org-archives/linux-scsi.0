From: Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH] fix sym2 negotiation
Date: Wed, 25 Aug 2004 22:11:29 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040825121129.GP2306@krispykreme>
References: <1093113450.1732.334.camel@mulgrave> <20040824132936.GA25263@suse.de> <20040824203914.GA25755@us.ibm.com> <20040824205126.GA10105@suse.de> <20040825065747.GA2275@us.ibm.com> <20040825092541.GA15466@suse.de> <20040825115819.GE16196@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:64952 "EHLO ozlabs.org")
	by vger.kernel.org with ESMTP id S267235AbUHYMLq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Aug 2004 08:11:46 -0400
Content-Disposition: inline
In-Reply-To: <20040825115819.GE16196@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: Olaf Hering <olh@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>


> > This broken chip seems to be so popular on PPC64 that the arch maintainers
> > want a PPC64 specific default. Oh well ...
> > 
> > +/* Some AChip ARC765 based DVD-ROM's take 15 or more seconds
> > + * to reset.  A scan will fail if made right after a reset.
> > + * It's completely broken device behaviour: SCSI specification
> > + * says devices need to be able to respond to INQUIRY always
> > + * (after a selection timeout ... of 250ms).
> > + */
> > +#ifdef __powerpc64__
> > +static unsigned int scsi_inq_timeout = SCSI_TIMEOUT/HZ+25;
> > +#else
> >  static unsigned int scsi_inq_timeout = SCSI_TIMEOUT/HZ+3;
> > +#endif
> >  
> >  module_param_named(inq_timeout, scsi_inq_timeout, int, S_IRUGO|S_IWUSR);
> >  MODULE_PARM_DESC(inq_timeout, 
> 
> How about hacking the ppc64 bootloader to always pass inq_timeout=30 instead?

Alternatively make scsi_inq_timeout non static and we can tweak this at
boot in ppc64 arch code. Assuming we no longer use these POS drives we
can avoid bumping the value on new machines.

Anton
