From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] target: Return descriptor format sense data
Date: Tue, 14 Jul 2015 00:17:03 -0700
Message-ID: <20150714071703.GC31117@infradead.org>
References: <1436697423-20611-1-git-send-email-sagig@mellanox.com>
 <1436697423-20611-4-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58416 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbbGNHRE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2015 03:17:04 -0400
Content-Disposition: inline
In-Reply-To: <1436697423-20611-4-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <bart.vanassche@sandisk.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>

On Sun, Jul 12, 2015 at 01:37:03PM +0300, Sagi Grimberg wrote:
> Fixed size sense data information field is only 32 bits which
> means the sector (64 bits) information will be truncated.
> 
> Move to descriptor format sense data to correctly report full
> sector information.

I think this needs to be a tunable as old initiators might not be
able to cope with descriptor sense data.  My idea was to only turn
it own if the LU is large enough to need it.  Initiators that can
deal with large LUs by using READ CAPACITY (16) and READ/WRITE (16)
should be able to handle descriptor style sense data as well.
