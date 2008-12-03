From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [Fwd: Re: iscsi update for 2.6.29]
Date: Wed, 03 Dec 2008 10:33:58 +0200
Message-ID: <49364476.5010608@panasas.com>
References: <4935764C.4080007@cs.wisc.edu> <8A71B368A89016469F72CD08050AD33403E32F0A@maui.asicdesigners.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:1589 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752655AbYLCIeD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Dec 2008 03:34:03 -0500
In-Reply-To: <8A71B368A89016469F72CD08050AD33403E32F0A@maui.asicdesigners.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Karen Xie <kxie@chelsio.com>
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

http://groups.google.com/group/open-iscsi/msg/dd660ab6b0def64f?&q=cxgb3i%3A+cxgb3+iSCSI+initiator+boaz

Karen Xie wrote:
> Hi, Boaz,
> 
> Sorry, I must have missed your bidi comment. I tried to search the archive but does not seem to be able to find anything. Do you mind forward me the email if you still have it?
> 
> Sorry for the inconvenience.
> Thanks,
> Karen
> 
> -------- Original Message --------
> Subject: Re: iscsi update for 2.6.29
> Date: Tue, 02 Dec 2008 19:10:49 +0200
> From: Boaz Harrosh <bharrosh@panasas.com>
> To: michaelc@cs.wisc.edu
> CC: linux-scsi@vger.kernel.org
> References: <1228199536-12595-1-git-send-email-michaelc@cs.wisc.edu>
> 
> michaelc@cs.wisc.edu wrote:
>> This patchset is for 2.6.29. This should be the final patches
>> to prepare the iscsi layer for cxgb3i, which looks like it
>> has gone through the netdev review and will be sent here next
>> shortly.
>>
>> This patchset was made over scsi-misc, and the fix here.
>> http://marc.info/?l=linux-scsi&m=122815519326207&w=2
>> (the fix in that email does not conflict with this patchset
>> and can be applied over or before these patches).
>>
>> cxgb3i adds a new offload model. Where qla4xxx offloaded pretty
>> much everything, and bnx2i offloaded the iscsi sequence processing
>> (give it the iscsi scsi command pdu and the offload engine will
>> handle everything between), cxgb3i offloads operations like
>> digest, padding, and data transfers. It relies on the iscsi layer
>> for the sequence state machine, so this patchset is basically
>> just breaking up iscsi_tcp into a lib layer so cxgb3i can share
>> the code.
>>
> 
> OK I tested that lot finally, and it's good. I'm able to bang
> bidi commands on it and it seems to works. exofs (was osdfs) mounts
> and works as before. I'll let it run through the night and see if
> it holds. (It should)
> 
> So the generic layer of this patchset is tested.
> 
> I have sent comments about bidi mistakes made in the cxgb3i side
> of this patchset but never got a response and it seems they have not
> been fixed. But I might have missed the fixes. is the cxgb3i branch on
> git://git.kernel.org/pub/scm/linux/kernel/git/mnc/linux-2.6-iscsi.git
> the latest iteration of these patches? I'll have another look if you want?
> 
> If you want I can help you set up a SW only OSD setup, to test if cxgb3i
> is bidi clean. What about the other accel cards?
> 
> One more test that I never did is OSD (bidi) commands with header+data
> digest enabled. Now with OSC's OSD target over TOMO's stgt I should be
> able to test that. IBM's target did not support it because OSD has its
> own digest stuff. TOMO's stgt does supports header+data digest right?
> I should run these tests later this week. Just to make sure the digest
> stuff is bidi safe. I'm sure it is but just that I never tested it.
> 
> Thanks
> Boaz

