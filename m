From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 1/24][RFC] scsi_eh: Define  new API for sense handling
Date: Tue, 05 Feb 2008 17:43:29 +0200
Message-ID: <47A88421.4080906@panasas.com>
References: 47A72A7F.1050301@panasas.com  <1202139034-4508-1-git-send-email-bharrosh@panasas.com> <1202146408.3096.56.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:52665 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980AbYBEPqC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 10:46:02 -0500
In-Reply-To: <1202146408.3096.56.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>, Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

On Mon, Feb 04 2008 at 19:33 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Mon, 2008-02-04 at 17:30 +0200, Boaz Harrosh wrote:
>> This patch defines a new API for sense handling. All drivers will
>>   be converted to this API, before the sense handling implementation will
>>   change. API is as follows:
>>
>>     void scsi_eh_cpy_sense(struct scsi_cmnd *cmd, void* sense,
>>         						 unsigned sense_bytes);
>>         To be used by drivers, when they have sense-bits
>>         and wants to send them to upper layer. Max size
>>         need not be a concern, If upper layer does not have
>>         enough space it will be automatically truncated.
>>
>>     u8 *scsi_make_sense(struct scsi_cmnd *cmd);
>>         To be used by drivers, and scsi-midlayer. Returns a DMA-able
>>         sense buffer. Must be returned by scsi_return_sense(). It should
>>         never fail if .pre_allocate_sense && .sense_buffsize in host
>>         template where properly set.
>>         the buffer is of shost->sense_buffsize long.
>>
>>     void *scsi_return_sense(struct scsi_cmnd *cmd, u8 *sb);
>>         Frees and returns the sense to the upper layer,
>>         copying only what's necessary.
>>
>>     void scsi_eh_reset_sense(struct scsi_cmnd *cmd)
>>         Should not be used or necessary.
>>
>>     const u8 *scsi_sense(struct scsi_cmnd *cmd)
>>         Used by ULDs and for inspecting the returned sense, can not
>>         be modified. It is only valid after a call to
>>         scsi_eh_cpy_sense() or a call to scsi_return_sense(). Before
>>         that it will/should return an empty buffer.
>>
>>     New members at scsi host template:
>>         .sense_buffsize - if a driver calls scsi_make_sense() or
>>                   scsi_eh_prep_cmnd(), This value should be none
>>                   zero indicating the max sense size, the driver
>>                   supports. In most cases it should be
>>                   SCSI_SENSE_BUFFERSIZE.
>>                   If this value is zero the driver will only call
>>                   scsi_eh_cpy_sense().
>>
>>         .pre_allocate_sense - if a Driver calls scsi_make_sense()
>>                       in .queuecommand for every cmnd, this
>>                       should be set to true. In which case
>>                       scsi_make_sense() will not fail because
>>                       midlayer will fail the command allocation.
>>                       If the drivers calls scsi_eh_prep_cmnd()
>>                       then sense_buffsize is not Zero but this
>>                       here is set to false.
> 
> My initial reaction to this is that you're doing too many contortions to
> ensure something we don't particularly care about:  whether we can
> allocate a sense buffer atomically or not.

I hope that now, once you've actually seen the implementation, my
motivation is clearer.  Perhaps I explained it badly, but the actual code
is pretty simple and contortions is not how I would describe it. The API
above is just a way for drivers to say how they intend to behave, and the
midlayer will accommodate easily. None of the solutions are hard and they
are all simpler then what exists today. The only added complexity introduced 
is the initial choice.

> 
> What all this code should be doing is simply allocating the sense buffer
> in scsi_eh_prep_cmnd() using tomo's existing slab (and GFP_ATOMIC) 

This is what we are doing. Only allocating the sense buffer in the very
unlikely event of the call to scsi_eh_prep_cmnd(). So we are in agreement
here.

> if
> that fails, we need a return from scsi_eh_prep_cmnd() telling us.  At
> that point, the driver should abandon the auto request sense attempt and
> instead just return the CC/UA without the DRIVER_SENSE bit set which
> will trigger the eh to collect the sense for us.
> 

This is a nightmare and a serious regression. It will cause an IO deadlock
in the event of an IO error during an IO-to-free-memory scenario.

The memory footprint of a system running with my patchset, after the very first 
request, is the same as with the current (Post Tomo) code. Only thing is, my system
will preallocate a bit more memory, 96 bytes, per device scanned.  This happens
anyway, currently, with Tomo's code as soon as the device is used the first time.

Preallocating the sense buffer during initialization eliminates the need to allocate
it for every command, providing considerable performance and memory consumption 
benefits. All that without compromising robustness in the event of an IO error on 
heavily loaded systems.

> Ideally, doing it this way might mean we could even dump the
> sense_buffer pointer from the command (although I don't see that as
> necessary).
> 
> This solves the 99% case without getting into preallocation contortions.
> 

after the final patch you can see that I have ditched the sense_buffer pointer
without sacrificing anything in reliability, and absolutely got rid of any
sense allocation in the 99% of successful IO.

> James
> 

I apologize for not explaining myself well. I think the point of this patchset
was missed. (I know it is me, because it happens to me often)

My primary motivation was as follows.
1. Get rid of the sense_buffer at scsi layer, and go directly to block layer
   sense buffer. But do this only once with a simple accessor that will let me
   have freedom of implementation later. (And simplify code, catch bugs and have
   a central point of control)

2. In the less common scenario of these drivers that need to DMA into the sense
   buffer, Only allocate the buffer in the error path but make sure that the system
   stays as robust as today. With hopefully no memory footprint penalty.

3. Since I need to change a bunch of drivers, and there are these rare drivers that
   absolutely need a DMA-able sense buffer before hand, and since there are more then
   two of them, so for the sake of reusable code: Have utility functions for these
   drivers as well. Even more so, if the same exact code can also be reused by the other
   code paths, but with a different usage model.

4. I had one more motivation which is not immediately apparent but is included in this
   patchset, that is the: "Bigger than 96 bytes sense buffer". The scsi protocol defines 
   the maximum possible sense buffer to be of 260 bytes. One-byte 4-bytes-aligned length
   specifier at offset 7 of header. hence 252+8. And guess what protocol needs these
   kind of sizes? you guessed right OSD. With submitted code an OSD ULD (like bsg) would
   allocate a 260 bytes buffer put 260 at request->max_sense_len. The iSCSI initiator
   that does a scsi_eh_cpy_sense() directly from network buffer at specified size will
   just copy all of it. Thanks to new request->max_sense_len and the new 
   scsi_eh_cpy_sense() that does the right job. All that with a minimal change (cleanup)
   to iscsi driver.
 
And hence what came out.
 
The patchset presented is just a pragmatic solution to the constraints and motivations
presented above, with "minimum change and maximum safety at drivers" mindset. When I began
this work I tended to do more work at the driver level, but very fast I got lazy and scared
from a "gdth effect", and settled on a good solid infrastructure at the mid-layer but
optional so it will only affect the more needy drivers.
 
Any new Ideas are welcome.
 
There are a couple of things to talk about, specifically the two WARN_ONs,
one at scsi_sense(), and one at scsi_make_sense() (See last patch) but lets do this
later. See how above is received first.
 
Thanks
Boaz

