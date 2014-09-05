From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: Re: [PATCH 08/20] scsi: use 'bool' as return value for scsi_normalize_sense()
Date: Fri, 05 Sep 2014 09:51:59 +0900
Message-ID: <5409092F.4080207@hitachi.com>
References: <1409738775-80876-1-git-send-email-hare@suse.de> <1409738775-80876-9-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail4.hitachi.co.jp ([133.145.228.5]:46305 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbaIEAwE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Sep 2014 20:52:04 -0400
In-Reply-To: <1409738775-80876-9-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org

(2014/09/03 19:06), Hannes Reinecke wrote:
> Convert scsi_normalize_sense() and frieds to return 'bool'
> instead of an integer.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/scsi/scsi_error.c | 14 +++++++-------
>   drivers/scsi/scsi_lib.c   |  2 +-
>   include/scsi/scsi_eh.h    | 12 ++++++------
>   3 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 6c99624..8a6d382 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -2408,20 +2408,20 @@ EXPORT_SYMBOL(scsi_reset_provider);
>    *	responded to a SCSI command with the CHECK_CONDITION status.
>    *
>    * Return value:
> - *	1 if valid sense data information found, else 0;
> + *	true if valid sense data information found, else false;
>    */
> -int scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
> -                         struct scsi_sense_hdr *sshdr)
> +bool scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
> +			  struct scsi_sense_hdr *sshdr)
>   {
>   	if (!sense_buffer || !sb_len)
> -		return 0;
> +		return false;
>   
>   	memset(sshdr, 0, sizeof(struct scsi_sense_hdr));
>   
>   	sshdr->response_code = (sense_buffer[0] & 0x7f);
>   
>   	if (!scsi_sense_valid(sshdr))
> -		return 0;
> +		return false;
>   
>   	if (sshdr->response_code >= 0x72) {
>   		/*
> @@ -2451,11 +2451,11 @@ int scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
>   		}
>   	}
>   
> -	return 1;
> +	return true;
>   }
>   EXPORT_SYMBOL(scsi_normalize_sense);
>   
> -int scsi_command_normalize_sense(struct scsi_cmnd *cmd,
> +bool scsi_command_normalize_sense(struct scsi_cmnd *cmd,
>   				 struct scsi_sense_hdr *sshdr)
>   {
>   	return scsi_normalize_sense(cmd->sense_buffer,
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index de178f7..8cad004 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -830,7 +830,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>   	struct request *req = cmd->request;
>   	int error = 0;
>   	struct scsi_sense_hdr sshdr;
> -	int sense_valid = 0;
> +	bool sense_valid = false;
>   	int sense_deferred = 0;
>   	enum {ACTION_FAIL, ACTION_REPREP, ACTION_RETRY,
>   	      ACTION_DELAYED_RETRY} action;
> diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
> index 06a8790..1427a66 100644
> --- a/include/scsi/scsi_eh.h
> +++ b/include/scsi/scsi_eh.h
> @@ -27,7 +27,7 @@ struct scsi_sense_hdr {		/* See SPC-3 section 4.5 */
>   	u8 additional_length;	/* always 0 for fixed sense format */
>   };
>   
> -static inline int scsi_sense_valid(struct scsi_sense_hdr *sshdr)
> +static inline bool scsi_sense_valid(struct scsi_sense_hdr *sshdr)
>   {
>   	if (!sshdr)
>   		return 0;

Should be "return false;"

The others in this patch look good.

Thanks,
Yoshihiro YUNOMAE

> @@ -42,12 +42,12 @@ extern void scsi_eh_flush_done_q(struct list_head *done_q);
>   extern void scsi_report_bus_reset(struct Scsi_Host *, int);
>   extern void scsi_report_device_reset(struct Scsi_Host *, int, int);
>   extern int scsi_block_when_processing_errors(struct scsi_device *);
> -extern int scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
> -		struct scsi_sense_hdr *sshdr);
> -extern int scsi_command_normalize_sense(struct scsi_cmnd *cmd,
> -		struct scsi_sense_hdr *sshdr);
> +extern bool scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
> +				 struct scsi_sense_hdr *sshdr);
> +extern bool scsi_command_normalize_sense(struct scsi_cmnd *cmd,
> +					 struct scsi_sense_hdr *sshdr);
>   
> -static inline int scsi_sense_is_deferred(struct scsi_sense_hdr *sshdr)
> +static inline bool scsi_sense_is_deferred(struct scsi_sense_hdr *sshdr)
>   {
>   	return ((sshdr->response_code >= 0x70) && (sshdr->response_code & 1));
>   }
> 

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


