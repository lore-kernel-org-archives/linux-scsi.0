From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Ang: Re: [Stgt-devel] Re: [Iscsitarget-devel] stgt a new
	version of iscsi target?
Date: Thu, 08 Dec 2005 14:48:10 -0500
Message-ID: <1134071290.3259.31.camel@mulgrave>
References: <OF6932015B.01CF53D9-ONC12570D0.00462028@capvert.ins>
	 <43972C2D.9060500@cs.wisc.edu> <43987F75.2000301@vlnb.net>
	 <4398850D.8070102@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:24456 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932300AbVLHTus (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Dec 2005 14:50:48 -0500
In-Reply-To: <4398850D.8070102@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, johan@capvert.se, iscsitarget-devel@lists.sourceforge.net, mingz@ele.uri.edu, stgt <stgt-devel@lists.berlios.de>, Robert Whitehead <WRWHITEHEAD@novell.com>, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

On Thu, 2005-12-08 at 13:10 -0600, Mike Christie wrote:
> cleanup. In the end some of the scsi people liked the idea of throwing 
> the non-read/write command to userspace and to do this we just decided 
> to start over but I have been cutting and pasting your code and cleaning 
> it up as I add more stuff.

To be honest, I'd like to see all command processing at user level
(including read/write ... for block devices, it shouldn't be that
inefficient, since you're merely going to say remap an area from one
device to another; as long as no data transformation ever occurs, the
user never touches the data and it all remains in the kernel page
cache).

My ideal for the kernel based infrastructure is a simple tap for
transporting commands addressed to devices upwards (and the responses
downwards).  Then everyone can have their own user space processing
implementation that I don't have to care about.

James


