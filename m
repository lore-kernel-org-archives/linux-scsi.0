From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [BUG] kzalloc overflow in lpfc driver on 6k core system
Date: Tue, 2 Dec 2014 22:39:40 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B4029593EFC9E@G4W3202.americas.hpqcorp.net>
References: <20141202215810.GT4720@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141202215810.GT4720@sgi.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Alex Thorlton <athorlton@sgi.com>
Cc: James Smart <james.smart@emulex.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Alex Thorlton
> Sent: Tuesday, 02 December, 2014 3:58 PM
...
> We've recently upgraded our big machine up to 6144 cores, and we're
> shaking out a number of bugs related to booting at that large core
> count.  Last night I tripped a warning from the lpfc driver that appears
> to be related to a kzalloc that uses the number of cores as part of it's
> size calculation.  Here's the backtrace from the warning:
...
> For a little bit more information on exactly what's going wrong, we're
> tripping the warning from lpfc_pci_probe_one_s4 (as you can see from the
> trace).  That function calls down to lpfc_sli4_driver_resource_setup,
> which contains the failing kzalloc here:
> 
> phba->sli4_hba.cpu_map = kzalloc((sizeof(struct lpfc_vector_map_info) *
>                                  phba->sli4_hba.num_present_cpu),
>                                  GFP_KERNEL);
> 
> As mentioned, it looks like we're multiplying the number available cpus
> by that struct size to get an allocation size, which ends up being
> greater than KMALLOC_MAX_SIZE.
> 
> Does anyone have any ideas on what could be done to break that
> allocation up into smaller pieces, or to make it in a different way so
> that we avoid this warning?
> 
> Any help is greatly appreciated.  Thanks!
> 

That structure includes an NR_CPU-based maskbits field, which is
probably too big.

include/cpumask.h:
typedef struct cpumask { DECLARE_BITMAP(bits, NR_CPUS); } cpumask_t;

drivers/scsi/lpfc/lpfc_sli4.h:
struct lpfc_vector_map_info {
        uint16_t        phys_id;
        uint16_t        core_id;
        uint16_t        irq;
        uint16_t        channel_id;
        struct cpumask  maskbits;
};

maskbits appears to only be used for setting IRQ affinity hints in
drivers/scsi/lpfc_init.c:
        for (idx = 0; idx < vectors; idx++) {
                cpup = phba->sli4_hba.cpu_map;
                cpu = lpfc_find_next_cpu(phba, phys_id);
                ...
                mask = &cpup->maskbits;
                cpumask_clear(mask);
                cpumask_set_cpu(cpu, mask);
                i = irq_set_affinity_hint(phba->sli4_hba.msix_entries[idx].
                                          vector, mask);

In similar code, mpt3sas and lockless hpsa just call get_cpu_mask()
inside the loop:
        cpu = cpumask_first(cpu_online_mask);
        for (i = 0; i < h->msix_vector; i++) {
                rc = irq_set_affinity_hint(h->intr[i], get_cpu_mask(cpu));
                cpu = cpumask_next(cpu, cpu_online_mask);
        }

get_cpu_mask() uses the global cpu_bit_bitmap array, which is declared
in kernel/cpu.c:
extern const unsigned long
        cpu_bit_bitmap[BITS_PER_LONG+1][BITS_TO_LONGS(NR_CPUS)];

That approach should work for lpfc.

---
Rob Elliott    HP Server Storage
