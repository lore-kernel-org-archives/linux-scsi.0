Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FE16C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Apr 2022 19:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232746AbiD0TeQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Apr 2022 15:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235161AbiD0TeG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Apr 2022 15:34:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6A7D31116B
        for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2022 12:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651087849;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fqkPaeEr0/s/QUyXfa0JdJ2y0zoET3+5u5xX7SykPZs=;
        b=h6jVD/k4UwVWIbiMxzsqQwtbhk98QFCp58Qf3DqYm6u7sslMQM5dfrdILyVyj4xqHKJHI6
        5Nng0+oa3paTU2AWdKFe5d9Otiexs7E+otr6LnZ5hJtEYg8YE92/Ux0Yp6uMtC3guXZR/l
        yHjaMGASy3OKOW+X+T4IzL7bsFQrGvM=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-20-AVMI3FxGN-KIN2BX7JnMYw-1; Wed, 27 Apr 2022 15:30:48 -0400
X-MC-Unique: AVMI3FxGN-KIN2BX7JnMYw-1
Received: by mail-qk1-f199.google.com with SMTP id o79-20020a374152000000b0069ee7515f53so1796559qka.14
        for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2022 12:30:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fqkPaeEr0/s/QUyXfa0JdJ2y0zoET3+5u5xX7SykPZs=;
        b=KsMgY+vgOPoJBnLtEK6Zhfm1hkbip9ikITXkmQPVhZpVSAZv1UQ/euqEdP3I8o5ojx
         2i2PlYvkuIP3iWSj5FBSlQkeHOhei+DoA4G3QR4Jl2V86nKqPDC9AhiAQe4Mp9w+JWKb
         5O/LogIz3AOles9rFfT1hvYzR6NejeRsB2F4n49JZ74enK0OXRekdfgmDrjS1XLWSCo5
         r8PktIbstTOlwzPD3VHnXzuJmSsi23SdiV+Tp0x1VuWJsvk1eYX8qx7TJXWhkbE0qOo5
         ZW8iv9JnnaOKqbBtR4bcqe7hgDdgMigSO3hnGleck255iEG7OFEvgWjnIL6ImdShhcQS
         GnlA==
X-Gm-Message-State: AOAM532VcVEpnKSJuBrFobU1BVFJWqfso4DBViGh3whDynMy4/RheKCo
        sNG8w9FVLc4b5s5lGHHEjWBZqmu5zrH4oFrr3x9pkrzrAN8Vqjn2cZLUCyOeakkhJTeN4rbRvdB
        Hw/9mC5bImCGjQ7Z4a/YY1Q==
X-Received: by 2002:a05:622a:1647:b0:2f3:6077:bffb with SMTP id y7-20020a05622a164700b002f36077bffbmr15437555qtj.462.1651087846934;
        Wed, 27 Apr 2022 12:30:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzW9IY37W+gHqFMGfCeWt+DOqQvQGUAtaKClK6ymbFn9j81hV9SBESEIucknLk6jMGnLPTUGQ==
X-Received: by 2002:a05:622a:1647:b0:2f3:6077:bffb with SMTP id y7-20020a05622a164700b002f36077bffbmr15437536qtj.462.1651087846556;
        Wed, 27 Apr 2022 12:30:46 -0700 (PDT)
Received: from loberman.users.ipa.redhat.com ([2600:6c64:4e7f:cee0:729d:61b6:700c:6b56])
        by smtp.gmail.com with ESMTPSA id t19-20020ac85893000000b002e1afa26591sm11717305qta.52.2022.04.27.12.30.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Apr 2022 12:30:46 -0700 (PDT)
Message-ID: <90ce634faf2484405a51b4628be5b61be5a0f0a6.camel@redhat.com>
Subject: Re: [PATCH] target: pscsi: set SCF_TREAT_READ_AS_NORMAL flag only
 if there is valid data
From:   Laurence Oberman <loberman@redhat.com>
To:     David Jeffery <djeffery@redhat.com>, target-devel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 27 Apr 2022 15:30:44 -0400
In-Reply-To: <ae63bff76f384ad7d28aa0833beba6860171aea9.camel@redhat.com>
References: <20220427183250.291881-1-djeffery@redhat.com>
         <ae63bff76f384ad7d28aa0833beba6860171aea9.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2022-04-27 at 15:26 -0400, Laurence Oberman wrote:
> On Wed, 2022-04-27 at 14:32 -0400, David Jeffery wrote:
> > With tape devices, the SCF_TREAT_READ_AS_NORMAL flag is used by the
> > target
> > subsystem to mark commands which have both data to return as well
> > as
> > sense data. But with pscsi, SCF_TREAT_READ_AS_NORMAL can be set
> > even
> > if
> > there is no data to return. The SCF_TREAT_READ_AS_NORMAL flag
> > causes
> > the
> > target core to call iscsit datain callbacks even if there is no
> > data,
> > which
> > iscsit does not support. This results in iscsit going into an error
> > state
> > requiring recovery and being unable to complete the command to the
> > initiator.
> > 
> > This issue can be resolved by fixing pscsi to only set
> > SCF_TREAT_READ_AS_NORMAL if there is valid data to return along
> > side
> > the
> > sense data.
> > 
> > Fixes: bd81372065fa ("scsi: target: transport should handle st
> > FM/EOM/ILI reads")
> > Signed-off-by: David Jeffery <djeffery@redhat.com>
> > Tested-by: Laurence Oberman <loberman@redhat.com>
> > ---
> >  drivers/target/target_core_pscsi.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/target/target_core_pscsi.c
> > b/drivers/target/target_core_pscsi.c
> > index ff292b75e23f..60dafe4c581b 100644
> > --- a/drivers/target/target_core_pscsi.c
> > +++ b/drivers/target/target_core_pscsi.c
> > @@ -588,7 +588,7 @@ static void pscsi_destroy_device(struct
> > se_device
> > *dev)
> >  }
> >  
> >  static void pscsi_complete_cmd(struct se_cmd *cmd, u8 scsi_status,
> > -			       unsigned char *req_sense)
> > +			       unsigned char *req_sense, int
> > valid_data)
> >  {
> >  	struct pscsi_dev_virt *pdv = PSCSI_DEV(cmd->se_dev);
> >  	struct scsi_device *sd = pdv->pdv_sd;
> > @@ -681,7 +681,7 @@ static void pscsi_complete_cmd(struct se_cmd
> > *cmd, u8 scsi_status,
> >  		 * back despite framework assumption that a
> >  		 * check condition means there is no data
> >  		 */
> > -		if (sd->type == TYPE_TAPE &&
> > +		if (sd->type == TYPE_TAPE && valid_data &&
> >  		    cmd->data_direction == DMA_FROM_DEVICE) {
> >  			/*
> >  			 * is sense data valid, fixed format,
> > @@ -1032,6 +1032,7 @@ static void pscsi_req_done(struct request
> > *req,
> > blk_status_t status)
> >  	struct se_cmd *cmd = req->end_io_data;
> >  	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
> >  	enum sam_status scsi_status = scmd->result & 0xff;
> > +	int valid_data = cmd->data_length - scmd->resid_len;
> >  	u8 *cdb = cmd->priv;
> >  
> >  	if (scsi_status != SAM_STAT_GOOD) {
> > @@ -1039,12 +1040,11 @@ static void pscsi_req_done(struct request
> > *req, blk_status_t status)
> >  			" 0x%02x Result: 0x%08x\n", cmd, cdb[0], scmd-
> > > result);
> > 
> >  	}
> >  
> > -	pscsi_complete_cmd(cmd, scsi_status, scmd->sense_buffer);
> > +	pscsi_complete_cmd(cmd, scsi_status, scmd->sense_buffer,
> > valid_data);
> >  
> >  	switch (host_byte(scmd->result)) {
> >  	case DID_OK:
> > -		target_complete_cmd_with_length(cmd, scsi_status,
> > -			cmd->data_length - scmd->resid_len);
> > +		target_complete_cmd_with_length(cmd, scsi_status,
> > valid_data);
> >  		break;
> >  	default:
> >  		pr_debug("PSCSI Host Byte exception at cmd: %p CDB:"
> 
> We added a bucnh of debug to track this down, and the fix is solid
> and
> makes perfect sense.
> 
> Reviewed-by: Laurence Oberman <loberman@redhat.com>

Martin, please add
Reported-by: Scott Hamilton <scott.hamilton@atos.net>

