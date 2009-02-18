From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] pci: enable MSI on 8132
Date: Wed, 18 Feb 2009 11:29:35 -0800
Message-ID: <499C619F.6050807@kernel.org>
References: <499B46B2.5040601@kernel.org>	<alpine.DEB.1.10.0902171537260.26625@asgard.lang.hm>	<499B6BF7.9090300@kernel.org>	<alpine.DEB.1.10.0902171803040.26625@asgard.lang.hm>	<499B724A.2040408@kernel.org>	<alpine.DEB.1.10.0902171832560.26625@asgard.lang.hm>	<alpine.DEB.1.10.0902171839420.26625@asgard.lang.hm>	<499B774C.5010705@kernel.org>	<alpine.DEB.1.10.0902171917420.26625@asgard.lang.hm>	<499B9129.50104@kernel.org>	<20090218122137.GJ16841@parisc-linux.org>	<alpine.DEB.1.10.0902180426420.25606@asgard.lang.hm>	<20090218100448.7f7c5b86.akpm@linux-foundation.org>	<1234982285.3225.42.camel@localhost.localdomain> <20090218111510.b720aacb.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20090218111510.b720aacb.akpm@linux-foundation.org>
Sender: linux-pci-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, david@lang.hm, matthew@wil.cx, jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Andrew Morton wrote:
> On Wed, 18 Feb 2009 18:38:04 +0000
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
>> On Wed, 2009-02-18 at 10:04 -0800, Andrew Morton wrote:
>>> On Wed, 18 Feb 2009 04:27:28 -0800 (PST) david@lang.hm wrote:
>>>
>>>> On Wed, 18 Feb 2009, Matthew Wilcox wrote:
>>>>
>>>>> On Tue, Feb 17, 2009 at 08:40:09PM -0800, Yinghai Lu wrote:
>>>>>> Impact: workaround BIOS that doesn't enable that bit
>>>>>>
>>>>>> David reported that LSI sas doesn't work with MSI.
>>>>>> it turns out that BIOS doesn't enable HT MSI
>>>>>> 8132 does support HT MSI.
>>>>>> add quirk to enable it
>>>>>>
>>>>>> Reported-by: David Lang <david@lang.hm>
>>>>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>>>> Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
>>>>>
>>>>> Jesse, I think this should go into Linus' tree sooner rather than later.
>>>> please forward to -stable as well. this is a regression since the card 
>>>> works with older kernels.
>>>>
>>> Which kernel version introduced the regression?
>> Technically, it's not a regression.  The MSI problem has always been
>> there, it was just exposed when the SAS card switched to using MSI by
>> default.  It's fixed by the bridge quirk  ... of course it's unclear how
>> many more bridges with problems there are.
>>
>>> Do we not need mpt-fix-enable-lsi-sas-to-use-msi-as-default.patch as
>>> well, to fix this regression?
>> No ... it's a separate issue.  MSI was enabled for fusion SAS in 2.6.26;
>> the problem msi patch which the above corrects actually has the effect
>> of disabling MSI for fusion and went into 2.6.29-rc2, which isn't a
>> kernel that's been tested here.
> 
> <scratches head>
> 
> So it should be the case that _either_ of
> mpt-fix-enable-lsi-sas-to-use-msi-as-default.patch and
> pci-enable-msi-on-8132.patch would fix David's machine?

On David's machine:
for kernel after 2.6.29-rc2, it should work, because that typo actually disable the MSI
for kernel from 2.6.26 to 2.6.28, MSI is enabled for MPT sas, so it need pci-enable-msi-on-8132.patch.

for 2.6.29, we need to fix that typo anyway. LIS guys seems to like to enable MSI in that case...

YH
