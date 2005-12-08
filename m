From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Ang: Re: [Stgt-devel] Re: [Iscsitarget-devel] stgt a new version
 of iscsi target?
Date: Thu, 08 Dec 2005 13:10:05 -0600
Message-ID: <4398850D.8070102@cs.wisc.edu>
References: <OF6932015B.01CF53D9-ONC12570D0.00462028@capvert.ins> <43972C2D.9060500@cs.wisc.edu> <43987F75.2000301@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:39653 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932254AbVLHTKc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2005 14:10:32 -0500
In-Reply-To: <43987F75.2000301@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: johan@capvert.se, iscsitarget-devel@lists.sourceforge.net, mingz@ele.uri.edu, stgt <stgt-devel@lists.berlios.de>, Robert Whitehead <WRWHITEHEAD@novell.com>, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

Vladislav Bolkhovitin wrote:
>  - Scst has some performance advantages over stgt, at least, on hardware 
> targets, because it allows internal handling in SIRQ context as well as 
> doesn't need user space program, so it eliminates additi
> switches (at least 3 per command for WRITEs and 2 per command for reads 
> plus switches to user space daemon, probably, 2 per command). 5 context 
> switches per command looks too much for me, especially considering how 
> little work is done on each context. It means ~15000 CS/sec on regular 
> 200Mb/sec link with 64K block size. Additionally, kernel only commands 
> execution allows direct access to page cache, which is GREAT performance 
> improvement, because in architecture with user space daemon the data 
> should be copied several times between kernel and user space. Or, do I 
> miss anything?

Userspace only occurs for READ/WRITEs. So for REPORT_LUNS, TUR, etc 
where performance is not a factor.

Also is the page cache comment in reference to us using the page cache 
for our reads and writes or I am not sure why you wrote that if you do 
not do it right now.

> 
>  From other side, stgt has not too much advantages over scst. 

Hey, we just started and have not had too much time.

> Actually, we would greatly appreciate if Mike or Christoph will tell us 
> what is so wrong in scst on their opinion, so they started they own new 
> project. (I'm not considering motivation like "I want to make my own in 
> any case" seriously). Is scst too complicated? Do you think stgt will be 
> simpler with all those features implemented?
> 

Didn't we go over this? To get SCST ready for mainline we would have had 
a large cleanup effort. I started this and sent you a patch to begin the 
cleanup. In the end some of the scsi people liked the idea of throwing 
the non-read/write command to userspace and to do this we just decided 
to start over but I have been cutting and pasting your code and cleaning 
it up as I add more stuff.

Simmer down :) If you had just gotton your code ready when christoph 
asked a year ago we would never have had this problem and I would be 
sending you patches to remove the scsi_request usage as we speak.
