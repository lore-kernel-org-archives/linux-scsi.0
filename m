Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3840BC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 12:53:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358567AbiAaMxn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 07:53:43 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34750 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239602AbiAaMxm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 07:53:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E81B06117F;
        Mon, 31 Jan 2022 12:53:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1CC5C340E8;
        Mon, 31 Jan 2022 12:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643633621;
        bh=eA131DsO2617F41APZiz6WWOO1bHcYQVJEx2KPUcwmw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FJ0nVKKC1NlwkcLksxeYuOlFIaYon7OaCkyD5WItmYL3wTh1NJD0bnUdnNRFwfQtY
         /uVufcjXzvhYvPdAOyqmr0mXoV4tBKQJA8X1usef+FKoLooMRgvsSn0lVtXkK7qY3c
         KuRquyoRFlYuL0MwAOvGih9IB3B2cE7+VEosJbr0=
Date:   Mon, 31 Jan 2022 13:53:38 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 40/44] scsi: usb: Stop using the SCSI pointer
Message-ID: <Yffb0sNy00eABeL6@kroah.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
 <20220128221909.8141-41-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128221909.8141-41-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jan 28, 2022 at 02:19:05PM -0800, Bart Van Assche wrote:
> Set scsi_host_template.cmd_size instead of using the SCSI pointer for
> storing driver-private data. Change the type of the argument of
> uas_add_work() from struct uas_cmd_info * into struct scsi_cmnd * because
> it is easier to convert a SCSI command pointer into a uas_cmd_info pointer
> than the other way around.
> 
> This patch prepares for removal of the SCSI pointer from struct scsi_cmnd.
> 
> Cc: Oliver Neukum <oneukum@suse.com>
> Cc: linux-usb@vger.kernel.org
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/usb/storage/uas.c | 41 +++++++++++++++++++--------------------
>  1 file changed, 20 insertions(+), 21 deletions(-)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
