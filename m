From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 07/12] hpsa: cleanup reset handler
Date: Tue, 11 Apr 2017 14:35:38 +0200
Message-ID: <1491914138.4742.17.camel@suse.com>
References: <149159483812.15658.615814291766210537.stgit@brunhilda>
         <149159558766.15658.11389910379646196354.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:55583 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752410AbdDKMf6 (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Tue, 11 Apr 2017 08:35:58 -0400
In-Reply-To: <149159558766.15658.11389910379646196354.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

On Fri, 2017-04-07 at 15:06 -0500, Don Brace wrote:
>  - mark device state sooner.
>
> Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
> Reviewed-by: Scott Teel <scott.teel@microsemi.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
> Signed-off-by: Don Brace <don.brace@microsemi.com>
> ---
>  drivers/scsi/hpsa.c |   44 ++++++++++++++++++++++++++++++-----------
> ---
>  1 file changed, 30 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index a2852da..a6a37e0 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -5834,7 +5834,7 @@ static int
> wait_for_device_to_become_ready(struct ctlr_info *h,
>   */
>  static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
>  {
> -	int rc;
> +	int rc = SUCCESS;
>  	struct ctlr_info *h;
>  	struct hpsa_scsi_dev_t *dev;
>  	u8 reset_type;
> @@ -5845,17 +5845,24 @@ static int
> hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
>  	if (h == NULL) /* paranoia */
>  		return FAILED;
>  
> -	if (lockup_detected(h))
> -		return FAILED;
> +	h->reset_in_progress = 1;
> +
> +	if (lockup_detected(h)) {
> +		rc = FAILED;
> +		goto return_reset_status;
> +	}

if this is meant to communicate host state to other threads, maybe you
should use an atomic type for h->reset_in_progress, or locking of some
sort?

Regards,
Martin

-- 
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
