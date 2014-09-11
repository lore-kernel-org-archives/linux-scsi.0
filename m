From: Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH] xen-scsifront: don't deadlock if the ring becomes full
Date: Thu, 11 Sep 2014 15:42:36 +0200
Message-ID: <5411A6CC.8090708@suse.com>
References: <1410442313-19639-1-git-send-email-david.vrabel@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35969 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbaIKNmj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Sep 2014 09:42:39 -0400
In-Reply-To: <1410442313-19639-1-git-send-email-david.vrabel@citrix.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xenproject.org
Cc: linux-scsi@vger.kernel.org

On 09/11/2014 03:31 PM, David Vrabel wrote:
> scsifront_action_handler() will deadlock on host->host_lock, if the
> ring is full and it has to wait for entries to become available.
>
> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
> ---
> This was found with sparse. I've not tested it.

Test might be difficult. :-)

Reviewed-by: Juergen Gross <jgross@suse.com>

Thanks for spotting this.

Juergen

> ---
>   drivers/scsi/xen-scsifront.c |    3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
> index 7e88659..cc14c8d 100644
> --- a/drivers/scsi/xen-scsifront.c
> +++ b/drivers/scsi/xen-scsifront.c
> @@ -541,8 +541,9 @@ static int scsifront_action_handler(struct scsi_cmnd *sc, uint8_t act)
>   	if (!shadow)
>   		return FAILED;
>
> +	spin_lock_irq(host->host_lock);
> +
>   	for (;;) {
> -		spin_lock_irq(host->host_lock);
>   		if (!RING_FULL(&info->ring)) {
>   			ring_req = scsifront_command2ring(info, sc, shadow);
>   			if (ring_req)
>

