From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [RFC] FC pass thru - Rev V
Date: Sun, 8 Mar 2009 11:00:07 -0400
Message-ID: <49B3DD77.3020600@emulex.com>
References: <1227043498.4949.21.camel@ogier> <1234365225.24194.3.camel@ogier> <968C4C03B4940B48A4A8B1EA417CD6D82D2639A19E@AVEXMB2.qlogic.org> <49B28869.6090507@emulex.com> <3256D4E4-B8C7-434C-AF07-5A7D73D7832D@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:48044 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbZCHPAU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Mar 2009 11:00:20 -0400
In-Reply-To: <3256D4E4-B8C7-434C-AF07-5A7D73D7832D@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seokmann Ju <seokmann.ju@qlogic.com>
Cc: "futjita.tomonori@lab.ntt.co.jp" <futjita.tomonori@lab.ntt.co.jp>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "sven@linux.vnet.ibm.com" <sven@linux.vnet.ibm.com>, "bharrosh@panasas.com" <bharrosh@panasas.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

>> If you're getting multiple sg's, then either the buffer spans some
>> condition that crosses a boundary that blk_rq_map_sg() enforces  
>> (like a
>> 4G boundary, but I doubt that's it), or - and more likely - your
>> application has a buffer that spans 2 pages which look contiguous to  
>> the
>> app, but are actually virtual-memory mapped to 2 independent physical
>> pages (thus the need for 2 sg's).  If your app knows the system page
>> size, and was careful about buffer placement and length within page
>> boundaries, it likely would never encounter this.  But, we would never
>> want to force apps to be this smart, and this would be a good
>> justification for supporting more than 1 sg.
> OK. So the whole point that I brought up is implementation specific.
> Thank you for the comment.

Yes, but I wouldn't be surprised to see it occur often enough to be a 
pain.  What I would recommend is :  if your hardware wants only one 
buffer descriptor for ELSs, and there's 2 BGs, that you double-buffer 
it. Allocate a local buffer, transfer the users data into the buffer, 
and then use the local buffer for the hardware. Same on the receive 
path. A pain, yes, but this isn't time critical stuff, and it's much 
better than just returning an error to the app based on it's buffer 
alignment (which it probably doesn't even realize).

The above works for ELS's (as its small), but I fully expect other 
things, like CT requests, to not be small and require multiple buffers. 
On those things, I hope the hardware supports multiple sg's as 
double-buffering it is ugly.

-- james s
