From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 26/28] libsas: check for 'gone' expanders in smp_execute_task()
Date: Mon, 9 Jan 2012 11:04:45 -0800
Message-ID: <CAA9_cmeLcUA5TdTgOSetb1XdNTEKwNMdfAyzM6nxoSU8s8WUkw@mail.gmail.com>
References: <20111223025350.21827.85779.stgit@localhost6.localdomain6>
	<20111223030044.21827.27431.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:41744 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755816Ab2AITEq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Jan 2012 14:04:46 -0500
In-Reply-To: <20111223030044.21827.27431.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org

On Thu, Dec 22, 2011 at 7:00 PM, Dan Williams <dan.j.williams@intel.com=
> wrote:
> No sense in issuing or retrying commands to an expander that has been
> removed.
>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> =A0drivers/scsi/libsas/sas_expander.c | =A0 =A03 +++
> =A01 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas=
/sas_expander.c
> index d9c2769..e2efc6c 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -74,6 +74,9 @@ static int smp_execute_task(struct domain_device *d=
ev, void *req, int req_size,
>
> =A0 =A0 =A0 =A0mutex_lock(&dev->ex_dev.cmd_mutex);
> =A0 =A0 =A0 =A0for (retry =3D 0; retry < 3; retry++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (dev->gone)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ECOMM;
> +

Test results are just now tripping up on this obvious deadlock.  Will r=
esend.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
