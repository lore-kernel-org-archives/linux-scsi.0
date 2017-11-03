From: Gavin Guo <gavin.guo@canonical.com>
Subject: Re: mptsas driver cannot detect hotplugging disk with the LSI SCSI
 SAS1068 controller in Ubuntu guest on VMware
Date: Fri, 3 Nov 2017 19:54:21 +0800
Message-ID: <CA+eFSM1BVfZ6OO7wdPR2nt4D6gxO39QE4prEivbr2r27wS8g=A@mail.gmail.com>
References: <CA+eFSM1aJRYs__pwtz+8E0TFOeKuKpHoiOkX6Wmm_2HMT1ut5A@mail.gmail.com>
 <1ad520f6-a1d8-5ce7-ee74-83edfdbfd39b@suse.de> <CA+eFSM24pwY0ViCiUqvzNDJa-Q0h0+XnEFF-gesKfBcEVKyLgQ@mail.gmail.com>
 <CA+eFSM3z=LdO78seoZtpAc7U7ec=Gzrm5ej76TafoM6Ea1Ektw@mail.gmail.com>
 <486fc58e-ac8f-cb48-4757-0b9a8e1c2121@suse.de> <CA+eFSM2hCmVTdAuvX0MeRzKLhCJJo1DePCo2jhjUXstguYNtgg@mail.gmail.com>
 <CA+eFSM3-ON+HhnepyXTtzAGSmA-Yvp6Eq9pmhcAXNrofpiBAVw@mail.gmail.com> <f6b38a1b-09d4-5aea-a8d6-c7568680823a@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f6b38a1b-09d4-5aea-a8d6-c7568680823a@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 3, 2017 at 6:59 PM, Hannes Reinecke <hare@suse.de> wrote:
> On 11/03/2017 04:38 AM, Gavin Guo wrote:
>> On Sat, Oct 28, 2017 at 11:35 AM, Gavin Guo <gavin.guo@canonical.com> wrote:
>>> On Fri, Oct 27, 2017 at 10:53 PM, Hannes Reinecke <hare@suse.de> wrote:
>>>> On 10/27/2017 04:02 PM, Gavin Guo wrote:
>>>>> Hi Hannes,
>>>>>
>>>>> Thank you for looking into the issue. If there is anything I can help
>>>>> to test the patch? I appreciate your help. Thank you.
>>>>>
>>>> If you had checked linux-scsi you would have found this patch:
>>>> '[PATCH] mptsas: Fixup device hotplug for VMWare ESXi', which I guess is
>>>> already scheduled for inclusion in 4.14.
>>>> Anything else I could help you with?
>>>>
>>>> Cheers,
>>>>
>>>> Hannes
>>>> --
>>>> Dr. Hannes Reinecke                Teamlead Storage & Networking
>>>> hare@suse.de                                   +49 911 74053 688
>>>> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
>>>> GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
>>>> HRB 21284 (AG Nürnberg)
>>>
>>> Really appreciate your help. I will proceed the testing and keep you posted.
>>
>> Hello Hannes,
>>
>> I've tested the MPT SAS device controller, the patch works perfectly.
>> However, the MPT SPI still cannot work with the hotplugging. The lspci
>> of the LSI SPI device is listed:
>>
>> 00:10.0 SCSI storage controller [0100]: LSI Logic / Symbios Logic
>> 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI [1000:0030] (rev 01)
>>         Subsystem: VMware LSI Logic Parallel SCSI Controller [15ad:1976]
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>>> TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 64 (1500ns min, 63750ns max)
>>         Interrupt: pin A routed to IRQ 17
>>         Region 0: I/O ports at 1400 [size=256]
>>         Region 1: Memory at feba0000 (64-bit, non-prefetchable) [size=128K]
>>         Region 3: Memory at febc0000 (64-bit, non-prefetchable) [size=128K]
>>         [virtual] Expansion ROM at 40008000 [disabled] [size=16K]
>>         Kernel driver in use: mptspi
>>
>> The vendor id/device id[1000:0030] can also be found in the
>> mptspi_pci_table(drivers/message/fusion/mptspi.c).
>>
>> PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVID_53C1030
>>
>> If there is anything I missed in the testing? I appreciate your help.
>>
> Don't. Ever. Try.
>
> SCSI Parallel hotplugging is so loosely defined that essentially every
> vendor can (and did!) implement their own thing, and _still_ be spec
> compliant.
> Plus there is no guarantee that we even see events when a hot-add
> occurs. So any thingie we put in here has a really high chance of
> breaking other installations.
> I wouldn't even bother to attempt this; it's virtualized anyway so you
> can as well switch to the SAS emulation here.
> Or use a different SCSI parallel emulation like the Symbios/LSI 53c800 one.
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                Teamlead Storage & Networking
> hare@suse.de                                   +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
> GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG Nürnberg)

Hello Hannes,

I totally understood your concern and appreciate your help again on
the hotplugging patch for MPT SAS controller. :)
