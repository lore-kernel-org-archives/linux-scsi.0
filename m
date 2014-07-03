From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: [PATCH] scsi: mpt2sas: mpt2sas_base.c:  Fix for possible null
 pointer dereference
Date: Thu, 3 Jul 2014 13:45:22 -0400
Message-ID: <alpine.DEB.2.02.1407031331520.9641@jlaw-desktop.mno.stratus.com>
References: <1400429439-11184-1-git-send-email-rickard_strandqvist@spectrumdigital.se> <20140528112628.GB11953@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140528112628.GB11953@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com, "James E.J. Bottomley" <JBottomley@parallels.com>, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 28 May 2014, Christoph Hellwig wrote:

> > -	ioc_status = le16_to_cpu(mpi_reply->IOCStatus) & MPI2_IOCSTATUS_MASK;
> > +	if (mpi_reply) {
> > +		ioc_status = le16_to_cpu(mpi_reply->IOCStatus) & MPI2_IOCSTATUS_MASK;
> > +	}
> >  
> >  	if (ioc_status != MPI2_IOCSTATUS_SUCCESS)
> >  		ioc->port_enable_failed = 1;
> 
> ioc_status isn't initialized without the reply and used here as well
> as later in the function.  I think we'll need input from LSI or others
> with the spec on what to do when we didn't get a reply.

Any update on this? 

The mpt3 version checks for !mpi_reply and returns 1.  Which leads to 
another question -- should mpt{2,3}sas_port_enable_done ever return 0 (as their 
respective comments describe)?

Regards,

-- Joe
