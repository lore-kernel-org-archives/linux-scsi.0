From: Grant Grundler <grundler@parisc-linux.org>
Subject: Re: MSIX and multiple reply queues
Date: Tue, 22 Jun 2010 00:08:39 -0600
Message-ID: <20100622060839.GB30041@lackof.org>
References: <4565AEA676113A449269C2F3A549520F3FF6C887@cosmail03.lsi.com> <1277163505.10998.143.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1277163505.10998.143.camel@mulgrave.site>
Sender: linux-pci-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, "willy@linux.intel.com" <willy@linux.intel.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 21, 2010 at 06:38:25PM -0500, James Bottomley wrote:
> Corrected CC: list.  DON'T send email to linux-scsi-owner without good
> reason because that's DaveM and he's been known to be wrathful when
> poked incorrectly ...
> 
> On Mon, 2010-06-21 at 15:56 -0600, Moore, Eric wrote:
> > Where does a SCSI lower layer driver obtain the MSIX Vector Index on a
> > per IO basis?  This is the index into the MSIX Vector Table. 
> 
> It doesn't; that's a pci/msix issue, so you use the regular pci msix
> APIs.  If you look at how the other HBAs do it, they store the table in
> a host structure and pass a pointer to the particular table entry into
> the request_irq() routine.
> 
> > Our controller is going to have a separate reply queue for each MSIX Vector.  

Which means each queue, could be pointed at either a different core
or a different socket. The desired mapping needs to be known to both
user space (which controls the CPU -> IRQ mapping) and device driver
(which knows IRQ <-> Completion Queue).

> > At driver load time, I will pass an array of msix_entry when calling
> > pci_enable_msix.  Each entry represents a different reply queue.  Then
> > I will call request_irq() for each vector/entry.  I will have a single
> > ISR callback with each vector/entry having a different data pointer
> > for bus_id.  Each data area will contain a unique reply queue, msix
> > vector index, among other info.
> > 
> > From shost->queuecommand, I will need to setup the proper MSI Vector
> > Index for each IO.  That way when the interrupt is called, it will
> > have the proper data pointer passed in bus_id, which contains the
> > matching reply queue.  According to my co-worker working windows
> > drivers, I suppose to get the MSI Vector Index from the OS on a per IO
> > basis.  He said he is  obtaining the MSI Vector Index from
> > StorPortGetStartIoPerfParams.  The index is returned inside
> > PerfParms.MessageNumber.
> 
> If I parse this correctly, you're asking how to route the I/O in the
> HBA?  That's a hba decision based on queueing parameters (and possibly
> incoming CPU number or VM originator) because which queue the msix
> interrupt comes back on is a HBA programming specific thing, the routing
> is done in the issue.

I think you've parsed it correctly.


> > I'm not sure if the MSIX vector table is aligned with CPU IDs, meaning
> > does smp_processor_id() aligns with the entries in the MSIX vector
> > table?

No. Each MSI Vector is directed at a specific CPU but it's arbitrary how
the two are initially bound. When an interrupt is delivered, the private
data for that interrupt will need to contain references to the corresponding
completion queue. The hard part is knowing which queue to assign to an
IO when the IO is started. Entirely up to the device driver.

For NUMA systems, binding CPUs to Completion Queue is a known problem and
I haven't yet seen an elegant solution. For now, the preference is to let
user space deal with it. Hrm...ISTR someone (willy?) posted a patch to
export some of the MSI-X info to /sys so user space could be better informed.
Anyway, optimal arrangement will likely involve knowing alot about
every HBA/NIC in the system and NUMA characteristics of the system.
I participated in the discussion about this at 2008 Linux Plumbers Conf.
Maybe others remember the outcome/followups better than I do.

>   Meaning does CPU ID 0 is the 1st entry in the MSIX vector
> > table, CPU ID 2 is the 2nd entry in the table, CPU ID 3 is the 3rd
> > entry, and so on.  Or is there another API in Linux to get the MSIX
> > Vector Index per IO basis?
> 
> So I think what you're saying is that you plan to have one MSI-X vector
> per CPU (which is possbile)?  If so, you just bind the vector affinity
> of the interrupt to the CPU you want.  If it's something more complex
> than this, I'd suggest asking the PCI list ... I cc'd them in case they
> have any insight.

The CPUs are not mapped/indexed into the MSI-X Vector table by CPU ID.
Each MSI-X table entry can point at the same or different CPU.

Eric, call me at work tomorrow if you need more background on how
MSI-X works. I can then also talk specifically about the adapter
you are working on.

cheers,
grant

> 
> James
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
