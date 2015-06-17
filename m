From: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] iSCSI: let session recovery_tmo sysfs writes persist
 across recovery
Date: Wed, 17 Jun 2015 08:31:07 -0700
Message-ID: <20150617153107.GB4996@straylight.hirudinean.org>
References: <1434496033-4601-1-git-send-email-cleech@redhat.com>
 <55818520.7030800@cs.wisc.edu>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <open-iscsi+bncBCYMVIPVXQMBBPVFQ2WAKGQEJX6MXSQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55818520.7030800-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/open-iscsi/subscribe>
To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 17, 2015 at 09:33:04AM -0500, Mike Christie wrote:
> On 06/16/2015 06:07 PM, Chris Leech wrote:
> > The iSCSI session recovery_tmo setting is writeable in sysfs, but it's
> > also set every time a connection is established when parameters are set
> > from iscsid over netlink.  That results in the timeout being reset to
> > the default value after every recovery.
> > 
> > The DM multipath tools want to use the sysfs interface to lower the
> > default timeout when there are multiple paths to fail over.  It has
> > caused confusion that we have a writeable sysfs value that seem to keep
> > resetting itself.
> > 
> > This patch adds an in-kernel flag that gets set once a sysfs write
> > occurs, and then ignores netlink parameter setting once it's been
> > modified via the sysfs interface.  My thinking here is that the sysfs
> > interface is much simpler for external tools to influence the session
> > timeout, but if we're going to allow it to be modified directly we
> > should ensure that setting is maintained.
> > 
> 
> What happened? Why didn't you make it more generic so all future iscsi
> sysfs settings work the same way like when I reviewed it in the bz? Did
> it get too messy when we only have the one writeable attr?

I kept the macro declaration, previous revision had that removed, and
modified it so that it could be used for future rw attrs in the same
manner.  It's possible something could be done for the override check in
iscsi_set_param, but there's not a lot of code to share here.

- Chris

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at http://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
