From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/2] isci: remove base_controller abstraction
Date: Thu, 31 Mar 2011 14:21:29 -0700
Message-ID: <AANLkTinp=w7H68jtmsZbTBJ6ijBcKxCHM9-LZCOufATd@mail.gmail.com>
References: <20110328000754.GA28347@infradead.org>
	<20110328132046.GA497@infradead.org>
	<20110328132103.GA11684@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61491 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab1CaVVb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2011 17:21:31 -0400
Received: by fxm17 with SMTP id 17so2183866fxm.19
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2011 14:21:30 -0700 (PDT)
In-Reply-To: <20110328132103.GA11684@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

On Mon, Mar 28, 2011 at 6:21 AM, Christoph Hellwig <hch@infradead.org> =
wrote:
> Merge struct sci_base_controller into scic_sds_controller, and also f=
actor
> the two types of state machine handlers into one function. =A0While w=
e're at
> it also remove lots of duplicate incorrect kerneldoc comments for the=
 state
> machine handlers.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Conversion looks correct to me and smoketests fine, applied.

> + * XXX: How does the io_tag parameter get assigned to the io request=
?

This is an area where I think we can make some further
simplifications.  Currently the core supports a concept of
lldd-assigned and core-assigned io tags (the latter is currently being
used and is set at scic_sds_request_constructed_state_start_handler
time).  The Linux driver will never have use for more than one
assignment mode and to me it is awkward to have separate
hw-task-context (tci pool index) and lldd-request-object
(dma_pool_alloc) allocation domains.  One allocation can handle the
request object, tci, and tag allocation.  So this looks like:

1/ Convert to mvsas style pre-allocation of request objects so a
single number space handles available requests, task contexts, and
tags.  Since libsas drivers do not queue we will never be in a
situation of needing to oversubscribe requests to hw-task-contexts.
Although I have found that the sci_pool interface is faster than a
bitmap by a wide margin for randomly arriving completions.  It does
tradeoff space and simple detection of double-free conditions.  If
acceptable that probably wants to be a generic kernel facility unless
there is an existing ring-buffer method for tracking unique numbers?

2/ Reuse the request object allocation index as the tag/tci and move
sequence number management to the request allocation routine.

Essentially this is the next level of detail on the
isci_request/scic_sds_request unification.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
