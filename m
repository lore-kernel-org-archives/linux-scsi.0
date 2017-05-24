From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 06/31] scmd_eh_abort_handler(): Add a comment
Date: Wed, 24 May 2017 07:53:23 +0200
Message-ID: <8fd2a9f2-1a68-aee2-f12a-992bacc27e8b@suse.de>
References: <20170524003420.5381-1-bart.vanassche@sandisk.com>
 <20170524003420.5381-7-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170524003420.5381-7-bart.vanassche@sandisk.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/24/2017 02:33 AM, Bart Van Assche wrote:
> After the patch that introduced this function was posted on the
> linux-scsi mailing list an explanation was posted why this patch
> is correct. Since that explanation contains important information,
> add a summary of it above the code that explanation applies to.
> See also http://www.spinics.net/lists/linux-scsi/msg106326.html.
> 
> References: e494f6a72839 ("[SCSI] improve eh timeout handler")
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi_error.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index ac3196420435..19cafa3efb17 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -116,6 +116,12 @@ static int scsi_host_eh_past_deadline(struct Scsi_Host *shost)
>  /**
>   * scmd_eh_abort_handler - Handle command aborts
>   * @work:	command to be aborted.
> + *
> + * Note: this function must be called only for a command that has timed out.
> + * Because the block layer sets REQ_ATOM_COMPLETE before it calls
> + * scsi_times_out(), any .scsi_done() calls from the LLD for commands that
> + * have timed out do not have any effect. Hence it is safe to call
> + * scsi_finish_command() from this function.
>   */
>  void
>  scmd_eh_abort_handler(struct work_struct *work)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
