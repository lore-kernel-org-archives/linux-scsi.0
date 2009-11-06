From: "Pravin Bathija" <pbathija@amcc.com>
Subject: RE: [PATCH] [SCSI] mpt fusion: Fix 32 bit platforms with 64 bit
	resources.
Date: Thu, 5 Nov 2009 21:57:06 -0800
Message-ID: <9D1E2BDCB5C57B46B56E6D80843439EB094F5008@SDCEXCHANGE01.ad.amcc.com>
References: <1253053555-25097-1-git-send-email-pbathija@amcc.com>
	<20091105134330.GA30489@zod.rchland.ibm.com>
	<1257437226.2753.64.camel@mulgrave.site>
	<1257451218.13611.114.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org>
Content-class: urn:content-classes:message
In-Reply-To: <1257451218.13611.114.camel@pasglop>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>, James Bottomley <James.Bottomley@suse.de>
Cc: Eric.Moore@lsi.com, linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Benjamin Herrenschmidt [mailto:benh@kernel.crashing.org]
> Sent: Thursday, November 05, 2009 12:00 PM
> To: James Bottomley
> Cc: Josh Boyer; Eric.Moore@lsi.com; Pravin Bathija; linux-
> scsi@vger.kernel.org; linuxppc-dev@ozlabs.org
> Subject: Re: [PATCH] [SCSI] mpt fusion: Fix 32 bit platforms with 64
> bit resources.
> 
> On Thu, 2009-11-05 at 10:07 -0600, James Bottomley wrote:
> 
> > > > 	ioc->memmap = mem;
> > > >-	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "mem = %p,
> mem_phys = %lx\n",
> > > >-	    ioc->name, mem, mem_phys));
> > > >+	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "mem = %p,
> mem_phys = %llx\n",
> > > >+	    ioc->name, mem, (u64)mem_phys));
> > > >
> > > > 	ioc->mem_phys = mem_phys;
> > > > 	ioc->chip = (SYSIF_REGS __iomem *)mem;
> > > >
> > > > 	/* Save Port IO values in case we need to do downloadboot
> */
> > > >-	ioc->pio_mem_phys = port;
> > > >+	port = ioremap(port_phys, psize);
> > > >+	if (port == NULL) {
> > > >+		printk(MYIOC_s_ERR_FMT " : ERROR - Unable to map
> adapter"
> > > >+			" port !\n", ioc->name);
> > > >+		return -EINVAL;
> >
> > So this looks problematic on a few platforms ... what happens to
> > platforms that have no IO space?  They automatically fail here and it
> > looks like the adapter never attaches.
> 
> Yup, that part of the patch looks wrong.
> 
> However, a mechanical replacement of unsigned long's with
> resource_size_t to hold physical addresses should be fine despite the
> lack of feedback from LSI.
> 
> Pravin, that ioremap definitely seems like it has nothing to do there,
> port IO is already remapped for you by the core PCI code and should
> work
> "as is". Please respin without that change.
> 
> Cheers,
> Ben.
> 

Thanks for the input. Will make the suggested changes and re-submit patch.
Regards,
Pravin
