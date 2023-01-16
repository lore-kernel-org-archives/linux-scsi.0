Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 787E1C678D7
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Jan 2023 14:54:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232605AbjAPOxd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Jan 2023 09:53:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjAPOwg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jan 2023 09:52:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6631323D87;
        Mon, 16 Jan 2023 06:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F9FDB80F4B;
        Mon, 16 Jan 2023 14:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 427F2C433D2;
        Mon, 16 Jan 2023 14:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673880009;
        bh=Zewr+BXSd1xtUfsVvelEr4+dgC5KA8R63s8FHwFEuQM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Su+jH/rs/rf/nSmhuq98WLmrdufhiZETt7JFu0Hu5BzrrjbSIsif0no/LoC46pfNC
         SF0VUA9Q7324WHsgmuzGPxE79ySpJQxjRIla2w+4s9BmL2CfzDNYlluSKSVFq6xqvb
         YY8KemrvGRHDntfHchJcF4bKNDyQjtKa59Cd47ew=
Date:   Mon, 16 Jan 2023 15:40:07 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev,
        Christoph Hellwig <hch@lst.de>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Pittman <jpittman@redhat.com>, linux-scsi@vger.kernel.org,
        it+linux-scsi@molgen.mpg.de
Subject: Re: [5.15] Backport commit 0c25422d34b4 (scsi: mpt3sas: Remove
 scsi_dma_map() error messages)
Message-ID: <Y8Vhx6XekU6ka3UZ@kroah.com>
References: <693e9047-f52a-b426-616a-6157505e5165@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <693e9047-f52a-b426-616a-6157505e5165@molgen.mpg.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jan 16, 2023 at 03:23:46PM +0100, Paul Menzel wrote:
> Dear Linux folks,
> 
> 
> Could you please apply commit 0c25422d34b4 (scsi: mpt3sas: Remove
> scsi_dma_map() error messages) to the 5.15.y series?
> 
> commit 0c25422d34b4726b2707d5f38560943155a91b80
> Author: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> Date:   Thu Mar 3 19:32:03 2022 +0530
> 
>     scsi: mpt3sas: Remove scsi_dma_map() error messages
> 
>     When scsi_dma_map() fails by returning a sges_left value less than zero,
>     the amount of logging produced can be extremely high.  In a recent
> end-user
>     environment, 1200 messages per second were being sent to the log buffer.
>     This eventually overwhelmed the system and it stalled.
> 
>     These error messages are not needed. Remove them.
> 
>     Link:
> https://lore.kernel.org/r/20220303140203.12642-1-sreekanth.reddy@broadcom.com
>     Suggested-by: Christoph Hellwig <hch@lst.de>
>     Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
>     Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> 
> We see this regression after upgrading from Linux 5.10 to 5.15 on our file
> servers with Broadcom/LSI SAS3008 PCI-Express Fusion-MPT SAS-3 (mpt3sas) –
> though luckily our systems do not stall/crash.
> 
> The commit message does not say anything about, what commit caused these
> error to be appearing – the log statements have been there since v4.20-rc1,
> if I am not mistaken, so it must be something else –, and also do not
> mention, why these log messages are not needed, but the new error condition
> is actually expected.

Now queued up, thanks.

greg k-h
