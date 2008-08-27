From: Ming Zhang <blackmagic02881@gmail.com>
Subject: Re: [Scst-devel] Kernel Summit Request for Discussion: The Future
	of Target mode and Cloud storage on Linux
Date: Wed, 27 Aug 2008 13:59:37 -0400
Message-ID: <1219859977.22978.7.camel@mzhang-PC.home>
References: <48ADC53B.6090501@vlnb.net> <48ADFAB7.5010201@cs.wisc.edu>
	 <1219701570.13470.156.camel@haakon2.linux-iscsi.org>
	 <48B59556.7050108@vlnb.net>
Reply-To: blackmagic02881@gmail.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hs-out-0708.google.com ([64.233.178.248]:21717 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbYH0R7l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Aug 2008 13:59:41 -0400
Received: by hs-out-0708.google.com with SMTP id 4so570177hsl.5
        for <linux-scsi@vger.kernel.org>; Wed, 27 Aug 2008 10:59:39 -0700 (PDT)
In-Reply-To: <48B59556.7050108@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, scst-devel <scst-devel@lists.sourceforge.net>

On Wed, 2008-08-27 at 21:56 +0400, Vladislav Bolkhovitin wrote:
> Nicholas A. Bellinger wrote:
> > On Thu, 2008-08-21 at 18:31 -0500, Mike Christie wrote:
> >> snip
> >>
> > 
> > Ok, I took in the weekend to let things settle for a few moments.. 
> > 
> >>> If all necessary pieces of STGT moved in the kernel, it would become 
> >>> pretty much the same as SCST at the moment. 
> >> In the top paragraph James is saying to move scst into stgt, so it seems 
> >> like we can do the following:
> >>
> >> 1. You and with Nick battle each other about what are the best pieces of 
> >> scst and his target and what should go upstream.
> >>
> > 
> > Ok, Vlad and I have discussed and determined that the process will be
> > something roughly along the lines of
> > 
> > *) Vlad releases upstream patches for SCST Core in the late v2.6.27 time
> > frame.
> > *) /me will cherry picks from lio-core-2.6.git specific code (namely the
> > memory allocation and mapping algorithms) and begin to integrate these
> > into SCST-Core upstream and get bulk I/O moving between SCST Core
> > kernel/user CDB generation API.
> > *) Around the same time, I will begin the porting process of moving
> > LIO-Target to use the new upstream target infrastructure, whatever it
> > shall be called.. :-)
> 
> I agree
> 
> >> Our userspace tools will also be able to support both kernel space and 
> >> userspace targets with little trouble so distros that have stgt will not 
> >> notice any differences.
> > 
> > So this is one of the items that I mentioned to Vlad as being a
> > potential stumbling block..  I stated that I have no problem dumping the
> > LIO IOCTL in favor of something better, and having to break backwards
> > compat with LIO userspace tools (well, until I have to emulate the
> > backwards compat wrt target-ctl ;-)) is something I am ready to deal
> > with.
> > 
> > So I definately see your point here, having the exist CLI logic in place
> > into distros is something that we are going to have to deal with (even
> > if the core behind them is completely different).  
> > 
> > I should also mention that virtually all of the configuration logic done
> > from the LIO-Core and LIO-Target IOCTLs today is intended (minus a bug
> > or two :-) to be done without having to shutdown/stop anything other
> > than the referenced object for the target-ctl operation.  Obviously, I
> > really want to keep the same functionality with the CLI interface the
> > LIO pieces are ported to.
> > 
> > I will be sure to take a look at the STGT control interface and see how
> > I can fit the current functionality in.  I believe SCST uses an IOCTL
> > today as well, which would put them in a similar situation.
> 
> I, personally, don't like an interface, like tgtadm, which tries to do 
> all non-trivial configuration work from a single command line tool, 
> because of the following 3 reasons:
> 
> 1. It's a lot of effort to write and maintain such a tool, because it 
> needs to be extensible to work with new modules and modes. For instance, 
> iptables tool is 86K lines long. The whole netfilter code for all 
> network protocols in the kernel is less that 50K lines long. Do we want 
> such a code bloat (170% of code to configure) and dedicated team of 
> maintainers to solve a fundamentally simple configuration task?
> 
> 2. It assumes the stateless type of configuration, when each call 
> configures exactly one thing without any side effects on already 
> configured or future entries. This approach is good for cases like 
> iptables, but for SCSI targets it's possible that several configuration 
> steps require to be done in an atomic manner, like adding an iSCSI 
> target and configuring its parameters.
> 
> 3. It's hard to read 5+ parameters in one command line, so it's a lot 
> easier to make a mistake there.
> 
> So, I believe, a configuration interface should be rather /proc or /sys 
> interface based. I don't think we should care much about backward 
> compatibility with tgtadm, because the existing interface doesn't reach 
> the state of being widely used. As I already mentioned, only ibmvscsi at 
> the moment uses it, hardware for which is pretty rare.
> 

forget about proc. configfs is better. but problem is how u configure
user space target with configfs?


> Thus, I would suggest that before making the further move we should also 
> consider configuration interfaces of SCST and LIO and choose the best 
> things from all 3.


> 
> Vlad
> 
> 
> -------------------------------------------------------------------------
> This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
> Build the coolest Linux based applications with Moblin SDK & win great prizes
> Grand prize is a trip for two to an Open Source event anywhere in the world
> http://moblin-contest.org/redirect.php?banner_id=100&url=/
> _______________________________________________
> Scst-devel mailing list
> Scst-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/scst-devel

