From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: lpfc: fix calls to dma_set_mask_and_coherent()
Date: Tue, 12 Feb 2019 10:34:52 -0800
Message-ID: <20190212183452.GA25206@infradead.org>
References: <20190211150502.9999-1-emilne@redhat.com>
 <20190212080627.GC10547@infradead.org>
 <9572ae3b0131ad1c74d6a775f819437e3d4f1795.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9572ae3b0131ad1c74d6a775f819437e3d4f1795.camel@redhat.com>
Sender: stable-owner@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, stable@vger.kernel.org, james.smart@broadcom.com, dick.kennedy@broadcom.com, martin.petersen@oracle.com, jejb@linux.ibm.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 12, 2019 at 10:37:45AM -0500, Ewan D. Milne wrote:
> 
> It looks like this would introduce a different problem.  "error" is set to
> -ENODEV earlier in the two functions so that the various error paths will return
> that value.  If it is overwritten with a successful result from the call to
> dma_set_mask_and_coherent() but a later call to e.g. ioremap() fails, the
> functions will incorrectly return a value indicating that they have succeeded.
> 
> It also appears as if the patches to hptiop, hisi_sas and bfa need to be fixed up.
> I don't have a test environment for these, although I might be able to modify the
> test environment for bfa.  Martin/James, what about the others?

I don't have a test environment for them either, and I doubt many
people have.  If you don't feel comfortable I can send a fix for
them.
