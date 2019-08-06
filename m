From: Qian Cai <cai@lca.pw>
Subject: Re: [PATCH] scsi/megaraid_sas: fix a compilation warning
Date: Mon, 5 Aug 2019 23:27:32 -0400
Message-ID: <B961A6AE-2377-406C-891D-4363DCD9827C@lca.pw>
References: <1564151143-22889-1-git-send-email-cai@lca.pw>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1564151143-22889-1-git-send-email-cai@lca.pw>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com
Cc: jejb@linux.ibm.com, Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, shivasharan.srikanteshwara@broadcom.com, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Ping. Please take a look at this trivial patch.

> On Jul 26, 2019, at 10:25 AM, Qian Cai <cai@lca.pw> wrote:
>=20
> The commit de516379e85f ("scsi: megaraid_sas: changes to function
> prototypes") introduced a comilation warning due to it changed the
> function prototype of read_fw_status_reg() to take an instance pointer
> instead, but forgot to remove an unused variable.
>=20
> drivers/scsi/megaraid/megaraid_sas_fusion.c: In function
> 'megasas_fusion_update_can_queue':
> drivers/scsi/megaraid/megaraid_sas_fusion.c:326:39: warning: variable
> 'reg_set' set but not used [-Wunused-but-set-variable]
>  struct megasas_register_set __iomem *reg_set;
>                                       ^~~~~~~
> Fixes: de516379e85f ("scsi: megaraid_sas: changes to function =
prototypes")
> Signed-off-by: Qian Cai <cai@lca.pw>
> ---
> drivers/scsi/megaraid/megaraid_sas_fusion.c | 3 ---
> 1 file changed, 3 deletions(-)
>=20
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c =
b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index a32b3f0fcd15..e8092d59d575 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -323,9 +323,6 @@ inline void megasas_return_cmd_fusion(struct =
megasas_instance *instance,
> {
> 	u16 cur_max_fw_cmds =3D 0;
> 	u16 ldio_threshold =3D 0;
> -	struct megasas_register_set __iomem *reg_set;
> -
> -	reg_set =3D instance->reg_set;
>=20
> 	/* ventura FW does not fill outbound_scratch_pad_2 with queue =
depth */
> 	if (instance->adapter_type < VENTURA_SERIES)
> --=20
> 1.8.3.1
>=20
