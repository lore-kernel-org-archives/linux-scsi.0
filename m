From: Jiang Liu <jiang.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: hpsa driver bug crack kernel down!
Date: Tue, 15 Apr 2014 00:19:53 +0800
Message-ID: <534C0AA9.5080909@linux.intel.com>
References: <20140409023935.GE11839@dhcp-16-105.nay.redhat.com>	
	<1397083799.2608.20.camel@buesod1.americas.hpqcorp.net>	
	<1397084904.9519.62.camel@dabdike>
	<1397085044.9519.63.camel@dabdike>	
	<1397086817.2608.25.camel@buesod1.americas.hpqcorp.net>	
	<1397087425.9519.67.camel@dabdike>	
	<1397089180.2608.27.camel@buesod1.americas.hpqcorp.net>	
	<CAErSpo4H=hcro8sMnt2MzDDVCROpASuUTQWBw37OxodHTyOfyw@mail.gmail.com>	
	<1397111557.2608.29.camel@buesod1.americas.hpqcorp.net>	
	<20140410071535.GX13491@8bytes.org>	
	<1397119587.19944.14.camel@shinybook.infradead.org>	
	<1397146781.2608.46.camel@buesod1.americas.hpqcorp.net>	
	<1397207932.19944.58.camel@shinybook.infradead.org>
	<1397490358.31076.6.camel@buesod1.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1397490358.31076.6.camel-5JQ4ckphU/8SZAcGdq5asR6epYMZPwEe5NbjCUgZEJk@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Davidlohr Bueso <davidlohr-VXdhtT5mjnY@public.gmane.org>, "Woodhouse, David" <david.woodhouse-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org" <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "scameron-3C9H9nn4BS4HL6m8NFMY+dBPR1lH4CV8@public.gmane.org" <scameron-3C9H9nn4BS4HL6m8NFMY+dBPR1lH4CV8@public.gmane.org>, "bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hi Davidlohr,
	Thanks for providing the DMAR table. According to the DMAR
table, one bug in the iommu driver fails to handle this entry:
[1D2h 0466   1]      Device Scope Entry Type : 01
[1D3h 0467   1]                 Entry Length : 0A
[1D4h 0468   2]                     Reserved : 0000
[1D6h 0470   1]               Enumeration ID : 00
[1D7h 0471   1]               PCI Bus Number : 00
[1D8h 0472   2]                     PCI Path : 1C,04
[1DAh 0474   2]                     PCI Path : 00,02

	And the patch sent out by me should fix this bug. Could you please help
to have a try?
Thanks!
Gerry

On 2014/4/14 23:45, Davidlohr Bueso wrote:
> Sorry for the delay, I've been having to take turns for this box.
> 
> On Fri, 2014-04-11 at 09:18 +0000, Woodhouse, David wrote:
>> On Thu, 2014-04-10 at 09:19 -0700, Davidlohr Bueso wrote:
>>> Attaching a dmesg from one of the kernels that boots. It doesn't appear
>>> to have much of the related information... is there any debug config
>>> option I can enable that might give you more data?
>>
>> I'd like the contents of /sys/firmware/acpi/tables/DMAR please.
> 
> Attached is the disassembly of the raw output.
> 
>>  And
>> please could you also apply this patch to both the last-working and
>> first-failing kernels and show me the output in both cases?
> 
> So I still cannot get around getting the info for the first failing
> kernel, but below is for the last working. Thanks.
> 
> Device 0:03:00.0 on IOMMU at a8000000
> Device 0:03:00.0 on IOMMU at a8000000
> IOMMU: Setting identity map for device 0000:02:00.0 [0x7f61e000 - 0x7f61ffff]
> Device 0:02:00.0 on IOMMU at a8000000
> Device 0:02:00.0 on IOMMU at a8000000
> IOMMU: Setting identity map for device 0000:02:00.2 [0x7f61e000 - 0x7f61ffff]
> Device 0:02:00.2 on IOMMU at a8000000
> Device 0:02:00.2 on IOMMU at a8000000
> IOMMU: Setting identity map for device 0000:00:1d.0 [0x7f7e7000 - 0x7f7ecfff]
> Device 0:00:1d.0 on IOMMU at a8000000
> Device 0:00:1d.0 on IOMMU at a8000000
> IOMMU: Setting identity map for device 0000:00:1d.1 [0x7f7e7000 - 0x7f7ecfff]
> Device 0:00:1d.1 on IOMMU at a8000000
> Device 0:00:1d.1 on IOMMU at a8000000
> IOMMU: Setting identity map for device 0000:00:1d.2 [0x7f7e7000 - 0x7f7ecfff]
> Device 0:00:1d.2 on IOMMU at a8000000
> Device 0:00:1d.2 on IOMMU at a8000000
> IOMMU: Setting identity map for device 0000:00:1d.3 [0x7f7e7000 - 0x7f7ecfff]
> Device 0:00:1d.3 on IOMMU at a8000000
> Device 0:00:1d.3 on IOMMU at a8000000
> IOMMU: Setting identity map for device 0000:02:00.0 [0x7f7e7000 - 0x7f7ecfff]
> Device 0:02:00.0 on IOMMU at a8000000
> IOMMU: Setting identity map for device 0000:02:00.2 [0x7f7e7000 - 0x7f7ecfff]
> Device 0:02:00.2 on IOMMU at a8000000
> IOMMU: Setting identity map for device 0000:02:00.4 [0x7f7e7000 - 0x7f7ecfff]
> Device 0:02:00.4 on IOMMU at a8000000
> Device 0:02:00.4 on IOMMU at a8000000
> IOMMU: Setting identity map for device 0000:00:1d.7 [0x7f7ee000 - 0x7f7effff]
> Device 0:00:1d.7 on IOMMU at a8000000
> Device 0:00:1d.7 on IOMMU at a8000000
> IOMMU: Prepare 0-16MiB unity mapping for LPC
> IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0xffffff]
> Device 0:00:1f.0 on IOMMU at a8000000
> Device 0:00:1f.0 on IOMMU at a8000000
> PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
> Device 0:00:00.0 on IOMMU at a8000000
> Device 0:00:01.0 on IOMMU at a8000000
> Device 0:00:02.0 on IOMMU at a8000000
> Device 0:00:03.0 on IOMMU at a8000000
> Device 0:00:04.0 on IOMMU at a8000000
> Device 0:00:05.0 on IOMMU at a8000000
> Device 0:00:06.0 on IOMMU at a8000000
> Device 0:00:07.0 on IOMMU at a8000000
> Device 0:00:08.0 on IOMMU at a8000000
> Device 0:00:09.0 on IOMMU at a8000000
> Device 0:00:0a.0 on IOMMU at a8000000
> Device 0:00:14.0 on IOMMU at a8000000
> Device 0:00:1c.0 on IOMMU at a8000000
> Device 0:00:1c.4 on IOMMU at a8000000
> Device 0:00:1d.0 on IOMMU at a8000000
> Device 0:00:1d.1 on IOMMU at a8000000
> Device 0:00:1d.2 on IOMMU at a8000000
> Device 0:00:1d.3 on IOMMU at a8000000
> Device 0:00:1d.7 on IOMMU at a8000000
> Device 0:00:1e.0 on IOMMU at a8000000
> Device 0:00:1f.0 on IOMMU at a8000000
> Device 0:04:00.0 on IOMMU at a8000000
> Device 0:04:00.1 on IOMMU at a8000000
> Device 0:04:00.2 on IOMMU at a8000000
> Device 0:04:00.3 on IOMMU at a8000000
> Device 0:03:00.0 on IOMMU at a8000000
> Device 0:02:00.0 on IOMMU at a8000000
> Device 0:02:00.2 on IOMMU at a8000000
> Device 0:02:00.4 on IOMMU at a8000000
> Device 0:01:03.0 on IOMMU at a8000000
> Device 0:50:00.0 on IOMMU at ac000000
> Device 0:50:01.0 on IOMMU at ac000000
> Device 0:50:02.0 on IOMMU at ac000000
> Device 0:50:03.0 on IOMMU at ac000000
> Device 0:50:04.0 on IOMMU at ac000000
> Device 0:50:05.0 on IOMMU at ac000000
> Device 0:50:06.0 on IOMMU at ac000000
> Device 0:50:07.0 on IOMMU at ac000000
> Device 0:50:08.0 on IOMMU at ac000000
> Device 0:50:09.0 on IOMMU at ac000000
> Device 0:50:0a.0 on IOMMU at ac000000
> Device 0:50:14.0 on IOMMU at a8000000
> Device 0:a0:00.0 on IOMMU at b0000000
> Device 0:a0:01.0 on IOMMU at b0000000
> Device 0:a0:02.0 on IOMMU at b0000000
> Device 0:a0:03.0 on IOMMU at b0000000
> Device 0:a0:04.0 on IOMMU at b0000000
> Device 0:a0:05.0 on IOMMU at b0000000
> Device 0:a0:06.0 on IOMMU at b0000000
> Device 0:a0:07.0 on IOMMU at b0000000
> Device 0:a0:08.0 on IOMMU at b0000000
> Device 0:a0:09.0 on IOMMU at b0000000
> Device 0:a0:0a.0 on IOMMU at b0000000
> Device 0:a0:14.0 on IOMMU at a8000000
> Device 0:7c:00.0 on IOMMU at a8000000
> Device 0:7c:08.0 on IOMMU at a8000000
> Device 0:82:00.0 on IOMMU at a8000000
> Device 0:82:08.0 on IOMMU at a8000000
> 
