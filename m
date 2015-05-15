From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] megaraid_sas : Modify return value of megasas_issue_blocked_cmd()
 and wait_and_poll() to consider command status returned by firmware
Date: Fri, 15 May 2015 11:34:06 +0200
Message-ID: <5555BD8E.1@suse.de>
References: <201505061333.t46DXdcM032441@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41495 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbbEOJeK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 May 2015 05:34:10 -0400
In-Reply-To: <201505061333.t46DXdcM032441@palmhbs0.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com, linux-scsi@vger.kernel.org
Cc: stable@vger.kernel.org, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, thenzl@redhat.com, kashyap.desai@avagotech.com

On 05/06/2015 03:31 PM, Sumit.Saxena@avagotech.com wrote:
> This patch is rebased on top of recently sent 18 patches(submitted by=
 me) for megaraid_sas driver.
>=20
> Change the return value of wait_and_poll() and megsas_issue_blocked_c=
md() based on MFI_STAT returned by firmware for that command. Earlier d=
river always
> send return type based on command completion (but never check MFI_STA=
T_OK for that command), so even if command is failed by firmware still =
driver will
> return SUCCESS status from these functions wait_and_poll() and megsas=
_issue_blocked_cmd() and if caller of these functions does not check co=
mmand status
> (MFI_STAT), then it may endup using invalid data returned in DMA buff=
ers(one of the example is megasas_ld_list_query DCMD). Best thing to av=
oid this type
> of issue is do error handling and set proper return type from caller =
function wait_and_poll() and megsas_issue_blocked_cmd().
>=20
> The change proposed in this patch will fix the regression introduced =
in patch- "90dc9d9 megaraid_sas : MFI MPT linked list corruption fix" i=
nside function
> megasas_ld_list_query().
> Prior to this MFI MPT linked list corruption fix patch, megasas_ld_li=
st_query() function used to check DCMD status(returned by firmware) but=
 with
> this linked list corruption fix patch, DCMD status will not be checke=
d inside function megasas_ld_list_query() and introduced this issue of =
wrong data
> being used by function megasas_ld_list_query().
>=20
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas.h        |    2 +-
>  drivers/scsi/megaraid/megaraid_sas_base.c   |   67 +++++++++++------=
----------
>  drivers/scsi/megaraid/megaraid_sas_fusion.c |    3 +-
>  3 files changed, 30 insertions(+), 42 deletions(-)
>=20
> diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/mega=
raid/megaraid_sas.h
> index 53a3c3f..20c3754 100644
> --- a/drivers/scsi/megaraid/megaraid_sas.h
> +++ b/drivers/scsi/megaraid/megaraid_sas.h
> @@ -1894,7 +1894,7 @@ struct megasas_cmd {
> =20
>  	u32 index;
>  	u8 sync_cmd;
> -	u8 cmd_status;
> +	u8 cmd_status_drv;
>  	u8 abort_aen;
>  	u8 retry_for_fw_reset;
> =20
Can you please avoid the renaming here?
It doesn't serve any purpose, and keeping it will make the diff smaller=
=2E

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
