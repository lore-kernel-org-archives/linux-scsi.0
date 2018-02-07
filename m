From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 04/13] lpfc: Add push-to-adapter support to sli4
Date: Wed, 7 Feb 2018 11:27:59 +0100
Message-ID: <20180207102759.qzzqleujqhxnenna@linux-x5ow.site>
References: <20180207022851.11800-1-jsmart2021@gmail.com>
 <20180207022851.11800-5-jsmart2021@gmail.com>
 <20180207095157.zejjbq6a7eeqmosx@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54006 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753476AbeBGK2B (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 7 Feb 2018 05:28:01 -0500
Content-Disposition: inline
In-Reply-To: <20180207095157.zejjbq6a7eeqmosx@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>
Cc: linux-scsi@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>, Michael Ellerman <mpe@ellerman.id.au>, Mark Rutland <mark.rutland@arm.com>

On Wed, Feb 07, 2018 at 10:51:57AM +0100, Johannes Thumshirn wrote:
> > +			/* Enable combined writes for DPP aperture */
> > +			pg_addr = (unsigned long)(wq->dpp_regaddr) & PAGE_MASK;
> > +#ifdef CONFIG_X86
> > +			rc = set_memory_wc(pg_addr, 1);
> > +			if (rc) {
> > +				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> > +						"3272 Cannot setup Combined "
> > +						"Write on WQ[%d] - disable DPP\n",
> > +						wq->queue_id);
> > +				phba->cfg_enable_dpp = 0;
> > +			}
> > +#else
> > +			phba->cfg_enable_dpp = 0;
> > +#endif
> > +		} else
> > +			wq->db_regaddr = phba->sli4_hba.WQDBregaddr;
> 
> I don't really like the set_memory_wc() call here. Neither do I like the ifdef
> CONFIG_X86 special casing.
> 
> If you really need write combining, can't you at least use ioremap_wc()?

Coming back to this again (after talking to our ARM/POWER folks internally).
Is this really x86 specific here? I know there are servers with other architectures
using lpfcs out there.

I _think_ write combining should be possible on other architectures (that have
PCIe and aren't dead) as well.

The ioremap_wc() I suggested is probably wrong.

So can you please revisit this? I CCed Mark and Michael, maybe they can help
here.

Byte,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
