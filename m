From: david@lang.hm
Subject: Re: mpt fusion broken sometime since 2.6.24
Date: Tue, 17 Feb 2009 18:34:21 -0800 (PST)
Message-ID: <alpine.DEB.1.10.0902171832560.26625@asgard.lang.hm>
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm>  <alpine.DEB.1.10.0902171343280.26625@asgard.lang.hm>  <20090217230050.GG16841@parisc-linux.org>  <alpine.DEB.1.10.0902171506500.26625@asgard.lang.hm> <86802c440902171511s1abcc0eao560df4b8fcea0e7c@mail.gmail.com>
 <alpine.DEB.1.10.0902171514120.26625@asgard.lang.hm> <499B46B2.5040601@kernel.org> <alpine.DEB.1.10.0902171537260.26625@asgard.lang.hm> <499B6BF7.9090300@kernel.org> <alpine.DEB.1.10.0902171803040.26625@asgard.lang.hm> <499B724A.2040408@kernel.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.lang.hm ([64.81.33.126]:59985 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbZBRCe0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Feb 2009 21:34:26 -0500
In-Reply-To: <499B724A.2040408@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com

On Tue, 17 Feb 2009, Yinghai Lu wrote:

> david@lang.hm wrote:
>> On Tue, 17 Feb 2009, Yinghai Lu wrote:
>>
>>> david@lang.hm wrote:
>>>> On Tue, 17 Feb 2009, Yinghai Lu wrote:
>>>>
>>>>> david@lang.hm wrote:
>>>>>> On Tue, 17 Feb 2009, Yinghai Lu wrote:
>>>>>>
>>>>>>> Subject: Re: mpt fusion broken sometime since 2.6.24
>>>>>>>
>>>>>>> On Tue, Feb 17, 2009 at 3:07 PM,  <david@lang.hm> wrote:
>>>>>>>> On Tue, 17 Feb 2009, Matthew Wilcox wrote:
>>>>>>>>
>>>>>>>>> On Tue, Feb 17, 2009 at 01:44:55PM -0800, david@lang.hm wrote:
>>>>>>>>>>
>>>>>>>>>> I got a picture of the failed boot at
>>>>>>>>>> http://linux.lang.hm/linux/IMG00052.jpg
>>>>>>>>>
>>>>>>>>> The PCI-MSI line is probably indicative.  Can you try booting with:
>>>>>>>>>
>>>>>>>>> mptbase.mpt_msi_enable_sas=0
>>>>>>>>>
>>>>>>>>> and also send us an lspci -v so we can update the blacklist?
>>>>>>>>
>>>>>>>> is that disabling SAS for this system? if so, that's the wrong thing
>>>>>>>> to do
>>>>>>>> (the drives are SAS)
>>>>>>>>
>>>>>>> it only disable MSI with that mptsas.
>>>>>>> and mptsas will use ioapic routing.
>>>>>>>
>>>>>>> can you post whole bootlog?
>>>>>>
>>>>>> unfortunantly it's booting from CD and the only drives in the
>>>>>> system are
>>>>>> the ones that are not being accessed.
>>>>>
>>>>> i mean with kernel before 2.6.24..
>>>>
>>>> Ok, attached.
>>>>
>>>
>>> so your lsi 1068 is under 8132... need to double check if that chip
>>> really support MSI.
<SNIP>

I don't understand the section I snipped from the message above

> do you have chance to try current tip/master
> http://people.redhat.com/mingo/tip.git/readme.txt
> or 2.6.29-rcX
> plus following patch?

I will see about trying this.

> or can you check if there is update fw for your LSI card?

this is more work, I'll look into that as well.

David Lang

> [PATCH] mpt: fix enable lsi sas to use msi as default
>
> Impact: fix bug
>
> the third param in module_param(,,) is perm instead of default value.
> we still need to assign default at first.
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>
> ---
> drivers/message/fusion/mptbase.c |    4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>
> Index: linux-2.6/drivers/message/fusion/mptbase.c
> ===================================================================
> --- linux-2.6.orig/drivers/message/fusion/mptbase.c
> +++ linux-2.6/drivers/message/fusion/mptbase.c
> @@ -90,8 +90,8 @@ module_param(mpt_msi_enable_fc, int, 0);
> MODULE_PARM_DESC(mpt_msi_enable_fc, " Enable MSI Support for FC \
> 		controllers (default=0)");
>
> -static int mpt_msi_enable_sas;
> -module_param(mpt_msi_enable_sas, int, 1);
> +static int mpt_msi_enable_sas = 1;
> +module_param(mpt_msi_enable_sas, int, 0);
> MODULE_PARM_DESC(mpt_msi_enable_sas, " Enable MSI Support for SAS \
> 		controllers (default=1)");
>
>
