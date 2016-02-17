From: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Use ida_simple for SCSI iSCSI transport session id
Date: Wed, 17 Feb 2016 14:37:08 -0800
Message-ID: <20160217223708.w35zn3h66gwv5jlw@straylight.hirudinean.org>
References: <1455298733-18651-1-git-send-email-lduncan@suse.com>
 <1455299691.2396.45.camel@HansenPartnership.com>
 <20160215182653.pvo6crry2wqwgjso@straylight.hirudinean.org>
 <56C36D0C.3030002@cs.wisc.edu>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <open-iscsi+bncBCYMVIPVXQMBBF7MSO3AKGQENMYJ5LY-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56C36D0C.3030002-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: Lee Duncan <lduncan-IBi9RG/b67k@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 16, 2016 at 12:40:12PM -0600, Mike Christie wrote:
> On 02/15/2016 12:26 PM, Chris Leech wrote:
> > On Fri, Feb 12, 2016 at 09:54:51AM -0800, James Bottomley wrote:
> >> On Fri, 2016-02-12 at 09:38 -0800, Lee Duncan wrote:
> >>> The scsi_transport_iscsi module already uses the ida_simple
> >>> routines for managing the target ID, if requested to do
> >>> so. This change replaces an ever-increasing atomic integer
> >>> that tracks the session ID itself with the ida_simple
> >>> family of routines. This means that the session ID
> >>> will be reclaimed and can be reused when the session
> >>> is freed.
> >>
> >> Is reusing session ID's really a good idea?  For sequential sessions it
> >> means that the ID of the next session will be re-used, i.e. the same as
> >> the previous sessions, which could lead to target confusion.  I think
> >> local uniqueness of session IDs is more important than wrap around
> >> because sessions are short lived entities and the chances of the same
> >> session being alive by the time we've wrapped is pretty tiny.
> > 
> > I've got a few complaints about target resources being tied up because
> > we don't reuse session IDs.  The ISID becomes a component in the
> > I_T nexus identifier, so changing it invalidates persistent reservations.
> > 
> >> If you can demostrate a multi-target problem, perhaps we should rather
> >> fix this by making the next session id a target local quantity?
> > 
> > Mike's got a good point that we don't really need to base the ISID off
> > of our local session identifier (kobject name).  I think getting reuse
> > right may be a bit trickier than being a target local value, because it
> > needs to be unique across target portal groups.  Which probably furthers
> > the argument that we should deal with that in the userspace tools.
> > 
> > If we plan to split the protocol ISID cleanly from the kobject name,
> > I guess the question is if aggressive reuse of the local identifier is
> > better than dealing with the unlikely collision on rollover?
> 
> I thought Lee's patch to convert the host_no from a atomic_t to ida
> based was merged in Martin's tree. If that is going upstream, then I
> thought you would want to fix the session id too.
> 
> Is the concern similar to /dev/sdX reuse and bad apps? In this case,
> some app might do a logout and login, but not update the sysfs mapping.
> You could then hit corruption due to the sysfs session id now mapping to
> a different target.

OK, I don't want to cause a rehash of the same concerns. I took a look
at whatever code I could think to check in that builds on top of the
Open-iSCSI tools, and I don't think this will break anything.

I'm OK with this.

- Chris

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
