Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C3A0C433F5
	for <linux-scsi@archiver.kernel.org>; Sat,  7 May 2022 07:32:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238791AbiEGHgk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 7 May 2022 03:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235270AbiEGHge (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 May 2022 03:36:34 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1114579C
        for <linux-scsi@vger.kernel.org>; Sat,  7 May 2022 00:32:48 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 217B921AA8;
        Sat,  7 May 2022 07:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651908767; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o/d9tKzplk2V2JR4RN/VsPDvgrivv6X9aIpdlUNRh5I=;
        b=aOYfppWz5Nnu4vM3/yPViyksXF0zttvPXUcRrTVpiUJgTDNijXt6+GEc3IDI2gpfl+jFQ7
        89T4Sz43YO4J9Mye8YA65MRD3ujmaBia5+sArIvgME5Ejc6UAdlReJWxuT5g4vg3ksXGmx
        rVSWHpC/GB6kNo7h5ndC02YpGcMX7HU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651908767;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o/d9tKzplk2V2JR4RN/VsPDvgrivv6X9aIpdlUNRh5I=;
        b=2OOHGX2PwEiqND71gU4i0bTrG7xpV60Dl83DkpoOxITa3wxoBajze7EhdB258Gi95WVJjX
        cs+3X/ITNfcfGBAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EA8BD13780;
        Sat,  7 May 2022 07:32:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id jTTHN50gdmKcTAAAMHmgww
        (envelope-from <hare@suse.de>); Sat, 07 May 2022 07:32:45 +0000
Message-ID: <42bded36-5125-e9c4-85ef-ab490612a550@suse.de>
Date:   Sat, 7 May 2022 09:32:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 17/24] snic: reserve tag for TMF
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20220502213820.3187-1-hare@suse.de>
 <20220502213820.3187-18-hare@suse.de>
 <39ac80da-ce97-55e5-4fb7-5bab02a191ea@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <39ac80da-ce97-55e5-4fb7-5bab02a191ea@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/6/22 06:28, John Garry wrote:
>> diff --git a/drivers/scsi/snic/snic_main.c 
>> b/drivers/scsi/snic/snic_main.c
>> index 29d56396058c..f344cbc27923 100644
>> --- a/drivers/scsi/snic/snic_main.c
>> +++ b/drivers/scsi/snic/snic_main.c
>> @@ -512,6 +512,9 @@ snic_probe(struct pci_dev *pdev, const struct 
>> pci_device_id *ent)
>>                        max_t(u32, SNIC_MIN_IO_REQ, max_ios));
>>       snic->max_tag_id = shost->can_queue;
>> +    /* Reserve one reset command */
>> +    shost->can_queue--;
>> +    snic->tmf_tag_id = shost->can_queue;
>>       shost->max_lun = snic->config.luns_per_tgt;
>>       shost->max_id = SNIC_MAX_TARGET;
>> diff --git a/drivers/scsi/snic/snic_scsi.c 
>> b/drivers/scsi/snic/snic_scsi.c
>> index 5f17666f3e1d..e18c8c5e4b46 100644
>> --- a/drivers/scsi/snic/snic_scsi.c
>> +++ b/drivers/scsi/snic/snic_scsi.c
>> @@ -1018,17 +1018,6 @@ snic_hba_reset_cmpl_handler(struct snic *snic, 
>> struct snic_fw_req *fwreq)
>>                 "reset_cmpl: type = %x, hdr_stat = %x, cmnd_id = %x, 
>> hid = %x, ctx = %lx\n",
>>                 typ, hdr_stat, cmnd_id, hid, ctx);
>> -    /* spl case, host reset issued through ioctl */
>> -    if (cmnd_id == SCSI_NO_TAG) {
>> -        rqi = (struct snic_req_info *) ctx;
>> -        SNIC_HOST_INFO(snic->shost,
>> -                   "reset_cmpl:Tag %d ctx %lx cmpl stat %s\n",
>> -                   cmnd_id, ctx, snic_io_status_to_str(hdr_stat));
>> -        sc = rqi->sc;
>> -
>> -        goto ioctl_hba_rst;
>> -    }
>> -
>>       if (cmnd_id >= snic->max_tag_id) {
>>           SNIC_HOST_ERR(snic->shost,
>>                     "reset_cmpl: Tag 0x%x out of Range,HdrStat %s\n",
>> @@ -1039,7 +1028,6 @@ snic_hba_reset_cmpl_handler(struct snic *snic, 
>> struct snic_fw_req *fwreq)
>>       }
>>       sc = scsi_host_find_tag(snic->shost, cmnd_id);
>> -ioctl_hba_rst:
>>       if (!sc) {
>>           atomic64_inc(&snic->s_stats.io.sc_null);
>>           SNIC_HOST_ERR(snic->shost,
>> @@ -1725,7 +1713,7 @@ snic_dr_clean_single_req(struct snic *snic,
>>   {
>>       struct snic_req_info *rqi = NULL;
>>       struct snic_tgt *tgt = NULL;
>> -    struct scsi_cmnd *sc = NULL;
>> +    struct scsi_cmnd *sc;
>>       spinlock_t *io_lock = NULL;
>>       u32 sv_state = 0, tmf = 0;
>>       DECLARE_COMPLETION_ONSTACK(tm_done);
>> @@ -2238,13 +2226,6 @@ snic_issue_hba_reset(struct snic *snic, struct 
>> scsi_cmnd *sc)
>>           goto hba_rst_end;
>>       }
>> -    if (snic_cmd_tag(sc) == SCSI_NO_TAG) {
>> -        memset(scsi_cmd_priv(sc), 0,
>> -            sizeof(struct snic_internal_io_state));
>> -        SNIC_HOST_INFO(snic->shost, "issu_hr:Host reset thru ioctl.\n");
>> -        rqi->sc = sc;
>> -    }
>> -
>>       req = rqi_to_req(rqi);
>>       io_lock = snic_io_lock_hash(snic, sc);
>> @@ -2319,11 +2300,13 @@ snic_issue_hba_reset(struct snic *snic, struct 
>> scsi_cmnd *sc)
>>   } /* end of snic_issue_hba_reset */
>>   int
>> -snic_reset(struct Scsi_Host *shost, struct scsi_cmnd *sc)
>> +snic_reset(struct Scsi_Host *shost)
>>   {
>>       struct snic *snic = shost_priv(shost);
>> +    struct scsi_cmnd *sc = NULL;
>>       enum snic_state sv_state;
>>       unsigned long flags;
>> +    u32 start_time  = jiffies;
>>       int ret = FAILED;
>>       /* Set snic state as SNIC_FWRESET*/
>> @@ -2348,6 +2331,18 @@ snic_reset(struct Scsi_Host *shost, struct 
>> scsi_cmnd *sc)
>>       while (atomic_read(&snic->ios_inflight))
>>           schedule_timeout(msecs_to_jiffies(1));
>> +    sc = scsi_host_find_tag(shost, snic->tmf_tag_id);
> 
> Maybe I am missing something but this does not seem right. As I see, 
> blk-mq has driver tags in range [0, snic->tmf_tag_id - 1], so we cannot 
> call scsi_host_find_tag() -> blk_mq_unique_tag_to_tag(snic->tmf_tag_id)
> 
We do decrease 'can_queue' by '1' just at the start of this patch, hence 
the last tag is always available for TMF.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
