From: Chris Leech <cleech@redhat.com>
Subject: Re: [PATCH] Use ida_simple for SCSI iSCSI transport session id
Date: Mon, 15 Feb 2016 10:26:53 -0800
Message-ID: <20160215182653.pvo6crry2wqwgjso@straylight.hirudinean.org>
References: <1455298733-18651-1-git-send-email-lduncan@suse.com>
 <1455299691.2396.45.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1455299691.2396.45.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: Lee Duncan <lduncan@suse.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Feb 12, 2016 at 09:54:51AM -0800, James Bottomley wrote:
> On Fri, 2016-02-12 at 09:38 -0800, Lee Duncan wrote:
> > The scsi_transport_iscsi module already uses the ida_simple
> > routines for managing the target ID, if requested to do
> > so. This change replaces an ever-increasing atomic integer
> > that tracks the session ID itself with the ida_simple
> > family of routines. This means that the session ID
> > will be reclaimed and can be reused when the session
> > is freed.
> 
> Is reusing session ID's really a good idea?  For sequential sessions it
> means that the ID of the next session will be re-used, i.e. the same as
> the previous sessions, which could lead to target confusion.  I think
> local uniqueness of session IDs is more important than wrap around
> because sessions are short lived entities and the chances of the same
> session being alive by the time we've wrapped is pretty tiny.

I've got a few complaints about target resources being tied up because
we don't reuse session IDs.  The ISID becomes a component in the
I_T nexus identifier, so changing it invalidates persistent reservations.

> If you can demostrate a multi-target problem, perhaps we should rather
> fix this by making the next session id a target local quantity?

Mike's got a good point that we don't really need to base the ISID off
of our local session identifier (kobject name).  I think getting reuse
right may be a bit trickier than being a target local value, because it
needs to be unique across target portal groups.  Which probably furthers
the argument that we should deal with that in the userspace tools.

If we plan to split the protocol ISID cleanly from the kobject name,
I guess the question is if aggressive reuse of the local identifier is
better than dealing with the unlikely collision on rollover?

- Chris
