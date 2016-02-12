From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH] Use ida_simple for SCSI iSCSI transport session id
Date: Fri, 12 Feb 2016 16:13:41 -0600
Message-ID: <56BE5915.9070308@cs.wisc.edu>
References: <1455298733-18651-1-git-send-email-lduncan@suse.com> <1455299691.2396.45.camel@HansenPartnership.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <open-iscsi+bncBCZ4TFNN2YMRBHFS7G2QKGQEQXEIR2A-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <1455299691.2396.45.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Lee Duncan <lduncan-IBi9RG/b67k@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 02/12/2016 11:54 AM, James Bottomley wrote:
> On Fri, 2016-02-12 at 09:38 -0800, Lee Duncan wrote:
>> The scsi_transport_iscsi module already uses the ida_simple
>> routines for managing the target ID, if requested to do
>> so. This change replaces an ever-increasing atomic integer
>> that tracks the session ID itself with the ida_simple
>> family of routines. This means that the session ID
>> will be reclaimed and can be reused when the session
>> is freed.
> 
> Is reusing session ID's really a good idea?

I think it is if we do it by the iscsi rfc. We have two issues.

1. For iSCSI's iSID we need a 24 bit id. The iSID + initiator name is
the SCSI initiator port ID, so targets want the iSID to be reused for
things like persistent reservation tracking.

There are a couple red hat bugzillas. I am not sure if they are open
though. Here is a KB

https://access.redhat.com/solutions/66861

for more info.

We have been lazy and did not implement this and were just reusing part
of the session->sid.

2. For the kobject/sysfs name we want a unique name/id. Linux boxes stay
up a long time and some users login and logout of sessions a lot. We
roll over and have collisions.

Lee's patch was only meant to fix this. The reuse part was not meant to
fix #1, and so it does not handle every case like you suspect.


To fix everything how about this:

- Use Lee's patch to fix #2. We do not need the iSID to match the sysfs
name. Userspace does not do any type of iSCSI iSID <-> kernel session id
matching.

- For #1, in the userespace node db code we can implement some iSID
allocation/management code that follows the spec. We can also add a
blacklist there in case we find broken targets.

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
