From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH v2 01/16] iscsi-target: add callback to alloc and free PDU
Date: Wed, 13 Apr 2016 12:56:25 +0300
Message-ID: <570E17C9.3010204@grimberg.me>
References: <cover.1460204441.git.varun@chelsio.com>
 <674e8ae2dae3d6274dcb1abe6ddef253f6a71256.1460204441.git.varun@chelsio.com>
 <570A8E81.8010007@grimberg.me> <20160411145446.GA1987@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36495 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030610AbcDMJ4a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Apr 2016 05:56:30 -0400
In-Reply-To: <20160411145446.GA1987@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, nab@linux-iscsi.org, swise@opengridcomputing.com, kxie@chelsio.com, indranil@chelsio.com


>> On 09/04/16 16:11, Varun Prakash wrote:
>>> Add two callbacks to struct iscsit_transport -
>>>
>>> 1. void *(*iscsit_alloc_pdu)()
>>>     iscsi-target uses this callback for
>>>     iSCSI PDU allocation.
>>>
>>> 2. void (*iscsit_free_pdu)
>>>     iscsi-target uses this callback
>>>     to free an iSCSI PDU which was
>>>     allocated by iscsit_alloc_pdu().
>>
>> Can you please explain why are you adding two different
>> callouts? Who (Chelsio T5) will need it, and why they can't
>> use the in-cmd pdu?
>
> I am adding these to avoid per PDU 48 bytes(BHS) memcpy from cmd->pdu to
> transport driver tx buffer, iscsi-target can directly form iscsi hdr
> in transport driver tx buffer.

Is that what it's for? Looks meaningless to me, do
you have an indication that this is some sort of bottleneck?

I see you memset in your pdu_alloc, where is the gain
here anyway?
