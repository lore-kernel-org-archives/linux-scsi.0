From: Chaitra Basappa <chaitra.basappa@avagotech.com>
Subject: RE: [PATCH-v2 1/2] mpt3sas: Refcount sas_device objects and fix
 unsafe list usage
Date: Wed, 9 Sep 2015 19:59:14 +0530
Message-ID: <e0bde29b9384f924b2868cd81b7b1c8d@mail.gmail.com>
References: <1440921279-9973-1-git-send-email-nab@daterainc.com>
	<1440921279-9973-2-git-send-email-nab@daterainc.com> <CAK=zhgrTpxiiEbHCvLL09EhyLq+xAdteMU1Gzd3jPg9UGo=BDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yk0-f176.google.com ([209.85.160.176]:35807 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915AbbIIO3v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Sep 2015 10:29:51 -0400
Received: by ykdu9 with SMTP id u9so17815790ykd.2
        for <linux-scsi@vger.kernel.org>; Wed, 09 Sep 2015 07:29:50 -0700 (PDT)
In-Reply-To: <CAK=zhgrTpxiiEbHCvLL09EhyLq+xAdteMU1Gzd3jPg9UGo=BDA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>, "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Calvin Owens <calvinowens@fb.com>, Christoph Hellwig <hch@infradead.org>, PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@avagotech.com>, kernel-team <kernel-team@fb.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Sreekanth Reddy [mailto:sreekanth.reddy@avagotech.com]
Sent: Tuesday, September 08, 2015 5:26 PM
To: Nicholas A. Bellinger
Cc: linux-scsi; linux-kernel; James Bottomley; Calvin Owens; Christoph
Hellwig; MPT-FusionLinux.pdl; kernel-team; Nicholas Bellinger; Chaitra
Basappa
Subject: Re: [PATCH-v2 1/2] mpt3sas: Refcount sas_device objects and fix
unsafe list usage

On Sun, Aug 30, 2015 at 1:24 PM, Nicholas A. Bellinger <nab@daterainc.com>
wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> These objects can be referenced concurrently throughout the driver, we
> need a way to make sure threads can't delete them out from under each
> other. This patch adds the refcount, and refactors the code to use it.
>
> Additionally, we cannot iterate over the sas_device_list without
> holding the lock, or we risk corrupting random memory if items are
> added or deleted as we iterate. This patch refactors
> _scsih_probe_sas() to use the sas_device_list in a safe way.
>
> This patch is a port of Calvin's PATCH-v4 for mpt2sas code, atop
> mpt3sas changes in scsi.git/for-next.
>
> Cc: Calvin Owens <calvinowens@fb.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
> Cc: MPT-FusionLinux.pdl <MPT-FusionLinux.pdl@avagotech.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.h      |  25 +-
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 479
> +++++++++++++++++++++----------
>  drivers/scsi/mpt3sas/mpt3sas_transport.c |  18 +-
>  3 files changed, 364 insertions(+), 158 deletions(-)
>
> @@ -2763,7 +2874,7 @@ _scsih_block_io_device(struct MPT3SAS_ADAPTER *ioc,
> u16 handle)
>         struct scsi_device *sdev;
>         struct _sas_device *sas_device;
>

[Sreekanth] Here sas_device_lock spin lock needs to be acquired before
calling
                  __mpt3sas_get_sdev_by_addr() function.

[Chaitra]Here instead of calling " __mpt3sas_get_sdev_by_handle()" function
calling
	"mpt3sas_get_sdev_by_handle()" function will fixes "invalid page access"
type of kernel panic

> -       sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
> +       sas_device = __mpt3sas_get_sdev_by_handle(ioc, handle);
>         if (!sas_device)
>                 return;
>
> @@ -2779,6 +2890,8 @@ _scsih_block_io_device(struct MPT3SAS_ADAPTER *ioc,
> u16 handle)
>                         continue;
>                 _scsih_internal_device_block(sdev, sas_device_priv_data);
>         }
> +
> +       sas_device_put(sas_device);
>  }
>


Regards,
Chaitra
