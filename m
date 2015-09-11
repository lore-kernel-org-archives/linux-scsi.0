From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target/qla2xxx: Honor max_data_sg_nents I/O transfer
 limit
Date: Thu, 10 Sep 2015 23:36:34 -0700
Message-ID: <1441953394.21634.12.camel@haakon3.risingtidesystems.com>
References: <1439455550-2626-1-git-send-email-nab@daterainc.com>
	 <alpine.LRH.2.00.1508171724150.19116@mvluser04.mv.qlogic.com>
	 <1440112633.14304.23.camel@haakon3.risingtidesystems.com>
	 <1441842255.6836.13.camel@haakon3.risingtidesystems.com>
	 <D2174D86.B2810%himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <D2174D86.B2810%himanshu.madhani@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: Arun Easi <arun.easi@qlogic.com>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Craig Watson <craig.watson@vanguard-rugged.com>, Roland Dreier <roland@purestorage.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2015-09-10 at 22:16 +0000, Himanshu Madhani wrote:
> Hi Nic,=20
>=20
> Sorry about the delay in response.
>=20
> I have tested with RHEL 6.5 and noticed that IO were not able to comp=
lete
> with 16M and 32M read/write. IO=C2=B9s were getting error due to Mid-=
layer
> underflow
>=20
> With initiator running upstream kernel version 4.2 as well I was seei=
ng
> error with Mid-layer reporting under-run.
>=20
> I made change in the driver to report DID_OK to Mid-layer with residu=
al
> count and I was able to see IO completed without any error.
> Basically, overriding driver=C2=B9s logic of failing an I/O, when res=
idual
> makes it an error with scsi_cmnd->underflow set.
> In reality, though, with scsi_cmnd->underflow being set, Linux Qlogic
> initiator will always see this as an error.
> Maybe this is useful in other OSes. We have verified both read and wr=
ite
> data on FC trace and it looks good.
>=20

Great.  Thanks for the update.

> Here=C2=B9s diff that was done in qla2xxx driver to report response t=
o
> mid-layer as DID_OK.
>=20
>=20
> # git diff
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c
> b/drivers/scsi/qla2xxx/qla_isr.c
> index ccf6a7f..fc7b6a2 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -2257,7 +2257,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, stru=
ct
> rsp_que *rsp, void *pkt)
>                                     "detected (0x%x of 0x%x bytes).\n=
",
>                                     resid, scsi_bufflen(cp));
>=20
> -                               res =3D DID_ERROR << 16;
> +                               res =3D DID_OK << 16;
>                                 break;
>                         }
>                 } else if (lscsi_status !=3D SAM_STAT_TASK_SET_FULL &=
&
> (END)
>=20
>=20
> Please go ahead and add patch to mainline kernel.
>=20

This missed the last linux-next build by a day, but with your Tested-by
+ Signed-off-by on this patch, I think it's still safe enough to queue
for v4.3-rc1 code.  (Adding JEJB CC')

qla2xxx: Allow DID_OK status for residual under/overflow completion
https://git.kernel.org/cgit/linux/kernel/git/nab/target-pending.git/com=
mit/?h=3Dfor-next&id=3D46376bdc1e8a77c6d2cc65b77a1e340d4b4c9f1c

The target-pending/for-next PULL request will be going out in the next
48 hours.

Please let me know ASAP if you hit any regressions.

Thank you,

--nab
