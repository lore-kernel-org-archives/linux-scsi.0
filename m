From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] ibmvscsis: Fix srp_transfer_data fail return code
Date: Tue, 10 Jan 2017 17:36:11 +0000
Message-ID: <1484069756.2588.12.camel@sandisk.com>
References: <1483978880-93705-1-git-send-email-bryantly@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1483978880-93705-1-git-send-email-bryantly@linux.vnet.ibm.com>
Content-Language: en-US
Content-ID: <48EA6ABE91D2BB42B14DC35268FDCB70@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: "bryantly@linux.vnet.ibm.com" <bryantly@linux.vnet.ibm.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "bgly@us.ibm.com" <bgly@us.ibm.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2017-01-09 at 10:21 -0600, Bryant G. Ly wrote:
> From: "Bryant G. Ly" <bgly@us.ibm.com>
>=20
> If srp_transfer_data fails within ibmvscsis_write_pending, then
> the most likely scenario is that the client timed out the op and
> removed the TCE mapping. Thus it will loop forever retrying the
> op that is pretty much guaranteed to fail forever. A better return
> code would be EIO instead of EAGAIN.
>=20
> Cc: stable@vger.kernel.org
> Reported-by: Steven Royer <seroyer@linux.vnet.ibm.com>
> Tested-by: Steven Royer <seroyer@linux.vnet.ibm.com>
> Signed-off-by: Bryant G. Ly <bgly@us.ibm.com>
> ---
> =A0drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 2 +-
> =A01 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmv=
scsi_tgt/ibmvscsi_tgt.c
> index 3d3768a..8fb5c54 100644
> --- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> +++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> @@ -3585,7 +3585,7 @@ static int ibmvscsis_write_pending(struct se_cmd *s=
e_cmd)
> =A0			=A0=A0=A0=A0=A0=A0=A01, 1);
> =A0	if (rc) {
> =A0		pr_err("srp_transfer_data() failed: %d\n", rc);
> -		return -EAGAIN;
> +		return -EIO;
> =A0	}
> =A0	/*
> =A0	=A0* We now tell TCM to add this WRITE CDB directly into the TCM stor=
age

Using the "Cc: stable@vger.kernel.org" tag is fine but please do not
add stable@vger.kernel.org to the CC-list of the e-mail header. Anyway,
thanks for the patch. It has been applied on my for-v4.10 branch.

Bart.=
