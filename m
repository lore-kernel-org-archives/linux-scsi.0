From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] kill obsolete typedefs and wrappers from tmscsim
Date: Fri, 25 Jun 2004 11:50:22 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040625095022.GA28822@lst.de>
References: <20040624081510.GA7950@lst.de> <Pine.LNX.4.60.0406242247500.4258@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:40901 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S266652AbUFYJuZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jun 2004 05:50:25 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0406242247500.4258@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Fri, Jun 25, 2004 at 12:44:56AM +0200, Guennadi Liakhovetski wrote:
> Why don't we remove all UCHAR / USHORT / UINT / ULONG... types altogether? 

One thing at a time, the patch is already huge enough.

> PUCHAR == (UCHAR*), and you replace PUCHAR with (u8*), although it is not 
> obvious, that UCHAR == u8... I know, many scsi (at least) drivers use 
> them, and each of them defines them itself, but... As well as all those 
> PACB, PSRB, PDCB,...

That'll happen sooner or later :)

> >-    ptr = (PSCSI_INQDATA) (pcmd->request_buffer);
> >-    if( pcmd->use_sg )
> >-	ptr = (PSCSI_INQDATA) (page_address(((PSGL) ptr)->page) + ((PSGL) 
> >ptr)->offset);
> >+    if (pcmd->use_sg) {
> >+	    ptr2 = (struct scatterlist *) ptr;
> >+	    ptr = (PSCSI_INQDATA) (page_address(ptr2->page) + ptr2->offset);
> >+    } else
> >+	    ptr = (PSCSI_INQDATA) (pcmd->request_buffer);
> >
> >    DEBUG0(printk (" SRBdone (%02x,%08x), SRB %p, pid %li\n", status, 
> >    pcmd->result,\
> >		pSRB, pcmd->pid));
> 
> This seems a typo (ptr uninitialised).

Indeed, thanks.  I wonder why gcc didn't spit a warning.

> Attaching a new, extended, and, hopefully, fixed version of your patch. 
> Please, have a look. I think, it is better to push all this cleanup as a 
> single patch, even though it looks horribly big... It compiles, will 
> run-test tomorrow (well, already today, but in about 20 hours).

We hsould probably call the types dc390_acb and dc390_dcb instead of the
shouting names?  Or maybe even better dc390_hba and dc390_lun so the
names are descriptive?

