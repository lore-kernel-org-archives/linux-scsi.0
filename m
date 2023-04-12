Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E9E6C7619A
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Apr 2023 16:34:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjDLQeW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Apr 2023 12:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjDLQeV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Apr 2023 12:34:21 -0400
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 699B59C
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2023 09:34:20 -0700 (PDT)
Received: by mail-pl1-f181.google.com with SMTP id n14so37084150plc.8
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2023 09:34:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681317260; x=1683909260;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0kuX9ghFwn+9vsXN9PFGDUnwPFN5ulaaY6hCJ60HPw0=;
        b=AQZ1ncbg+PgWXihBDhR0eZQoCCLw1BC7JolQJgiCVTMGXKw+Eta+Jo8YYkVJkPblde
         z2wiFAqK8gePuKc9eNEdwjCLKBPd6Sf6Q80LKbc7TpR8gEoPsCoaNSiO6zXh9jBkd3Ty
         FnB1a7yFE1rjluU+TDGWyuYqlUtDJvL7fAjz9HiDOAGSGX65lh9xEt+S+KLrylCcdLGb
         WHuaILQJPY1zV/9tAxb4PdPYi8tc0vK+91L2nCcieiKKEyTOXo5zL46+Ex4qgIni+k0a
         UpD7OsZyP2pzNN0d7bd9YWKU47QgK6oV4g9Uo7WZXuCoNALeBStAqdxGkaGeG2D6H/6J
         RDaA==
X-Gm-Message-State: AAQBX9fvWYhppObJdPpy4X0GmVskP5rQfJVfQRHVk27sDxO4HjfGmiaH
        V8InfDPBAP9vI/xqU5T7uxs=
X-Google-Smtp-Source: AKy350a3HU37lkxbQrzJ2jEf/GGy++XRLld6rYrxubcSuN0tiTV56IEJNcdoiT1r8tfcZG/iDTpDIw==
X-Received: by 2002:a17:902:cf52:b0:1a6:5263:47f2 with SMTP id e18-20020a170902cf5200b001a6526347f2mr8141731plg.65.1681317259604;
        Wed, 12 Apr 2023 09:34:19 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:d89d:35dd:5938:1993? ([2620:15c:211:201:d89d:35dd:5938:1993])
        by smtp.gmail.com with ESMTPSA id s7-20020a170902988700b0019f1027f88bsm11743834plp.307.2023.04.12.09.34.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Apr 2023 09:34:19 -0700 (PDT)
Message-ID: <ce0794e1-45d5-c76a-9835-7285353e786c@acm.org>
Date:   Wed, 12 Apr 2023 09:34:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] scsi: ufs: Increase the START STOP UNIT timeout from 1 s
 to 10 s
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20230411001132.1239225-1-bvanassche@acm.org>
 <17217146-9c07-3963-fd32-02704632330d@intel.com>
 <0c8b4904-31f4-d21a-7554-6525a264293b@acm.org>
 <a71dc651-a306-eebe-968e-0d9e56f44a76@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <a71dc651-a306-eebe-968e-0d9e56f44a76@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/11/23 11:31, Adrian Hunter wrote:
> It would be better not to assume current stable trees are the only
> consumers of fixes.  Presumably adding the extra Fixes tag does no
> harm.

Hi Adrian,

The convention is to add a reference to the most recent patch that got 
fixed in the patch description. Anyone who backports fixes is assumed to 
follow the chain of patches transitively that is created by Fixes: tags.

Thanks,

Bart.


