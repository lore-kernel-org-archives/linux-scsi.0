From: david@lang.hm
Subject: Re: [PATCH] pci: enable MSI on 8132
Date: Wed, 18 Feb 2009 10:40:29 -0800 (PST)
Message-ID: <alpine.DEB.1.10.0902181039240.26625@asgard.lang.hm>
References: <499B46B2.5040601@kernel.org>  <alpine.DEB.1.10.0902171537260.26625@asgard.lang.hm>  <499B6BF7.9090300@kernel.org>  <alpine.DEB.1.10.0902171803040.26625@asgard.lang.hm>  <499B724A.2040408@kernel.org>  <alpine.DEB.1.10.0902171832560.26625@asgard.lang.hm>
  <alpine.DEB.1.10.0902171839420.26625@asgard.lang.hm>  <499B774C.5010705@kernel.org>  <alpine.DEB.1.10.0902171917420.26625@asgard.lang.hm>  <499B9129.50104@kernel.org> <20090218122137.GJ16841@parisc-linux.org>  <alpine.DEB.1.10.0902180426420.25606@asgard.lang.hm>
  <20090218100448.7f7c5b86.akpm@linux-foundation.org> <1234982285.3225.42.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.lang.hm ([64.81.33.126]:39206 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722AbZBRSks (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Feb 2009 13:40:48 -0500
In-Reply-To: <1234982285.3225.42.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew@wil.cx>, Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com, linux-pci@vger.kernel.org

On Wed, 18 Feb 2009, James Bottomley wrote:

> On Wed, 2009-02-18 at 10:04 -0800, Andrew Morton wrote:
>> On Wed, 18 Feb 2009 04:27:28 -0800 (PST) david@lang.hm wrote:
>>
>>> On Wed, 18 Feb 2009, Matthew Wilcox wrote:
>>>
>>>> On Tue, Feb 17, 2009 at 08:40:09PM -0800, Yinghai Lu wrote:
>>>>>
>>>>> Impact: workaround BIOS that doesn't enable that bit
>>>>>
>>>>> David reported that LSI sas doesn't work with MSI.
>>>>> it turns out that BIOS doesn't enable HT MSI
>>>>> 8132 does support HT MSI.
>>>>> add quirk to enable it
>>>>>
>>>>> Reported-by: David Lang <david@lang.hm>
>>>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>>>
>>>> Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
>>>>
>>>> Jesse, I think this should go into Linus' tree sooner rather than later.
>>>
>>> please forward to -stable as well. this is a regression since the card
>>> works with older kernels.
>>>
>>
>> Which kernel version introduced the regression?
>
> Technically, it's not a regression.  The MSI problem has always been
> there, it was just exposed when the SAS card switched to using MSI by
> default.  It's fixed by the bridge quirk  ... of course it's unclear how
> many more bridges with problems there are.
>
>> Do we not need mpt-fix-enable-lsi-sas-to-use-msi-as-default.patch as
>> well, to fix this regression?
>
> No ... it's a separate issue.  MSI was enabled for fusion SAS in 2.6.26;
> the problem msi patch which the above corrects actually has the effect
> of disabling MSI for fusion and went into 2.6.29-rc2, which isn't a
> kernel that's been tested here.

actually, some of the failed tests were using the 2.6.29-rc5+ git tree 
pulled last evening. so that should have included any fixes that went into 
-rc2

David Lang

>> I sent mpt-fix-enable-lsi-sas-to-use-msi-as-default.patch to the
>> maintainers a week ago and it was ignored, along with everything else.
>> If this happens again I shall merge it under my own cognisance, along
>> with everything else.
>
> Yes, they've been a bit unresponsive.   I'm not unhappy with the current
> situation, since MSI is globally disabled for fusion at the moment (so
> we shouldn't get any more MSI problem reports), so I'm happy to wait and
> see what they want to do.
>
> James
>
>
>
