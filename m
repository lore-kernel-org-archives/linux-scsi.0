From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH]scsi_dh_rdac: Retry for Quiescence in Progress in rdac
	device handler
Date: Tue, 10 Feb 2009 20:44:50 +0000
Message-ID: <1234298690.3268.58.camel@localhost.localdomain>
References: <0D1E8821739E724A86F4D16902CE275C13FF9AFFD6@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:55105 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755229AbZBJUox (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Feb 2009 15:44:53 -0500
In-Reply-To: <0D1E8821739E724A86F4D16902CE275C13FF9AFFD6@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "sekharan@us.ibm.com" <sekharan@us.ibm.com>

On Mon, 2009-01-26 at 21:29 +0530, Chauhan, Vijay wrote:
> During device discovery read capacity fails with 0x068b02 and sets the device size to 0. As a reason any I/O submitted to this path gets killed at sd_prep_fn with BLKPREP_KILL. This patch is to retry for 0x068b02. Please apply.
> 
> From: Vijay Chauhan<vijay.chauhan@lsi.com>
> 
> This patch adds retry for Quiescence in Progress in rdac device handler.
> 
> Signed-off-by: Vijay Chauhan <vijay.chauhan@lsi.com>
> 
> ---
> --- linux-2.6.29-rc2/drivers/scsi/device_handler/scsi_dh_rdac.c.orig    2009-01-26 20:46:05.000000000 +0530
> +++ linux-2.6.29-rc2/drivers/scsi/device_handler/scsi_dh_rdac.c 2009-01-26 20:47:34.000000000 +0530
> @@ -579,6 +579,11 @@ static int rdac_check_sense(struct scsi_
>                          * Power On, Reset, or Bus Device Reset, just retry.
>                          */
>                         return ADD_TO_MLQUEUE;
> +               if (sense_hdr->asc == 0x8b && sense_hdr->ascq == 0x02)
> +                       /*
> +                        * Quiescence in progress , just retry.
> +                        */
> +                       return ADD_TO_MLQUEUE;
>                 break;
>         }
>         /* success just means we do not care what scsi-ml does */

This patch has all the tabs converted to spaces.  Please see 

Documentation/SubmittingPatches
Documentation/email-clients.txt

for preventing this in future.

James


