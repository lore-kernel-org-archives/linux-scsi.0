Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90723C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 06:26:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71B1B61052
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 06:26:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234277AbhG2G0R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Jul 2021 02:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234135AbhG2G0Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jul 2021 02:26:16 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE8C3C061757
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jul 2021 23:26:12 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id b11so63925wrx.6
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jul 2021 23:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=RM/mVolK9Y7981fMfvXztEQGEYWsgqxiD3DSw0/oAu4=;
        b=uqb/DMlUZCRqsDoV8QfesY6gcZgEZ9Hy7U4nezt/6QB2jWpCiofNIh5sRhoeptkG85
         9eNZeYxvEIX4Q4HYz32+4tAsQaiG0JL0n3N8NgdDyIunHea+fsVj97nYgrYiKHYkhtHT
         OzfntfGZcBAg2calwUQS22EKbL+XHbSL5s7NWGhka0H1/tY0G8grbPfKU6BDuzj8XuSy
         lCMNMQDTD1bipbhGohzZDdLEUHoLPl+UefPcAHMhKeQnUi4GU2mrW9xbNBLlxtsqnrwZ
         oTK+5TJqmLylle0zp0Ef8hF0MnwyAeesac3FU1DYu77jGtwGIzHj6oAa15UfYkjj8PmS
         zt4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=RM/mVolK9Y7981fMfvXztEQGEYWsgqxiD3DSw0/oAu4=;
        b=ShrTW/C12lQ+0sdUfzgDtIl/WwVUmwwJ5T7KoOq0N20y44ohNkaywDl19wWtpu9hOn
         pkk7l34leQUVhsO7by9zW3nmCKSbFM1iWae045g+NxqyU1ZeKjN6IXwumNgAZZJhWttV
         le9gKJI4M3rC+P/2izEK480NxfGsRoN9kVv9i7zqCP/pkiVQ/99F8MnkMVBfJZzxbQ84
         pLlqifRcLZ1O7lmhEP4NzLoHGI2oP65WHQM6e/gZ0HwDvPWyI6npsFRIi4zr+LKKKRT0
         Rzl0vODh7VwR5cX2qoXGJbZZ06kfh/1JOg91jUXLu6q4RWIIgqy4XokHjZZ4U3gcsoBB
         YNOA==
X-Gm-Message-State: AOAM531x79p8s4b1GjRh5YgYc5B8bynmlkIjPeR/rhuMtXt1eIStHpVO
        jMKTdd/XgYK66civeTc6Lp4=
X-Google-Smtp-Source: ABdhPJwmqvtX2VqcYtdd+K8L2trTEFlO0XYsJa5ke2+/Qnxm/CGRKIBQd4M6ao9RwupZqTvJG3YMjQ==
X-Received: by 2002:adf:cd86:: with SMTP id q6mr2897187wrj.422.1627539971447;
        Wed, 28 Jul 2021 23:26:11 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bfdd7.dynamic.kabel-deutschland.de. [95.91.253.215])
        by smtp.googlemail.com with ESMTPSA id k6sm2111197wrm.10.2021.07.28.23.26.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 23:26:11 -0700 (PDT)
Message-ID: <3ac08e062b160befd183e0348b53aaabcc84402d.camel@gmail.com>
Subject: Re: [PATCH 1/3] scsi: ufs: Remove redundant define
From:   Bean Huo <huobean@gmail.com>
To:     Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
Date:   Thu, 29 Jul 2021 08:26:07 +0200
In-Reply-To: <20210727123546.17228-2-avri.altman@wdc.com>
References: <20210727123546.17228-1-avri.altman@wdc.com>
         <20210727123546.17228-2-avri.altman@wdc.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-07-27 at 15:35 +0300, Avri Altman wrote:
> UFS_UPIU_RPMB_WLUN already describe the rpmb wlun index.
> 
> 
> 
> Signed-off-by: Avri Altman <avri.altman@wdc.com>

Reviewed-by: Bean Huo <beanhuo@micron.com>

