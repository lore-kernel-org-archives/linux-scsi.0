From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH] pci: enable MSI on 8132
Date: Sat, 21 Feb 2009 00:58:31 -0800
Message-ID: <m1r61sf9oo.fsf@fess.ebiederm.org>
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm>
	<alpine.DEB.1.10.0902171803040.26625@asgard.lang.hm>
	<499B724A.2040408@kernel.org>
	<alpine.DEB.1.10.0902171832560.26625@asgard.lang.hm>
	<alpine.DEB.1.10.0902171839420.26625@asgard.lang.hm>
	<499B774C.5010705@kernel.org>
	<alpine.DEB.1.10.0902171917420.26625@asgard.lang.hm>
	<499B9129.50104@kernel.org> <499CD466.1060900@gmail.com>
	<m1fxi82pq0.fsf@fess.ebiederm.org>
	<86802c440902210031j698403cev2147e72a61e17194@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out02.mta.xmission.com ([166.70.13.232]:45832 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbZBUI6L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Feb 2009 03:58:11 -0500
In-Reply-To: <86802c440902210031j698403cev2147e72a61e17194@mail.gmail.com> (Yinghai Lu's message of "Sat\, 21 Feb 2009 00\:31\:43 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Robert Hancock <hancockrwd@gmail.com>, Jesse Barnes <jbarnes@virtuousgeek.org>, Andrew Morton <akpm@linux-foundation.org>, david@lang.hm, Matthew Wilcox <matthew@wil.cx>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com, linux-pci@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> On Fri, Feb 20, 2009 at 11:50 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> Robert Hancock <hancockrwd@gmail.com> writes:
>>>
>>> Is there a reason why we can't just enable the HT MSI mapping for any bridge
>>> device that has that PCI capability and is underneath an HT bridge?
>>
>> The code should be under CONFIG_X86 because the rules for enabling HT MSI
> mappings
>> are different for other architectures.  But otherwise I can't think of a
> reason.
>
> move to arch/x86/pci/fixup.c?
>
> it seems some other arch do support HT ... powerpc, mips?

The difference is that there is a magic address on x86 that all MSI
cycles are sent to.  I think it is 0xfffe0000.  In an msi to HT
mapping capability it is necessary to program in the address to listen
for msi packets.  That is very much an arch dependent thing.

>>> Essentially
>>> the code for nv_msi_ht_cap_quirk could potentially be applied to all bridges
> as
>>> it is currently for NVIDIA and ALi bridges..
>>
>> Sounds like it would save a fair amount of grief.
>
> it seems there is some difference.
> 8132 is some kind of HT tunnel, and the bridge is acctually pci-x bridge.
>
> mcp55 and ck804: is HT end device with several pcie bridges.

Not really they are all hypertransport to pci bridges (of some flavor).
But any hypertransport device is allowed to have a mapping capability.
In which case they can implement normal MSI interrupts instead of the
weird hypertransport ones.

> also 8131 has problem with HT MSI?

The 8131 does not implement the msi to hypertransport mapping
capability so it can not support MSI interrupts.


In general on x86, if a device has a MSI to hypertransport mapping
capability then we can enable it and mark that devices and all
downstream devices as supporting MSI.

Eric

