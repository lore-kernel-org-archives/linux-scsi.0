From: Gavin Guo <gavin.guo@canonical.com>
Subject: Re: mptsas driver cannot detect hotplugging disk with the LSI SCSI
 SAS1068 controller in Ubuntu guest on VMware
Date: Fri, 3 Nov 2017 11:38:54 +0800
Message-ID: <CA+eFSM3-ON+HhnepyXTtzAGSmA-Yvp6Eq9pmhcAXNrofpiBAVw@mail.gmail.com>
References: <CA+eFSM1aJRYs__pwtz+8E0TFOeKuKpHoiOkX6Wmm_2HMT1ut5A@mail.gmail.com>
 <1ad520f6-a1d8-5ce7-ee74-83edfdbfd39b@suse.de> <CA+eFSM24pwY0ViCiUqvzNDJa-Q0h0+XnEFF-gesKfBcEVKyLgQ@mail.gmail.com>
 <CA+eFSM3z=LdO78seoZtpAc7U7ec=Gzrm5ej76TafoM6Ea1Ektw@mail.gmail.com>
 <486fc58e-ac8f-cb48-4757-0b9a8e1c2121@suse.de> <CA+eFSM2hCmVTdAuvX0MeRzKLhCJJo1DePCo2jhjUXstguYNtgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:47904 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965069AbdKCDi6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Nov 2017 23:38:58 -0400
Received: from mail-qt0-f197.google.com ([209.85.216.197])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <gavin.guo@canonical.com>)
        id 1eASor-0008A0-2t
        for linux-scsi@vger.kernel.org; Fri, 03 Nov 2017 03:38:57 +0000
Received: by mail-qt0-f197.google.com with SMTP id t54so1152127qte.14
        for <linux-scsi@vger.kernel.org>; Thu, 02 Nov 2017 20:38:57 -0700 (PDT)
In-Reply-To: <CA+eFSM2hCmVTdAuvX0MeRzKLhCJJo1DePCo2jhjUXstguYNtgg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>

On Sat, Oct 28, 2017 at 11:35 AM, Gavin Guo <gavin.guo@canonical.com> wrote:
> On Fri, Oct 27, 2017 at 10:53 PM, Hannes Reinecke <hare@suse.de> wrote:
>> On 10/27/2017 04:02 PM, Gavin Guo wrote:
>>> Hi Hannes,
>>>
>>> Thank you for looking into the issue. If there is anything I can help
>>> to test the patch? I appreciate your help. Thank you.
>>>
>> If you had checked linux-scsi you would have found this patch:
>> '[PATCH] mptsas: Fixup device hotplug for VMWare ESXi', which I guess is
>> already scheduled for inclusion in 4.14.
>> Anything else I could help you with?
>>
>> Cheers,
>>
>> Hannes
>> --
>> Dr. Hannes Reinecke                Teamlead Storage & Networking
>> hare@suse.de                                   +49 911 74053 688
>> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
>> GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
>> HRB 21284 (AG Nürnberg)
>
> Really appreciate your help. I will proceed the testing and keep you posted.

Hello Hannes,

I've tested the MPT SAS device controller, the patch works perfectly.
However, the MPT SPI still cannot work with the hotplugging. The lspci
of the LSI SPI device is listed:

00:10.0 SCSI storage controller [0100]: LSI Logic / Symbios Logic
53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI [1000:0030] (rev 01)
        Subsystem: VMware LSI Logic Parallel SCSI Controller [15ad:1976]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (1500ns min, 63750ns max)
        Interrupt: pin A routed to IRQ 17
        Region 0: I/O ports at 1400 [size=256]
        Region 1: Memory at feba0000 (64-bit, non-prefetchable) [size=128K]
        Region 3: Memory at febc0000 (64-bit, non-prefetchable) [size=128K]
        [virtual] Expansion ROM at 40008000 [disabled] [size=16K]
        Kernel driver in use: mptspi

The vendor id/device id[1000:0030] can also be found in the
mptspi_pci_table(drivers/message/fusion/mptspi.c).

PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVID_53C1030

If there is anything I missed in the testing? I appreciate your help.
