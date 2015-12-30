From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 08/20] scsi_dh_alua: use unique device id
Date: Wed, 30 Dec 2015 12:20:24 +0100
Message-ID: <20151230112024.GB14156@lst.de>
References: <1449560260-53407-1-git-send-email-hare@suse.de> <1449560260-53407-9-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49210 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754397AbbL3LU0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Dec 2015 06:20:26 -0500
Content-Disposition: inline
In-Reply-To: <1449560260-53407-9-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jbottomley@odin.com>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Tue, Dec 08, 2015 at 08:37:28AM +0100, Hannes Reinecke wrote:
> Use scsi_vpd_lun_id() to assign a unique device identification
> to the alua port group structure.

I really hate the fix length arrays and how they are passed around.

Can't you move the call to scsi_vpd_lun_id into alua_get_pg (alua_alloc_pg)?

Also I think the new alua_lookup_pg should be alua_find_get_pg or
similar as it takes a reference on the pg.
