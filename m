From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 03/16] scsi_dh_alua: Pass buffer as function argument
Date: Fri, 14 Feb 2014 12:22:13 +0100
Message-ID: <52FDFC65.2040906@acm.org>
References: <1391160600-19652-1-git-send-email-hare@suse.de> <1391160600-19652-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp03.stone-is.org ([87.238.162.65]:60948 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751758AbaBNLWV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Feb 2014 06:22:21 -0500
In-Reply-To: <1391160600-19652-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, linux-scsi@vger.kernel.org

On 01/31/14 10:29, Hannes Reinecke wrote:
> -	rq->cmd[6] = (h->bufflen >> 24) & 0xff;
> -	rq->cmd[7] = (h->bufflen >> 16) & 0xff;
> -	rq->cmd[8] = (h->bufflen >>  8) & 0xff;
> -	rq->cmd[9] = h->bufflen & 0xff;
> +	rq->cmd[6] = (bufflen >> 24) & 0xff;
> +	rq->cmd[7] = (bufflen >> 16) & 0xff;
> +	rq->cmd[8] = (bufflen >>  8) & 0xff;
> +	rq->cmd[9] = bufflen & 0xff;

Since you are changing this code, please use put_unaligned_be32() for
storing bufflen in the CDB.

Bart.
