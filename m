From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Proposals to change the way all drivers work with SCSI commands
Date: Fri, 11 May 2007 13:33:41 -0500
Message-ID: <1178908422.3692.58.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:51401 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761683AbXEKSdo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 May 2007 14:33:44 -0400
Received: from [172.17.6.40] (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id l4BIXgk20279
	for <linux-scsi@vger.kernel.org>; Fri, 11 May 2007 14:33:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Right at the moment, we're planning to clean up the way SCSI drivers
process commands.  The proposals are essentially:

     1. Get rid of the now unnecessary map_single path (every command is
        either zero transfer or scatter/gather)
     2. use accessors to manipulate the SG lists (mainly so that we can
        alter the implementation without affecting the drivers)

It strikes me that in all of this, we could also consider doing the DMA
mapping inside the mid layer (instead of in every driver).  This is
essentially what libata is already doing ... leading to confusion in
SCSI drivers that use libata for SATA.

So what do people think about this?

James


