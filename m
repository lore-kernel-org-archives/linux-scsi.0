Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F4C2C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 16:29:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8EBD61261
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 16:29:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238127AbhERQah (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 12:30:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:32954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235595AbhERQag (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 May 2021 12:30:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AE1C61209;
        Tue, 18 May 2021 16:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621355357;
        bh=ze91BynnfABXx7sx8dZETlu6cHgdcooShAfKV+ve/Sw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nB5aEXLEYkZBjO8QG+xLkqPzUg+ir6VM3CdFUcL/UjEKspwWlee4CdUHhmEUIFE6t
         pdK61puYRRcrXTi/aWPR3VPdVthM8VvQKHSli2uaTxak8rbVBcPUbnGKzmfFOkabet
         euSuoI2GbzvgvU/DOtj49cKV05jz5pTYsorecUO0=
Date:   Tue, 18 May 2021 18:29:15 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com
Cc:     Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: snic: debugfs: remove local storage of debugfs
 files
Message-ID: <YKPrW1rdDE7GgjOm@kroah.com>
References: <20210518161625.3696996-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210518161625.3696996-1-gregkh@linuxfoundation.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, May 18, 2021 at 06:16:25PM +0200, Greg Kroah-Hartman wrote:
> There is no need to keep the dentry around for the debugfs trace files,
> as we can just look it up when we want to remove it later on.  Simplify
> the structure by removing the dentries and relying on debugfs to find
> the dentry to remove when we want to.
> 
> By doing this change, we remove the last in-kernel user that was storing
> the result of debugfs_create_bool(), so that api can be cleaned up.
> 
> Cc: Karan Tilak Kumar <kartilak@cisco.com>
> Cc: Sesidhar Baddela <sebaddel@cisco.com>
> Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/scsi/snic/snic_debugfs.c | 23 +++++++++--------------
>  drivers/scsi/snic/snic_trc.h     |  3 ---
>  2 files changed, 9 insertions(+), 17 deletions(-)

I can take this through my debugfs tree so I can clean up the
debugfs_create_bool() api if no one objects.

thanks,

greg k-h
