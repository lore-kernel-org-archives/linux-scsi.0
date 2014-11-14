From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 10/10] scsi: Do not display buffer pointers in
 scsi_log_send()
Date: Fri, 14 Nov 2014 22:53:19 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B4029593A8697@G9W0745.americas.hpqcorp.net>
References: <1415262639-121586-1-git-send-email-hare@suse.de>
 <1415262639-121586-11-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:4291 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550AbaKNW5U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Nov 2014 17:57:20 -0500
In-Reply-To: <1415262639-121586-11-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Thursday, 06 November, 2014 2:31 AM
> To: James Bottomley
> Cc: Christoph Hellwig; Ewan Milne; Elliott, Robert (Server Storage);
> linux-scsi@vger.kernel.org; Hannes Reinecke
> Subject: [PATCH 10/10] scsi: Do not display buffer pointers in
> scsi_log_send()
> 
> scsi_log_send() would display buffer pointer for higher
> logging levels. This is not only of questionable value
> but also exposes kernel pointer to userspace, which is
> discouraged in some setups. So drop this message
> altogether.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi.c | 9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 92d5912..9ec576d 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -531,7 +531,7 @@ void scsi_log_send(struct scsi_cmnd *cmd)
>  	 *
>  	 * 3: same as 2
>  	 *
> -	 * 4: same as 3 plus dump extra junk
> +	 * 4: same as 3
>  	 */
>  	if (unlikely(scsi_logging_level)) {
>  		level = SCSI_LOG_LEVEL(SCSI_LOG_MLQUEUE_SHIFT,
> @@ -540,13 +540,6 @@ void scsi_log_send(struct scsi_cmnd *cmd)
>  			scmd_printk(KERN_INFO, cmd,
>  				    "Send: scmd 0x%p\n", cmd);
>  			scsi_print_command(cmd);
> -			if (level > 3) {
> -				printk(KERN_INFO "buffer = 0x%p, bufflen =
> %d,"
> -				       " queuecommand 0x%p\n",
> -					scsi_sglist(cmd), scsi_bufflen(cmd),
> -					cmd->device->host->hostt-
> >queuecommand);
> -
> -			}
>  		}
>  	}
>  }

Reviewed-by: Robert Elliott <elliott@hp.com>

One more comment on the series:

After the tags, there are still a few scmd %p prints left
including the one above.  Is this series supposed to get
rid of the rest of them?

drivers/scsi/scsi.c:                                "Send: scmd 0x%p\n", cmd);
drivers/scsi/scsi_error.c:                                  "scmd %p eh timeout, not aborting\n",
drivers/scsi/scsi_error.c:                                  "aborting command %p\n", scmd));
drivers/scsi/scsi_error.c:                                                  "scmd %p eh timeout, "
drivers/scsi/scsi_error.c:                                                  "scmd %p retry "
drivers/scsi/scsi_error.c:                                                  "scmd %p finish "
drivers/scsi/scsi_error.c:                                          "scmd %p abort %s\n", scmd,
drivers/scsi/scsi_error.c:                                  "scmd %p terminate "
drivers/scsi/scsi_error.c:                                  "scmd %p previous abort failed\n", scmd));
drivers/scsi/scsi_error.c:                                  "scmd %p not aborting, host in recovery\n",
drivers/scsi/scsi_error.c:                          "scmd %p abort scheduled\n", scmd));
drivers/scsi/scsi_error.c:                      "%s scmd: %p result: %x\n",
drivers/scsi/scsi_error.c:                      "%s: scmd: %p, timeleft: %ld\n",
drivers/scsi/scsi_error.c:                      "sense requested for %p result %x\n",
drivers/scsi/scsi_error.c:              "%s: scmd %p rtn %x\n", __func__, scmd, rtn));
drivers/scsi/scsi_error.c:                                           "%s: flush retry cmd: %p\n",
drivers/scsi/scsi_error.c:                                           "%s: flush finish cmd: %p\n",
drivers/scsi/scsi_lib.c:                "Inserting command %p into mlqueue\n", cmd));
drivers/scsi/scsi_scan.c:               printk(KERN_WARNING "%s no slave_alloc function in hostt %p\n", __func__, shost->hostt);
drivers/scsi/scsi_scan.c:               printk(KERN_WARNING "sdev %p scmd %p sending INQUIRY\n", sdev, scsi_cmd);
drivers/scsi/scsi_scan.c:               printk(KERN_WARNING "%s sdev %p from lookup_by_target\n", __func__, sdev);
drivers/scsi/scsi_scan.c:               printk(KERN_WARNING "%s sdev %p from alloc_sdev\n", __func__, sdev);
drivers/scsi/scsi_scan.c:               printk(KERN_WARNING "%s sdev %p from alloc_sdev\n", __func__, sdev);
drivers/scsi/scsi_scan.c:               printk(KERN_WARNING "%s sdev %p from lookup_by_target\n", __func__, sdev);
drivers/scsi/scsi_scan.c:       printk(KERN_WARNING "%s sdev %p from alloc_sdev\n", __func__, sdev);



