From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/4] async: introduce 'async_domain' type
Date: Fri, 25 May 2012 08:51:07 +0100
Message-ID: <1337932267.2932.7.camel@dabdike.int.hansenpartnership.com>
References: <20120525074813.21933.91876.stgit@dwillia2-linux.jf.intel.com>
	 <20120525075027.21933.75815.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55676 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750984Ab2EYHvK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 May 2012 03:51:10 -0400
In-Reply-To: <20120525075027.21933.75815.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: mroos@linux.ee, linux-scsi@vger.kernel.org, Mark Brown <broonie@opensource.wolfsonmicro.com>, linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>, Liam Girdwood <lrg@ti.com>

On Fri, 2012-05-25 at 00:50 -0700, Dan Williams wrote:
> This is in preparation for teaching async_synchronize_full() to sync all
> pending async work, and not just on the async_running domain.  This
> conversion is functionally equivalent, just embedding the existing list
> in a new async_domain type.

This looks good, but I want Arjan and others who invented the async code
to speed up boot to comment on all of this.  What was the intention of
async_synchronize_full() and if it wasn't to synchronise all domains,
should we fix the documentation and add a new primitive to do that,
since boot clearly assumes the all domains behaviour.

In the mean time, this is probably all a bit much for a merge window, so
I'll revert 

commit a7a20d103994fd760766e6c9d494daa569cbfe06
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Mar 22 17:05:11 2012 -0700

    [SCSI] sd: limit the scope of the async probe domain

And we'll put whatever is chosen in early for the next merge window.

James


