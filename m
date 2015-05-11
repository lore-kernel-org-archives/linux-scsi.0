From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 11/17] scsi_dh_alua: simplify sense code handling
Date: Mon, 11 May 2015 08:58:02 +0200
Message-ID: <20150511065802.GH30516@lst.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de> <1430743343-47174-12-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:39024 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434AbbEKG6E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 May 2015 02:58:04 -0400
Content-Disposition: inline
In-Reply-To: <1430743343-47174-12-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Mon, May 04, 2015 at 02:42:17PM +0200, Hannes Reinecke wrote:
> Most sense code is already handled in the generic
> code, so we shouldn't be adding special cases here.
> However, when doing so we need to check for
> unit attention whenever we're sending an internal
> command.

Shouldn't we move handling of all these sense codes to common code?  They
are part of the generic SPC list of sense codes, so splitting them up
into two functions is rather confusing.

> @@ -474,6 +440,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg, int w
>  		}
>  
>  		err = alua_check_sense(sdev, &sense_hdr);
> +		if (sense_hdr.sense_key == UNIT_ATTENTION)
> +			err = ADD_TO_MLQUEUE;

And this really should be a separate patch.
