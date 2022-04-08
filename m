Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52FE7C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 14:55:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237210AbiDHO5q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 10:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234894AbiDHO5o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 10:57:44 -0400
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5CA6640D
        for <linux-scsi@vger.kernel.org>; Fri,  8 Apr 2022 07:55:39 -0700 (PDT)
Received: by mail-pg1-f181.google.com with SMTP id r66so7999101pgr.3
        for <linux-scsi@vger.kernel.org>; Fri, 08 Apr 2022 07:55:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NH509X6GhcPmX4Tr55p31LAnmUFJMEZCzUH+OxEQKyI=;
        b=Yx5ra25UeuRNDKLpDZ6n39YR1+pa026bucq4MrEVy/2ndRV8PBRft8mmZUOyX4whha
         FIGQQQykS/aXTSprs8goiNbNdrimA8SnflZ0bs2dAqk2k51wK+Z5FIUAozYHVJLI2+UF
         WyG2TDZ+5Wshr2ienxIbyLYc2XgChuOiREuev5Hgs6apT9RhjbB3TPPzLoe9maUx6m8Q
         X46O0DgDpCPPHWXsMFXktsY8Ae/TkoHQvaUaEpIVTaUv95kh9SQ3URw31rX6O4U4W9qd
         vWyQC665c3iDow2tNWpMIybPHD2UtapaizamOV/JJOB4Y3UzkfkWS5RBY5/7O9bGiG2P
         Lirw==
X-Gm-Message-State: AOAM530PGbo/S0VAnMdGOFL8zm8kPMfd1uDpp3eLxcXwETswDxg2cS43
        WTMbBMtUjXSqgK94GKMGk5s=
X-Google-Smtp-Source: ABdhPJyiZD5lUofOTyY08Ez0yuXZ/Ulh7HlHYtRZQfBduyZLYNwVJnbno4qxGwGlqYOhpILQMDZbEg==
X-Received: by 2002:a63:6c8a:0:b0:398:5208:220a with SMTP id h132-20020a636c8a000000b003985208220amr15907136pgc.176.1649429739185;
        Fri, 08 Apr 2022 07:55:39 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id s16-20020a056a001c5000b00505688553e1sm5800482pfw.57.2022.04.08.07.55.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Apr 2022 07:55:38 -0700 (PDT)
Message-ID: <78f9dc98-cca8-6ba2-9146-082f95c8d5ab@acm.org>
Date:   Fri, 8 Apr 2022 07:55:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 1/6] scsi_cmnd: reinstate support for cmd_len > 32
Content-Language: en-US
To:     Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        hch@lst.de
References: <20220408035651.6472-1-dgilbert@interlog.com>
 <20220408035651.6472-2-dgilbert@interlog.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220408035651.6472-2-dgilbert@interlog.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/7/22 20:56, Douglas Gilbert wrote:
>   static int scsi_eh_tur(struct scsi_cmnd *scmd)
>   {
> -	static unsigned char tur_command[6] = {TEST_UNIT_READY, 0, 0, 0, 0, 0};
> +	static const u8 tur_command[6] = {TEST_UNIT_READY, 0, 0, 0, 0, 0};
>   	int retry_cnt = 1;
>   	enum scsi_disposition rtn;
>   
>   retry_tur:
> -	rtn = scsi_send_eh_cmnd(scmd, tur_command, 6,
> -				scmd->device->eh_timeout, 0);
> +	rtn = scsi_send_eh_cmnd(scmd, (u8 *)tur_command, 6, scmd->device->eh_timeout, 0);

Does the cast in the above function call cast away constness? There must 
be a better solution than casting away constness.

> -bool scsi_cmd_allowed(unsigned char *cmd, fmode_t mode)
> +bool scsi_cmd_allowed(/* const */ unsigned char *cmd, fmode_t mode)
>   {

Why has 'const' been commented out?

> @@ -1460,6 +1462,7 @@ static void scsi_complete(struct request *rq)
>   static int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
>   {
>   	struct Scsi_Host *host = cmd->device->host;
> +	u8 *cdb = (u8 *)scsi_cmnd_get_cdb(cmd);
>   	int rtn = 0;

Casting away constness is ugly. Consider providing two versions of 
scsi_cmnd_get_cdb(): one version that accepts a const pointer and 
returns a const pointer and another version that accepts a non-const 
pointer and returns a non-const pointer. Maybe _Generic() or 
__same_type() can be used to combine both versions into a single macro?

> +/* This value is used to size a C array, see below if cdb length > 32 */
> +#define SCSI_MAX_COMPILE_TIME_CDB_LEN 32

Since CDBs longer than 16 bytes are rare, how about using 16 as the 
maximum compile-time CDB size?

Thanks,

Bart.
