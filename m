From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH]: Flexible timeout infrastructure
Date: Tue, 15 Jun 2004 14:37:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40CF4207.9050108@adaptec.com>
References: <40CF0F9F.4050902@adaptec.com> <1087313492.1796.37.camel@mulgrave> <20040615181536.GA12611@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:8388 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S265815AbUFOSiC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2004 14:38:02 -0400
In-Reply-To: <20040615181536.GA12611@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

> Could we get the eh_times_out part of the patch broken out as the
> addition of the return values look like a good idea along with some
> method to call a modified version of scsi_done through a exported
> function to the LLDD.

Hm, yes, I saw the thread back in January I believe it was on this.

Basically I want to keep queuecommand() and scsi_done()
pretty much unchanged -- being antagonists of each other.

SAM 5.4 describes that interface (SCSI Core <--> LLDD) and
SAM 5.1 describes Application Client <--> SCSI Core.

We seem on track with 5.4 and I'd rather not overload
scsi_done().

Note that this patch would be a lot _less_ intrusive than the
one propsed in January, as the one proposed in January
discloses the internals of SCSI Core to LLDD, via
the scsi midlayer scsi_eh_scmd_add() method which
drivers would be supposed to call.
http://marc.theaimsgroup.com/?l=linux-scsi&m=107461451911771&w=2

I'd rather all this information be conveyed through
the Service Response and Status Code values to be
returned to SCSI Core from the LLDD via scsi_done(), in
the scsi command structure.

Then SCSI Core makes the decision, as to what is to be
done with the command.

This patch is very small and non-intrusive with 0 effects
to any LLDD or SCSI Core.

-- 
Luben


