From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Tue, 15 Feb 2011 12:42:21 +0900
Message-ID: <20110215124208B.fujita.tomonori@lab.ntt.co.jp>
References: <AANLkTikWDxfTFeGqG36Z1dAdWLeXmN7r=AsR3fsjBok+@mail.gmail.com>
	<20110214181129X.fujita.tomonori@lab.ntt.co.jp>
	<AANLkTin3Zb3OQz0942-2bcpfwqd8dGGnHyBjmeYt0FwZ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:50897 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196Ab1BODm3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Feb 2011 22:42:29 -0500
In-Reply-To: <AANLkTin3Zb3OQz0942-2bcpfwqd8dGGnHyBjmeYt0FwZ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bvanassche@acm.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com

On Mon, 14 Feb 2011 12:50:40 +0100
Bart Van Assche <bvanassche@acm.org> wrote:

> - send_rsp() sends back an SRP response with req_lim_delta = 1 before
> srp_iu_put() is invoked. I think this is a race condition: it can
> happen that the SRP initiator has received an SRP_RSP and sends a new
> SRP_CMD before srp_iu_put() was invoked. On a heavily loaded system
> that can trigger a queue overflow in the target.

Yeah, we had better to handle such case better.

But I don't think that we hit a critical event such as crash, memory
corruption, etc, with the current code.

In such case, srp_iu_get return NULL, so the target ignores the
request, then eventually the initiator recovers.

Probably, we should set the queue size to INITIAL_SRP_LIMIT + 1.


> - As anyone can see in the driver code (and as specified in the PAPR)
> management datagrams (MADs) fall outside the SRP credit mechanism.
> Hence not reserving one credit (assuming that the initiator makes sure
> there is at most one outstanding MAD) for MAD can - at least in theory
> - trigger a queue overflow.

I think that MAD is used only before the initiator starts real
I/Os. So I don't think that we can hit this issue in reality.


Thanks,
