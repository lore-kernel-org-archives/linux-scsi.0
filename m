Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5492BC76196
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Mar 2023 16:37:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbjC1QhA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Mar 2023 12:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjC1Qg7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Mar 2023 12:36:59 -0400
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4422A5F5
        for <linux-scsi@vger.kernel.org>; Tue, 28 Mar 2023 09:36:11 -0700 (PDT)
Received: by mail-qt1-f179.google.com with SMTP id ga7so12493488qtb.2
        for <linux-scsi@vger.kernel.org>; Tue, 28 Mar 2023 09:36:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680021371;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qZR6cbXQdwB5nUHvEEH2VeiB5R9CC8hRiYSzmgcjAyg=;
        b=qDwSMAxu8OrdsApx4yVzTlE9HKtZ+9+KpgZ8Yzh4xfWAeXr0m9YToS49jlclVafvyU
         NdzJwi1EmbQiuCHP3a1Xeq8WBK9YzNoHryy18vnnvFwgN3FxHpWS28Nl7cVo6+xiz0qD
         xtVF5dlgTRl2v79OT6q9Cdg5oVeOiyZ0nkyRL+9vAK/pIv4yictxyrlpZN3KYnRcfhHe
         Z4UQR48CVFgtD48ktuBRr218RTltkhzUCZZLmTJ/f6Re8DlTZaC9BGhzML7L1FsTz9QW
         jCQv4l4J9IICniZKk49VUNAuxqsvXYl7gt2d8zOlgs3HE0e2TOdNcjASaNQbG67kAdX4
         ObbQ==
X-Gm-Message-State: AO0yUKUP9Q4PStCOsqIN71qKOt1/oL9nMtele9yRRl698ScBV6UlNUrD
        R5DsRefkOq9vuCWz8lVekMAW
X-Google-Smtp-Source: AK7set8/4ablYvt1w3rWWxBu5RP3Per1gtZi0bV85eHN9m6lD3okcPGkDhxHJ2UAhi56YjYdObx6pQ==
X-Received: by 2002:ac8:7d46:0:b0:3e3:95fb:8771 with SMTP id h6-20020ac87d46000000b003e395fb8771mr28046888qtb.31.1680021371021;
        Tue, 28 Mar 2023 09:36:11 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net. [68.160.166.30])
        by smtp.gmail.com with ESMTPSA id t23-20020ac865d7000000b003b635a5d56csm15765739qto.30.2023.03.28.09.36.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 09:36:10 -0700 (PDT)
Date:   Tue, 28 Mar 2023 12:36:09 -0400
From:   Mike Snitzer <snitzer@kernel.org>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org,
        Chaitanya Kulkarni <kch@nvidia.com>
Subject: Re: [PATCH v5 01/18] block: Add PR callouts for read keys and
 reservation
Message-ID: <ZCMXecSrJ97oCD+s@redhat.com>
References: <20230324181741.13908-1-michael.christie@oracle.com>
 <20230324181741.13908-2-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230324181741.13908-2-michael.christie@oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Mar 24 2023 at  2:17P -0400,
Mike Christie <michael.christie@oracle.com> wrote:

> Add callouts for reading keys and reservations. This allows LIO to support
> the READ_KEYS and READ_RESERVATION commands and will allow dm-multipath
> to optimize it's error handling so it can check if it's getting an error
> because there's an existing reservation or if we need to retry different
> paths.

Not seeing anything in DM's path selectors that adds these
optimizations. Is there accompanying multipath-tools callouts to get
at this data to optimize path selection (via DM table reloads)?

Mike
