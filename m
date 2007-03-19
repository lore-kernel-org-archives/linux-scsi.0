From: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: 2.6.20.3: kernel BUG at mm/slab.c:597 try#2
Date: Mon, 19 Mar 2007 10:35:46 +0200
Message-ID: <84144f020703190135t40e7cebnfa4f8443f514c24d@mail.gmail.com>
References: <45FDDA8E.8030100@domdv.de>
	 <20070318220006.7230fd58.akpm@linux-foundation.org>
	 <84144f020703190100j5becc9dka2eba58456ab95f3@mail.gmail.com>
	 <84144f020703190132w4596a810k23f3423f36a52630@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:32960 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbXCSIfs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Mar 2007 04:35:48 -0400
Received: by nf-out-0910.google.com with SMTP id o25so989333nfa
        for <linux-scsi@vger.kernel.org>; Mon, 19 Mar 2007 01:35:47 -0700 (PDT)
In-Reply-To: <84144f020703190132w4596a810k23f3423f36a52630@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Steinmetz <ast@domdv.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On 3/19/07, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> You can see that mempool_free is passing a NULL pointer to
> kmem_cache_free() which doesn't handle it properly. The NULL pointer
> comes from bio_free() where ->bi_io_vec is  NULL because nr_iovecs
> passed to bio_alloc_bioset() was zero.
>
> The question is, why is nr_pages zero in scsi_req_map_sg()?

Note that the following patch I posted only addresses the part where
slab is clearly failing here:

http://lkml.org/lkml/2007/3/19/42

So, while it should fix the oops, there might be a bug lurking in the
SCSI or block layer still.
