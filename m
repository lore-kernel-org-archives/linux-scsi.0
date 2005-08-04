From: Arjan van de Ven <arjan@infradead.org>
Subject: RE: [PATCH 6/7] aacraid: unlock around kfree
Date: Thu, 04 Aug 2005 13:47:50 +0200
Message-ID: <1123156071.3318.16.camel@laptopd505.fenrus.org>
References: <60807403EABEB443939A5A7AA8A7458B017931E7@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:18824 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262486AbVHDLsS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2005 07:48:18 -0400
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B017931E7@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Haverkamp <markh@osdl.org>, James Bottomley <James.Bottomley@SteelEye.com>

On Thu, 2005-08-04 at 07:33 -0400, Salyzyn, Mark wrote:
> Good to know. I went through one too many code reviews and had no
> defense against the request.
> 
> There is a follow-up to this one not yet submitted to MarkH where I
> endeavor to pre-allocate with kmalloc(,GFP_ATOMIC|GFP_KERNEL) a pool
> before entering a locked list traversal rather than risking making the
> calls with the locks held. The code is in an independent kernel thread
> handling deferred actions triggered by the interrupt. Am I barking up
> the wrong tree?

why do you need the GFP_ATOMIC if you allocate outside all locks?
Yes the idea is the right one; do a sleeping alloc outside all locks,
instead of a far more fragile atomic alloc inside locks.

Note: if you don't want the allocation to cause IO (which could recurse
into your driver) you need to use GFP_NOIO not GFP_KERNEL; the
difference is important for avoiding recursion-deadlocks


