From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: iscsi update for 2.6.29
Date: Tue, 02 Dec 2008 19:10:49 +0200
Message-ID: <49356C19.3020207@panasas.com>
References: <1228199536-12595-1-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:24428 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754826AbYLBRKx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Dec 2008 12:10:53 -0500
In-Reply-To: <1228199536-12595-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org

michaelc@cs.wisc.edu wrote:
> This patchset is for 2.6.29. This should be the final patches
> to prepare the iscsi layer for cxgb3i, which looks like it
> has gone through the netdev review and will be sent here next
> shortly.
> 
> This patchset was made over scsi-misc, and the fix here.
> http://marc.info/?l=linux-scsi&m=122815519326207&w=2
> (the fix in that email does not conflict with this patchset
> and can be applied over or before these patches).
> 
> cxgb3i adds a new offload model. Where qla4xxx offloaded pretty
> much everything, and bnx2i offloaded the iscsi sequence processing
> (give it the iscsi scsi command pdu and the offload engine will
> handle everything between), cxgb3i offloads operations like
> digest, padding, and data transfers. It relies on the iscsi layer
> for the sequence state machine, so this patchset is basically
> just breaking up iscsi_tcp into a lib layer so cxgb3i can share
> the code.
> 

OK I tested that lot finally, and it's good. I'm able to bang
bidi commands on it and it seems to works. exofs (was osdfs) mounts
and works as before. I'll let it run through the night and see if
it holds. (It should)

So the generic layer of this patchset is tested.

I have sent comments about bidi mistakes made in the cxgb3i side
of this patchset but never got a response and it seems they have not
been fixed. But I might have missed the fixes. is the cxgb3i branch on
git://git.kernel.org/pub/scm/linux/kernel/git/mnc/linux-2.6-iscsi.git
the latest iteration of these patches? I'll have another look if you want?

If you want I can help you set up a SW only OSD setup, to test if cxgb3i
is bidi clean. What about the other accel cards?

One more test that I never did is OSD (bidi) commands with header+data
digest enabled. Now with OSC's OSD target over TOMO's stgt I should be
able to test that. IBM's target did not support it because OSD has its
own digest stuff. TOMO's stgt does supports header+data digest right?
I should run these tests later this week. Just to make sure the digest
stuff is bidi safe. I'm sure it is but just that I never tested it.

Thanks
Boaz
