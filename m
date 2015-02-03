From: "Dr. Greg Wettstein" <greg@wind.enjellic.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Unifying the LIO and SCST target drivers
Date: Tue, 3 Feb 2015 04:06:20 -0600
Message-ID: <201502031006.t13A6KhM008961@wind.enjellic.com>
References: <hch@infradead.org>
Reply-To: greg@enjellic.com
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: Christoph Hellwig <hch@infradead.org>
       "Re: [Lsf-pc] [LSF/MM TOPIC] Unifying the LIO and SCST target drivers" (Jan 19,  1:21am)
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On Jan 19,  1:21am, Christoph Hellwig wrote:
} Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Unifying the LIO and SCST target driv

Hi, I hope the week is going well for everyone.

I'm a bit behind on e-mail and getting ready for travel but wanted to
reply back to this thread because of our involvement and interest in
this whole situation.

> On Thu, Jan 15, 2015 at 05:13:00PM +0100, Bart Van Assche wrote:
> > My goal is to realize this proposal without adding hooks for out-of-tree
> > code in the upstream kernel. What I had in mind is to raise the
> > abstraction level of the API between LIO core and target drivers a
> > little bit (e.g. by using accessor functions where necessary instead of
> > accessing structure members directly)

> That's very much a hook, althiugh a week one.
> 
> Either way I don't think bringing up a very much political topic
> without even any code to discuss isn't a very valueable use of our time
> slots.

There is code, no one is bothering to look at it or understand the
issues involved.

It takes a six line patch to the in-kernel Qlogic target driver for
SCST to leverage and contribute positively to the state of the
in-kernel driver.  A six line patch, which if we were engaging in
grounded engineering discussions, implements an interface which we
haven't found anyone who suggests is unfounded.

Our bona-fides in all this is that we developed the SCST target
interface driver which allows SCST to sit on top of the in-kernel
Qlogic target driver.  That driver is in use in a number of locations
driving hundreds and hundreds and hundreds of terrabytes of storage.

See the scst-devel and linux-scsi lists and the following:

ftp://ftp.enjellic.com/pub/scst/sqa_driver-1.1.tar.gz

Based on these experiences and building and debugging very complex
converged networks we can state pretty unequivocably that the current
target driver situation is working to no ones advantage.

The in-kernel target driver hasn't seen significant improvement or
work in over a year.  We carry a number of patches and bug fixes to
the driver which we have identified and fixed locally.  We are so
frustrated with the whole situation we don't even bother to push fixes
upstream.  So the notion that holding the in-kernel target driver as a
sacred bastion of purity will lead to a better codebase is ill
founded.

We cherry pick patches back and forther between the in-kernel and
out-of-kernel drivers and can speak pretty authoritatively to the fact
the in-kernel driver is now slipping behind the out-of-tree code.

There is a significant regression, which we believe can lead to
catastrophic data corruption under the right conditions, in the Qlogic
target driver, both in-tree and out-of-tree.  We believe the problem
is in session handling and have provided logs to Qlogic and were told,
'there is a issue and we are looking into it', but haven't heard
anything back.

The simple fact of the matter is that in modern CNA's/HBA's all of
this behavior is ultimately governed by the firmware in the cards.  No
one has access to that but the vendors.  We can make their job in
supporting the whole storage community easier if we are all looking at
and working on the same code, to the extent that is possible.

I can't speak to Infiniband but in the realm of fibre-channel/FCOE the
only problem is political not technical.

This is not an issue of a vendor electing to keep code out of tree.
The decision was made to take LIO into the kernel and there are not
going to be two in-kernel target stacks, so SCST is going to live out
of tree.  Those of us with significant engineering investments are not
going to dump SCST and move to the in tree code, good, bad or
indifferent.

We are willing and have expended the engineering time to make this
situation better.  An engineering based discussion comes down to what
types of legitimate API's the kernel needs to expose.  We do that all
over the kernel, I'm not sure why storage, other then politics, needs
to be any different.

Best wishes for a productive week.

Greg

}-- End of excerpt from Christoph Hellwig

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"For a successful technology, reality must take precedence over public
 relations, for nature cannot be fooled."
                                -- Richard Feynmann
