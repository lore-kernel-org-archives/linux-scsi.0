From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 2/2] scsi: don't use execute_in_process_context()
Date: Wed, 15 Dec 2010 14:10:46 -0500
Message-ID: <1292440246.4688.416.camel@mulgrave.site>
References: <4CBD95C0.6060302@kernel.org>  <4CBD95DC.8000001@kernel.org>
	 <1292194113.2989.9.camel@mulgrave.site>  <4D073E9A.3000608@kernel.org>
	 <1292335754.3058.2.camel@mulgrave.site>  <4D077CD9.6050907@kernel.org>
	 <1292336798.3058.5.camel@mulgrave.site>  <4D078052.3040800@kernel.org>
	 <1292382245.19511.56.camel@mulgrave.site>  <4D08E2FF.5090605@kernel.org>
	 <1292428486.4688.180.camel@mulgrave.site>  <4D08E624.3020808@kernel.org>
	 <1292433773.4688.278.camel@mulgrave.site>  <4D09116C.6010508@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:50113 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754846Ab0LOTKv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Dec 2010 14:10:51 -0500
In-Reply-To: <4D09116C.6010508@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, lkml <linux-kernel@vger.kernel.org>

On Wed, 2010-12-15 at 20:05 +0100, Tejun Heo wrote:
> Hey, James.
> 
> On 12/15/2010 06:22 PM, James Bottomley wrote:
> > Hmm, I suppose the original coding didn't contemplate pre-emption.  This
> > should fix it then, I think (with no alteration to the callsites because
> > of the encapsulating API).  It does assume the function being executed
> > is local to the file doing the execution, which is true in all current
> > cases.
> 
> Yes, it would do, but we were already too far with the existing
> implementation and I don't agree we need more when replacing it with
> usual workqueue usage would remove the issue.  So, when we actually
> need them, let's consider that or any other way to do it, please.
> A core API with only a few users which can be easily replaced isn't
> really worth keeping around.  Wouldn't you agree?

Not really ... since the fix is small and obvious.  Plus now it can't be
moved into SCSI because I need the unremovable call chain.

Show me how you propose to fix it differently first, since we both agree
the initial attempt doesn't work, and we can take the discussion from
there.

James


