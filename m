From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] aic94xx: fix routing algorithms
Date: Tue, 11 Jul 2006 08:54:43 -0400
Message-ID: <1152622483.3575.11.camel@mulgrave.il.steeleye.com>
References: <16C8363E16D7234AB844FDB52D4AEA650C2DB6@ntserv.PacificCodeWorks.local>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:32976 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751274AbWGKMyx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jul 2006 08:54:53 -0400
In-Reply-To: <16C8363E16D7234AB844FDB52D4AEA650C2DB6@ntserv.PacificCodeWorks.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Tarte <robt@PacificCodeWorks.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2006-07-11 at 01:30 -0700, Robert Tarte wrote:
> [Tarte, Robert] There is a very specific algorithm for programming the
> routing tables to avoid routing table thrashing in a mixed OS /
> adapter
> multi-initiator environments (the last one I looked at was from the
> SAS-1.1 draft, sas1r07.pdf, project T10/1601-D,
> SASDiscoverSimulation.cpp or see section 4.8.7).  I had always assumed
> that the original route table configuration code adhered to that
> algorithm.  Has this patch been verified against that algorithm?  Or
> does it now come up with the exact same route tables as mptsas? When
> you
> say table routed ports, you mean that both the upstream and down
> stream
> expanders are configured as table routed?

No ... this is the programme in annex L of sas-2, isn't it?  Even if it
were available somewhere, the aic94xx doesn't yet have the necessary SMP
tap to try it.

The problem it's solving, which is legal under the sas2 standard is S->T
routing (not T->T which is technically illegal under the standard, but
which this change will also make possible).

If an expander configuration is set up in the recommended cascade (i.e.
T->S) then this addition will never even be activated, so the change
doesn't modify the existing algorithm for the pure and recommended T->S
cases.

And yes, you're right, I'm gearing up to test this out multi-initiator
(when I actually get the right cables) ... and since I don't have a
fanout expander, my configuration is going to have to be

HBA --------- Edge Expander ----------- Edge Expander ---------- HBA
                   |                         |
               Device                     Device

James


James

