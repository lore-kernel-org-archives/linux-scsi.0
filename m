From: Dan Williams <dan.j.williams@gmail.com>
Subject: Re: [PATCH] libsas: add SMP READ/WRTIE GPIO support
Date: Wed, 22 Jun 2011 11:27:59 -0700
Message-ID: <BANLkTim_8-6_0eodM32-3cuU1Nk2Ubyh6g@mail.gmail.com>
References: <20110601140203.26324.22849.stgit@gklab-128-184.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37255 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757429Ab1FVS2A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jun 2011 14:28:00 -0400
Received: by pvg12 with SMTP id 12so672615pvg.19
        for <linux-scsi@vger.kernel.org>; Wed, 22 Jun 2011 11:28:00 -0700 (PDT)
In-Reply-To: <20110601140203.26324.22849.stgit@gklab-128-184.igk.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Artur Wojcik <artur.wojcik@intel.com>

On Wed, Jun 1, 2011 at 7:02 AM, Artur Wojcik <artur.wojcik@intel.com> w=
rote:
> This patch enables the SMP READ/WRITE GPIO function interface in libs=
as SMP
> host module. The interface is used to control the SGPIO initiator in =
the SAS
> initiator. The implementation is SFF-8485 and SAS-2 compliant.
>
> There are two functions in transport class only responsible for readi=
ng and
> writting GPIO registers. I decided to leave the decission about what =
type of
> registers are supported to lldd.
>
> Now the user space application may issue SMP READ/WRITE GPIO frame to=
 HBA in
> order to read/write GPIO registers.
>
> Signed-off-by: Artur Wojcik <artur.wojcik@intel.com>
> ---
> =A0drivers/scsi/libsas/sas_host_smp.c | =A0 48 ++++++++++++++++++++++=
+++++++++++++-
> =A0include/scsi/libsas.h =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 14 ++++++++=
+++
> =A0include/scsi/sas.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A04 +++
> =A03 files changed, 64 insertions(+), 2 deletions(-)
>

James, thoughts?

The thing that struck me most about this patch was the following
subtle deletion:

> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* FIXME: need GPIO support in the tran=
sport class */

Transport class support in my mind implies sysfs representation of the
sgpio targets, this patch is just providing an interface for tickling
sgpio-initiator registers in the hba.  This is likely fine to get the
conversation started, but it punts on the bigger question on
whether/how to describe the sgpio initiator topology to userspace.
This patch also enforces that the interface to the lldd is raw sgpio
protocol, which seems like a passable idea to me.  If a vendor does
something non-standard they can internally translate sgpio to
vendor-specific.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
