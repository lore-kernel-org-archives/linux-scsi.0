Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1523C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 06:25:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82EC9611CB
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 06:25:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbhKDG2I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Nov 2021 02:28:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:50584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230084AbhKDG2H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 4 Nov 2021 02:28:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A97E611C9;
        Thu,  4 Nov 2021 06:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636007130;
        bh=Wrb1NEAkG/87PNEOfNe7egV2xOVnLOO55nNFd2hpx/Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nzyfVa82gJNgOeRZLYfaBB4Fjp/UEsAbeSiwfq67Qr8V4daGq2yOqd1qm8uKqXSph
         XI4bYgEChXSd5ynbyYtQf6iCkI/6K+W5IGQMpyC1/NK7wmD/JXxLcKpa8EMpsJwSEl
         ReafO7eopoTmQrIq4OqxQug9HUk2kIJdWeBvrhNM=
Date:   Thu, 4 Nov 2021 07:25:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     George Kennedy <george.kennedy@oracle.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com
Subject: Re: [PATCH] scsi: scsi_debug: fix return checks for kcalloc
Message-ID: <YYN81hZyBZ2dU3Wu@kroah.com>
References: <1635966102-29320-1-git-send-email-george.kennedy@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1635966102-29320-1-git-send-email-george.kennedy@oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 03, 2021 at 02:01:42PM -0500, George Kennedy wrote:
> Change return checks from kcalloc() to now check for NULL and
> ZERO_SIZE_PTR using the ZERO_OR_NULL_PTR macro or the following
> crash can occur if ZERO_SIZE_PTR indicator is returned.

That seems really broken in the api, why is kcalloc() returning
ZERO_SIZE_PTR?

Please fix that, otherwise you need to fix all callers in the kernel
tree.

thanks,

greg k-h
