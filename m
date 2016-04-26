From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] megaraid_sas: trivial fix, add missing space in dev_err
 message
Date: Mon, 25 Apr 2016 18:05:53 -0700
Message-ID: <1461632753.2726.108.camel@perches.com>
References: <1461621523-30162-1-git-send-email-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461621523-30162-1-git-send-email-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Jiri Kosina <trivial@kernel.org>, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2016-04-25 at 22:58 +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>=20
> Add a missing space in dev_err message, missed because the string
> spans a few lines.

This is a dev_notice() not dev_err().

> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi=
/megaraid/megaraid_sas_base.c
[]
> @@ -3345,7 +3345,7 @@ megasas_internal_reset_defer_cmds(struct megasa=
s_instance *instance)
> =A0			if (!list_empty(&cmd->list)) {
> =A0				dev_notice(&instance->pdev->dev, "ERROR while"
> =A0					" moving this cmd:%p, %d %p, it was"
> -					"discovered on some list?\n",
> +					" discovered on some list?\n",
> =A0					cmd, cmd->sync_cmd, cmd->scmd);
> =A0
> =A0				list_del_init(&cmd->list);

Better would be to coalesce the format, but perhaps
this dev_notice should be dev_err?

				dev_notice(&instance->pdev->dev,
					=A0 =A0"ERROR while moving this cmd:%p, %d %p, it was discovered o=
n some list?\n",
					   cmd, cmd->sync_cmd, cmd->scmd);

And the message seems oddly phrased.
