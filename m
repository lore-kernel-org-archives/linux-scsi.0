From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Open-FCoE] [RFC PATCH] scsi, fcoe, libfc: drop scsi host_lock
 use from fc_queuecommand
Date: Wed, 01 Sep 2010 20:37:03 -0500
Message-ID: <4C7EFFBF.3050705@cs.wisc.edu>
References: <20100831225338.25102.59500.stgit@localhost.localdomain>	<1283298985.32007.530.camel@haakon2.linux-iscsi.org>	<4C7DD3E8.9050700@cs.wisc.edu>	<7C88852EF6F99F4EB538472FCFEBE222013AF95EB2@orsmsx509.amr.corp.intel.com>	<1283371821.32007.636.camel@haakon2.linux-iscsi.org>	<1283375187.30431.71.camel@vi2.jf.intel.com>	<20100901224503.GB4089@cleech-lnx.jf.intel.com> <4C7EE3F2.70409@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:55241 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383Ab0IBBcQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Sep 2010 21:32:16 -0400
In-Reply-To: <4C7EE3F2.70409@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Leech <christopher.leech@intel.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@suse.de>, "devel@open-fcoe.org" <devel@open-fcoe.org>, Christoph Hellwig <hch@lst.de>

On 09/01/2010 06:38 PM, Mike Christie wrote:
> wondering if there could be a problem where one thread completes the IO
> and sets those fields to NULL, but another thread could be completing it
> too and it would see a scsi_cmnd that is not released and reallocated by

There should not be a not in there. So it should be and it would see a 
scsi_cmnd that is released and reallocated by the other thread.

> the other thread. So for example the fc_eh_abort code still grabs the
> host_lock when calling CMD_SP and taking a ref and checking that the fsp
> is not null.

