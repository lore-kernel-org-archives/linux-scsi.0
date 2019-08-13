Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32A96C32750
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 12:45:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0266C20840
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 12:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1565700345;
	bh=Iq/q6d5EveJM9EUD3E8Rf9SvcCHMy071F099+FRroh0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=G7xNhQRJJkvWj2yJC/Vr2bF1uRzWl9e2BPwlyKQywOqdb9Igebn3VmSSworER56rF
	 fOf4jDAC0sEJLCLunc/5Hsb7QFmABLC6Tq7/XZHajTpizHktJzb2TuV7o6Lj6WwY5y
	 R3Y3ar1ign6xDWbC6frVe3fMEe65JMlnkDCLmQPM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728576AbfHMMpl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 08:45:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:52138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727837AbfHMMpk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Aug 2019 08:45:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E2F520578;
        Tue, 13 Aug 2019 12:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565700339;
        bh=Iq/q6d5EveJM9EUD3E8Rf9SvcCHMy071F099+FRroh0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NH+JQhYuZ7QImgVM06ymo9Hjam1Y9Vcl21Ti3Ch+tnd8yUuf9/+IqblrYOyK8iDsD
         1vajJN5Bxp/sxonANyJmwqjDmLFlw0imrlFG4xeG5IFYoj42MUd0DHJvyLN7DpB6PU
         m/WN66dZAyy9zR7GnHGVXIEowx5d4DG/HTU54Rg0=
Date:   Tue, 13 Aug 2019 14:45:37 +0200
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
Subject: Re: [PATCH v2 10/10] RFC: usb-storage: export symbols in USB_STORAGE
 namespace
Message-ID: <20190813124537.GB12475@kroah.com>
References: <20180716122125.175792-1-maco@android.com>
 <20190813121733.52480-1-maennich@google.com>
 <20190813121733.52480-11-maennich@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813121733.52480-11-maennich@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 13, 2019 at 01:17:07PM +0100, Matthias Maennich wrote:
> Modules using these symbols are required to explicitly import the
> namespace. This patch was generated with the following steps and serves
> as a reference to use the symbol namespace feature:
> 
>  1) Define DDEFAULT_SYMBOL_NAMESPACE in the corresponding Makefile
>  2) make  (see warnings during modpost about missing imports)
>  3) make nsdeps
> 
> Instead of a DEFAULT_SYMBOL_NAMESPACE definition, the EXPORT_SYMBOL_NS
> variants can be used to explicitly specify the namespace. The advantage
> of the method used here is that newly added symbols are automatically
> exported and existing ones are exported without touching their
> respective EXPORT_SYMBOL macro expansion.
> 
> Signed-off-by: Matthias Maennich <maennich@google.com>
> ---
>  drivers/usb/storage/Makefile        | 2 ++
>  drivers/usb/storage/alauda.c        | 1 +
>  drivers/usb/storage/cypress_atacb.c | 1 +
>  drivers/usb/storage/datafab.c       | 1 +
>  drivers/usb/storage/ene_ub6250.c    | 1 +
>  drivers/usb/storage/freecom.c       | 1 +
>  drivers/usb/storage/isd200.c        | 1 +
>  drivers/usb/storage/jumpshot.c      | 1 +
>  drivers/usb/storage/karma.c         | 1 +
>  drivers/usb/storage/onetouch.c      | 1 +
>  drivers/usb/storage/realtek_cr.c    | 1 +
>  drivers/usb/storage/sddr09.c        | 1 +
>  drivers/usb/storage/sddr55.c        | 1 +
>  drivers/usb/storage/shuttle_usbat.c | 1 +
>  drivers/usb/storage/uas.c           | 1 +
>  15 files changed, 16 insertions(+)
> 
> diff --git a/drivers/usb/storage/Makefile b/drivers/usb/storage/Makefile
> index a67ddcbb4e24..46635fa4a340 100644
> --- a/drivers/usb/storage/Makefile
> +++ b/drivers/usb/storage/Makefile
> @@ -8,6 +8,8 @@
>  
>  ccflags-y := -I $(srctree)/drivers/scsi
>  
> +ccflags-y += -DDEFAULT_SYMBOL_NAMESPACE=USB_STORAGE

Wait, we have to do this for every subsystem?  I thought there was a
macro we could use in the code itself for this.  What changed from
earlier versions, or was this always here?

thanks,

greg k-h
