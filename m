From: Andrew Morton <akpm@osdl.org>
Subject: Re: git-acpi breakage, sym2
Date: Fri, 12 May 2006 00:35:18 -0700
Message-ID: <20060512003518.276420bc.akpm@osdl.org>
References: <CFF307C98FEABE47A452B27C06B85BB66D5565@hdsmsx411.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <CFF307C98FEABE47A452B27C06B85BB66D5565@hdsmsx411.amr.corp.intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: "Brown, Len" <len.brown@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org, willy@debian.org
List-Id: linux-scsi@vger.kernel.org

"Brown, Len" <len.brown@intel.com> wrote:
>
> >The latest
> >git+ssh://master.kernel.org/pub/scm/linux/kernel/git/lenb/linux
> >-acpi-2.6.git#test
> >kills my very vanilla P4 box.
> 
> hmmm, killed my p4 box too in a similar way.
> 
> booting with "acpi=off" made it work,
> so I expect the failures after ACPI refuses to start
> are due to ACPI and not do to something outside ACPI.
> 

Yeah.  Turns out I'm basically unable to drop the acpi tree because I have
so much other stuff dependent upon it.  So it's debugging time.

By the time we get to IO_APIC_get_PCI_irq_vector(), mp_bus_id_to_pci_bus[]
is still all -1's.

Because MP_bus_info() hasn't been called yet.

get_smp_config() is being called, but bales because

	 if (acpi_lapic && acpi_ioapic) {

returns true.

However that all appears to be normal.  Am still poking at it.

git-bisect came up with garbage.
