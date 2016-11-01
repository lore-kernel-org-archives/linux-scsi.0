From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/3] scsi_dh_rdac: switch to scsi_execute_req_flags()
Date: Tue, 1 Nov 2016 15:47:44 +0100
Message-ID: <20161101144744.GB17827@lst.de>
References: <1477936770-106687-1-git-send-email-hare@suse.de> <1477936770-106687-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53746 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966477AbcKAOrq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 1 Nov 2016 10:47:46 -0400
Content-Disposition: inline
In-Reply-To: <1477936770-106687-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Mon, Oct 31, 2016 at 06:59:28PM +0100, Hannes Reinecke wrote:
> Switch to using scsi_execute_req_flags() instead of using the
> block primitives.

__scsi_execute adds RQF_QUIET and RQF_PREEMPT to the request flags, which
would be a change in behavior.  A little analysis on why that's safe or
even desireable would be nice.  (This also applies to the other two patches
I think).

>  
>  static void release_controller(struct kref *kref)
>  static int get_lun_info(struct scsi_device *sdev, struct rdac_dh_data *h,
>  			char *array_name, u8 *array_id)
>  {
> +	int err = SCSI_DH_IO, i;
>  	struct c8_inquiry *inqp;
>  
> +	if (!scsi_get_vpd_page(sdev, 0xC8, (unsigned char *)h,
> +			       sizeof(struct c8_inquiry))) {

This looks completely bogus to me - h is a struct rdac_dh_data pointer,
which is an in-kernel data structure that scsi_get_vpd_page would
scramble over.
