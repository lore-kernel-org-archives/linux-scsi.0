From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/10] mpt3sas: Introduce mpt3sas_get_st_from_smid()
Date: Tue, 7 Feb 2017 14:17:35 +0100
Message-ID: <20170207131735.GF19247@lst.de>
References: <1485854760-122683-1-git-send-email-hare@suse.de> <1485854760-122683-7-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:40582 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754168AbdBGNRl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Feb 2017 08:17:41 -0500
Content-Disposition: inline
In-Reply-To: <1485854760-122683-7-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, mpt-fusionlinux.pdl@broadcom.com, Hannes Reinecke <hare@suse.com>

>  inline u8
>  mpt3sas_scsi_direct_io_get(struct MPT3SAS_ADAPTER *ioc, u16 smid)
>  {
> -	return ioc->scsi_lookup[smid - 1].direct_io;
> +	struct scsiio_tracker *st = mpt3sas_get_st_from_smid(ioc, smid);
> +
> +	return st ? st->direct_io : 0;

This wrapper can go away and be merged into the only caller.

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
