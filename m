From: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: iscsi flashnode bus? Re: [RFC PATCH 2/4] iscsi: sysfs filtering by
 network namespace
Date: Thu, 21 May 2015 13:49:06 -0700
Message-ID: <20150521204906.GF17115@straylight.hirudinean.org>
References: <1431555167-23995-1-git-send-email-cleech@redhat.com>
 <1431555167-23995-3-git-send-email-cleech@redhat.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <open-iscsi+bncBCYMVIPVXQMBBRMJ7GVAKGQES2P7SWI-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1431555167-23995-3-git-send-email-cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/open-iscsi/subscribe>
To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, May 13, 2015 at 03:12:45PM -0700, Chris Leech wrote:
> This makes the iscsi_host, iscsi_session, iscsi_connection, and
> iscsi_endpoint transport class devices only visible in sysfs under a
> matching network namespace.  The network namespace for all of these
> objects is tracked in the iscsi_cls_host structure.

I noticed that I didn't change iscsi_iface, but it should probably be
handled the same was as iscsi_endpoint.

I had intentionally skipped over all the flashnode stuff, until I had a
chance to go back and take a closer look.

Is there any particular reason why the flashnode support was implemented
as a bus?  Following the pattern of everything else in
scsi_transport_iscsi it should probably have been two classes
(iscsi_flash_session and iscsi_flash_conn).  It's an issue as sysfs
tagging only works on a per-class basis right now.

I can see a couple of ways forward.

1) Extend sysfs tagging to work with device_type as well as class, and
   use that for the two types on the flashnode "bus"

2) Change the flashnode code to use classes instead of a bus.  
   Keeping a single iscsi_flashnode class and continuing to use the two
   device_types for sessions and connections should result in the only
   visible change being /sys/bus/iscsi_flashnode moving to
   /sys/class/iscsi_flashnode.

I prefer #2, but it looks like the open-iscsi tools would need to be
updated (not all code paths follow the recommendations to ignore
bus/class differences and check all subsystem locations).  And I don't
know for sure that there aren't any other tools using this interface
(it's only implemented for qla4xxx).

- Chris

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at http://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
