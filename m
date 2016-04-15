From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] qla2xxx: rewrite code to avoid hitting gcc bug 70646
Date: Fri, 15 Apr 2016 14:15:58 -0700
Message-ID: <1460754958.2331.43.camel@HansenPartnership.com>
References: <1460716583-15673-1-git-send-email-dvlasenk@redhat.com>
	 <1460731203.2331.7.camel@HansenPartnership.com>
	 <57113959.8050103@redhat.com>
	 <1460747126.2331.28.camel@HansenPartnership.com>
	 <20160415200235.cqsozl445k6evhok@treble>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160415200235.cqsozl445k6evhok@treble>
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2016-04-15 at 15:02 -0500, Josh Poimboeuf wrote:
> On Fri, Apr 15, 2016 at 12:05:26PM -0700, James Bottomley wrote:
> > On Fri, 2016-04-15 at 20:56 +0200, Denys Vlasenko wrote:
> > > and now *many* users of qla2x00 and new-ish gcc are going to
> > > very much notice it, as their kernels will start crashing
> > > reliably.
> > > 
> > > The commits can be reverted, sure, but they per se do not contain
> > > anything unusual. They, together with not very typical construct
> > > in qla2x00_get_host_fabric_name, one
> > > which boils down to "swab64p(constant_array_of_8_bytes)",
> > > just happen to nudge gcc in a right way to finally trigger the
> > > bug.
> > > 
> > > So I came with another idea how to forestall the imminent deluge
> > > of
> > > qla2x00 oops reports - this patch.
> > 
> > There are actually a raft of checkers that run the upstream code
> > which
> > aren't seeing any problem; likely because the code is harder to
> > trigger
> > than you think.  So, lets wait until the resolution of the other
> > thread
> > before we panic, especially since we're only at -rc3.
> 
> Regardless of the outcome of the gcc bug, it seems kind of silly to
> byteswap a constant value of 0xffffffffffffffff.
> 
> 	uint8_t node_name[WWN_SIZE] = { 0xFF, 0xFF, 0xFF, 0xFF, \
> 		0xFF, 0xFF, 0xFF, 0xFF};
> 	u64 fabric_name = wwn_to_u64(node_name);
> 
> Similar to what Denys suggested, it can just be:
> 
> 	u64 fabric_name = -1;
> or
> 	u64 fabric_name = 0xffffffffffffffff;
> 
> Wouldn't that be an improvement to the code regardless?

"Improvement" would be in the eye of the beholder.  Semantically it
would be wrong because we're initialising a CPU local representation of
a big endian structure, so we *should* use the conversion.

James
