From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCHSET 0/4] libosd: scatter gather commands and stuff for 2.6.37
Date: Tue, 19 Oct 2010 14:18:51 +0200
Message-ID: <4CBD8CAB.2030207@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og114.obsmtp.com ([64.18.0.28]:43324 "HELO
	exprod5og114.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758442Ab0JSMUA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Oct 2010 08:20:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, John Chandy <john.chandy@uconn.edu>, open-osd <osd-dev@open-osd.org>, linux-scsi <linux-scsi@vger.kernel.org>

Hi James.

Please submit the following patches hopefully for the 2.6.37 merge window.
2 first patches are just bug fixes. The Last two patches enable the
scatter gather OSD operations. These will only be used in filesystem code
at the 2.6.38 Kernel but it could be nice to have them in before hand, so
to avoid trees dependencies.

The original scatter gather work was done by John Chandy. I have reworked
most of it, to better fit with the rest of the library, and the design
decisions made there. I have also removed some fixture support that was
originally available, for lack of any users.

I must say that John's original work had some merit and robustness to it
but higher complexity and slower execution in the way the library is used
today. If we want his system we should enable it for all segments not
only the continuation segment. To get people up to speed. John's work
enabled a bio-list for the continuation segment. But the rest of the
code assumes a single allocation, single bio_map_kern for each segment.
So to match the other segments handling I converted the continuation 
segment to a flat single-allocation as well.

The patches are:
[PATCH 1/4] libosd: Fix bug in attr_page handling
[PATCH 2/4] libosd: Free resources in reverse order of allocation

	These two should go in regardless

[PATCH 3/4] libosd: Support for scatter gather write/read commands

	Please submit this patch as well I will need it in the RAID5
	support for exofs. (Read without XOR blocks)

[PATCH 4/4] libosd: write/read_sg_kern API

	This patch is currently only used in the out-of-tree osd_ktest.ko
	module. I can keep it in that tree if needed until Kernel users
	come up. Please advise.

Thanks
Boaz
