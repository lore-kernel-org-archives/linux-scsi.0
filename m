From: Hannes Reinecke <hare@suse.de>
Subject: [LSF/MM TOPIC] irq affinity handling for high CPU count machines
Date: Mon, 29 Jan 2018 10:08:43 +0100
Message-ID: <45dc032d-a0ce-816c-d2c5-74c69433bd29@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51767 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751361AbeA2KXX (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
        Mon, 29 Jan 2018 05:23:23 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Kashyap Desai <kashyap.desai@broadcom.com>

Hi all,

here's a topic which came up on the SCSI ML (cf thread '[RFC 0/2]
mpt3sas/megaraid_sas: irq poll and load balancing of reply queue').

When doing I/O tests on a machine with more CPUs than MSIx vectors
provided by the HBA we can easily setup a scenario where one CPU is
submitting I/O and the other one is completing I/O. Which will result in
the latter CPU being stuck in the interrupt completion routine for
basically ever, resulting in the lockup detector kicking in.

How should these situations be handled?
Should it be made the responsibility of the drivers, ensuring that the
interrupt completion routine is terminated after a certain time?
Should it be made the resposibility of the upper layers?
Should it be the responsibility of the interrupt mapping code?
Can/should interrupt polling be used in these situations?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
