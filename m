From: "Javali, Nilesh" <Nilesh.Javali@cavium.com>
Subject: Re: [PATCH] qedi: Fix a potential buffer overflow
Date: Fri, 27 Jul 2018 09:34:53 +0000
Message-ID: <D780E4AD.27101%njavali@caviumnetworks.com>
References: <20180726211037.6257-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180726211037.6257-1-bart.vanassche@wdc.com>
Content-Language: en-US
Content-ID: <F366FBA0CDCDBA4E99381584D60098F7@namprd07.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dept-Eng QLogic Storage Upstream <QLogic-Storage-Upstream@cavium.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


On 7/27/18, 2:40 AM, "Bart Van Assche" <bart.vanassche@wdc.com> wrote:

>External Email
>
>Tell snprintf() to store at most 255 characters in the output buffer
>instead of 256. This patch avoids that smatch reports the following
>warning:
>
>drivers/scsi/qedi/qedi_main.c:891: qedi_get_boot_tgt_info() error:
>snprintf() is printing too much 256 vs 255
>
>Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
>Cc: <QLogic-Storage-Upstream@cavium.com>
>Cc: <stable@vger.kernel.org>
>---
> drivers/scsi/qedi/qedi_main.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
>index 682f3ce31014..ea62180d9ec8 100644
>--- a/drivers/scsi/qedi/qedi_main.c
>+++ b/drivers/scsi/qedi/qedi_main.c
>@@ -888,7 +888,7 @@ static void qedi_get_boot_tgt_info(struct
>nvm_iscsi_block *block,
>        ipv6_en =3D !!(block->generic.ctrl_flags &
>                     NVM_ISCSI_CFG_GEN_IPV6_ENABLED);
>
>-       snprintf(tgt->iscsi_name, NVM_ISCSI_CFG_ISCSI_NAME_MAX_LEN,
>"%s\n",
>+       snprintf(tgt->iscsi_name, sizeof(tgt->iscsi_name), "%s\n",
>                 block->target[index].target_name.byte);
>
>        tgt->ipv6_en =3D ipv6_en;
>--
>2.18.0
>

Thanks,

Acked-by: Nilesh Javali <nilesh.javali@cavium.com>
