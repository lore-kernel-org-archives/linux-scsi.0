From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH] [SCSI] mpt fusion: Fix 32 bit platforms with 64 bit
 resources.
Date: Fri, 6 Nov 2009 10:29:04 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C1C93C03CD6@inbmail01.lsi.com>
References: <1253053555-25097-1-git-send-email-pbathija@amcc.com>
	 <20091105134330.GA30489@zod.rchland.ibm.com>
	 <1257437226.2753.64.camel@mulgrave.site>
 <1257451218.13611.114.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:40809 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759341AbZKFE7a convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Nov 2009 23:59:30 -0500
In-Reply-To: <1257451218.13611.114.camel@pasglop>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>, James Bottomley <James.Bottomley@suse.de>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>, "Moore, Eric" <Eric.Moore@lsi.com>, "pbathija@amcc.com" <pbathija@amcc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>



-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Benjamin Herrenschmidt
Sent: Friday, November 06, 2009 1:30 AM
To: James Bottomley
Cc: Josh Boyer; Moore, Eric; pbathija@amcc.com; linux-scsi@vger.kernel.org; linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] [SCSI] mpt fusion: Fix 32 bit platforms with 64 bit resources.

On Thu, 2009-11-05 at 10:07 -0600, James Bottomley wrote:

> > > 	ioc->memmap = mem;
> > >-	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "mem = %p, mem_phys = %lx\n",
> > >-	    ioc->name, mem, mem_phys));
> > >+	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "mem = %p, mem_phys = %llx\n",
> > >+	    ioc->name, mem, (u64)mem_phys));
> > >
> > > 	ioc->mem_phys = mem_phys;
> > > 	ioc->chip = (SYSIF_REGS __iomem *)mem;
> > >
> > > 	/* Save Port IO values in case we need to do downloadboot */
> > >-	ioc->pio_mem_phys = port;
> > >+	port = ioremap(port_phys, psize);
> > >+	if (port == NULL) {
> > >+		printk(MYIOC_s_ERR_FMT " : ERROR - Unable to map adapter"
> > >+			" port !\n", ioc->name);
> > >+		return -EINVAL;
> 
> So this looks problematic on a few platforms ... what happens to
> platforms that have no IO space?  They automatically fail here and it
> looks like the adapter never attaches.

Yup, that part of the patch looks wrong.

However, a mechanical replacement of unsigned long's with
resource_size_t to hold physical addresses should be fine despite the
lack of feedback from LSI.

--> I was thinking this was actual fix for the issue. Use of resource_size_t is understood. Why submitter has added extra ioremap code in this patch? Because of ioremap code only this patch was on hold before going for ACK.
Pravin, Any specific reason to add above code?

Pravin, that ioremap definitely seems like it has nothing to do there,
port IO is already remapped for you by the core PCI code and should work
"as is". Please respin without that change.

Cheers,
Ben.


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
