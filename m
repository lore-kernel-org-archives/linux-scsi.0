Return-Path: <SRS0=OG9y=YO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE403CA9EAF
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 23:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAAED2084C
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 23:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728353AbfJUXbm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Oct 2019 19:31:42 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:52710 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbfJUXbm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Oct 2019 19:31:42 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 3C4DA29E53;
        Mon, 21 Oct 2019 19:31:38 -0400 (EDT)
Date:   Tue, 22 Oct 2019 10:31:37 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Hannes Reinecke <hare@suse.de>
cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 12/24] scsi: introduce scsi_build_sense()
In-Reply-To: <20191021095322.137969-13-hare@suse.de>
Message-ID: <alpine.LNX.2.21.1910221026330.14@nippy.intranet>
References: <20191021095322.137969-1-hare@suse.de> <20191021095322.137969-13-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On Mon, 21 Oct 2019, Hannes Reinecke wrote:

> Introduce scsi_build_sense() as a wrapper around
> scsi_build_sense_buffer() to format the buffer and set
> the correct SCSI status.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/ata/libata-scsi.c             |  7 ++--
>  drivers/s390/scsi/zfcp_scsi.c         |  5 +--
>  drivers/scsi/3w-xxxx.c                |  3 +-
>  drivers/scsi/libiscsi.c               |  5 +--
>  drivers/scsi/lpfc/lpfc_scsi.c         | 30 ++++-------------
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c  |  5 +--
>  drivers/scsi/mvumi.c                  |  5 +--
>  drivers/scsi/myrb.c                   | 61 ++++++++---------------------------
>  drivers/scsi/myrs.c                   |  9 ++----
>  drivers/scsi/ps3rom.c                 |  3 +-
>  drivers/scsi/qla2xxx/qla_isr.c        | 15 ++-------
>  drivers/scsi/scsi_debug.c             | 11 +++----
>  drivers/scsi/scsi_lib.c               | 18 +++++++++++
>  drivers/scsi/smartpqi/smartpqi_init.c |  3 +-
>  drivers/scsi/stex.c                   |  5 +--
>  include/scsi/scsi_cmnd.h              |  3 ++
>  16 files changed, 60 insertions(+), 128 deletions(-)
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index b197d2fbe3f8..0fd3cb8e4e49 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -342,9 +342,7 @@ void ata_scsi_set_sense(struct ata_device *dev, struct scsi_cmnd *cmd,
>  	if (!cmd)
>  		return;
>  
> -	cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
> -
> -	scsi_build_sense_buffer(d_sense, cmd->sense_buffer, sk, asc, ascq);
> +	scsi_build_sense(cmd, d_sense, sk, asc, ascq);
>  }
>  
>  void ata_scsi_set_sense_information(struct ata_device *dev,
> @@ -1092,8 +1090,7 @@ static void ata_gen_passthru_sense(struct ata_queued_cmd *qc)
>  		 * ATA PASS-THROUGH INFORMATION AVAILABLE
>  		 * Always in descriptor format sense.
>  		 */
> -		scsi_build_sense_buffer(1, cmd->sense_buffer,
> -					RECOVERED_ERROR, 0, 0x1D);
> +		scsi_build_sense(cmd, 1, RECOVERED_ERROR, 0, 0x1D);
>  	}
>  
>  	if ((cmd->sense_buffer[0] & 0x7f) >= 0x72) {
> diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
> index e9ded2befa0d..da52d7649f4d 100644
> --- a/drivers/s390/scsi/zfcp_scsi.c
> +++ b/drivers/s390/scsi/zfcp_scsi.c
> @@ -834,10 +834,7 @@ void zfcp_scsi_set_prot(struct zfcp_adapter *adapter)
>   */
>  void zfcp_scsi_dif_sense_error(struct scsi_cmnd *scmd, int ascq)
>  {
> -	scsi_build_sense_buffer(1, scmd->sense_buffer,
> -				ILLEGAL_REQUEST, 0x10, ascq);
> -	set_driver_byte(scmd, DRIVER_SENSE);
> -	scmd->result |= SAM_STAT_CHECK_CONDITION;
> +	scsi_build_sense(scmd, 1, ILLEGAL_REQUEST, 0x10, ascq);
>  	set_host_byte(scmd, DID_SOFT_ERROR);
>  }
>  
> diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
> index 79eca8f1fd05..381723634c13 100644
> --- a/drivers/scsi/3w-xxxx.c
> +++ b/drivers/scsi/3w-xxxx.c
> @@ -1981,8 +1981,7 @@ static int tw_scsi_queue_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_c
>  			printk(KERN_NOTICE "3w-xxxx: scsi%d: Unknown scsi opcode: 0x%x\n", tw_dev->host->host_no, *command);
>  			tw_dev->state[request_id] = TW_S_COMPLETED;
>  			tw_state_request_finish(tw_dev, request_id);
> -			SCpnt->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
> -			scsi_build_sense_buffer(1, SCpnt->sense_buffer, ILLEGAL_REQUEST, 0x20, 0);
> +			scsi_build_sense(SCpnt, 1, ILLEGAL_REQUEST, 0x20, 0);
>  			done(SCpnt);
>  			retval = 0;
>  	}
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index ebd47c0cf9e9..9c85d7902faa 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -813,10 +813,7 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
>  
>  		ascq = session->tt->check_protection(task, &sector);
>  		if (ascq) {
> -			sc->result = DRIVER_SENSE << 24 |
> -				     SAM_STAT_CHECK_CONDITION;
> -			scsi_build_sense_buffer(1, sc->sense_buffer,
> -						ILLEGAL_REQUEST, 0x10, ascq);
> +			scsi_build_sense(sc, 1, ILLEGAL_REQUEST, 0x10, ascq);
>  			scsi_set_sense_information(sc->sense_buffer,
>  						   SCSI_SENSE_BUFFERSIZE,
>  						   sector);
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index f06f63e58596..aa8431fe9c1f 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -2843,10 +2843,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
>  	}
>  out:
>  	if (err_type == BGS_GUARD_ERR_MASK) {
> -		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
> -					0x10, 0x1);
> -		cmd->result = DRIVER_SENSE << 24 | DID_ABORT << 16 |
> -			      SAM_STAT_CHECK_CONDITION;
> +		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x1);

set_host_byte(cmd, DID_ABORT);

>  		phba->bg_guard_err_cnt++;
>  		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
>  				"9069 BLKGRD: LBA %lx grd_tag error %x != %x\n",
> @@ -2854,10 +2851,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
>  				sum, guard_tag);
>  
>  	} else if (err_type == BGS_REFTAG_ERR_MASK) {
> -		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
> -					0x10, 0x3);
> -		cmd->result = DRIVER_SENSE << 24 | DID_ABORT << 16 |
> -			      SAM_STAT_CHECK_CONDITION;
> +		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x3);
>  

Same.

>  		phba->bg_reftag_err_cnt++;
>  		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
> @@ -2866,10 +2860,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
>  				ref_tag, start_ref_tag);
>  
>  	} else if (err_type == BGS_APPTAG_ERR_MASK) {
> -		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
> -					0x10, 0x2);
> -		cmd->result = DRIVER_SENSE << 24 | DID_ABORT << 16 |
> -			      SAM_STAT_CHECK_CONDITION;
> +		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x2);
>  

Same. 

>  		phba->bg_apptag_err_cnt++;
>  		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
> @@ -2930,10 +2921,7 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
>  	if (lpfc_bgs_get_guard_err(bgstat)) {
>  		ret = 1;
>  
> -		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
> -				0x10, 0x1);
> -		cmd->result = DRIVER_SENSE << 24 | DID_ABORT << 16 |
> -			      SAM_STAT_CHECK_CONDITION;
> +		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x1);

Same.

>  		phba->bg_guard_err_cnt++;
>  		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
>  				"9055 BLKGRD: Guard Tag error in cmd"
> @@ -2946,10 +2934,7 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
>  	if (lpfc_bgs_get_reftag_err(bgstat)) {
>  		ret = 1;
>  
> -		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
> -				0x10, 0x3);
> -		cmd->result = DRIVER_SENSE << 24 | DID_ABORT << 16 |
> -			      SAM_STAT_CHECK_CONDITION;
> +		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x3);
>  

Same.

>  		phba->bg_reftag_err_cnt++;
>  		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
> @@ -2963,10 +2948,7 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
>  	if (lpfc_bgs_get_apptag_err(bgstat)) {
>  		ret = 1;
>  
> -		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
> -				0x10, 0x2);
> -		cmd->result = DRIVER_SENSE << 24 | DID_ABORT << 16 |
> -			      SAM_STAT_CHECK_CONDITION;
> +		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x2);
>  

Same.

>  		phba->bg_apptag_err_cnt++;
>  		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index 3f0797e6f941..802b0d39bdf3 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -4619,10 +4619,7 @@ _scsih_eedp_error_handling(struct scsi_cmnd *scmd, u16 ioc_status)
>  		ascq = 0x00;
>  		break;
>  	}
> -	scsi_build_sense_buffer(0, scmd->sense_buffer, ILLEGAL_REQUEST, 0x10,
> -	    ascq);
> -	scmd->result = DRIVER_SENSE << 24 | (DID_ABORT << 16) |
> -	    SAM_STAT_CHECK_CONDITION;
> +	scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x10, ascq);

Same.

-- 
