Return-Path: <SRS0=edO9=4X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F20FCC10DCE
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Mar 2020 22:52:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7AA7206E6
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Mar 2020 22:52:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=octiron.net header.i=@octiron.net header.b="r/7G9/sE";
	dkim=pass (2048-bit key) header.d=octiron.net header.i=@octiron.net header.b="r/7G9/sE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgCFWwR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Mar 2020 17:52:17 -0500
Received: from chalk.uuid.uk ([51.68.227.198]:35576 "EHLO chalk.uuid.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726185AbgCFWwR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 6 Mar 2020 17:52:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=octiron.net
        ; s=20180214; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:References:Cc:To:Subject:From;
        bh=rEvCkqukeIX0hyLei79ZYd+BK6bE20qe0Fox/V+xcf8=; b=r/7G9/sEVj9J6GRLPhCAKReTh1
        K2WXCCHgxTdYHwONWEf0/e4Ckf2mZf2DGxZLzWg6cUoP4XEiFoSEzVpHeVHc6/q9aAvWYChAwF2mf
        ITeFRDGIJgQMTlLTy929L2RX8BCyQCXTQiuWwHsILO2uCGAAbzXZfdSkmpji81wAnhz+NiWakDXc6
        Zd+78h1DxO0L5d7eN6YC2sbkk7Jh9u2PjvmuWsdN+HsXN/K+nS2gngEHABxVPVaCvNUZPiFEamWOH
        E9Uvvcxq9FNwUFGYs1cPCuhSwF9COaRJk/fensIUkSw+BJBQv4qYKF6XWauAtkbQVF5hWPQVBB1Bx
        yOEhWZUw==;
Received: by chalk.uuid.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <simon@octiron.net>)
        id 1jALgP-0003Sq-ES; Fri, 06 Mar 2020 22:43:06 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=octiron.net
        ; s=20180214; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:References:Cc:To:Subject:From;
        bh=rEvCkqukeIX0hyLei79ZYd+BK6bE20qe0Fox/V+xcf8=; b=r/7G9/sEVj9J6GRLPhCAKReTh1
        K2WXCCHgxTdYHwONWEf0/e4Ckf2mZf2DGxZLzWg6cUoP4XEiFoSEzVpHeVHc6/q9aAvWYChAwF2mf
        ITeFRDGIJgQMTlLTy929L2RX8BCyQCXTQiuWwHsILO2uCGAAbzXZfdSkmpji81wAnhz+NiWakDXc6
        Zd+78h1DxO0L5d7eN6YC2sbkk7Jh9u2PjvmuWsdN+HsXN/K+nS2gngEHABxVPVaCvNUZPiFEamWOH
        E9Uvvcxq9FNwUFGYs1cPCuhSwF9COaRJk/fensIUkSw+BJBQv4qYKF6XWauAtkbQVF5hWPQVBB1Bx
        yOEhWZUw==;
Received: by tsort.uuid.uk with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <simon@octiron.net>)
        id 1jALgN-0008WB-Uq; Fri, 06 Mar 2020 22:43:04 +0000
From:   Simon Arlott <simon@octiron.net>
Subject: Re: [PATCH v2] scsi: sr: get rid of sr global mutex
To:     "Merlijn B.W. Wajer" <merlijn@archive.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <jens.axboe@oracle.com>,
        James Bottomley <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Christoph Hellwig <hch@infradead.org>
References: <9d50ecd4-9fd1-6865-5509-a5ef119828df () archive ! org>
Message-ID: <8df4a060-0576-ebeb-f3f4-cc35fcbef3e2@0882a8b5-c6c3-11e9-b005-00805fc181fe>
Date:   Fri, 6 Mar 2020 22:43:02 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <9d50ecd4-9fd1-6865-5509-a5ef119828df () archive ! org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 24/02/2020 21:20, Merlijn B.W. Wajer wrote:
> Just wanted to check if you planned to apply this v2 (you tried to apply
> v1 but it didn't compile, so I rebased it onto 5.7/scsi-queue as you
> requested). Please let me know if there's anything you'd like to see
> changed.

There's a missing call to mutex_destroy(&cd->lock) in sr_probe() if
there are any failures after calling mutex_init(&cd->lock).

> On 18/02/2020 20:21, Merlijn B.W. Wajer wrote:
>> Perhaps I or someone else can work on removing the usage of the locks,
>> but as it stands I think this addresses the performance issue present in
>> the current kernel, and removing locks and the associated testing
>> required with that is something I am not entirely comfortable doing.

I have a patch to move the locks into the cdrom driver and I've got
multiple PATA drives to test it with.

-- 
Simon Arlott
