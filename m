From: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: 2.6.20.3: kernel BUG at mm/slab.c:597 try#2
Date: Mon, 19 Mar 2007 10:32:00 +0200
Message-ID: <84144f020703190132w4596a810k23f3423f36a52630@mail.gmail.com>
References: <45FDDA8E.8030100@domdv.de>
	 <20070318220006.7230fd58.akpm@linux-foundation.org>
	 <84144f020703190100j5becc9dka2eba58456ab95f3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:27914 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbXCSIcE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Mar 2007 04:32:04 -0400
Received: by nf-out-0910.google.com with SMTP id o25so988327nfa
        for <linux-scsi@vger.kernel.org>; Mon, 19 Mar 2007 01:32:01 -0700 (PDT)
In-Reply-To: <84144f020703190100j5becc9dka2eba58456ab95f3@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Steinmetz <ast@domdv.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On 3/19/07, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> EIP is at kmem_cache_free+0x29/0x5a
> eax: c1800000   ebx: f0ae12c0   ecx: c18f73c0   edx: c1800000
> esi: c1919de0   edi: 00000000   ebp: 00001000   esp: f1fe7e14
> ds: 007b   es: 007b   ss: 0068
>
> But somehow eax and edx have the same value 0xc1800000 here. Hmm?

Aah, but if you look at contents of the stack:

Stack: f0ae12c0 c1919de0 ffffffea c0137f97 00000000 f0ae12c0 c1919e20 c0168d45
       f0ae12c0 00001000 c0168fb9 c02a77e3 00001000 00000000 00000000 00000000
       00000000 c17bb6e0 00001000 00000000 f1b38be8 00000003 f54ac050 c1b9d6e8
Call Trace:
 [<c0137f97>] mempool_free+0x48/0x4c
 [<c0168d45>] bio_free+0x21/0x2c
 [<c0168fb9>] bio_put+0x22/0x23

You can see that mempool_free is passing a NULL pointer to
kmem_cache_free() which doesn't handle it properly. The NULL pointer
comes from bio_free() where ->bi_io_vec is  NULL because nr_iovecs
passed to bio_alloc_bioset() was zero.

The question is, why is nr_pages zero in scsi_req_map_sg()?
