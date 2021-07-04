Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34703C07E95
	for <linux-scsi@archiver.kernel.org>; Sun,  4 Jul 2021 23:52:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14172613D8
	for <linux-scsi@archiver.kernel.org>; Sun,  4 Jul 2021 23:52:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbhGDXys (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 4 Jul 2021 19:54:48 -0400
Received: from mail-pf1-f170.google.com ([209.85.210.170]:35680 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbhGDXys (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Jul 2021 19:54:48 -0400
Received: by mail-pf1-f170.google.com with SMTP id d12so15187286pfj.2
        for <linux-scsi@vger.kernel.org>; Sun, 04 Jul 2021 16:52:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NxNH0kxML0Dkl/1cZmmPZ61GxtNAUf5BhrnxufZsodw=;
        b=f8Sy/X3uQQYimWtnYX+brwV18Ao2rgPmFk6WCij4I6bmUNPjTsaggJDl0yMadZP6zp
         sb+VBrs8lt+PqSxpuUCPFhT2ZW5BpXTDz0YkTRKJGH/dpt93OXuOpO7mb0PPHUmzvjHT
         CgAmIPD63KhojRajNmL5lLDHKZzaIuKfRpd+aU0j9irYt6Ir79bcMfGnqboMw0M+Dyxs
         S8Z2Sflw9vLol0nzSsOtyVcyZKTVVBCTkWn4rY9/2X1YFoDanVA2tlzBwK75YQ+64dQ3
         CYjCWNPO+JbfgL4DzaCymRO0PzOk0uWlC/OdXPQEffkOPywlo3hFbWoPovn7XSXbzeiZ
         0hPQ==
X-Gm-Message-State: AOAM5327NF9D7QhU4NTMSkc7r3aciS0qzSzdstw0RcyX0IjJRbJpcRE5
        Uad5uAoESPWpuOfwFi7VVTg=
X-Google-Smtp-Source: ABdhPJzY0ZR677LsCqiEC7MPR2Y32i2u1MwDDcnInBQwlSE90/NZR4m6Qe4fWUSll8GdrwiTt6viOw==
X-Received: by 2002:a63:d60b:: with SMTP id q11mr12433765pgg.270.1625442731757;
        Sun, 04 Jul 2021 16:52:11 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:5a94:252a:6c7b:1c5a? ([2601:647:4000:d7:5a94:252a:6c7b:1c5a])
        by smtp.gmail.com with ESMTPSA id o16sm5326980pjw.51.2021.07.04.16.52.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Jul 2021 16:52:11 -0700 (PDT)
Subject: Re: [PATCH 02/21] libsas: Only abort commands from inside the error
 handler
To:     Jason Yan <yanaijie@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>,
        Yves-Alexis Perez <corsac@debian.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Yufen Yu <yuyufen@huawei.com>
References: <20210701211224.17070-1-bvanassche@acm.org>
 <20210701211224.17070-3-bvanassche@acm.org>
 <779caa02-6c9f-183b-2f3d-2b7dc5c877ef@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <97cd426c-e421-0912-311c-930b277cdb22@acm.org>
Date:   Sun, 4 Jul 2021 16:52:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <779caa02-6c9f-183b-2f3d-2b7dc5c877ef@huawei.com>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/2/21 7:32 PM, Jason Yan wrote:
> No idea why sas_eh_abort_handler() is only used by isci. The other
> libsas drivers just let the error handler do the aborting work. So my
> question is can the isci driver delete this callback and let the error
> handler do this? If so, then we cann remove this function directly.

Hmm ... I think that's a question for an isci expert. Unfortunately I'm
not familiar with the isci driver myself.

Thanks,

Bart.
