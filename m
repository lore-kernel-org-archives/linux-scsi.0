From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Ang: Re: [Stgt-devel] Re: [Iscsitarget-devel] stgt a new version
 of iscsi target?
Date: Fri, 09 Dec 2005 16:23:30 -0600
Message-ID: <439A03E2.7030308@cs.wisc.edu>
References: <OF6932015B.01CF53D9-ONC12570D0.00462028@capvert.ins> <43972C2D.9060500@cs.wisc.edu> <43987F75.2000301@vlnb.net> <4398850D.8070102@cs.wisc.edu> <4399A2BA.1070505@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:12270 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932476AbVLIWZN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2005 17:25:13 -0500
In-Reply-To: <4399A2BA.1070505@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: johan@capvert.se, iscsitarget-devel@lists.sourceforge.net, mingz@ele.uri.edu, stgt <stgt-devel@lists.berlios.de>, Robert Whitehead <WRWHITEHEAD@novell.com>, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

Vladislav Bolkhovitin wrote:
> Mike Christie wrote:
> 
>> Vladislav Bolkhovitin wrote:
>>
>>>  - Scst has some performance advantages over stgt, at least, on 
>>> hardware targets, because it allows internal handling in SIRQ context 
>>> as well as doesn't need user space program, so it eliminates additi
>>> switches (at least 3 per command for WRITEs and 2 per command for 
>>> reads plus switches to user space daemon, probably, 2 per command). 5 
>>> context switches per command looks too much for me, especially 
>>> considering how little work is done on each context. It means ~15000 
>>> CS/sec on regular 200Mb/sec link with 64K block size. Additionally, 
>>> kernel only commands execution allows direct access to page cache, 
>>> which is GREAT performance improvement, because in architecture with 
>>> user space daemon the data should be copied several times between 
>>> kernel and user space. Or, do I miss anything?
>>
>>
>>
>> Userspace only occurs for READ/WRITEs. So for REPORT_LUNS, TUR, etc 
>> where performance is not a factor.
> 
> 
> So, do you mean that READ/WRITE operations are (or will be) performed in 
>  kernel space only? I don't see that from the code.


They are today. I think they have always been that way. Look again :)


>>>
>>>  From other side, stgt has not too much advantages over scst. 
>>
>>
>>
>> Hey, we just started and have not had too much time.
> 
> 
> No offense, please, you wrote stgt and scst are the same, I wrote, they 
> aren't :-)
> 

Yeah, I know. It was my mistake. If you read other mails, you would see 
I mentioned that we do not have any type of eh and I make Tomo mess up 
the serialization stuff becase I asked him to try to reuse some block 
layer code.

If you read other mails, you would also see I reccomended scst to people 
requesting something stable :)

>>> Actually, we would greatly appreciate if Mike or Christoph will tell 
>>> us what is so wrong in scst on their opinion, so they started they 
>>> own new project. (I'm not considering motivation like "I want to make 
>>> my own in any case" seriously). Is scst too complicated? Do you think 
>>> stgt will be simpler with all those features implemented?
>>>
>>
>> Didn't we go over this? To get SCST ready for mainline we would have 
>> had a large cleanup effort. I started this and sent you a patch to 
>> begin the cleanup. In the end some of the scsi people liked the idea 
>> of throwing the non-read/write command to userspace and to do this we 
>> just decided to start over but I have been cutting and pasting your 
>> code and cleaning it up as I add more stuff.
> 
> 
> The patches that I've seen were just pretty mechanic cleanups and 
> renames, which could be done in a half of hour time and which I'm going 

Yeah it was the beginning of the easy work. I did not mean that as an 
example of evertthing. I thought you would remember when we discussed 
this on linux-scsi before.


> to do in any case before preparing the patch. So, that reason doesn't 
> look convincing for me to throw away a big chunk of working code. Doing 
> so you delayed SCSI targets development for at least to a year-two, 

Hey, looked how long it took iscsi to get in becuase we wasted so much 
time cleaning up iscsi-sfnet :)

> because there are too much features for you to implement in stgt, which 
> are already working and useful in scst.

Well, there was more when you asked on linux-scsi. You have other things 
like refcouting (we only are adding that in today, but we do get 
references to the scsi_host when we access the qla2xxx ha at least). If 
someone ripps out a qla2xxx card you will oops.

We also did not want to hook in as a SCSI ULD interface becuase we did 
not want to worry about what happens when poeple start using 
usb-mass-storage for targets and LUNs. Look how many times we see Alan 
Stern pop up for just the initiator side :) And to be honest DM would do 
a lot of what tgt and scst want as far as giving us a reference to the 
devive we want to use as a LUN and handling all the setup work so we 
probably both messed up there :(

> 
>  From other side, if you look on scst closely you will see that:
> 
> - The user space gate could be easily and clearly done using existing 
> dev handler's hooks

Yeah and the problem is that we just do not believe those are 
implemented in the correct place. We do not like class interface SCSI 
hook in, when we can do the same thing from userspace.

> 
> - There is nothing in current SCST that could be moved in user space 
> without sacrificing performance. Neither task management, nor UA 
> processing, nor RESERVE/RELEASE emulation. Otherwise, you will have to 
> pass *all* the commands to the user space to check allowed this command 
> for processing or it shall be returned with an error.

For non READ/WRITE, we are ok with that performance drops. Even for 
doing READ/WRITEs in the kernel from interrupt context, we were going to 
run from a softirq, but we thought allocating the whole command with 
GFP_ATOMIC would not be liked so we pass it to the thread. And for when 
we do pass through (using elv_add_request/blk_rq_execute_nowait), we can 
do it in just the context swith needed for the memory allocation. But to 
do GFP_ATOMOIC softirq or hw irq would not be a problem, although I do 
not think we want to submit IO from the hw interrupt incase the queue 
gets unplugged at the same time :)

For non READ/WRITEs look how far open-iscsi went. And from James's 
reply, you see that he thinks READs and WRITEs can go to userspace too, 
so you know this is an uphill battle to get everything in the kernel.


  SCST core is just
> about 7500 lines of code. Is it too much?

Ask the people that have to review the code? :) After sfnet, I learned 
that it is sometimes best to get the basics in the kernel first so we do 
not burn out the christoph robot :) I think part of this stems from the 
fact that I touched pretty much every line in that driver to clean it up 
and it took me about a year. And while I was beginning to clean up scst 
I began to remember sfnet.

But there are other cleanups like moving some of the state to per 
target, cleaningup the scattlist allocation code and moving it to 
scsi-ml so the SCSI ULDs can use them and convert them. There is also 
thing like converting to the right APIs for 2.6 (rm kernel_thread, rm 
scsi_request, rm proc, fixup class interface refcouting problems, fixup 
scsi_device lack of refcounting usage, etc).


> 
>> Simmer down :) If you had just gotton your code ready when christoph 
>> asked a year ago we would never have had this problem and I would be 
>> sending you patches to remove the scsi_request usage as we speak.
> 
> 
> Christoph didn't ask me to do anything. Actually, nobody contacted and 

What? Look at the review comments you got on the list when you first 
posted scst. It asked you to take out the 2.4ish code out and clean it 
up didn't it?

> asked anything about that me when you with Christoph conceived stgt.
> 

I do not think Christoph and I conceived stgt. Tomo and I did or 
actually Tomo did the original code to push things to userspace. I just 
bugged him about getting something in mainlin. We only asked Christoph 
what we would should do to get things in mainline. After seeing what 
open-iscsi did and the comments from Arjan about IET, we thought we 
would have to follow a similar route as open-iscsi.


At this point I do not care what we do. I just want to get something in 
mainline for everyone to use and so I can use it at home becuase I am 
lazy and do not want to drive to work in the snow to test FC card 
updates :) If we can come to some conclusions on some of these issues I 
am sure Tomo and I would be happy to work together.
