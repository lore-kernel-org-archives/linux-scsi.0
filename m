From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Kernel Summit Request for Discussion: The Future of Target mode
 and Cloud storage on Linux
Date: Wed, 27 Aug 2008 21:56:38 +0400
Message-ID: <48B59556.7050108@vlnb.net>
References: <48ADC53B.6090501@vlnb.net>  <48ADFAB7.5010201@cs.wisc.edu> <1219701570.13470.156.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-04.mailcluster.net ([77.221.130.216]:50404 "EHLO
	mail-relay-02.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751068AbYH0R4J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Aug 2008 13:56:09 -0400
In-Reply-To: <1219701570.13470.156.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, scst-devel <scst-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@gmail.com>

Nicholas A. Bellinger wrote:
> On Thu, 2008-08-21 at 18:31 -0500, Mike Christie wrote:
>> snip
>>
> 
> Ok, I took in the weekend to let things settle for a few moments.. 
> 
>>> If all necessary pieces of STGT moved in the kernel, it would become 
>>> pretty much the same as SCST at the moment. 
>> In the top paragraph James is saying to move scst into stgt, so it seems 
>> like we can do the following:
>>
>> 1. You and with Nick battle each other about what are the best pieces of 
>> scst and his target and what should go upstream.
>>
> 
> Ok, Vlad and I have discussed and determined that the process will be
> something roughly along the lines of
> 
> *) Vlad releases upstream patches for SCST Core in the late v2.6.27 time
> frame.
> *) /me will cherry picks from lio-core-2.6.git specific code (namely the
> memory allocation and mapping algorithms) and begin to integrate these
> into SCST-Core upstream and get bulk I/O moving between SCST Core
> kernel/user CDB generation API.
> *) Around the same time, I will begin the porting process of moving
> LIO-Target to use the new upstream target infrastructure, whatever it
> shall be called.. :-)

I agree

>> Our userspace tools will also be able to support both kernel space and 
>> userspace targets with little trouble so distros that have stgt will not 
>> notice any differences.
> 
> So this is one of the items that I mentioned to Vlad as being a
> potential stumbling block..  I stated that I have no problem dumping the
> LIO IOCTL in favor of something better, and having to break backwards
> compat with LIO userspace tools (well, until I have to emulate the
> backwards compat wrt target-ctl ;-)) is something I am ready to deal
> with.
> 
> So I definately see your point here, having the exist CLI logic in place
> into distros is something that we are going to have to deal with (even
> if the core behind them is completely different).  
> 
> I should also mention that virtually all of the configuration logic done
> from the LIO-Core and LIO-Target IOCTLs today is intended (minus a bug
> or two :-) to be done without having to shutdown/stop anything other
> than the referenced object for the target-ctl operation.  Obviously, I
> really want to keep the same functionality with the CLI interface the
> LIO pieces are ported to.
> 
> I will be sure to take a look at the STGT control interface and see how
> I can fit the current functionality in.  I believe SCST uses an IOCTL
> today as well, which would put them in a similar situation.

I, personally, don't like an interface, like tgtadm, which tries to do 
all non-trivial configuration work from a single command line tool, 
because of the following 3 reasons:

1. It's a lot of effort to write and maintain such a tool, because it 
needs to be extensible to work with new modules and modes. For instance, 
iptables tool is 86K lines long. The whole netfilter code for all 
network protocols in the kernel is less that 50K lines long. Do we want 
such a code bloat (170% of code to configure) and dedicated team of 
maintainers to solve a fundamentally simple configuration task?

2. It assumes the stateless type of configuration, when each call 
configures exactly one thing without any side effects on already 
configured or future entries. This approach is good for cases like 
iptables, but for SCSI targets it's possible that several configuration 
steps require to be done in an atomic manner, like adding an iSCSI 
target and configuring its parameters.

3. It's hard to read 5+ parameters in one command line, so it's a lot 
easier to make a mistake there.

So, I believe, a configuration interface should be rather /proc or /sys 
interface based. I don't think we should care much about backward 
compatibility with tgtadm, because the existing interface doesn't reach 
the state of being widely used. As I already mentioned, only ibmvscsi at 
the moment uses it, hardware for which is pretty rare.

Thus, I would suggest that before making the further move we should also 
consider configuration interfaces of SCST and LIO and choose the best 
things from all 3.

Vlad

