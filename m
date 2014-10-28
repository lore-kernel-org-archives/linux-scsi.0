From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 26/27] scsi: correct return values for .eh_abort_handler
 implementations
Date: Tue, 28 Oct 2014 23:49:20 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B4029593470E7@G9W0745.americas.hpqcorp.net>
References: <1414153627-2863-1-git-send-email-hare@suse.de>
 <1414153627-2863-27-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1414153627-2863-27-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Friday, 24 October, 2014 7:27 AM
> To: James Bottomley
> Cc: Christoph Hellwig; Elliott, Robert (Server Storage); linux-
> scsi@vger.kernel.org; Hannes Reinecke; stable@vger.kernel.org
> Subject: [PATCH 26/27] scsi: correct return values for
> .eh_abort_handler implementations
> 
> The .eh_abort_handler needs to return SUCCESS, FAILED, or
> FAST_IO_FAIL. So fixup all callers to adhere to this requirement.
> 
> Cc: Robert Elliott <elliott@hp.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/NCR5380.c            | 2 +-
>  drivers/scsi/aha1740.c            | 2 +-
>  drivers/scsi/esas2r/esas2r_main.c | 2 +-
>  drivers/scsi/megaraid.c           | 8 ++++----
>  4 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
> index 50873bb..e2c9e73 100644
> --- a/drivers/scsi/NCR5380.c
> +++ b/drivers/scsi/NCR5380.c
> @@ -2703,7 +2703,7 @@ static int NCR5380_abort(Scsi_Cmnd * cmd) {
>   * aborted flag and get back into our main loop.
>   */
> 
> -		return 0;
> +		return SUCCESS;
>  	}
>  #endif

The comment above this function still says:
* Returns : 0 - success, -1 on failure.

The same comment problem also exists in
atari_NCR5380.c and sun3_NCR5380.c, which have
functions with this same name.

With all those comments also updated...
Reviewed-by: Robert Elliott <elliott@hp.com>
