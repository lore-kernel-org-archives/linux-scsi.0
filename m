From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 6/6] Invalidate VPD page data
Date: Tue, 18 Mar 2014 14:45:35 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B4029548CAED0@G4W3202.americas.hpqcorp.net>
References: <1394873512-102073-1-git-send-email-hare@suse.de>
 <1394873512-102073-7-git-send-email-hare@suse.de>
 <53277311.9000105@tributary.com> <5327ED4A.9020202@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:14039 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189AbaCROq0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Mar 2014 10:46:26 -0400
Received: from g4t3425.houston.hp.com (g4t3425.houston.hp.com [15.201.208.53])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id E30943005
	for <linux-scsi@vger.kernel.org>; Tue, 18 Mar 2014 14:46:16 +0000 (UTC)
In-Reply-To: <5327ED4A.9020202@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Jeremy Linton <jlinton@tributary.com>, James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


> On 03/17/2014 11:11 PM, Jeremy Linton wrote:
> >
> > I didn't study the whole code path but does the VPD data get
> > updated on a 6/2900? I suspect it should be. I can imagine a
> > number of cases where the luns changed check condition gets
> > preempted/lost by a device reset. I guess much of that should
> > be masked by the port login/logout, but its probably better to
> > be safe...
> >

See the unit attention condition precedence level table in the 
SCSI Architecture Model (sam5r15 table 54 page 121).

POWER ON, RESET, OR BUS DEVICE RESET OCCURRED 
(29h 00h) has the highest precedence, meaning that
any other unit attention condition might also have 
occurred but no longer be individually reported.

Similarly, all the others in table 54 have precedence over
(and thus imply the possibility of) INQUIRY DATA HAS 
CHANGED.

In addition to the codes in table 54, since INQUIRY DATA 
HAS CHANGED has a nonzero ASCQ (3Fh 03h),  it also has 
lower precedence than 3Fh 00h TARGET OPERATING 
CONDITIONS HAVE CHANGED.

For generic SCSI code, the "protocol specific" codes
may be the hardest to handle.  That covers these old 
parallel SCSI codes:
29h 05h TRANSCEIVER MODE CHANGED TO SINGLE-ENDED
29h 06h TRANSCEIVER MODE CHANGED TO LVD
but allows newer protocols to add codes if needed.

You may need the LLD to report an optional list of 
extra codes to consider at that precedence level.

