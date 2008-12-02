From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: iscsi update for 2.6.29
Date: Tue, 02 Dec 2008 11:52:55 -0600
Message-ID: <493575F7.5090706@cs.wisc.edu>
References: <1228199536-12595-1-git-send-email-michaelc@cs.wisc.edu> <49356C19.3020207@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:41044 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754591AbYLBRxJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Dec 2008 12:53:09 -0500
In-Reply-To: <49356C19.3020207@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi@vger.kernel.org

Boaz Harrosh wrote:
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

Thanks.


> I have sent comments about bidi mistakes made in the cxgb3i side
> of this patchset but never got a response and it seems they have not
> been fixed. But I might have missed the fixes. is the cxgb3i branch on


You mean you have sent comments about cxgb3i patches right? I think they 
are saving them for last.


> git://git.kernel.org/pub/scm/linux/kernel/git/mnc/linux-2.6-iscsi.git
> the latest iteration of these patches? I'll have another look if you want?
> 


Yes, but my cxgb3i driver in there is a little old. It is the latest 
they have sent to the lists, but there are lots of fixes floating around.


> If you want I can help you set up a SW only OSD setup, to test if cxgb3i
> is bidi clean. What about the other accel cards?

I do not think cxgb3i is ready for ahs in the send path. See the comment 
in cxgb3i_ulp.c's cxgb3i_conn_ulp2_alloc_pdu callout. It requires some 
changes to iscsi_prep_scsi_cmd_pdu header setup so we have the size 
before we allocate the header (cxgb3i works with skbs and uses the skb 
allocators from the network layer for its header allocation and does not 
preallocate like iscsi_tcp), or that we allocate a skb large enough to 
hold any header then trim it if we have extra space. Your help in this 
area would be really helpful. I did not want to much around a lot 
because I could not test and did not want to add a regression to the 
existing ahs code.

qla4xxx is a offload card you might want to test. Then there is iser, 
and I thought you had patches for them already.

bnx2i is reworking their firmware according to the netdev review, so you 
can look at the driver in the bnx2i branch, but it is really old. It 
would probably be helpful to get an idea of how they are working with 
the scatterlists and scsi commands though.


> 
> One more test that I never did is OSD (bidi) commands with header+data
> digest enabled. Now with OSC's OSD target over TOMO's stgt I should be
> able to test that. IBM's target did not support it because OSD has its
> own digest stuff. TOMO's stgt does supports header+data digest right?
> I should run these tests later this week. Just to make sure the digest
> stuff is bidi safe. I'm sure it is but just that I never tested it.
> 

I think there might be a bug in the data digest code. When testing this 
code I noticed that around the time the scatterlist changes started 
showing up a couple kernels ago, data digests did not work in iscsi. I 
started tracking it down and I think it might be in the crypto 
scatterlist code. I am not sure and do not have enough info to make a 
bug report yet.
