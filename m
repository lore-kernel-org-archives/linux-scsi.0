From: Chiaki <ishikawa@yk.rim.or.jp>
Subject: Re: [PATCH] kill tmscsim ->proc_info
Date: Wed, 18 Aug 2004 02:03:22 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41223A5A.8090409@yk.rim.or.jp>
References: <20040817161858.GA16589@lst.de> <4122366E.1040204@yk.rim.or.jp> <20040817164824.GA17074@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from serio.al.rim.or.jp ([202.247.191.123]:64399 "EHLO
	serio.al.rim.or.jp") by vger.kernel.org with ESMTP id S268346AbUHQRDa
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Aug 2004 13:03:30 -0400
In-Reply-To: <20040817164824.GA17074@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: g.liakhovetski@gmx.de, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Wed, Aug 18, 2004 at 01:46:38AM +0900, Chiaki wrote:
> 
>>Christoph Hellwig wrote:
>>
>>>hrrible code like all proc_info implementations and no really usefull
>>>information.  We might want to add sysfs attributes if some users really
>>>miss anything.
>>>
>>
>>Setting aside the horribleness of the code and suitability
>>of the code for 2.6.x kernel,
>>I found the information very useful when I did the debugging
>>with tmscsim driver code with
>>a rather obscure CD changer device and
>>other odd SCSI devices.
> 
> 
> What particular information?
> 
> 

In the removed code section, there is a loop
that begins with
"for (dev = 0; dev < pACB->DCBCnt; dev++)".

I found the information printed by the code up to it
very informative.
Now my memory is getting hazy, but from the end user's view
point those are the informatin very useful.
A stupid user/administrator mistake like
forgetting to set lun search in the kernel is
made pretty obvious by the display.
(And I remember finding the problem with old linux
kernel code that the maximum limit of
added hard disk or removable devices was way too
low for modern PCs [even for home usage]. As a result of
input from users like me, the maximum added device limit
is increased very much if I recall correctly.)
Also, sometimes the available spec of disks and such
may not reflect the reality (the real shipped product
and the specification published may not agree,
or the difference between
the spec and the latest ROM information. By looking at the
display from the tmscsim module, I can learn the
real characteristics of the device as opposed to
the paper spec, and this was very useful for
a home user who doesn't have elaborate scsi inquiry tools.
Yes I know some free/non-free tools exist today, but
being able to look at such output of information
as understood by the driver itself, and sharing it
with the original author without requiring the
installation of additional tool when a problem occured was
very useful.

Sorry, I am not using 2.6.xx series kernel myself,
and writing sysfs support for the driver is beyond my
skill now.


I believe the output produced by the code below
the loop mentioned above would be
useful to the code maintainers who need to
learn what is going on (performance-wise, or
logical incorrectness, etc..), but I am not
sure on this part. (At one point during 2.2.x series,
a long time ago, I found an obscure list processing
problem possibly caused by the main kernel code.
But it was such a long time ago, I can't recall
the details now.)


-- 
int main(void){int j=2003;/*(c)2003 cishikawa. */
char t[] ="<CI> @abcdefghijklmnopqrstuvwxyz.,\n\"";
char *i ="g>qtCIuqivb,gCwe\np@.ietCIuqi\"tqkvv is>dnamz";
while(*i)((j+=strchr(t,*i++)-(int)t),(j%=sizeof t-1),
(putchar(t[j])));return 0;}/* under GPL */
