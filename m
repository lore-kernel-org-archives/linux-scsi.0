From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] scsi: scsi_transport_fc: Fix a bug in the error
 handling function
Date: Thu, 07 Jan 2016 15:48:31 -0800
Message-ID: <1452210511.15259.38.camel@HansenPartnership.com>
References: <1452213645-18889-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1452213645-18889-1-git-send-email-kys@microsoft.com>
Sender: stable-owner@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com, martin.petersen@oracle.com, hare@suse.de
Cc: stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2016-01-07 at 16:40 -0800, K. Y. Srinivasan wrote:
> The macro startget_to_rport() can return NULL; handle that case
> properly.

OK, can we unwind why you think you could possibly need this?  It would
mean that fc_timed_out was called for a non-FC device, which was
thought to be an impossibility when the fc transport class was
designed.

James

> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/scsi/scsi_transport_fc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_fc.c
> b/drivers/scsi/scsi_transport_fc.c
> index 24eaaf6..42a908f 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -2081,7 +2081,7 @@ fc_timed_out(struct scsi_cmnd *scmd)
>  {
>  	struct fc_rport *rport = starget_to_rport(scsi_target(scmd
> ->device));
>  
> -	if (rport->port_state == FC_PORTSTATE_BLOCKED)
> +	if ((rport == NULL) || (rport->port_state ==
> FC_PORTSTATE_BLOCKED))
>  		return BLK_EH_RESET_TIMER;
>  
>  	return BLK_EH_NOT_HANDLED;
