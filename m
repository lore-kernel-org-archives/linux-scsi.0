Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5883BC433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Nov 2021 03:35:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbhK1Di3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Nov 2021 22:38:29 -0500
Received: from mail-pg1-f178.google.com ([209.85.215.178]:42890 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbhK1Dg1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Nov 2021 22:36:27 -0500
Received: by mail-pg1-f178.google.com with SMTP id s37so2418722pga.9
        for <linux-scsi@vger.kernel.org>; Sat, 27 Nov 2021 19:33:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=iK+nv4WRnCXzRDP0qgC/Hs5CR428/MTDPuyL8xNF4cc=;
        b=F3PqbXg+/PM/I5yFqHfgP9NrVfBLKIOzjPh2YmwyR2sZNW88OPYenBVLeA7m6vSBke
         ZtqfMzVL7KcK0eC8rKCIRyOlYBxbCjVtThUw9LW8Y8BrK7qivIO2fcyblHAKbImojXFO
         8dLg24dIyhlWNsZ89OsaAKhJ1izmpm4tfBX1DBSEIOw+liqyyJsKjrRx2HllothY0LBb
         2uOAv8cA+/sBJqxDaMVrxAaNVPdXX26feof1qcWS2/1cMdfCLYKP0TpNfQkI+H3i6TmA
         AsFwtBH11RbbxaJ3t36O6dPne+rvv+RCGGWQ+xAMRkj1I2177jewNAwWdkwh/r+q88Ur
         DzWA==
X-Gm-Message-State: AOAM532LEKAZD50pUwOKJUtCNNfGibnEqr5FbGaU4KwUlaM93PcOY/84
        W0k1ellCgdo/Hs784SatlI4=
X-Google-Smtp-Source: ABdhPJz6/5sAGOmER8jXz+EXfPBkeWdcD6yVSxQroncY+QBQRhr31pDPUmbZgLUuywBDOGayY5vEKA==
X-Received: by 2002:a65:4209:: with SMTP id c9mr28627694pgq.399.1638070392175;
        Sat, 27 Nov 2021 19:33:12 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id cv1sm14074919pjb.48.2021.11.27.19.33.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Nov 2021 19:33:11 -0800 (PST)
Message-ID: <abdf4383-23d7-d569-5aa8-92f3e3f12409@acm.org>
Date:   Sat, 27 Nov 2021 19:33:10 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 02/15] scsi: add scsi_{get,put}_internal_cmd() helper
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>
References: <20211125151048.103910-1-hare@suse.de>
 <20211125151048.103910-3-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20211125151048.103910-3-hare@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/25/21 07:10, Hannes Reinecke wrote:
> Add helper functions to allow LLDDs to allocate and free
> internal commands.

Are the changes for the SCSI timeout handler perhaps missing from this 
patch? In the UFS driver we need the ability not to trigger the SCSI 
error handler if an internal command times out.

Thanks,

Bart.
