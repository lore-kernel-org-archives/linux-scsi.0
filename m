From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi_dh: avoid allowing dh_state to pass format specs when requesting a module
Date: Thu, 24 Sep 2015 09:49:15 +0200
Message-ID: <mqdvbb0uuis.fsf@c203.arch.suse.de>
References: <1443056906-7306-1-git-send-email-sasha.levin@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1443056906-7306-1-git-send-email-sasha.levin@oracle.com> (Sasha
	Levin's message of "Wed, 23 Sep 2015 21:08:26 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: Sasha Levin <sasha.levin@oracle.com>
Cc: JBottomley@odin.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Sasha Levin <sasha.levin@oracle.com> writes:

> A malicious string passed from userspace might contain format specifi=
ers which
> request_module() might try to handle, which is bad.
>
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  drivers/scsi/scsi_dh.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
> index edb044a..24be260 100644
> --- a/drivers/scsi/scsi_dh.c
> +++ b/drivers/scsi/scsi_dh.c
> @@ -111,7 +111,7 @@ static struct scsi_device_handler *scsi_dh_lookup=
(const char *name)
> =20
>  	dh =3D __scsi_dh_lookup(name);
>  	if (!dh) {
> -		request_module(name);
> +		request_module("%s", name);
>  		dh =3D __scsi_dh_lookup(name);
>  	}

Good catch.

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                           Storage
jthumshirn@suse.de                                 +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=C3=BCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600  D0D0 0393 969D 2D76 0850
