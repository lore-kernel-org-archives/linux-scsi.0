From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH RESEND v2 2/2] scsi: 64-bit port of buslogic driver
Date: Wed, 26 Jun 2013 18:34:39 -0700
Message-ID: <1372296879.557.3.camel@dabdike>
References: <cover.1368754558.git.khalid.aziz@oracle.com>
	 <97daf2d29ceb78bdef3ddf6358dc634de35d0345.1368754556.git.khalid.aziz@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <97daf2d29ceb78bdef3ddf6358dc634de35d0345.1368754556.git.khalid.aziz@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Khalid Aziz <khalid@gonehiking.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2013-06-24 at 14:26 -0600, Khalid Aziz wrote:=20
> @@ -5072,17 +5039,15 @@ static void FPT_busMstrSGDataXferStart(unsign=
ed long p_port,
>   * Description:=20
>   *
>   *------------------------------------------------------------------=
---*/
> -static void FPT_busMstrDataXferStart(unsigned long p_port,
> -				     struct sccb *pcurrSCCB)
> +static void FPT_busMstrDataXferStart(u32 p_port, struct sccb *pcurrS=
CCB)
>  {
> -	unsigned long addr, count;
> +	u32 addr, count;
> =20
>  	if (!(pcurrSCCB->Sccb_XferState & F_AUTO_SENSE)) {
> =20
>  		count =3D pcurrSCCB->Sccb_XferCnt;
> =20
> -		addr =3D
> -		    (unsigned long)pcurrSCCB->DataPointer + pcurrSCCB->Sccb_ATC;
> +		addr =3D (u32)pcurrSCCB->DataPointer + pcurrSCCB->Sccb_ATC;

This is giving

In file included from drivers/scsi/BusLogic.c:57:0:
drivers/scsi/FlashPoint.c: In function =E2=80=98FPT_busMstrDataXferStar=
t=E2=80=99:
drivers/scsi/FlashPoint.c:5050:10: warning: cast from pointer to intege=
r
of different size [-Wpointer-to-int-cast]

to do this cast, you need first to cast to unsigned long and then
truncate the long with u32.  I fixed it up.

James
