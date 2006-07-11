From: "Robert Tarte" <robt@PacificCodeWorks.com>
Subject: RE: [PATCH] aic94xx: fix routing algorithms
Date: Tue, 11 Jul 2006 01:30:07 -0700
Message-ID: <16C8363E16D7234AB844FDB52D4AEA650C2DB6@ntserv.PacificCodeWorks.local>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from h-67-101-118-101.snfccasy.covad.net ([67.101.118.101]:6296 "EHLO
	PacificCodeWorks.com") by vger.kernel.org with ESMTP
	id S1750737AbWGKIZj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2006 04:25:39 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>

> I've been trying to work out for a while why certain cascaded expander
> configurations work with the mptsas, but don't with the aic94xx.
> Eventually I discovered that the non-functional configurations are the
> ones where the cascaded expander is connected to the parent on table
> routed ports.  The problem is that the aic94xx routing algorithms
never
> seem to consider the necessity of a route back to the HBA.  This patch
> adds such a routing configuration, and now (at least for all my
> configurations) the hitherto unseen disks become visible.

[Tarte, Robert] There is a very specific algorithm for programming the
routing tables to avoid routing table thrashing in a mixed OS / adapter
multi-initiator environments (the last one I looked at was from the
SAS-1.1 draft, sas1r07.pdf, project T10/1601-D,
SASDiscoverSimulation.cpp or see section 4.8.7).  I had always assumed
that the original route table configuration code adhered to that
algorithm.  Has this patch been verified against that algorithm?  Or
does it now come up with the exact same route tables as mptsas? When you
say table routed ports, you mean that both the upstream and down stream
expanders are configured as table routed?

