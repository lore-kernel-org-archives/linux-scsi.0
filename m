From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 13/15] qla4xxx: Added bsg support
Date: Wed, 16 Jun 2010 06:51:06 -0500
Message-ID: <4C18BAAA.3000507@cs.wisc.edu>
References: <20100611074900.GA27827@sles11sp1b1.qlogic.org>	 <4C12D398.8020200@cs.wisc.edu> <1276382259.10508.25.camel@mulgrave.site> <5E4F49720D0BAD499EE1F01232234BA871286CE740@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:60703 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168Ab0FPLsv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2010 07:48:51 -0400
In-Reply-To: <5E4F49720D0BAD499EE1F01232234BA871286CE740@AVEXMB1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: "james.bottomley@suse.de" <james.bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Ravi Anand <ravi.anand@qlogic.com>

On 06/15/2010 09:40 PM, Vikas Chaudhary wrote:
>
> But the reason we are trying to implement most of the commands using vendor
> specific way is because *setting up the card/configuration* related stuff
> are communicated using mailbox command interface with our firmware which
> do blob data transfer back and forth. Driver is basically funneling info
> back and forth between F/W and API in a blob format. So we need this to allow
> end user's to configure the card using QLogic Application or *iscsiadm* in
> future as we are migrating from ioctl interface to bsg/netlink/sysfs route
> which will require API changes.

We all know we are adding a interface so some tools can config the card. 
The question is why does it have to be a binary driver specific blob 
though? Why can't you do something like  qla4extioctl_set_init_fw_iscsi 
in the qlogic.com driver, but instead of a qlogic specific struct 
pinit_fw use a common struct?


>
> Additionally we are working on to add support in  libiscsi user space to
> support qla4xxx which will manipulate this blob and hookup with Linux Native
> *iscsiadm*  tool. Mike was OK with this approach as long as user space
> iscsiadm support will be enabled. This is something we are working on
> parallely as well. Here's the email thread where Mike responded and we pretty
> much agreed to it :
> http://article.gmane.org/gmane.linux.scsi/58849/match=qla4xxx+bsg


I think if we go this route, I think it is best to see the userspace 
code finished before the kernel code is merged, so my concern in that 
thread is nullified. At least could we come up with a rough outline? 
Something to give users a little hope that it will be done one day :)



>
>
>>      2. QL4_SET_FLASH looks a bit suspicious ... the only thing I think
>>         you could really set from that is the mac addresses ... is this
>>         so?
>
> It's used for multiple purpose, for ex :-
> 	1. write firmware image to flash
> 	2. write target configuration to flash and make target persistent
> 	3. write firmware control block to flash
> 	4. write chap information to flash, etc..
>
>>      3. the DDB commands seem to be for manipulating the end point
>>         table ... which is basically the iscsi connection table ... does
>>         manipulating that from BSG make sense?
>
> For qla4xxx firmware establishes  Connection/Session and qla4xxx driver
> works in session mode. We are using ddb commands here to establish
> session with target.
> Let us know if you have any suggestions over here.

Do you have an idea of how to manage this stuff in the userspace lib, so 
it gives a better picture of why your approach is better? When I asked 
for you guys to come up with a way to add a kernel interface that does 
this in a standard way, could you not figure out a nice way to do it, 
but figured out a nice way to do it in userspace instead (if so what is it)?
