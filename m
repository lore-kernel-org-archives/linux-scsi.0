From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH 0/5] Remove scmd->tag
Date: Thu, 2 Oct 2014 13:20:30 +0200
Message-ID: <20141002112030.GA31346@lst.de>
References: <1412246593-107001-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:44644 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbaJBLUe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Oct 2014 07:20:34 -0400
Content-Disposition: inline
In-Reply-To: <1412246593-107001-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jbottomley@parallels.com>, Sagi Grimberg <sagig@dev.mellanox.co.il>, Webb Scales <webbnh@hp.com>, linux-scsi@vger.kernel.org

This seems to miss a places, that mostly just seem to use scmd->tag
where they should be using scmd->request->tag:

 - acornscsi.c (and arm/queue.c)
 - fas216
 - qla1280

As well as virtio_scsi, which does a pointless assignment to scmd->tag.

It might be worth to push this out to somewhere where the buildbot
can find it while waiting for the NCR5380 overhaul.
