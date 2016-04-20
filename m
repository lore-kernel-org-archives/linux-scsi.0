From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] libfc: unsafe refcounting in fc_rport_work()
Date: Wed, 20 Apr 2016 21:19:18 +0200
Message-ID: <20160420191918.GA28741@lst.de>
References: <1461158661-97688-1-git-send-email-hare@suse.de> <1461178992.14609.12.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:40853 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbcDTTTV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Apr 2016 15:19:21 -0400
Content-Disposition: inline
In-Reply-To: <1461178992.14609.12.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org

On Wed, Apr 20, 2016 at 03:03:12PM -0400, James Bottomley wrote:
> Plus, kref_get_unless_zero() should not be used.  At that point, the
> structure would be freed, so there's no point looking for it. 

Agreed for this particular case.  Note that the whole code seems rather
whckay as it uses a rport_destroy method that just has one instance,
so I'd really like to see things cleaned up to remove this method
and add a warapper for the kref_put before doing further changes.

>  kref_get_unless_zero is for refcounts that don't necessarily free the
> structure (embedded ones).

The main case actually is for embedded krefs.  The important bit is that
the structure is on some lookup data structure (typically list), and
kref_get_unless_zero protects against the window from between dropping
the last references and doing the list removal in the destructor.
