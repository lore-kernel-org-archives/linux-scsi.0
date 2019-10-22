Return-Path: <SRS0=5qjn=YP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24714CA9EA0
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Oct 2019 06:02:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E941C21783
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Oct 2019 06:02:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbfJVGC6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Oct 2019 02:02:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:33700 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725788AbfJVGC6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 22 Oct 2019 02:02:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3ADB8AF38;
        Tue, 22 Oct 2019 06:02:53 +0000 (UTC)
Subject: Re: [PATCH 12/24] scsi: introduce scsi_build_sense()
To:     Finn Thain <fthain@telegraphics.com.au>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        linux-scsi@vger.kernel.org
References: <20191021095322.137969-1-hare@suse.de>
 <20191021095322.137969-13-hare@suse.de>
 <alpine.LNX.2.21.1910221026330.14@nippy.intranet>
From:   Hannes Reinecke <hare@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=hare@suse.de; prefer-encrypt=mutual; keydata=
 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
 azzYF4VRJsdl+d0MCaSy8mUh
Message-ID: <dec14d69-d1da-24f9-6fa3-550ce48e6662@suse.de>
Date:   Tue, 22 Oct 2019 08:02:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.21.1910221026330.14@nippy.intranet>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/22/19 1:31 AM, Finn Thain wrote:
> 
> On Mon, 21 Oct 2019, Hannes Reinecke wrote:
> 
>> Introduce scsi_build_sense() as a wrapper around
>> scsi_build_sense_buffer() to format the buffer and set
>> the correct SCSI status.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/ata/libata-scsi.c             |  7 ++--
>>  drivers/s390/scsi/zfcp_scsi.c         |  5 +--
>>  drivers/scsi/3w-xxxx.c                |  3 +-
>>  drivers/scsi/libiscsi.c               |  5 +--
>>  drivers/scsi/lpfc/lpfc_scsi.c         | 30 ++++-------------
>>  drivers/scsi/mpt3sas/mpt3sas_scsih.c  |  5 +--
>>  drivers/scsi/mvumi.c                  |  5 +--
>>  drivers/scsi/myrb.c                   | 61 ++++++++---------------------------
>>  drivers/scsi/myrs.c                   |  9 ++----
>>  drivers/scsi/ps3rom.c                 |  3 +-
>>  drivers/scsi/qla2xxx/qla_isr.c        | 15 ++-------
>>  drivers/scsi/scsi_debug.c             | 11 +++----
>>  drivers/scsi/scsi_lib.c               | 18 +++++++++++
>>  drivers/scsi/smartpqi/smartpqi_init.c |  3 +-
>>  drivers/scsi/stex.c                   |  5 +--
>>  include/scsi/scsi_cmnd.h              |  3 ++
>>  16 files changed, 60 insertions(+), 128 deletions(-)
>>
>> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
>> index b197d2fbe3f8..0fd3cb8e4e49 100644
>> --- a/drivers/ata/libata-scsi.c
>> +++ b/drivers/ata/libata-scsi.c
>> @@ -342,9 +342,7 @@ void ata_scsi_set_sense(struct ata_device *dev, struct scsi_cmnd *cmd,
>>  	if (!cmd)
>>  		return;
>>  
>> -	cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
>> -
>> -	scsi_build_sense_buffer(d_sense, cmd->sense_buffer, sk, asc, ascq);
>> +	scsi_build_sense(cmd, d_sense, sk, asc, ascq);
>>  }
>>  
>>  void ata_scsi_set_sense_information(struct ata_device *dev,
>> @@ -1092,8 +1090,7 @@ static void ata_gen_passthru_sense(struct ata_queued_cmd *qc)
>>  		 * ATA PASS-THROUGH INFORMATION AVAILABLE
>>  		 * Always in descriptor format sense.
>>  		 */
>> -		scsi_build_sense_buffer(1, cmd->sense_buffer,
>> -					RECOVERED_ERROR, 0, 0x1D);
>> +		scsi_build_sense(cmd, 1, RECOVERED_ERROR, 0, 0x1D);
>>  	}
>>  
>>  	if ((cmd->sense_buffer[0] & 0x7f) >= 0x72) {
>> diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
>> index e9ded2befa0d..da52d7649f4d 100644
>> --- a/drivers/s390/scsi/zfcp_scsi.c
>> +++ b/drivers/s390/scsi/zfcp_scsi.c
>> @@ -834,10 +834,7 @@ void zfcp_scsi_set_prot(struct zfcp_adapter *adapter)
>>   */
>>  void zfcp_scsi_dif_sense_error(struct scsi_cmnd *scmd, int ascq)
>>  {
>> -	scsi_build_sense_buffer(1, scmd->sense_buffer,
>> -				ILLEGAL_REQUEST, 0x10, ascq);
>> -	set_driver_byte(scmd, DRIVER_SENSE);
>> -	scmd->result |= SAM_STAT_CHECK_CONDITION;
>> +	scsi_build_sense(scmd, 1, ILLEGAL_REQUEST, 0x10, ascq);
>>  	set_host_byte(scmd, DID_SOFT_ERROR);
>>  }
>>  
>> diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
>> index 79eca8f1fd05..381723634c13 100644
>> --- a/drivers/scsi/3w-xxxx.c
>> +++ b/drivers/scsi/3w-xxxx.c
>> @@ -1981,8 +1981,7 @@ static int tw_scsi_queue_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_c
>>  			printk(KERN_NOTICE "3w-xxxx: scsi%d: Unknown scsi opcode: 0x%x\n", tw_dev->host->host_no, *command);
>>  			tw_dev->state[request_id] = TW_S_COMPLETED;
>>  			tw_state_request_finish(tw_dev, request_id);
>> -			SCpnt->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
>> -			scsi_build_sense_buffer(1, SCpnt->sense_buffer, ILLEGAL_REQUEST, 0x20, 0);
>> +			scsi_build_sense(SCpnt, 1, ILLEGAL_REQUEST, 0x20, 0);
>>  			done(SCpnt);
>>  			retval = 0;
>>  	}
>> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
>> index ebd47c0cf9e9..9c85d7902faa 100644
>> --- a/drivers/scsi/libiscsi.c
>> +++ b/drivers/scsi/libiscsi.c
>> @@ -813,10 +813,7 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
>>  
>>  		ascq = session->tt->check_protection(task, &sector);
>>  		if (ascq) {
>> -			sc->result = DRIVER_SENSE << 24 |
>> -				     SAM_STAT_CHECK_CONDITION;
>> -			scsi_build_sense_buffer(1, sc->sense_buffer,
>> -						ILLEGAL_REQUEST, 0x10, ascq);
>> +			scsi_build_sense(sc, 1, ILLEGAL_REQUEST, 0x10, ascq);
>>  			scsi_set_sense_information(sc->sense_buffer,
>>  						   SCSI_SENSE_BUFFERSIZE,
>>  						   sector);
>> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
>> index f06f63e58596..aa8431fe9c1f 100644
>> --- a/drivers/scsi/lpfc/lpfc_scsi.c
>> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
>> @@ -2843,10 +2843,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
>>  	}
>>  out:
>>  	if (err_type == BGS_GUARD_ERR_MASK) {
>> -		scsi_build_sense_buffer(1, cmd->sense_buffer, ILLEGAL_REQUEST,
>> -					0x10, 0x1);
>> -		cmd->result = DRIVER_SENSE << 24 | DID_ABORT << 16 |
>> -			      SAM_STAT_CHECK_CONDITION;
>> +		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x1);
> 
> set_host_byte(cmd, DID_ABORT);
> 
[ .. ]
>>  		phba->bg_apptag_err_cnt++;
>>  		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>> index 3f0797e6f941..802b0d39bdf3 100644
>> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>> @@ -4619,10 +4619,7 @@ _scsih_eedp_error_handling(struct scsi_cmnd *scmd, u16 ioc_status)
>>  		ascq = 0x00;
>>  		break;
>>  	}
>> -	scsi_build_sense_buffer(0, scmd->sense_buffer, ILLEGAL_REQUEST, 0x10,
>> -	    ascq);
>> -	scmd->result = DRIVER_SENSE << 24 | (DID_ABORT << 16) |
>> -	    SAM_STAT_CHECK_CONDITION;
>> +	scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x10, ascq);
> 
> Same.
> 
And while you are correct that it should introduce set_host_byte() here,
too, the larger issue here is that setting DID_ABORT will obliterate any
sense code we set; in scsi_decide_dispostion() the sense code is never
evaluated if DID_ABORT is set.
But indeed, that should be a separate patch, and possibly even a
separate discussion.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      Teamlead Storage & Networking
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 247165 (AG München), GF: Felix Imendörffer
