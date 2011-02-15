From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Tue, 15 Feb 2011 20:20:53 +0100
Message-ID: <AANLkTimPyjgoSnZrSXT2asV1Ly5D3NFUM3cn0-Jmp3Zm@mail.gmail.com>
References: <AANLkTikWDxfTFeGqG36Z1dAdWLeXmN7r=AsR3fsjBok+@mail.gmail.com>
 <20110214181129X.fujita.tomonori@lab.ntt.co.jp> <AANLkTin3Zb3OQz0942-2bcpfwqd8dGGnHyBjmeYt0FwZ@mail.gmail.com>
 <20110215124208B.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52120 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab1BOTVO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Feb 2011 14:21:14 -0500
Received: by gxk9 with SMTP id 9so255734gxk.19
        for <linux-scsi@vger.kernel.org>; Tue, 15 Feb 2011 11:21:14 -0800 (PST)
In-Reply-To: <20110215124208B.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com

On Tue, Feb 15, 2011 at 4:42 AM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
> On Mon, 14 Feb 2011 12:50:40 +0100
> Bart Van Assche <bvanassche@acm.org> wrote:
>
>> - send_rsp() sends back an SRP response with req_lim_delta = 1 before
>> srp_iu_put() is invoked. I think this is a race condition: it can
>> happen that the SRP initiator has received an SRP_RSP and sends a new
>> SRP_CMD before srp_iu_put() was invoked. On a heavily loaded system
>> that can trigger a queue overflow in the target.
>
> Yeah, we had better to handle such case better.
>
> But I don't think that we hit a critical event such as crash, memory
> corruption, etc, with the current code.
>
> In such case, srp_iu_get return NULL, so the target ignores the
> request, then eventually the initiator recovers.

Sorry but I do not agree that hitting this race is harmless. If this
race gets triggered the credit associated with the lost SRP
information unit will never be returned to the initiator. If this
happens frequently enough (INITIAL_SRP_LIMIT times), the initiator
will run out of credits and will lock up forever.

> Probably, we should set the queue size to INITIAL_SRP_LIMIT + 1.

With the current implementation of the SCSI storage target core that's
probably sufficient. But if that core is ever modified such that
multiple SCSI commands can be processed concurrently, that limit
wouldn't be sufficient anymore because then the described race
condition could be triggered in multiple threads simultaneously - at
least in theory.

An alternative solution is to modify send_iu() such that srp_iu_put()
is invoked after all relevant data has been copied via h_copy_rdma()
and to the CRQ and before h_send_crq() is invoked. That approach has
e.g. been implemented in this patch:
http://www.spinics.net/lists/linux-scsi/msg49105.html.

Bart.
