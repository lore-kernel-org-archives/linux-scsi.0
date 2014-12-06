From: James Smart <james.smart@emulex.com>
Subject: Re: [BUG] kzalloc overflow in lpfc driver on 6k core system
Date: Sat, 6 Dec 2014 15:14:45 -0500
Message-ID: <548363B5.1040909@emulex.com>
References: <20141202215810.GT4720@sgi.com> <94D0CD8314A33A4D9D801C0FE68B4029593EFC9E@G4W3202.americas.hpqcorp.net> <20141203160546.GA4720@sgi.com>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141203160546.GA4720@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alex Thorlton <athorlton@sgi.com>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Alex,

Myself and several others here at Emulex maintain the code. The 
recommendations look fine.   Feel free to post something if you beat us 
to the work.

-- james s


On 12/3/2014 11:05 AM, Alex Thorlton wrote:
> On Tue, Dec 02, 2014 at 10:39:40PM +0000, Elliott, Robert (Server Storage) wrote:
>> In similar code, mpt3sas and lockless hpsa just call get_cpu_mask()
>> inside the loop:
>>          cpu = cpumask_first(cpu_online_mask);
>>          for (i = 0; i < h->msix_vector; i++) {
>>                  rc = irq_set_affinity_hint(h->intr[i], get_cpu_mask(cpu));
>>                  cpu = cpumask_next(cpu, cpu_online_mask);
>>          }
>>
>> get_cpu_mask() uses the global cpu_bit_bitmap array, which is declared
>> in kernel/cpu.c:
>> extern const unsigned long
>>          cpu_bit_bitmap[BITS_PER_LONG+1][BITS_TO_LONGS(NR_CPUS)];
>>
>> That approach should work for lpfc.
> Ok, good deal.  Thanks for the info, Robert.  Do you know who the
> current maintainer is for this code?  Would that be you?  I included the
> two authors that get_maintainer reported, but haven't heard from them.
>
> I like this approach and don't mind implementing it myself, but I'd like
> to confirm that whoever would be responsible for merging the code is ok
> with the change before going forward.  Of course, if the code has been
> orphaned, then I guess we just write away :)
>
> Thanks again for the help!
>
> - Alex
>
>
