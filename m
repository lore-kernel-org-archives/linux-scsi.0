From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 10/10] mpt3sas: scsi-mq interrupt steering
Date: Tue, 31 Jan 2017 11:05:37 +0100
Message-ID: <20170131100537.GB1811@lst.de>
References: <1485854760-122683-1-git-send-email-hare@suse.de> <1485854760-122683-11-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55256 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750809AbdAaKGW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 31 Jan 2017 05:06:22 -0500
Content-Disposition: inline
In-Reply-To: <1485854760-122683-11-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, mpt-fusionlinux.pdl@broadcom.com, Hannes Reinecke <hare@suse.com>


We should not need multiple submission queues for IRQ steering.

We just need to build the cpu to vector reverse map that
blk_mq_pci_map_queues builds.  So maybe we need to refactor
the API for ->map_queues a bit so that it's not tied to
submission queues.  In the meantime you can just opencode
that loop.
