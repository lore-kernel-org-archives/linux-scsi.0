From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [ANNOUNCE] Status of unlocked_qcmds=1 operation for .37
Date: Sun, 31 Oct 2010 14:14:28 +0200
Message-ID: <4CCD5DA4.9090806@panasas.com>
References: <1288132071.8283.689.camel@mulgrave.site> <1288132464.5169.112.camel@haakon2.linux-iscsi.org> <1288133450.8283.723.camel@mulgrave.site> <1288134048.5169.132.camel@haakon2.linux-iscsi.org> <1288134713.19649.11.camel@mulgrave.site> <1288135918.5169.149.camel@haakon2.linux-iscsi.org> <20101027075349.GA32585@gargoyle.fritz.box> <1288189658.4692.13.camel@mulgrave.site> <20101028091020.GA7906@gargoyle.fritz.box> <4CC95BE8.3000909@panasas.com> <20101028182610.GA4592@gargoyle.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og110.obsmtp.com ([64.18.0.20]:38352 "HELO
	exprod5og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755376Ab0JaMOg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Oct 2010 08:14:36 -0400
In-Reply-To: <20101028182610.GA4592@gargoyle.fritz.box>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@linux.intel.com>
Cc: James Bottomley <James.Bottomley@suse.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Mike Anderson <andmike@linux.vnet.ibm.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <jaxboe@fusionio.com>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>, Jon Hawley <warthog9@kernel.org>, Brian King <brking@linux.vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "H. Peter Anvin" <hpa@zytor.com>, julia@diku.d

On 10/28/2010 08:26 PM, Andi Kleen wrote:
>> I disagree with your approach this introduces a spin_unlock_irqrestore
>> call site at every return, in the usually huge queuecommand.
> 
> I converted the full tree and in practice it turns out there 
> are very few returns in nearly all queuecommands. So it won't
> make much difference.
> 

"few returns" is too much. Any thing bigger than 1 is a total wast.

And the mess?!? Where to add the flags? where the returns? Need a 
"{...}" or not. Lots of manual intervention, and possible errors.
I bet with my approach you wouldn't need to manually fix a single
file.

> Longer term they will be all hopefully gone again anyways.
> 

That one I'm most afraid of. These that did not get fixed in this
round, will not be fixed for a long time (if ever). I'd even go
anal and not open code the lock but actually call the original
__queue_command through a MACRO, that can be change in one place.
(And will solve your patchset bisect-ability)

- XXX_queue_command(...
+ XXX_queue_command_unlocked(...


+ XXX_queue_command(...
+ {
+ 	return SCSI_LOCKED_QUEUECOMMAND(XXX_queue_command_unlocked, ...);
+ }
> -Andi

But since I'm only blabing, the one that "do", gets to decide ;-) .
Perhaps next time.

Boaz
