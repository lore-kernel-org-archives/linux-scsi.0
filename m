From: Michael Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] be2iscsi: add an missing goto in error path
Date: Fri, 6 Jun 2014 12:04:45 -0500
Message-ID: <DEDE4B73-E326-4120-A3FA-F3262F38B41B@cs.wisc.edu>
References: <5391AEC6.1040207@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:58840 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334AbaFFRE5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2014 13:04:57 -0400
In-Reply-To: <5391AEC6.1040207@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, jayamohank@gmail.com, sony.john-n@emulex.com


On Jun 6, 2014, at 7:06 AM, Tomas Henzl <thenzl@redhat.com> wrote:

> a jump to 'free_memory' is apparently missing
>=20
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> ---
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/=
be_main.c
> index ac54cf5..442982d 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -4209,6 +4209,8 @@ static int hba_setup_cid_tbls(struct beiscsi_hb=
a *phba)
> 		kfree(phba->ep_array);
> 		phba->ep_array =3D NULL;
> 		ret =3D -ENOMEM;
> +
> +		goto free_memory;
> 	}
>=20
> 	for (i =3D 0; i < phba->params.cxns_per_ctrl; i++) {
> =97=20

Thanks.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
