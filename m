From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [RFC] relaxed barrier semantics
Date: Thu, 05 Aug 2010 23:48:19 +0400
Message-ID: <4C5B1583.6070706__25908.5265374326$1281037743$gmane$org@vlnb.net>
References: <4C4FE58C.8080403@kernel.org> <20100728082447.GA7668@lst.de> <4C4FECFE.9040509@kernel.org> <20100728085048.GA8884@lst.de> <4C4FF136.5000205@kernel.org> <20100728090025.GA9252@lst.de> <4C4FF592.9090800@kernel.org> <20100728092859.GA11096@lst.de> <20100802173930.GP16630@think> <4C5AB89C.5080700@vlnb.net> <20100805133225.GF29846@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:63013 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759315Ab0HETsz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2010 15:48:55 -0400
In-Reply-To: <20100805133225.GF29846@think>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.B

Chris Mason, on 08/05/2010 05:32 PM wrote:
> On Thu, Aug 05, 2010 at 05:11:56PM +0400, Vladislav Bolkhovitin wrote:
>> Chris Mason, on 08/02/2010 09:39 PM wrote:
>>> I regret putting the ordering into the original barrier code...it
>>> definitely did help reiserfs back in the day but it stinks of magic and
>>> voodoo.
>>
>> But if the ordering isn't in the common (block) code, how to
>> implement the "hardware offload" for ordering, i.e. ORDERED
>> commands, in an acceptable way?
>>
>> I believe, the decision was right, but the flags and magic requests
>> based interface (and, hence, implementation) was wrong. That's it
>> which stinks of magic and voodoo.
>
> The interface definitely has flaws.  We didn't expand it because James
> popped up with a long list of error handling problems.

Could you point on the corresponding message, please? I can't find it in 
my archive.

> Basically how
> do the hardware and the kernel deal with a failed request at the start
> of the chain.  Somehow the easy way of failing them all turned out to be
> extremely difficult.

Have you considered to not fail them all, but using ACA SCSI facility 
just suspend the queue, then requeue the failed request, then restart 
processing? I might be missing something, but using this approach the 
failed requests recovery should look quite simple and, most important, 
compact, hence easily audited. Something like below. Sorry, since it's a 
low level recovery, it requires some deep SCSI knowledge to follow.

We need:

1. A low level driver without internal queue and masking returned status 
and sense. At first look, many of the existing drivers more or less 
satisfy this requirement, including drivers in my direct interest: 
qla2xxx, iscsi and ib_srp.

2. A device with support of ORDERED commands as well as ACA and 
UA_INTLCK facilities in QERR mode 0.

Assume we have N ORDERED requests queued to a device and one of them 
failed. Then submitting new requests to the device would be suspended 
and recovery thread woken up.

Let's we have a list of queued to the device requests in order as they 
queued. Then the recovery thread would need to deal with the following 
cases:

1. The failed command failed with CHECK_CONDITION and from the head of 
the queue. (The device now established ACA and suspended its internal 
queue.) Then the command should be sent to the device as ACA task and, 
after it's finished, ACA should be cleared. (The device now would 
restart its queue.) Then submitting new requests to the device would 
also be resumed.

2. The failed command failed with CHECK_CONDITION and isn't from the 
head of the queue.

2.1. The failed command in the last in the queue. ACA should be cleared 
and the failed command should simply be restarted. Then submitting new 
requests to the device would also be resumed.

2.2. The failed command isn't last in the queue. Then the recovery 
thread would send ACA command TEST UNIT READY to be sure all in-flight 
commands reached the device. Then it would abort all the commands after 
the failed one using ABORT TASK Task Management function. Then ACA 
should be cleared and the failed command as well as all the aborted 
commands would be resend to the device. Then submitting new requests to 
the device would also be resumed.

3. The failed command failed with other status than CHECK_CONDITION and 
from the head of the queue.

3.1. The failed command is the only queued command. Then TEST UNIT READY 
command should be sent to the device to get the post UA_INTLCK CHECK 
CONDITION and trigger ACA. Then ACA should be cleared and the failed 
command restarted. Then submitting new requests to the device would also 
be resumed.

3.2. There are other queued commands. Then the recovery thread should 
remember the failed command and exit. The next command would get the 
post UA_INTLCK CHECK CONDITION and trigger ACA. Then recovery would 
proceed as in (1), except that 2 failed commands would be restarted as 
ACA commands before clearing ACA.

4. The failed command isn't from the head of the queue and failed with 
other status than CHECK_CONDITION. It might happen in case of TASK QUEUE 
FULL condition. This case would be proceed similarly as cases (3.x), 
then (2.2).

That's all. Simple, compact and clear for auditing.

> Even if that part had been refined, I think trusting the ordering down
> to the lower layers was a doomed idea.  The list of ways it could go
> wrong is much much longer (and harder to debug) than the list of
> benefits.

It's hard to debug, because it's currently a overloaded flags nightmare. 
It isn't the idea to trust lower level doomed, everybody trust lower 
levels everywhere in the kernel. Doomed the idea to provide requested 
functionality via a set of flags and artificial barrier requests with 
obscured side effects. Linux just needs a clear and _natural_ interface 
for that. Like one I proposed in 
http://marc.info/?l=linux-scsi&m=128077574815881&w=2. Yes, I am 
proposing to slowly start thinking to move to a new interface and 
implementation out from the current hell. It's obvious that what Linux 
has now in this area is a dead end. The new flag Christoph is going to 
add makes it even worse.

> With all of that said, I did go ahead and benchmark real ordered tags
> extensively on a scsi drive in the initial implementation.  There was
> very little performance difference.

It isn't surprise that you didn't see much difference with a local 
(Wide?) SCSI drive. Such drives sit on a low latency link, simple enough 
to have small internal latencies and dumb enough to not make much 
benefits from internal reordering. But how about external arrays? Or 
even clusters? Nowadays everybody can build such arrays and clusters 
from any Linux (or other *nix) box using any OSS SCSI target 
implementation starting from SCST I have been developing. Such 
array/cluster devices use links with in an order of magnitude higher 
latency, they are very sophisticated inside, so have much bigger 
internal latencies as well as they have much bigger opportunities to 
optimize I/O pattern by internal reordering. All the record numbers I've 
seen so far were reached with deep queue. For instance, the last SCST 
record (>500K 4K IOPSes from a single target) was achieved with queue 
depth 128!

So, I believe, Linux must use that possibility to get full storage 
performance and to finally simplify its storage stack.

Vlad
