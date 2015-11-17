From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 1/2] qla2xxx: Remove unavailable firmware files
Date: Tue, 17 Nov 2015 22:04:38 +0100
Message-ID: <564B9666.9010103@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33943 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983AbbKQVEl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Nov 2015 16:04:41 -0500
Received: by wmww144 with SMTP id w144so8179331wmw.1
        for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2015 13:04:40 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Qlogic internal list <Linux-Driver@qlogic.com>, Julian Calaby <julian.calaby@gmail.com>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, "James E.J. Bottomley " <JBottomley@odin.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michal Marek <mmarek@suse.com>

On 10/14/2015 05:57 PM, Himanshu Madhani wrote:

> Remove firmware binary names for the ISPs, which
> are not submitted to linux-firmware
> 
> Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_os.c |   29 -----------------------------
>  1 files changed, 0 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index c2dd17b..41aca16 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -5293,11 +5293,6 @@ qla2x00_timer(scsi_qla_host_t *vha)
>  #define FW_ISP2322	3
>  #define FW_ISP24XX	4
>  #define FW_ISP25XX	5
> -#define FW_ISP81XX	6
> -#define FW_ISP82XX	7
> -#define FW_ISP2031	8
> -#define FW_ISP8031	9
> -#define FW_ISP27XX	10
>  
>  #define FW_FILE_ISP21XX	"ql2100_fw.bin"
>  #define FW_FILE_ISP22XX	"ql2200_fw.bin"
> @@ -5305,12 +5300,6 @@ qla2x00_timer(scsi_qla_host_t *vha)
>  #define FW_FILE_ISP2322	"ql2322_fw.bin"
>  #define FW_FILE_ISP24XX	"ql2400_fw.bin"
>  #define FW_FILE_ISP25XX	"ql2500_fw.bin"
> -#define FW_FILE_ISP81XX	"ql8100_fw.bin"
> -#define FW_FILE_ISP82XX	"ql8200_fw.bin"
> -#define FW_FILE_ISP2031	"ql2600_fw.bin"
> -#define FW_FILE_ISP8031	"ql8300_fw.bin"
> -#define FW_FILE_ISP27XX	"ql2700_fw.bin"
> -
>  
>  static DEFINE_MUTEX(qla_fw_lock);
>  
> @@ -5321,11 +5310,6 @@ static struct fw_blob qla_fw_blobs[FW_BLOBS] = {
>  	{ .name = FW_FILE_ISP2322, .segs = { 0x800, 0x1c000, 0x1e000, 0 }, },
>  	{ .name = FW_FILE_ISP24XX, },
>  	{ .name = FW_FILE_ISP25XX, },
> -	{ .name = FW_FILE_ISP81XX, },
> -	{ .name = FW_FILE_ISP82XX, },
> -	{ .name = FW_FILE_ISP2031, },
> -	{ .name = FW_FILE_ISP8031, },
> -	{ .name = FW_FILE_ISP27XX, },
>  };
>  
>  struct fw_blob *
> @@ -5346,16 +5330,6 @@ qla2x00_request_firmware(scsi_qla_host_t *vha)
>  		blob = &qla_fw_blobs[FW_ISP24XX];
>  	} else if (IS_QLA25XX(ha)) {
>  		blob = &qla_fw_blobs[FW_ISP25XX];
> -	} else if (IS_QLA81XX(ha)) {
> -		blob = &qla_fw_blobs[FW_ISP81XX];
> -	} else if (IS_QLA82XX(ha)) {
> -		blob = &qla_fw_blobs[FW_ISP82XX];
> -	} else if (IS_QLA2031(ha)) {
> -		blob = &qla_fw_blobs[FW_ISP2031];
> -	} else if (IS_QLA8031(ha)) {
> -		blob = &qla_fw_blobs[FW_ISP8031];
> -	} else if (IS_QLA27XX(ha)) {
> -		blob = &qla_fw_blobs[FW_ISP27XX];
>  	} else {
>  		return NULL;
>  	}
> @@ -5844,6 +5818,3 @@ MODULE_FIRMWARE(FW_FILE_ISP2300);
>  MODULE_FIRMWARE(FW_FILE_ISP2322);
>  MODULE_FIRMWARE(FW_FILE_ISP24XX);
>  MODULE_FIRMWARE(FW_FILE_ISP25XX);
> -MODULE_FIRMWARE(FW_FILE_ISP2031);
> -MODULE_FIRMWARE(FW_FILE_ISP8031);
> -MODULE_FIRMWARE(FW_FILE_ISP27XX);
> -- 
> 1.7.7

You should remove this info also from Kconfig:
      2031              ql2600_fw.bin
      8031              ql8300_fw.bin
      27xx              ql2700_fw.bin

Anyway,

Reviewed-by: Xose Vazquez Perez <xose.vazquez@gmail.com>


BTW, linux-firmware still contains release 7.03.00 of ql2400_fw.bin and ql2500_fw.bin .
SLES-11_SP4 already brings 8.00.00. And I did test 8.01.00 time ago and it worked flawlessly.

So, please *regularly* send latest FW releases to linux-firmware.git

-thanks-
