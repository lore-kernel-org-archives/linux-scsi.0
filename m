From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Ang: Re: [Stgt-devel] Re: [Iscsitarget-devel] stgt a new version
 of iscsi target?
Date: Sat, 10 Dec 2005 12:22:35 -0600
Message-ID: <439B1CEB.5070300@cs.wisc.edu>
References: <OF6932015B.01CF53D9-ONC12570D0.00462028@capvert.ins> <43972C2D.9060500@cs.wisc.edu> <43987F75.2000301@vlnb.net> <4398850D.8070102@cs.wisc.edu> <4399A2BA.1070505@vlnb.net> <439A03E2.7030308@cs.wisc.edu> <439A2C49.4010208@cs.wisc.edu> <439AF4AB.1040006@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:4228 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1161021AbVLJSW6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Dec 2005 13:22:58 -0500
In-Reply-To: <439AF4AB.1040006@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: johan@capvert.se, iscsitarget-devel@lists.sourceforge.net, mingz@ele.uri.edu, stgt <stgt-devel@lists.berlios.de>, Robert Whitehead <WRWHITEHEAD@novell.com>, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

Vladislav Bolkhovitin wrote:
> Mike Christie wrote:
> 
>>> But there are other cleanups like moving some of the state to per 
>>> target, cleaningup the scattlist allocation code and moving it to 
>>> scsi-ml so the SCSI ULDs can use them and convert them. There is also 
>>> thing like converting to the right APIs for 2.6 (rm kernel_thread, rm 
>>> scsi_request, rm proc, fixup class interface refcouting problems, 
>>> fixup scsi_device lack of refcounting usage, etc).
>>>
>>
>> Oh yeah I think the other major issue at least I had with scst was 
>> that it was scsi specific and we wanted try and seperate things so if 
>> drivers like IET and vscsi are allowed then we could also do other 
>> drivers like a ATA over ethernet target driver or allow any other 
>> target driver that wanted to to hook in. I think you noted that we 
>> were spererating some protocol specific things as a distadvantage or 
>> mentioned it for some reason but I am not completely sure why and we 
>> may not agree on that issue too.
> 
> 
> SCSI has a lot of very specific stuff like UA handling and (at least) 
> some parts of task management, especially if we consider honoring NACA, 
> QErr, TST, UA_INTLCK_CTRL bits, therefore I'm not sure that to have 
> common target parts for other protocols worths complicating the 
> mid-layer with code and interfaces that will separate SCSI-specifics 
> from non-SCSI protocols. So, good luck with it :-)
> 

I am talking about the memory allocation bits for starters. For example 
the way you allocate the scatterlists and memory is useful to other 
parts of the kernel not just scst. The userspace interface, if we added 
the netlink parts to scst could be useful too.
