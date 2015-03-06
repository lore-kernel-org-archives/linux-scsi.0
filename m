From: "Dr. Greg Wettstein" <greg@wind.enjellic.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Unifying the LIO and SCST target drivers
Date: Thu, 5 Mar 2015 18:01:52 -0600
Message-ID: <201503060001.t2601qPJ021326@wind.enjellic.com>
References: <nab@linux-iscsi.org>
Reply-To: greg@enjellic.com
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
       "Re: [Lsf-pc] [LSF/MM TOPIC] Unifying the LIO and SCST target drivers" (Mar  1, 10:59pm)
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@infradead.org>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mar 1, 10:59pm, "Nicholas A. Bellinger" wrote:
} Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Unifying the LIO and SCST target driv

Hi, I hope the week is progressing well for everyone.

> On Sat, 2015-02-28 at 12:59 +0100, Bart Van Assche wrote:
> > On 02/27/15 22:58, Nicholas A. Bellinger wrote:
> > > Looking at how your attempting to drive creation + removal of struct
> > > config_group from within kernel code here:
> > > 
> > > target: Add target port registration API
> > > https://github.com/bvanassche/linux/commit/dbb8bf32db3428ede6ecc688ede1e5e01fc59d88
> > > 
> > > is the exactly the wrong approach to take.
> > > 
> > > The creation and deletion of struct config_group must be driven by
> > > user-space, and by user-space only.  No exceptions will be made.
> > 
> > There exists an approach that preserves the ABI of both SCST and LIO,
> > namely:
> > * Add empty transport_register_wwn() and transport_unregister_wwn()
> >   functions in the LIO core.
> > * Add calls to these functions at the appropriate place in the FC
> >   and SRP target drivers.
> > * In the SCST implementation of the unified target driver API, route
> >   calls to transport_register_wwn() and transport_unregister_wwn() to
> >   scst_register_target() and scst_unregister_target() respectively.
> > 

> NAK.
>
> I'll not consider any hooks in upstream target code, and certainly
> not driver hooks for a control-plane approach unanimously rejected
> by both configfs and sysfs maintainers in 2008 and 2010.
>
> The whole point of target_core_fabric_configfs.c is to transparently
> reference count fabric driver data structures populated underneath
> /sys/kernel/config/target/$FABRIC/, who's design also has the added
> bonus of providing module reference counting to drivers 'for free'.
>
> So until you're prepared to evolve on this issue and stop pretending
> as if the future didn't already happen, this type of discussion at
> LSF is a waste of time.

So, in this spirit of collaborative and collegial exchange, which I
see that Christoph has called for, I have a question for those who
posess familiarity with the LIO control plane design.

In this parousia of total user-space configuration, not necessarily a
bad thing, what would be the target fabric presentation of a storage
target server which has one Qlogic 8242 card and one Qlogic 8362 card
in it?

> --nab

Best wishes for a pleasant remainder of the week to everyone.

Greg

}-- End of excerpt from "Nicholas A. Bellinger"

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Man, despite his artistic pretensions, his sophistication and many
 accomplishments, owes the fact of his existence to a six-inch layer of
 topsoil and the fact that it rains."
                                -- Anonymous writer on perspective.
                                   GAUSSIAN quote.
