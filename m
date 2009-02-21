From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] pci: enable MSI on 8132
Date: Sat, 21 Feb 2009 02:23:31 -0800
Message-ID: <499FD623.1010105@kernel.org>
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm>	<alpine.DEB.1.10.0902171803040.26625@asgard.lang.hm>	<499B724A.2040408@kernel.org>	<alpine.DEB.1.10.0902171832560.26625@asgard.lang.hm>	<alpine.DEB.1.10.0902171839420.26625@asgard.lang.hm>	<499B774C.5010705@kernel.org>	<alpine.DEB.1.10.0902171917420.26625@asgard.lang.hm>	<499B9129.50104@kernel.org> <499CD466.1060900@gmail.com>	<m1fxi82pq0.fsf@fess.ebiederm.org>	<86802c440902210031j698403cev2147e72a61e17194@mail.gmail.com> <m1r61sf9oo.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:53315 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbZBUKYg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Feb 2009 05:24:36 -0500
In-Reply-To: <m1r61sf9oo.fsf@fess.ebiederm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, Jesse Barnes <jbarnes@virtuousgeek.org>, Andrew Morton <akpm@linux-foundation.org>, david@lang.hm, Matthew Wilcox <matthew@wil.cx>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com, linux-pci@vger.kernel.org

Eric W. Biederman wrote:
> Yinghai Lu <yinghai@kernel.org> writes:
> 
>> On Fri, Feb 20, 2009 at 11:50 PM, Eric W. Biederman
>> <ebiederm@xmission.com> wrote:
>>> Robert Hancock <hancockrwd@gmail.com> writes:
>>>> Is there a reason why we can't just enable the HT MSI mapping for any bridge
>>>> device that has that PCI capability and is underneath an HT bridge?
>>> The code should be under CONFIG_X86 because the rules for enabling HT MSI
>> mappings
>>> are different for other architectures.  But otherwise I can't think of a
>> reason.
>>
>> move to arch/x86/pci/fixup.c?
>>
>> it seems some other arch do support HT ... powerpc, mips?
> 
> The difference is that there is a magic address on x86 that all MSI
> cycles are sent to.  I think it is 0xfffe0000.  In an msi to HT
> mapping capability it is necessary to program in the address to listen
> for msi packets.  That is very much an arch dependent thing.
> 
>>>> Essentially
>>>> the code for nv_msi_ht_cap_quirk could potentially be applied to all bridges
>> as
>>>> it is currently for NVIDIA and ALi bridges..
>>> Sounds like it would save a fair amount of grief.
>> it seems there is some difference.
>> 8132 is some kind of HT tunnel, and the bridge is acctually pci-x bridge.
>>
>> mcp55 and ck804: is HT end device with several pcie bridges.
> 
> Not really they are all hypertransport to pci bridges (of some flavor).
> But any hypertransport device is allowed to have a mapping capability.
> In which case they can implement normal MSI interrupts instead of the
> weird hypertransport ones.
for mcp55
00:00.0 is HT device
00:0b.0 00:0c.0, 00:0d.0, 00:0e.0, 00:0f.0 are pcie bridge.
current quirks will check 00:00.0 HT MSI is set, it will not set that in those bridges any more.

> 
>> also 8131 has problem with HT MSI?
> 
> The 8131 does not implement the msi to hypertransport mapping
> capability so it can not support MSI interrupts.
it seems there is one quirks to disable MSI for 8131.
/* Disable MSI on chipsets that are known to not support it */
static void __devinit quirk_disable_msi(struct pci_dev *dev)
{
        if (dev->subordinate) {
                dev_warn(&dev->dev, "MSI quirk detected; "
                        "subordinate MSI disabled\n");
                dev->subordinate->bus_flags |= PCI_BUS_FLAGS_NO_MSI;
        }
}
DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_8131_BRIDGE, quirk_disable_msi);


> 
> 
> In general on x86, if a device has a MSI to hypertransport mapping
> capability then we can enable it and mark that devices and all
> downstream devices as supporting MSI.

looks some aggressive.

YH
