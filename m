Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B71D7C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 18:22:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350784AbiDLSYb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 14:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349236AbiDLSYZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 14:24:25 -0400
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DEAD5D64B
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:22:07 -0700 (PDT)
Received: by mail-pj1-f42.google.com with SMTP id md4so10965699pjb.4
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:22:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xjbtb04X5/DtSEYh7gcD/eedsjhU/N04s1DTBZ+XXlU=;
        b=YbDS1GCFfVzy4024wZcERuhIleCjwJTgJOIMRpl5kXopslqErS+OdkbmJ4D7R6EJoe
         nDLXZb3mowT8QPSoA9L5x29DzA8zZYXTXhIi5u4I3iYJzh4C7xeyDcpBsXleQHeTiqkx
         K5snzgr+GFrtpcLbtw7qsAq+rgJNs0ACJM6KimQtFOS5XLODGGko5G6jm+M3FQJu/Drm
         hNpnB5foePWFBjmXRV8s9ItNGfjkwLTcS0hBaaITgrhF6492gqmvGQ+fGc+ePDFH/H9/
         IXLXDyPt8z6w/NE+tt06HNk3nfZVC8mb7505kT7Sxjbj4yRhfW0XEiAyArnSGwbQash4
         B7ew==
X-Gm-Message-State: AOAM531PwvovBrtFRZclq3x88kSw8aAw1wGEhWKoz3/WziSkOCERwTpj
        C9LyOTHsyDI96xCzBRmWI4U=
X-Google-Smtp-Source: ABdhPJx1YyR92Pc6OW1LlHVTyGqdCdNPcN/EUPkX5EipuOeR7np2WxVla9K/tAYgpWEhGCPrH+j+Rg==
X-Received: by 2002:a17:90b:1c8b:b0:1ca:1ff6:607b with SMTP id oo11-20020a17090b1c8b00b001ca1ff6607bmr6399023pjb.244.1649787726792;
        Tue, 12 Apr 2022 11:22:06 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:d4b2:56ee:d001:c159? ([2620:15c:211:201:d4b2:56ee:d001:c159])
        by smtp.gmail.com with ESMTPSA id b25-20020a637159000000b00381fda49d15sm3625409pgn.39.2022.04.12.11.22.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 11:22:06 -0700 (PDT)
Message-ID: <16ccd860-1b07-512b-63c1-46433160b008@acm.org>
Date:   Tue, 12 Apr 2022 11:22:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] Revert "scsi: scsi_debug: Address races following module
 load"
Content-Language: en-US
To:     Luis Chamberlain <mcgrof@kernel.org>,
        Douglas Gilbert <dgilbert@interlog.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Yi Zhang <yi.zhang@redhat.com>,
        Bob Pearson <rpearsonhpe@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220409043704.28573-1-bvanassche@acm.org>
 <5fb68dbd-ae0e-6230-8f9f-dd6df5593584@interlog.com>
 <YlW8ZrL65ZKpQZ+j@bombadil.infradead.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <YlW8ZrL65ZKpQZ+j@bombadil.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/12/22 10:52, Luis Chamberlain wrote:
> Upstream patient module removal inside kmod will help and is the right
> thing to do all around. However modules can also strive to make the
> removal painless too. How much work a module does to make it painless is
> up to its authors. In lieu of kmod patient module removal, users of the
> module should be aware of these issue though and open code it as I have
> in fstests [0] as an example.

If a new version of patch "Address races following module load" is posted I
will help with reviewing it.

Thanks,

Bart.
