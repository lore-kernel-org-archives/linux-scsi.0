From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 04/16] scsi_dh_alua: Make stpg synchronous
Date: Fri, 14 Feb 2014 12:27:01 +0100
Message-ID: <52FDFD85.9050106@acm.org>
References: <1391160600-19652-1-git-send-email-hare@suse.de> <1391160600-19652-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp03.stone-is.org ([87.238.162.65]:37764 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751525AbaBNL1F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Feb 2014 06:27:05 -0500
In-Reply-To: <1391160600-19652-5-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, linux-scsi@vger.kernel.org

On 01/31/14 10:29, Hannes Reinecke wrote:
> -	memset(h->buff, 0, stpg_len);
> -	h->buff[4] = TPGS_STATE_OPTIMIZED & 0x0f;
> -	h->buff[6] = (h->group_id >> 8) & 0xff;
> -	h->buff[7] = h->group_id & 0xff;
> +	memset(stpg_data, 0, stpg_len);
> +	stpg_data[4] = TPGS_STATE_OPTIMIZED & 0x0f;
> +	stpg_data[6] = (group_id >> 8) & 0xff;
> +	stpg_data[7] = group_id & 0xff;

Any reason why put_unaligned_be16() is not used here ?

Bart.
