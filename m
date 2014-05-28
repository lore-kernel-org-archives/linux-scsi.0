From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: mpt2sas: mpt2sas_base.c:  Fix for possible null
 pointer dereference
Date: Wed, 28 May 2014 04:26:28 -0700
Message-ID: <20140528112628.GB11953@infradead.org>
References: <1400429439-11184-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1400429439-11184-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-kernel-owner@vger.kernel.org
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com, "James E.J. Bottomley" <JBottomley@parallels.com>, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> -	ioc_status = le16_to_cpu(mpi_reply->IOCStatus) & MPI2_IOCSTATUS_MASK;
> +	if (mpi_reply) {
> +		ioc_status = le16_to_cpu(mpi_reply->IOCStatus) & MPI2_IOCSTATUS_MASK;
> +	}
>  
>  	if (ioc_status != MPI2_IOCSTATUS_SUCCESS)
>  		ioc->port_enable_failed = 1;

ioc_status isn't initialized without the reply and used here as well
as later in the function.  I think we'll need input from LSI or others
with the spec on what to do when we didn't get a reply.
