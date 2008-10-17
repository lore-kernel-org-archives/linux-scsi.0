From: Levy_Jerome@emc.com
Subject: RE: [PATCH 1/1] scsi_dh: fix boot oops with EMC Clariion
Date: Fri, 17 Oct 2008 14:35:17 -0400
Message-ID: <6416EE16C1AF1E4C86882867E4DD0FF65CFD10@CORPUSMX40B.corp.emc.com>
References: <6416EE16C1AF1E4C86882867E4DD0FF6026D1BF1@CORPUSMX40B.corp.emc.com><6416EE16C1AF1E4C86882867E4DD0FF602B1F971@CORPUSMX40B.corp.emc.com><1224264890.3368.24.camel@localhost.localdomain><6416EE16C1AF1E4C86882867E4DD0FF65CFD0F@CORPUSMX40B.corp.emc.com> <1224268412.3368.27.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mexforward.lss.emc.com ([128.222.32.20]:11628 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbYJQShd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Oct 2008 14:37:33 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

Ah! Fair enough. I was working off of .105, so I'll check for a newer release. Seen something very similar in scsi_dh_alua, perhaps that is fixed too.

Thanks...

Jerry


-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
Sent: Fri 10/17/2008 2:33 PM
To: Levy, Jerome
Cc: linux-scsi@vger.kernel.org
Subject: RE: [PATCH 1/1] scsi_dh: fix boot oops with EMC Clariion
 
On Fri, 2008-10-17 at 14:17 -0400, Levy_Jerome@emc.com wrote:
> The change was the addition of rq->flags = 0; the memset isn't mine.
> Sorry about the whitespace -- I'm still a bit new at this. 

That's OK.

Documentation/SubmittingPatches
Documentation/email-clients.txt

contain useful information.

> As to why it's necessary, I've had boot-time oopses on two completely
> different hosts -- one iSCSI, one FC -- which both resolved to exactly
> the same code; bizarre values in rq->flags. The source seems to OR the
> desired values in but never actually initializes rq->flags (the memset
> initializes the CDB, not the flags variable), so I added the line to
> do so. After testing the old module to confirm the oops still occurred
> regularly, I installed the new code and have since (in over 100
> reboots) been unable to reproduce the oops. 

No, my point is that this was fixed by a memset to zero of the request
in blk_rq_init() in 2.6.26 (so it fixed every other problem, not just
the one in dm_emc).  I think the kernel you're testing is too old to see
the generic fix (based on what the diff contained).

James




