From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [bug] SCSI/SLUB - latest -git: WARNING: at mm/slub.c:2443
	kmem_cache_destroy, scsi_put_host_cmd_pool()
Date: Tue, 22 Apr 2008 15:10:20 +0200
Message-ID: <20080422131020.GB7311@elte.hu>
References: <20080419085758.GA18612@elte.hu> <1208611357.3280.5.camel@localhost.localdomain> <20080421134925.GK9554@elte.hu> <1208793440.3640.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3.mail.elte.hu ([157.181.1.138]:51752 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763527AbYDVNKi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Apr 2008 09:10:38 -0400
Content-Disposition: inline
In-Reply-To: <1208793440.3640.22.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>, Christoph Lameter <clameter@sgi.com>, linux-scsi <linux-scsi@vger.kernel.org>


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> Thanks ... it looks like we may have trouble from devices that alter 
> the unchecked isa dma flag after scsi_host_alloc.  The guilty parties 
> appear to be gdth, eata, u14-34f, ultrastor, BusLogic and advansys.
> 
> The trouble is that if you alloc the host with it one way and free it 
> with it the other, the wrong freelist is used and the ref counts are 
> invalid.
> 
> Try this pseudo fix: it avoids allocating the freelist until add time 
> (by which time they should all have fixed the flag).  It still doesn't 
> change the fact that the host is allocated in the wrong region, but 
> that shouldn't matter too much.

ok - do you intend to push this pseudo-fix upstream? If yes then please 
consider it fixed as far as i'm concerned - i'll re-reply if the warning 
resurfaces (it wasnt lethal to the bootup otherwise). Or if you've got 
some other approach/fix then i can test that too.

	Ingo
