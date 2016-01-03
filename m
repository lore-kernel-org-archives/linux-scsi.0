From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 12/20] scsi_dh_alua: Allow workqueue to run
	synchronously
Date: Sun, 3 Jan 2016 11:54:58 +0100
Message-ID: <20160103105458.GC10025@lst.de>
References: <1449560260-53407-1-git-send-email-hare@suse.de> <1449560260-53407-13-git-send-email-hare@suse.de> <20151230132010.GB15270@lst.de> <5685338A.5010801@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:60024 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656AbcACKzA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 3 Jan 2016 05:55:00 -0500
Content-Disposition: inline
In-Reply-To: <5685338A.5010801@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jbottomley@odin.com>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Thu, Dec 31, 2015 at 02:54:18PM +0100, Hannes Reinecke wrote:
> ATM the only ones I know of is NetApp (both FAS and E-series; E-series 
> requires it, and FAS benefits greatly).
> But this is not to say that these are the only ones, _and_ the more obvious 
> approach would be to add the handling to multipath-tools settings, so I 
> really would like to keep the module option for now.

Anything involving multipath-tools settings is a giant nightmare.  We
need to get it rifght in the kernel so that multipathing can work
out of the box.  And the right place for SCSI-level quirks are the
devlist entries.

Module options for hardware specific behavior are a horrible idea - you
can be connect to different devies, which is a very common setup.
