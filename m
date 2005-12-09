From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Ang: Re: [Stgt-devel] Re: [Iscsitarget-devel] stgt a new version
 of iscsi target?
Date: Fri, 09 Dec 2005 18:28:58 +0300
Message-ID: <4399A2BA.1070505@vlnb.net>
References: <OF6932015B.01CF53D9-ONC12570D0.00462028@capvert.ins> <43972C2D.9060500@cs.wisc.edu> <43987F75.2000301@vlnb.net> <4398850D.8070102@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay03.infobox.ru ([195.208.235.28]:61888 "EHLO
	relay03.infobox.ru") by vger.kernel.org with ESMTP id S964782AbVLIP27
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Dec 2005 10:28:59 -0500
In-Reply-To: <4398850D.8070102@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: johan@capvert.se, iscsitarget-devel@lists.sourceforge.net, mingz@ele.uri.edu, stgt <stgt-devel@lists.berlios.de>, Robert Whitehead <WRWHITEHEAD@novell.com>, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

Mike Christie wrote:
> Vladislav Bolkhovitin wrote:
> 
>>  - Scst has some performance advantages over stgt, at least, on 
>> hardware targets, because it allows internal handling in SIRQ context 
>> as well as doesn't need user space program, so it eliminates additi
>> switches (at least 3 per command for WRITEs and 2 per command for 
>> reads plus switches to user space daemon, probably, 2 per command). 5 
>> context switches per command looks too much for me, especially 
>> considering how little work is done on each context. It means ~15000 
>> CS/sec on regular 200Mb/sec link with 64K block size. Additionally, 
>> kernel only commands execution allows direct access to page cache, 
>> which is GREAT performance improvement, because in architecture with 
>> user space daemon the data should be copied several times between 
>> kernel and user space. Or, do I miss anything?
> 
> 
> Userspace only occurs for READ/WRITEs. So for REPORT_LUNS, TUR, etc 
> where performance is not a factor.

So, do you mean that READ/WRITE operations are (or will be) performed in 
  kernel space only? I don't see that from the code.

> Also is the page cache comment in reference to us using the page cache 
> for our reads and writes or I am not sure why you wrote that if you do 
> not do it right now.

Hm, at first, the page cache already used somehow in fileio dev handler 
(though, with additional mem copy). At the second, fully utilize the 
page cache is one of two major improvements that are pending in scst, 
because it is required changing the kernel, which until some moment try 
to avoid. Although I prepared what is necessary for that.

The idea basically is the following. When READ operation arrives, pages 
for all requested blocks are at first searched in the page cache 
(probably, in SIRQ context, because it isn't expensive operation) and if 
all pages are found, they are referenced and the result will be sent to 
the initiator. Then the pages will be dereferenced (so, no pages 
allocation will be done at all). Otherwise, the missed pages will be 
allocated and the command will be rescheduled to the thread, which will 
read them. Then, after the response is sent, the pages will remain in 
the page cache for future accesses. For WRITEs the processing is the 
similar, the pages with the data will be put in the page cache.

I doubt it is possible to implement such simple and effective algorithm 
via user space. Pages mapping and unmapping is quite expensive for both 
coding effort and performance.

>>
>>  From other side, stgt has not too much advantages over scst. 
> 
> 
> Hey, we just started and have not had too much time.

No offense, please, you wrote stgt and scst are the same, I wrote, they 
aren't :-)

>> Actually, we would greatly appreciate if Mike or Christoph will tell 
>> us what is so wrong in scst on their opinion, so they started they own 
>> new project. (I'm not considering motivation like "I want to make my 
>> own in any case" seriously). Is scst too complicated? Do you think 
>> stgt will be simpler with all those features implemented?
>>
> 
> Didn't we go over this? To get SCST ready for mainline we would have had 
> a large cleanup effort. I started this and sent you a patch to begin the 
> cleanup. In the end some of the scsi people liked the idea of throwing 
> the non-read/write command to userspace and to do this we just decided 
> to start over but I have been cutting and pasting your code and cleaning 
> it up as I add more stuff.

The patches that I've seen were just pretty mechanic cleanups and 
renames, which could be done in a half of hour time and which I'm going 
to do in any case before preparing the patch. So, that reason doesn't 
look convincing for me to throw away a big chunk of working code. Doing 
so you delayed SCSI targets development for at least to a year-two, 
because there are too much features for you to implement in stgt, which 
are already working and useful in scst.

 From other side, if you look on scst closely you will see that:

- The user space gate could be easily and clearly done using existing 
dev handler's hooks

- There is nothing in current SCST that could be moved in user space 
without sacrificing performance. Neither task management, nor UA 
processing, nor RESERVE/RELEASE emulation. Otherwise, you will have to 
pass *all* the commands to the user space to check allowed this command 
for processing or it shall be returned with an error. SCST core is just 
about 7500 lines of code. Is it too much?

So, in my opinion, there is/was no technical point to drop scst in favor 
of stgt.

> Simmer down :) If you had just gotton your code ready when christoph 
> asked a year ago we would never have had this problem and I would be 
> sending you patches to remove the scsi_request usage as we speak.

Christoph didn't ask me to do anything. Actually, nobody contacted and 
asked anything about that me when you with Christoph conceived stgt.

Vlad

