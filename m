From: Lee Duncan <lduncan@suse.com>
Subject: Re: [Patch] scsi_ioctl: support persistent reserve commands through
 ioctl for non-root user.
Date: Thu, 3 Sep 2015 09:13:25 -0700
Message-ID: <55E871A5.6020701@suse.com>
References: <OF31114848.5C193F0C-ON48257E94.00359001-48257E94.00363255@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:44470 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932787AbbICQNl (ORCPT
	<rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
	Thu, 3 Sep 2015 12:13:41 -0400
In-Reply-To: <OF31114848.5C193F0C-ON48257E94.00359001-48257E94.00363255@zte.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jiang.biao2@zte.com.cn, linux-scsi@vger.kernel.org, JBottomley@odin.com

On 08/01/2015 02:51 AM, jiang.biao2@zte.com.cn wrote:
> scsi_ioctl: support persistent reserve commands through ioctl for
> non-root user.
>=20
> Scsi persistent reserve commands need to be used for non-root user in
> many scenarios.
> EPERM error will be returned by sg_io() when PERSISTENT_RESERVE_OUT
> or PERSISTENT_RESERVE_IN command is sent through ioctl() for
> non-root user.
> Add PERSISTENT_RESERVE_OUT and PERSISTENT_RESERVE_IN into
> blk_default_cmd_filter in blk_set_cmd_filter_defaults() to support=20
> persistent reserve commands for non-root user.
>=20
> Signed-off-by: Jiang Biao <jiang.biao2@zte.com.cn>
> Signed-off-by: Li Ping <li.ping288@zte.com.cn>
> Reviewed-by: Liu Jianjun <liu.jianjun3@zte.com.cn>
>=20
> diff -urpN block/scsi_ioctl.c block_new/scsi_ioctl.c
> --- block/scsi_ioctl.c  2015-08-01 17:07:47.000000000 +0800
> +++ block_new/scsi_ioctl.c      2015-08-01 17:09:56.000000000 +0800
> @@ -202,6 +202,9 @@ static void blk_set_cmd_filter_defaults(
>         __set_bit(GPCMD_LOAD_UNLOAD, filter->write_ok);
>         __set_bit(GPCMD_SET_STREAMING, filter->write_ok);
>         __set_bit(GPCMD_SET_READ_AHEAD, filter->write_ok);
> +       /* Persistent reserve command*/
> +       __set_bit(PERSISTENT_RESERVE_IN, filter->read_ok);
> +       __set_bit(PERSISTENT_RESERVE_OUT, filter->write_ok);
>  }
>=20
>  int blk_verify_command(unsigned char *cmd, fmode_t has_write_perm)
> N=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDr=EF=BF=BD=EF=BF=BDy=EF=
=BF=BD=EF=BF=BD=EF=BF=BDb=EF=BF=BDX=EF=BF=BD=EF=BF=BD=C7=A7v=EF=BF=BD^=EF=
=BF=BD)=DE=BA{.n=EF=BF=BD+=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD{=EF=BF=BD=
=EF=BF=BD=EF=BF=BD"=EF=BF=BD{ay=EF=BF=BD=1D=CA=87=DA=99=EF=BF=BD,j=07=EF=
=BF=BD=EF=BF=BDf=EF=BF=BD=EF=BF=BD=EF=BF=BDh=EF=BF=BD=EF=BF=BD=EF=BF=BD=
z=EF=BF=BD=1E=EF=BF=BDw=EF=BF=BD=EF=BF=BD=EF=BF=BD=0C=EF=BF=BD=EF=BF=BD=
=EF=BF=BDj:+v=EF=BF=BD=EF=BF=BD=EF=BF=BDw=EF=BF=BDj=EF=BF=BDm=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=07=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDzZ+=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=DD=A2j"=EF=BF=BD=EF=BF=BD!tml=3D
>=20

I disagree that it is a good idea to give non-root users permanent
access to the reservation commands. This can be used to coopt a disc,
including the root disc.

--=20
Lee Duncan

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
