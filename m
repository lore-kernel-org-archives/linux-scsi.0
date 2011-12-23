From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH 13/14] ib_srp: Implement transport layer ping
Date: Fri, 23 Dec 2011 16:56:05 -0600
Message-ID: <4EF50705.7090200@cs.wisc.edu>
References: <201112011954.25811.bvanassche@acm.org>  <201112012011.45444.bvanassche@acm.org>  <1324255806.17849.68.camel@obelisk.thedillows.org>  <CAO+b5-o+-JF61a+8vFWj1rxMuVWuG-CVLQKorr5cKzi-Kc44Ag@mail.gmail.com>  <1324333931.7043.52.camel@lap75545.ornl.gov>  <CAO+b5-r4AZymMkVyFSXbBzpcc86hL0RJm2j3FnT3=uXSLUkj9A@mail.gmail.com>  <1324436736.7621.38.camel@obelisk.thedillows.org>  <CAO+b5-p=01KyDv7swOP_K39+i1rSMDsd_VVvSi5rBWveMaov1Q@mail.gmail.com> <1324679698.3004.12.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1324679698.3004.12.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Fujita Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Brian King <brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 12/23/2011 04:34 PM, David Dillow wrote:
> On Wed, 2011-12-21 at 14:07 +0000, Bart Van Assche wrote:
>> On Wed, Dec 21, 2011 at 3:05 AM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
>>> We don't want to leave a target blocked indefinitely -- commands caught
>>> in the blocked queue won't be reissued until the queue is unblocked --
>>> but we may want to keep the sdX mappings around for a long time.
>>> fast_io_fail_tmo gives us the ability to do that -- the expiration of
>>> fast_io_fail_tmo unblocks the queue and allows commands to be failed due
>>> to the transport error. See commit f2818663.
>>
>> Our opinions may differ here. My opinion is that for some use cases it
>> is crucial to be able to block a target indefinitely, e.g. when there
>> is only a single path between initiator and target and when the user
>> prefers that I/O blocks instead of encountering I/O errors. See e.g.
>> the "iSCSI settings for iSCSI root" section in the iSCSI README
>> (http://www.open-iscsi.org/docs/README).
> 
> I can see admins desiring that option, but it's also handled by putting
> your root on a dm-multipath volume. Either way, I'm open to letting
> things block indefinitely, but I do think we should look into why the
> SCSI stack has a concept of the maximum blocking time.
> 
>> Regarding commit f2818663: as far as I can see what that commit does
>> is to make it impossible for a user to set fast_io_fail_tmo == -1
> 
> I was pointing to the commit message as evidence of more prominent SCSI
> developer's line of thought on handling missing devices. As you note,
> the actual diff is uninteresting.
> 
> We should match the rest of the SCSI stack unless there is good reason
> to go our own way. The iSCSI transport can do what it does because it
> has a native ping, but I'm not convinced they should have introduced new
> semantics and/or names when taking advantage of that. As far as I can
> tell without deeply studying it, replacement_timeout is equivalent to
> fast_io_fail_tmo.
> 

iSCSI replacement_timeout is the same as fast_io_fail_tmo for FC. iSCSI
replacement_timeout actually came first so you should say FC should have
copied our name :)

So FC has fast_io_fail_tmo which controls when to fail IO when a port is
blocked. This can be set to so that it does not ever fire. However, FC
also has the dev_loss_tmo which controls when to remove devices (and
also fail IO) when a port is blocked. This one cannot be turned off, so
it will eventually fire and you will get IO errors (this is due to the
devices being removed and the scsi layer then failing all IO).

iSCSI had replacement_timeout first, and it only fails IO, because at
the time things did not handle hotplug removal well, and I did not know
there was a need for the removal. There is patch to add dev_loss_tmo to
the iSCSI layer. There have been some bugs though, so I have not pushed
it. But it will also work like FC where you cannot turn it off.

SAS has something like the dev_loss_tmo. It does not have something like
the fast_io_fail/replacement_timeout.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
