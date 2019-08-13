Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20A4FC32750
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 12:43:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD8132085A
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 12:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1565700187;
	bh=VXKk41Wt478iNXMKBAO+rPvFh8uyaEaq4alpvMMP20o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=FlUbdl3fcmx8o7j0R1lvgVskIw/Zk/YFd2J4S+YJf9Nmrg8jxmoqPLVk1O9x7D8hZ
	 io5u1rnredLCHOsOUJYmr4cxVUTWdmsQuChq2gha/WB6WQhqt1fAkhLy6ZmExF+7u6
	 zxrxoFDXWWqarB3e+i/26uCmLQ3Gp9akufVBidDg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728384AbfHMMnC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 08:43:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:50908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728327AbfHMMnC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Aug 2019 08:43:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0B2120578;
        Tue, 13 Aug 2019 12:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565700181;
        bh=VXKk41Wt478iNXMKBAO+rPvFh8uyaEaq4alpvMMP20o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IyOUegnCHWbh8RCFC75gcic4L8wPxpBirABdegJnRLEJX4C7tQucNYndyztZSP724
         UYModhg9f7I2RkRlKcvd6mchu86mbMqfnhNWx9TxSBwCt8vQbxL9deEgwDLR+2RsNq
         0wVXO+RVmE+jrghw9+cu0r+0pIKiccAiCRhkzOCc=
Date:   Tue, 13 Aug 2019 14:42:59 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Matthias Maennich <maennich@google.com>
Cc:     linux-kernel@vger.kernel.org, maco@android.com,
        kernel-team@android.com, arnd@arndb.de, geert@linux-m68k.org,
        hpa@zytor.com, jeyu@kernel.org, joel@joelfernandes.org,
        kstewart@linuxfoundation.org, linux-arch@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        linux-modules@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-usb@vger.kernel.org, lucas.de.marchi@gmail.com,
        maco@google.com, michal.lkml@markovi.net, mingo@redhat.com,
        oneukum@suse.com, pombredanne@nexb.com, sam@ravnborg.org,
        sboyd@codeaurora.org, sspatil@google.com,
        stern@rowland.harvard.edu, tglx@linutronix.de,
        usb-storage@lists.one-eyed-alien.net, x86@kernel.org,
        yamada.masahiro@socionext.com
Subject: Re: [PATCH v2 09/10] usb-storage: remove single-use define for
 debugging
Message-ID: <20190813124259.GC14284@kroah.com>
References: <20180716122125.175792-1-maco@android.com>
 <20190813121733.52480-1-maennich@google.com>
 <20190813121733.52480-10-maennich@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813121733.52480-10-maennich@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 13, 2019 at 01:17:06PM +0100, Matthias Maennich wrote:
> USB_STORAGE was defined as "usb-storage: " and used in a single location
> as argument to printk. In order to be able to use the name
> 'USB_STORAGE', drop the definition and use the string directly for the
> printk call.
> 
> Signed-off-by: Matthias Maennich <maennich@google.com>
> ---
>  drivers/usb/storage/debug.h    | 2 --
>  drivers/usb/storage/scsiglue.c | 2 +-
>  2 files changed, 1 insertion(+), 3 deletions(-)

I'll go take this today.  The module really should just be using
dev_err() there.  It needs to be cleaned up :(

thanks,

greg k-h
