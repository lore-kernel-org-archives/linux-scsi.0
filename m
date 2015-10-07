From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH for-next] scsi: qla2xxx: Hide unavailable firmware
Date: Wed, 7 Oct 2015 17:13:06 +0200
Message-ID: <56153682.1030801@gmail.com>
References: <1432252831-7551-1-git-send-email-julian.calaby@gmail.com>
 <CAGRGNgVSuMD3B4B0Jr-TOT5Kr4NRvJR=0e3tu71OxUzQtrq2sg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35559 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbbJGPNL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2015 11:13:11 -0400
Received: by wicge5 with SMTP id ge5so217862952wic.0
        for <linux-scsi@vger.kernel.org>; Wed, 07 Oct 2015 08:13:09 -0700 (PDT)
In-Reply-To: <CAGRGNgVSuMD3B4B0Jr-TOT5Kr4NRvJR=0e3tu71OxUzQtrq2sg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Julian Calaby <julian.calaby@gmail.com>
Cc: qla2xxx-upstream@qlogic.com, linux-scsi <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@odin.com>, Linux Firmware Maintainers <linux-firmware@kernel.org>

On Fri, May 22, 2015 at 10:00 AM, Julian Calaby <julian.calaby@gmail.com> wrote:

> Some qla2xxx devices have firmware stored in flash on the device,
> however for debugging and triage purposes, Qlogic staff like to
> be able to load known-good versions of these firmwares through
> request_firmware().
>
> These firmware files were never distributed and are unlikely to ever
> be released publically, so to hide these missing firmware files from
> scripts which check such things, (e.g. Debian's initramfs-tools) put
> them behind a new EXPERT Kconfig option.


What is state of this patch ?


> Cc: <qla2xxx-upstream@qlogic.com>
> Cc: James E.J. Bottomley <JBottomley@odin.com>
> Cc: Linux Firmware Maintainers <linux-firmware@kernel.org>
> Signed-off-by: Julian Calaby <julian.calaby@gmail.com>
> ---
>  drivers/scsi/qla2xxx/Kconfig  | 25 +++++++++++++++++++++++++
>  drivers/scsi/qla2xxx/qla_os.c | 40 +++++++++++++++++++++++++++-------------
>  2 files changed, 52 insertions(+), 13 deletions(-)
>
> This is against linux-next @next-20150520 and has been compile
> tested only.
>
> diff --git a/drivers/scsi/qla2xxx/Kconfig b/drivers/scsi/qla2xxx/Kconfig
> index 33f60c9..31e9db4 100644
> --- a/drivers/scsi/qla2xxx/Kconfig
> +++ b/drivers/scsi/qla2xxx/Kconfig
> @@ -31,6 +31,31 @@ config SCSI_QLA_FC
>
>         They are also included in the linux-firmware tree as well.
>
> +       This driver also supports some adapters with firmware stored
> +       onboard in flash.
> +
> +config SCSI_QLA_FC_TRIAGE
> +       bool "Firmware loading support for flash based adapters"
> +       depends on SCSI_QLA_FC
> +       depends on EXPERT
> +       default n
> +       ---help---
> +       Add firmware definitions for adapters with firmware stored
> +       onboard in flash.
> +
> +       This requires the following firmware files which are not
> +       distributed:
> +
> +       ISP               Firmware Filename
> +       ----------        -----------------
> +       81xx              ql8100_fw.bin
> +       82xx              ql8200_fw.bin
> +
> +       This option should only be enabled by Qlogic support staff
> +       as these firmware files are not available publically.
> +
> +       If unsure say N.
> +
>  config TCM_QLA2XXX
>         tristate "TCM_QLA2XXX fabric module for Qlogic 2xxx series target mode HBAs"
>         depends on SCSI_QLA_FC && TARGET_CORE
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 7462dd7..da98d83 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -5284,11 +5284,14 @@ qla2x00_timer(scsi_qla_host_t *vha)
>  #define FW_ISP2322     3
>  #define FW_ISP24XX     4
>  #define FW_ISP25XX     5
> -#define FW_ISP81XX     6
> -#define FW_ISP82XX     7
> -#define FW_ISP2031     8
> -#define FW_ISP8031     9
> -#define FW_ISP27XX     10
> +#define FW_ISP2031     6
> +#define FW_ISP8031     7
> +#define FW_ISP27XX     8
> +
> +#ifdef CONFIG_SCSI_QLA_FC_TRIAGE
> +#define FW_ISP81XX     9
> +#define FW_ISP82XX     10
> +#endif
>
>  #define FW_FILE_ISP21XX        "ql2100_fw.bin"
>  #define FW_FILE_ISP22XX        "ql2200_fw.bin"
> @@ -5296,12 +5299,14 @@ qla2x00_timer(scsi_qla_host_t *vha)
>  #define FW_FILE_ISP2322        "ql2322_fw.bin"
>  #define FW_FILE_ISP24XX        "ql2400_fw.bin"
>  #define FW_FILE_ISP25XX        "ql2500_fw.bin"
> -#define FW_FILE_ISP81XX        "ql8100_fw.bin"
> -#define FW_FILE_ISP82XX        "ql8200_fw.bin"
>  #define FW_FILE_ISP2031        "ql2600_fw.bin"
>  #define FW_FILE_ISP8031        "ql8300_fw.bin"
>  #define FW_FILE_ISP27XX        "ql2700_fw.bin"
>
> +#ifdef CONFIG_SCSI_QLA_FC_TRIAGE
> +#define FW_FILE_ISP81XX        "ql8100_fw.bin"
> +#define FW_FILE_ISP82XX        "ql8200_fw.bin"
> +#endif
>
>  static DEFINE_MUTEX(qla_fw_lock);
>
> @@ -5312,11 +5317,13 @@ static struct fw_blob qla_fw_blobs[FW_BLOBS] = {
>         { .name = FW_FILE_ISP2322, .segs = { 0x800, 0x1c000, 0x1e000, 0 }, },
>         { .name = FW_FILE_ISP24XX, },
>         { .name = FW_FILE_ISP25XX, },
> -       { .name = FW_FILE_ISP81XX, },
> -       { .name = FW_FILE_ISP82XX, },
>         { .name = FW_FILE_ISP2031, },
>         { .name = FW_FILE_ISP8031, },
>         { .name = FW_FILE_ISP27XX, },
> +#ifdef CONFIG_SCSI_QLA_FC_TRIAGE
> +       { .name = FW_FILE_ISP81XX, },
> +       { .name = FW_FILE_ISP82XX, },
> +#endif
>  };
>
>  struct fw_blob *
> @@ -5337,16 +5344,18 @@ qla2x00_request_firmware(scsi_qla_host_t *vha)
>                 blob = &qla_fw_blobs[FW_ISP24XX];
>         } else if (IS_QLA25XX(ha)) {
>                 blob = &qla_fw_blobs[FW_ISP25XX];
> -       } else if (IS_QLA81XX(ha)) {
> -               blob = &qla_fw_blobs[FW_ISP81XX];
> -       } else if (IS_QLA82XX(ha)) {
> -               blob = &qla_fw_blobs[FW_ISP82XX];
>         } else if (IS_QLA2031(ha)) {
>                 blob = &qla_fw_blobs[FW_ISP2031];
>         } else if (IS_QLA8031(ha)) {
>                 blob = &qla_fw_blobs[FW_ISP8031];
>         } else if (IS_QLA27XX(ha)) {
>                 blob = &qla_fw_blobs[FW_ISP27XX];
> +#ifdef CONFIG_SCSI_QLA_FC_TRIAGE
> +       } else if (IS_QLA81XX(ha)) {
> +               blob = &qla_fw_blobs[FW_ISP81XX];
> +       } else if (IS_QLA82XX(ha)) {
> +               blob = &qla_fw_blobs[FW_ISP82XX];
> +#endif
>         } else {
>                 return NULL;
>         }
> @@ -5837,3 +5846,8 @@ MODULE_FIRMWARE(FW_FILE_ISP25XX);
>  MODULE_FIRMWARE(FW_FILE_ISP2031);
>  MODULE_FIRMWARE(FW_FILE_ISP8031);
>  MODULE_FIRMWARE(FW_FILE_ISP27XX);
> +
> +#ifdef CONFIG_SCSI_QLA_FC_TRIAGE
> +MODULE_FIRMWARE(FW_FILE_ISP81XX);
> +MODULE_FIRMWARE(FW_FILE_ISP82XX);
> +#endif
> --
> 2.1.4
>
