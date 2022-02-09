Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42A00C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 18:33:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239196AbiBISds (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 13:33:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239015AbiBISdq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 13:33:46 -0500
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAFC6C0613C9
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 10:33:49 -0800 (PST)
Received: by mail-pf1-f169.google.com with SMTP id u16so87191pfg.3
        for <linux-scsi@vger.kernel.org>; Wed, 09 Feb 2022 10:33:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Cf+eHkyXFz8gbDKowDns4DWEkzfSjqkP4ugcRazq0QU=;
        b=TRRSask/2sHOyUuBmhB2fBhBDGzRZ8PiKLsj1MgDeFfkphQhkIBo/wHpKRfltT49LA
         y1Oa2SQz35OB04Tqx3oQhEfVaudo/TgDlch7xC/HUuswzpFq1wg9ozHkTfQjzNcFaeUK
         iuxZDNvfiRA4VsmGSmWG1IqfGU2YgbybL5nK0sas75cEM6cKce5/Ps/TTFGq7xzQYinB
         LiaufMFBCnkgTME210UB3Jy30MDJTl0fSjABsxRnR8oECY/a3Gq/EyzYwy8foP169qMA
         Iz83rV0n8fmMR57mNnk450mr3bldM35nGh2WZB8nAcAGrtcPl+Zb7EYWBp/cClzTldKR
         g6dA==
X-Gm-Message-State: AOAM532er4XIWwFN6UGsex0Nd7qSkuF7kQPepsNL3lsCZhmFQBJ5uGqo
        38A9uuAJWUHjCAK/flu6HPU=
X-Google-Smtp-Source: ABdhPJyHPbNBEYH+MEXDyLwvmL8irzm/Z/KKBu+Pa+5musRHNCWfxb+duO0WNiB5gKQfDt8eORYT1g==
X-Received: by 2002:a05:6a00:1c77:: with SMTP id s55mr3572927pfw.3.1644431629318;
        Wed, 09 Feb 2022 10:33:49 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id r12sm14700342pgn.6.2022.02.09.10.33.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 10:33:48 -0800 (PST)
Message-ID: <31246489-b949-bb05-e8a9-6053ce72d9a4@acm.org>
Date:   Wed, 9 Feb 2022 10:33:47 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v2 24/44] libfc: Stop using the SCSI pointer
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-25-bvanassche@acm.org>
 <dae3f6d8-efc4-b295-351c-e9a0a8e46138@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <dae3f6d8-efc4-b295-351c-e9a0a8e46138@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/9/22 00:10, Hannes Reinecke wrote:
> On 2/8/22 18:24, Bart Van Assche wrote:
>> +struct bnx2fc_priv {
>> +    struct libfc_cmd_priv libfc_data; /* must be the first member */
>> +    struct bnx2fc_cmd *io_req;
>> +};
> I am not sure this is correct.
> 
> Both, libfc and the fcoe drivers do use SCp.ptr, but from what I can see 
> each in different ways.
> So I'm not sure that we need to stack the private data; we never did 
> that previously.
> Some more careful audit is required to separate out the usage here.

My understanding is that the bnx2fc driver works as follows:
- libfc and libfcoe are used for the slow path. These libraries use the 
'fsp' member of struct libfc_cmd_priv (formerly CMD_SP(scsi_cmd)).
- bnx2fc_priv.io_req is only used for the fast path (hardware offloading).

I think it is safe to use different pointer members for the slow path 
and the fast path. Although this change is not essential, this allows to 
remove several pointer type casts from the bnx2fc driver.

Thanks,

Bart.
