From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: mpt fusion broken sometime since 2.6.24
Date: Tue, 17 Feb 2009 21:10:52 -0800
Message-ID: <499B985C.1090100@kernel.org>
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm>  <alpine.DEB.1.10.0902171343280.26625@asgard.lang.hm>  <20090217230050.GG16841@parisc-linux.org>  <alpine.DEB.1.10.0902171506500.26625@asgard.lang.hm> <86802c440902171511s1abcc0eao560df4b8fcea0e7c@mail.gmail.com> <alpine.DEB.1.10.0902171514120.26625@asgard.lang.hm> <499B46B2.5040601@kernel.org> <alpine.DEB.1.10.0902171537260.26625@asgard.lang.hm> <499B6BF7.9090300@kernel.org> <alpine.DEB.1.10.0902171803040.26625@asgard.lang.hm> <499B724A.2040408@kernel.org> <alpine.DEB.1.10.0902171832560.26625@asgard.lang.hm> <alpine.DEB.1.10.0902171839420.26625@asgard.lang.hm> <499B774C.5010705@kernel.org> <alpine.DEB.1.10.0902171917420.26625@asgard.lang.hm> <499B807B.2050509@kernel.org> <alpine.DEB.1.10.0902171935110.26625@asgard.lang.hm> <
 499B84CE.7090707@kernel.org> <alpine.DEB.1.10.0902172013230.26625@asgard.lang.hm> <499B976B.6010605@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754756AbZBRFMK@vger.kernel.org>
In-Reply-To: <499B976B.6010605@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: david@lang.hm
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com
List-Id: linux-scsi@vger.kernel.org

Yinghai Lu wrote:
> david@lang.hm wrote:
>> On Tue, 17 Feb 2009, Yinghai Lu wrote:
>>
>>> please try two patches at the same time on 2.6.29-rc5.
>>> don't apply other patch.
>> I did a git checkout -f HEAD then applied these two patches and the
>> result works.
>>
> but should have
> 
> pci 0000:80:10.0: Enabling HT MSI Mapping
> pci 0000:80:11.0: Enabling HT MSI Mapping
> 
> because previous patch have
> pci 0000:80:10.0: Found disabled HT MSI Mapping
> pci 0000:80:10.0: MSI quirk detected; subordinate MSI disabled
> pci 0000:80:11.0: Found disabled HT MSI Mapping
> pci 0000:80:11.0: MSI quirk detected; subordinate MSI disabled
> 

ok i saw that...

pci 0000:80:10.0: Enabling HT MSI Mapping
pci 0000:80:10.1: reg 10 64bit mmio: [0xfebfe000-0xfebfefff]
pci 0000:80:11.0: Enabling HT MSI Mapping
pci 0000:80:11.1: reg 10 64bit mmio: [0xfebff000-0xfebfffff]

it appears early.

that patch enabling MSI does work...

YH
