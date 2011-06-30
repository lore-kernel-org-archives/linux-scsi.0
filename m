From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 9/9] [SCSI] mvsas: Add support for interrupt tasklet
Date: Thu, 30 Jun 2011 10:46:37 -0700
Message-ID: <BANLkTinDLpb=mQpBEF3JnaA4eXrZC14aYA@mail.gmail.com>
References: <1309444056-29277-1-git-send-email-yxlraid@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1309444056-29277-1-git-send-email-yxlraid@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: yxlraid@gmail.com
Cc: JBottomley@parallels.com, James.Bottomley@suse.de, jack_wang@usish.com, lucas.demarchi@profusion.mobi, maciej.trela@intel.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, yuxiangl@marvell.com, jfeng@marvell.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 30, 2011 at 7:27 AM,  <yxlraid@gmail.com> wrote:
> From: Xiangliang Yu <yuxiangl@marvell.com>
>
> -- Add support for interrupt tasklet, which will improve performance.

Interesting, do you happen to have comparative performance numbers?
The other thing we are looking at with isci is performance impact of
task collector mode and trying to decide whether the potential for
injecting scheduling latency into command submission is worth it.  The
aic94xx driver seemed to have a specific coalescing behavior in mind
for this mode that I have not grokked yet.

> -- Correct spelling of "20011"
>
> Signed-off-by: Xiangliang Yu <yuxiangl@marvell.com>
> ---
> =A0drivers/scsi/mvsas/Kconfig =A0 | =A0 =A09 ++++++++-
> =A0drivers/scsi/mvsas/Makefile =A0| =A0 =A01 +
> =A0drivers/scsi/mvsas/mv_64xx.c | =A0 =A06 ++----
> =A0drivers/scsi/mvsas/mv_94xx.c | =A0 =A05 +----
> =A0drivers/scsi/mvsas/mv_init.c | =A0 32 ++++++++++++++++++++--------=
----
> =A0drivers/scsi/mvsas/mv_sas.h =A0| =A0 =A01 +
> =A06 files changed, 33 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/scsi/mvsas/Kconfig b/drivers/scsi/mvsas/Kconfig
> index c82b012..78f7e20 100644
> --- a/drivers/scsi/mvsas/Kconfig
> +++ b/drivers/scsi/mvsas/Kconfig
> @@ -3,7 +3,7 @@
> =A0#
> =A0# Copyright 2007 Red Hat, Inc.
> =A0# Copyright 2008 Marvell. <kewei@marvell.com>
> -# Copyright 2009-20011 Marvell. <yuxiangl@marvell.com>
> +# Copyright 2009-2011 Marvell. <yuxiangl@marvell.com>
> =A0#
> =A0# This file is licensed under GPLv2.
> =A0#
> @@ -41,3 +41,10 @@ config SCSI_MVSAS_DEBUG
> =A0 =A0 =A0 =A0help
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Compiles the 88SE64XX/88SE94XX driver =
in debug mode. =A0In debug mode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0the driver prints some messages to the=
 console.
> +config SCSI_MVSAS_TASKLET
> + =A0 =A0 =A0 bool "Support for interrupt tasklet"
> + =A0 =A0 =A0 default n
> + =A0 =A0 =A0 depends on SCSI_MVSAS
> + =A0 =A0 =A0 help
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 Compiles the 88SE64xx/88SE94xx driver i=
n interrupt tasklet mode.In this mode,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 the interrupt will schedule a tasklet.
> diff --git a/drivers/scsi/mvsas/Makefile b/drivers/scsi/mvsas/Makefil=
e
> index 87b231a..40aae8a 100644
> --- a/drivers/scsi/mvsas/Makefile
> +++ b/drivers/scsi/mvsas/Makefile
> @@ -23,6 +23,7 @@
> =A0# USA
>
> =A0ccflags-$(CONFIG_SCSI_MVSAS_DEBUG) :=3D -DMV_DEBUG
> +ccflags-$(CONFIG_SCSI_MVSAS_TASKLET) :=3D -DMVS_USE_TASKLET

Question, why not just use "#ifdef CONFIG_SCSI_MVSAS_TASKLET" and drop
these redefinitions?
