Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B68C6EE4996
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Aug 2023 15:25:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237045AbjHVPZq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Aug 2023 11:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237040AbjHVPZp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Aug 2023 11:25:45 -0400
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE82FCD7
        for <linux-scsi@vger.kernel.org>; Tue, 22 Aug 2023 08:25:43 -0700 (PDT)
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1bba48b0bd2so29906505ad.3
        for <linux-scsi@vger.kernel.org>; Tue, 22 Aug 2023 08:25:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692717943; x=1693322743;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YAkU1QzOoKrcdySGvOFpCsMAoNjuFyWtpinl5f9soh8=;
        b=kSJNAD9RW/uMHJt/abC7ung7BcV2vmccIwDPnN+Bwc4fk+yH3TCE/oDhkCStsvie3B
         PucCMttTBjedcNyu6isvTHiShxxUAi8mhzGZbsjJ8XuIIGiiHLem1MG+BrGT/ezDwa5f
         inh930bXl3fZaCSsTPckjxxwRfGP2dbDCJPPeuyNQIMIWhDBXb8fVwP2Le4rM3DbbhIr
         bweQCil7SBYqXnhZrr9AIQOAmQsqIx/iSuViPqksO7iZ0eKnGVOS1TU5l0qMZaVpHHns
         J3PuS5918OPmPILDJ2pDqf14QlChmX74i/1EEulbNOm6v2XXBOygt9i2yyZHZrhUqdgq
         fyQQ==
X-Gm-Message-State: AOJu0YygxZlZNClnQ1bpQWfJtxgIOg3LGhLMUcLlcOjxw1+bCxfJs0/U
        hTkyF3WFSuCh0FLqbBFj6oE=
X-Google-Smtp-Source: AGHT+IEtDXiM+6ONaJWQRETTOUGSFPUC3xMDKQLDSirPh8pHqdYFf3+QCOhbFLVQb0qqCy3qwyKXyA==
X-Received: by 2002:a17:902:ea11:b0:1bd:f69e:6630 with SMTP id s17-20020a170902ea1100b001bdf69e6630mr10412320plg.65.1692717943151;
        Tue, 22 Aug 2023 08:25:43 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:88be:bf57:de29:7cc? ([2620:15c:211:201:88be:bf57:de29:7cc])
        by smtp.gmail.com with ESMTPSA id e9-20020a170902b78900b001b5656b0bf9sm9139230pls.286.2023.08.22.08.25.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Aug 2023 08:25:42 -0700 (PDT)
Message-ID: <9c32fc0f-b14e-9f7d-7ebc-11c0710d6365@acm.org>
Date:   Tue, 22 Aug 2023 08:25:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
Subject: Re: [PATCH] scsi: core: Report error list information in debugfs
Content-Language: en-US
To:     John Garry <john.g.garry@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Mike Christie <michael.christie@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230821204101.3601799-1-bvanassche@acm.org>
 <36f46807-2cc0-1efd-b900-54bcaa0cba15@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <36f46807-2cc0-1efd-b900-54bcaa0cba15@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/22/23 02:04, John Garry wrote:
> If it's on the first list, then there is not much point in checking this list.
> It might be even worth checking list_empty(&cmd->eh_entry) initially also to
> save the bother.
> 
> Having said all this, adding those checks will add lots of unpleasant indentation...

Since the above code is only used to export information through debugfs I don't
think that it should be optimized heavily? Anyway, how about combining the
(untested) patch below with the above patch?

diff --git a/drivers/scsi/scsi_debugfs.c b/drivers/scsi/scsi_debugfs.c
index a9bc5f7ce745..f795848b316c 100644
--- a/drivers/scsi/scsi_debugfs.c
+++ b/drivers/scsi/scsi_debugfs.c
@@ -45,15 +45,16 @@ void scsi_show_rq(struct seq_file *m, struct request *rq)
  	list_for_each_entry(cmd2, &shost->eh_abort_list, eh_entry) {
  		if (cmd == cmd2) {
  			list_info = "on eh_abort_list";
-			break;
+			goto unlock;
  		}
  	}
  	list_for_each_entry(cmd2, &shost->eh_cmd_q, eh_entry) {
  		if (cmd == cmd2) {
  			list_info = "on eh_cmd_q";
-			break;
+			goto unlock;
  		}
  	}
+unlock:
  	spin_unlock_irq(shost->host_lock);

  	__scsi_format_command(buf, sizeof(buf), cmd->cmnd, cmd->cmd_len);

Thanks,

Bart.
