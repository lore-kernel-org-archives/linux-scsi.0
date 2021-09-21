Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18245C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Sep 2021 01:04:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F092561019
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Sep 2021 01:04:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233572AbhIUBFj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Sep 2021 21:05:39 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:8780 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233095AbhIUBDh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Sep 2021 21:03:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1632186131; x=1663722131;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=w2YKAQIR2Xp6CZ8Aowvu+sorzjHNYI0cYpbBdYLz+1w=;
  b=jY/x1APyoM+ljp+d7Ru6zkrRg4ZJYGRf469d2O+1o0NNZ4tYUnLlD2/B
   PbUEb2YSIEtwZ9782+/A1OiE0y13whHswhK8hNLwyeoCAnHZfZ77PL2aV
   Z/9QcFE7mi3x7RLMN1o7h8W2EkcYtSybsRyjWbHdwzaypNqLURknvk0n9
   r214eU2/IiMwWGzJJczrD1lb6UcgStyZQ+vcTCfnEl6zra+ECxwl4F1Et
   mGuueOBaitUa4N8Fx9P2sN0IB7Kb4N6eueHu6mC7bb/u7vdoeoNzwtm87
   3cYtsEa8zq/oT1iWEtMlNd8x3NIsa4PqwgzKlHamA3Stk7zEHiryIbOyP
   A==;
X-IronPort-AV: E=Sophos;i="5.85,309,1624291200"; 
   d="scan'208";a="181011084"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Sep 2021 09:02:10 +0800
IronPort-SDR: EDbAbSG5EMHkuEACkwI6SoOsyvD4sPA2F7Vo8Ai5+kahBgSyBQI9CYbKh+Z5IuFuhBDWoFkXHj
 RFRPWrWopl2soT+ZyKp5mSgR/k0DzU1O0Y7x0zzrNJUvQ2KPxULB/OI6A3mXznJrFz+dLOSpsb
 VkxZ0jwUuH/cYSDT2iiAeMhTSTZB6q8ygFhC81b2D0MDveWwrb164XIfOAMCTARDbweuiuL4Il
 GXpRpZjO/uCes9pqVnEOu6YzL5Azqs/RHQIohL9va4djWgf5LFSd7fDMoVtrVfYRZcN8MUXTib
 QIVDqQYIKE/aBID78lSP/tIi
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2021 17:38:24 -0700
IronPort-SDR: oNucw9UxhtugBT2nmHvyNuaPdzp+0l8NraT4PKyqy1gooQXQRxttkYiENGjeirhJK+MG1nBPuO
 /rAkDwZ6QaAwUCBeZJ0Uzd9g7p3frFRUkDHjOqgMddUYagjXCL95txAj6po00ULKbtdGc5wOdn
 WfTeTfOHk3WvuIe/ZcUvvQ2LM7h42h+ZA6zloPMAqA/Oz/EAtUNsxW8ezon6Oq3UP4mJp43XwC
 RP6d1WelPxideRKMOD/n+jVUiuiUwRfikCX+f9lCJPEP9xi04wAYzofnGDMbGOuTWvdVeHCUxE
 SX4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2021 18:02:09 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4HD36n2J2dz1Rws0
        for <linux-scsi@vger.kernel.org>; Mon, 20 Sep 2021 18:02:09 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1632186128; x=1634778129; bh=w2YKAQIR2Xp6CZ8Aowvu+sorzjHNYI0cYpb
        BdYLz+1w=; b=X7sWCnam9MQfoYxSy4jl8DzoqERxhTv61Z1432BYlSEl6yAYG1D
        Oyy5jAFw2OlwNX0Lpi/tl886Wyqgm02sdImjn3KAoVih7l6CcdFIOMQ2sEx4Z357
        Qv9gUnSFCFlMUXHKvriAjyuYikiKGtaqtRDAvv7a11hOoxbB8XyJNZIyH+cW2xQg
        UPOfoQxGJMUAaqZRx/KrDgjF6LUkUd1meYBcrpk9BMLId4ez3kPWJUYiF32jqyPO
        wBWCtxbBZ4GhFvpJDArYKNeUyrsdhUE3SnxUVszsLSdJaG0kWVSnqKq6c6mm/e3r
        63pr+z1Gp+TpfFE4+0qoWotGL2PobiuGtEg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id nAQI1tQmyBtZ for <linux-scsi@vger.kernel.org>;
        Mon, 20 Sep 2021 18:02:08 -0700 (PDT)
Received: from [10.225.163.24] (unknown [10.225.163.24])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4HD36m0vlGz1RvlH;
        Mon, 20 Sep 2021 18:02:07 -0700 (PDT)
Message-ID: <b825a66e-86ee-5763-cc0a-83f5d18f2eca@opensource.wdc.com>
Date:   Tue, 21 Sep 2021 10:02:06 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 04/84] ata: Call scsi_done() directly
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <20210918000607.450448-1-bvanassche@acm.org>
 <20210918000607.450448-5-bvanassche@acm.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20210918000607.450448-5-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/18/21 09:04, Bart Van Assche wrote:
> Conditional statements are faster than indirect calls. Hence call
> scsi_done() directly.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ata/libata-sata.c |  2 +-
>  drivers/ata/libata-scsi.c | 14 +++++++-------
>  2 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
> index 8f3ff830ab0c..60418d872c12 100644
> --- a/drivers/ata/libata-sata.c
> +++ b/drivers/ata/libata-sata.c
> @@ -1258,7 +1258,7 @@ int ata_sas_queuecmd(struct scsi_cmnd *cmd, struct ata_port *ap)
>  		rc = __ata_scsi_queuecmd(cmd, ap->link.device);
>  	else {
>  		cmd->result = (DID_BAD_TARGET << 16);
> -		cmd->scsi_done(cmd);
> +		scsi_done(cmd);
>  	}
>  	return rc;
>  }
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 1fb4611f7eeb..4afe1abc4709 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -634,7 +634,7 @@ static struct ata_queued_cmd *ata_scsi_qc_new(struct ata_device *dev,
>  	qc = ata_qc_new_init(dev, scsi_cmd_to_rq(cmd)->tag);
>  	if (qc) {
>  		qc->scsicmd = cmd;
> -		qc->scsidone = cmd->scsi_done;
> +		qc->scsidone = scsi_done;
>  
>  		qc->sg = scsi_sglist(cmd);
>  		qc->n_elem = scsi_sg_count(cmd);
> @@ -643,7 +643,7 @@ static struct ata_queued_cmd *ata_scsi_qc_new(struct ata_device *dev,
>  			qc->flags |= ATA_QCFLAG_QUIET;
>  	} else {
>  		cmd->result = (DID_OK << 16) | SAM_STAT_TASK_SET_FULL;
> -		cmd->scsi_done(cmd);
> +		scsi_done(cmd);
>  	}
>  
>  	return qc;
> @@ -1738,14 +1738,14 @@ static int ata_scsi_translate(struct ata_device *dev, struct scsi_cmnd *cmd,
>  
>  early_finish:
>  	ata_qc_free(qc);
> -	cmd->scsi_done(cmd);
> +	scsi_done(cmd);
>  	DPRINTK("EXIT - early finish (good or error)\n");
>  	return 0;
>  
>  err_did:
>  	ata_qc_free(qc);
>  	cmd->result = (DID_ERROR << 16);
> -	cmd->scsi_done(cmd);
> +	scsi_done(cmd);
>  err_mem:
>  	DPRINTK("EXIT - internal\n");
>  	return 0;
> @@ -4018,7 +4018,7 @@ int __ata_scsi_queuecmd(struct scsi_cmnd *scmd, struct ata_device *dev)
>  	DPRINTK("bad CDB len=%u, scsi_op=0x%02x, max=%u\n",
>  		scmd->cmd_len, scsi_op, dev->cdb_len);
>  	scmd->result = DID_ERROR << 16;
> -	scmd->scsi_done(scmd);
> +	scsi_done(scmd);
>  	return 0;
>  }
>  
> @@ -4060,7 +4060,7 @@ int ata_scsi_queuecmd(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
>  		rc = __ata_scsi_queuecmd(cmd, dev);
>  	else {
>  		cmd->result = (DID_BAD_TARGET << 16);
> -		cmd->scsi_done(cmd);
> +		scsi_done(cmd);
>  	}
>  
>  	spin_unlock_irqrestore(ap->lock, irq_flags);
> @@ -4188,7 +4188,7 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd)
>  		break;
>  	}
>  
> -	cmd->scsi_done(cmd);
> +	scsi_done(cmd);
>  }
>  
>  int ata_scsi_add_hosts(struct ata_host *host, struct scsi_host_template *sht)
> 

Acked-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research
