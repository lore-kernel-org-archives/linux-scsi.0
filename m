From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [SCSI] qla1280: endianess annotations
Date: Thu, 8 Sep 2005 11:44:00 +0100
Message-ID: <20050908104400.GA5627@infradead.org>
References: <200509080111.j881BbNm032480@hera.kernel.org> <431F9E41.5010701@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:42731 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S964807AbVIHKoE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Sep 2005 06:44:04 -0400
Content-Disposition: inline
In-Reply-To: <431F9E41.5010701@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Christoph Hellwig <hch@infradead.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Sep 07, 2005 at 10:13:21PM -0400, Jeff Garzik wrote:
> Linux Kernel Mailing List wrote:
> >diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
> >--- a/drivers/scsi/qla1280.c
> >+++ b/drivers/scsi/qla1280.c
> >@@ -1546,7 +1546,7 @@ qla1280_return_status(struct response * 
> > 	int host_status = DID_ERROR;
> > 	uint16_t comp_status = le16_to_cpu(sts->comp_status);
> > 	uint16_t state_flags = le16_to_cpu(sts->state_flags);
> >-	uint16_t residual_length = le16_to_cpu(sts->residual_length);
> >+	uint16_t residual_length = le32_to_cpu(sts->residual_length);
> > 	uint16_t scsi_status = le16_to_cpu(sts->scsi_status);
> [...]
> >+	__le16 status_flags;	/* Status flags. */
> >+	__le16 time;		/* Time. */
> >+	__le16 req_sense_length;/* Request sense data length. */
> >+	__le32 residual_length;	/* Residual transfer length. */
> >+	__le16 reserved[4];
> > 	uint8_t req_sense_data[32];	/* Request sense data. */
> 
> This isn't merely an endian annotation.
> 
> Is this a size fix, from 16 to 32, or a typo?  If its not a typo, 
> shouldn't the variable be declared 'uint32_t residual_length'?

It's a typo-fix.  The variable is 32bits in hardware.  Declaring it
in 32bit in software might make sense, but isn't that important.  Feel
free to send a patch if you care enough.

