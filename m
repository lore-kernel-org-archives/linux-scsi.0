From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 08/16] scsi_dh_alua: parse target device id
Date: Fri, 14 Feb 2014 13:09:55 +0100
Message-ID: <52FE0793.9040505@acm.org>
References: <1391160600-19652-1-git-send-email-hare@suse.de> <1391160600-19652-9-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp03.stone-is.org ([87.238.162.65]:48460 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751767AbaBNMKA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Feb 2014 07:10:00 -0500
In-Reply-To: <1391160600-19652-9-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, linux-scsi@vger.kernel.org

On 01/31/14 10:29, Hannes Reinecke wrote:
> +	if (!target_id_size) {
> +		/* Check for EMC Clariion extended inquiry */
> +		if (!strncmp(sdev->vendor, "DGC     ", 8) &&
> +		    sdev->inquiry_len > 160) {
> +			target_id_size = sdev->inquiry[160];
> +			target_id = sdev->inquiry + 161;
> +			strcpy(target_id_str, "emc.");
> +			memcpy(target_id_str + 4, target_id, target_id_size);
> +		}
> +		/* Check for HP EVA extended inquiry */
> +		if (!strncmp(sdev->vendor, "HP      ", 8) &&
> +		    !strncmp(sdev->model, "HSV", 3) &&
> +		    sdev->inquiry_len > 170) {
> +			target_id_size = 16;
> +			target_id = sdev->inquiry + 154;
> +			strcpy(target_id_str, "naa.");
> +			memcpy(target_id_str + 4, target_id, target_id_size);
> +		}
> +	}

Being able to identify a storage array unambiguously is essential for
the new ALUA device handler algorithm introduced by this patch series.
What if a new storage array is introduced that is not covered by one of
the heuristics in this patch ? Has it been considered to let storage
array identification occur in user space instead of in the kernel ?

Thanks,

Bart.


