From: Anil Gurumurthy <Anil.Gurumurthy@qlogic.com>
Subject: RE: [SCSI] bfa: Added support to obtain SFP info.
Date: Wed, 30 Apr 2014 08:43:52 +0000
Message-ID: <20B1A3CBD98F3845B3F5F56D8597EF59F84A79@avmb2.qlogic.org>
References: <20140327230514.GA15507@mwanda> <20140327230737.GB7045@mwanda>
 <20140429125100.GS4963@mwanda>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_000_20B1A3CBD98F3845B3F5F56D8597EF59F84A79avmb2qlogicorg_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:39715 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757634AbaD3In4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Apr 2014 04:43:56 -0400
Received: from pps.filterd (m0000643.ppops.net [127.0.0.1])
	by mx0b-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id s3U8hQsL005583
	for <linux-scsi@vger.kernel.org>; Wed, 30 Apr 2014 01:43:55 -0700
Received: from avcashub1.qlogic.com (avcashub1.qlogic.com [198.70.193.115])
	by mx0b-0016ce01.pphosted.com with ESMTP id 1kj1t3jv51-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 30 Apr 2014 01:43:55 -0700
In-Reply-To: <20140429125100.GS4963@mwanda>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Sudarsana Kalluru <Sudarsana.Kalluru@qlogic.com>

--_000_20B1A3CBD98F3845B3F5F56D8597EF59F84A79avmb2qlogicorg_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Dan,
  The indentation of the code is an issue here. We will fix it in the next =
patch submission.

The code should be
static void
bfa_cb_sfp_state_query(struct bfa_sfp_s *sfp)
{
        bfa_trc(sfp, sfp->portspeed);
        if (sfp->media) {
                bfa_sfp_media_get(sfp);
                if (sfp->state_query_cbfn)
                        sfp->state_query_cbfn(sfp->state_query_cbarg,
                                              sfp->status);
                sfp->media =3D NULL;
        }

        if (sfp->portspeed) {
                sfp->status =3D bfa_sfp_speed_valid(sfp, sfp->portspeed);
                if (sfp->state_query_cbfn)
                        sfp->state_query_cbfn(sfp->state_query_cbarg,
                                              sfp->status);
                sfp->portspeed =3D BFA_PORT_SPEED_UNKNOWN;
        }

        sfp->state_query_lock =3D 0;
        sfp->state_query_cbfn =3D NULL;
}

Thanks,
Anil

-----Original Message-----
From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
Sent: 29 April 2014 18:21
To: linux-scsi
Cc: Vijaya Mohan Guvva; Anil Gurumurthy; Sudarsana Kalluru
Subject: Re: [SCSI] bfa: Added support to obtain SFP info.

Krishna isn't around any more.  Does anyone else know what's going on in th=
is code?  It looks buggy to me.

regards,
dan carpenter

On Fri, Mar 28, 2014 at 02:07:37AM +0300, Dan Carpenter wrote:
> On Fri, Mar 28, 2014 at 02:05:14AM +0300, Dan Carpenter wrote:
> > Hello Krishna Gudipati,
> >
> > The patch 51e569aa1f0c: "[SCSI] bfa: Added support to obtain SFP
> > info." from Jun 24, 2011, leads to the following static checker
> > warning:
> >
> >     drivers/scsi/bfa/bfa_ioc.c:3668 bfa_cb_sfp_state_query()
> >     warn: add curly braces?
> >
> > drivers/scsi/bfa/bfa_ioc.c
> >   3659  static void
> >   3660  bfa_cb_sfp_state_query(struct bfa_sfp_s *sfp)
> >   3661  {
> >   3662          bfa_trc(sfp, sfp->portspeed);
> >   3663          if (sfp->media) {
> >   3664                  bfa_sfp_media_get(sfp);
> >   3665                  if (sfp->state_query_cbfn)
> >                                                    ^ Add a curly
> > brace here?
> >
> >   3666                          sfp->state_query_cbfn(sfp->state_query_=
cbarg,
> >   3667                                          sfp->status);
> >   3668                          sfp->media =3D NULL;
> >   3669                  }
> >   3670
> >   3671                  if (sfp->portspeed) {
> >   3672                          sfp->status =3D bfa_sfp_speed_valid(sfp=
, sfp->portspeed);
> >   3673                          if (sfp->state_query_cbfn)
> >   3674                                  sfp->state_query_cbfn(sfp->stat=
e_query_cbarg,
> >   3675                                                  sfp->status);
> >   3676                                  sfp->portspeed =3D BFA_PORT_SPE=
ED_UNKNOWN;
>
> It looks like this if statement needs curly braces as well.
>
> regards,
> dan carpenter
>
> >   3677                  }
> >   3678
> >   3679                  sfp->state_query_lock =3D 0;
> >   3680                  sfp->state_query_cbfn =3D NULL;
> >
> >                 ^
> > And another close curly brace here?
> >
> >   3681  }
> >
> > regards,
> > dan carpenter

________________________________

This message and any attached documents contain information from QLogic Cor=
poration or its wholly-owned subsidiaries that may be confidential. If you =
are not the intended recipient, you may not read, copy, distribute, or use =
this information. If you have received this transmission in error, please n=
otify the sender immediately by reply e-mail and then delete this message.

--_000_20B1A3CBD98F3845B3F5F56D8597EF59F84A79avmb2qlogicorg_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
W29cf12Mjwh/NyIg/5gwfmSwUaezB4ACMCbRCYDvfqGgSSSABCB3jREoNo8I/4FtojGCb+/K0EXG
H89/0IG+OM++zm/h32FfpFc4ptH//D/jb2Qfv1+77YxZZxB7Ev+HoCUhG9AJAHzBoDm+n/7tv6rS
+emMWfVP9j8oal8OP/8PLChOJGEScWlCJIF7FBiA93ggl/EcYGRhgHNQIxF+oj8jIXhBeLIbAiNi
HINRTP5vaLArABtAawBs4SNUGLDPJkDzwSnAJdB5LX0QJuD9klJiJ/DMsY1wfAEj0IVR/2uQB0Ej
8njA2PDyQczA9BD3fyCwYHxQdXqxJsGMECPD33hAi7Ai8RdwC1BjjhAdcP/yUNlQGjIYshqyC1CW
MNlQuW1QcHnZUMywqHFpf8D/i7DZUBZRWcDxRhQoGed9UPuigBuyZaJxF3B+c60QezBecyfFJmKi
kIwActlQcP+WEXzBBjGwUIABGwF8wBtx/RZhbTNzi7CgYgdAC1AjUP8HQGlwa5IR05ahDKAZcJYQ
z4uwfmQRZYB2fX1mECkgAAAfAEIAAQAAACAAAABBAG4AaQBsACAARwB1AHIAdQBtAHUAcgB0AGgA
eQAAAB8AZQABAAAANgAAAEEAbgBpAGwALgBHAHUAcgB1AG0AdQByAHQAaAB5AEAAcQBsAG8AZwBp
AGMALgBjAG8AbQAAAAAAHwBkAAEAAAAKAAAAUwBNAFQAUAAAAAAAAgFBAAEAAAB4AAAAAAAAAIEr
H6S+oxAZnW4A3QEPVAIAAACAQQBuAGkAbAAgAEcAdQByAHUAbQB1AHIAdABoAHkAAABTAE0AVABQ
AAAAQQBuAGkAbAAuAEcAdQByAHUAbQB1AHIAdABoAHkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAA
HwACXQEAAAA2AAAAQQBuAGkAbAAuAEcAdQByAHUAbQB1AHIAdABoAHkAQABxAGwAbwBnAGkAYwAu
AGMAbwBtAAAAAAAfAOVfAQAAAD4AAABzAGkAcAA6AGEAbgBpAGwALgBnAHUAcgB1AG0AdQByAHQA
aAB5AEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAAAAHwAaDAEAAAAgAAAAQQBuAGkAbAAgAEcAdQBy
AHUAbQB1AHIAdABoAHkAAAAfAB8MAQAAADYAAABBAG4AaQBsAC4ARwB1AHIAdQBtAHUAcgB0AGgA
eQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAAAB8AHgwBAAAACgAAAFMATQBUAFAAAAAAAAIBGQwB
AAAAeAAAAAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAAgEEAbgBpAGwAIABHAHUAcgB1AG0AdQByAHQA
aAB5AAAAUwBNAFQAUAAAAEEAbgBpAGwALgBHAHUAcgB1AG0AdQByAHQAaAB5AEAAcQBsAG8AZwBp
AGMALgBjAG8AbQAAAB8AAV0BAAAANgAAAEEAbgBpAGwALgBHAHUAcgB1AG0AdQByAHQAaAB5AEAA
cQBsAG8AZwBpAGMALgBjAG8AbQAAAAAAHwD4PwEAAAAgAAAAQQBuAGkAbAAgAEcAdQByAHUAbQB1
AHIAdABoAHkAAAAfACNAAQAAADYAAABBAG4AaQBsAC4ARwB1AHIAdQBtAHUAcgB0AGgAeQBAAHEA
bABvAGcAaQBjAC4AYwBvAG0AAAAAAB8AIkABAAAACgAAAFMATQBUAFAAAAAAAAIB+T8BAAAAeAAA
AAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAAgEEAbgBpAGwAIABHAHUAcgB1AG0AdQByAHQAaAB5AAAA
UwBNAFQAUAAAAEEAbgBpAGwALgBHAHUAcgB1AG0AdQByAHQAaAB5AEAAcQBsAG8AZwBpAGMALgBj
AG8AbQAAAB8ACV0BAAAANgAAAEEAbgBpAGwALgBHAHUAcgB1AG0AdQByAHQAaAB5AEAAcQBsAG8A
ZwBpAGMALgBjAG8AbQAAAAAAHwAxQAEAAAACAAAAAAAAAAsAQDoBAAAAHwAwQAEAAAACAAAAAAAA
AB8AGgABAAAAEgAAAEkAUABNAC4ATgBvAHQAZQAAAAAAAwDxPwkEAAALAEA6AQAAAAMA/T/kBAAA
AgELMAEAAAAQAAAALOqdag3OXkSFf1FPbw8ulwMAFwABAAAAQAA5AACUCVBQZM8BQAAIMLXTS1BQ
ZM8BCwApAAAAAAALACMAAAAAAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAAB4AAABhAGMAYwBlAHAA
dABsAGEAbgBnAHUAYQBnAGUAAAAAAAEAAAAMAAAAZQBuAC0AVQBTAAAACwAAgAggBgAAAAAAwAAA
AAAAAEYAAAAABoUAAAAAAAAfADcAAQAAAGQAAABSAEUAOgAgAFsAUwBDAFMASQBdACAAYgBmAGEA
OgAgAEEAZABkAGUAZAAgAHMAdQBwAHAAbwByAHQAIAB0AG8AIABvAGIAdABhAGkAbgAgAFMARgBQ
ACAAaQBuAGYAbwAuAAAAHwA9AAEAAAAKAAAAUgBFADoAIAAAAAAAAwA2AAAAAAADAC4AAAAAAB8A
QhABAAAAPgAAADwAMgAwADEANAAwADQAMgA5ADEAMgA1ADEAMAAwAC4ARwBTADQAOQA2ADMAQABt
AHcAYQBuAGQAYQA+AAAAAAACAXEAAQAAACUAAAABAc9KERLpDEfX6eqYTJVl8mWu+IjymvYD5oCA
MzCoAIAA1rgwAAAAHwBwAAEAAABcAAAAWwBTAEMAUwBJAF0AIABiAGYAYQA6ACAAQQBkAGQAZQBk
ACAAcwB1AHAAcABvAHIAdAAgAHQAbwAgAG8AYgB0AGEAaQBuACAAUwBGAFAAIABpAG4AZgBvAC4A
AAAfADUQAQAAAHQAAAA8ADIAMABCADEAQQAzAEMAQgBEADkAOABGADMAOAA0ADUAQgAzAEYANQBG
ADUANgBEADgANQA5ADcARQBGADUAOQBGADgANABBADcAOQBAAGEAdgBtAGIAMgAuAHEAbABvAGcA
aQBjAC4AbwByAGcAPgAAAB8AORABAAAAvAAAADwAMgAwADEANAAwADMAMgA3ADIAMwAwADUAMQA0
AC4ARwBBADEANQA1ADAANwBAAG0AdwBhAG4AZABhAD4AIAA8ADIAMAAxADQAMAAzADIANwAyADMA
MAA3ADMANwAuAEcAQgA3ADAANAA1AEAAbQB3AGEAbgBkAGEAPgAgADwAMgAwADEANAAwADQAMgA5
ADEAMgA1ADEAMAAwAC4ARwBTADQAOQA2ADMAQABtAHcAYQBuAGQAYQA+AAAAAwDeP59OAAALAACA
CCAGAAAAAADAAAAAAAAARgAAAAADhQAAAAAAAAMAAIAIIAYAAAAAAMAAAAAAAABGAAAAAAGFAAAA
AAAAAwCAEP////9AAAcwVc0rT1BkzwELAAIAAQAAAAMAJgAAAAAACwArAAAAAAACAUcAAQAAAC8A
AABjPVVTO2E9IDtwPVFMb2dpYztsPUFWTUIyLTE0MDQzMDA4NDM1MlotMjAxMDUxAAACARAwAQAA
AEYAAAAAAAAApfa6WPiUnECXquZDOkRWvwcAILGjy9mPOEWz9fVthZfvWQAAAPSNGAAAZwQxjMtx
okilXd7HughfeQBLeqWN3wAAAAAfAPo/AQAAACAAAABBAG4AaQBsACAARwB1AHIAdQBtAHUAcgB0
AGgAeQAAAAMACVkBAAAAAwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAEIUAAAAAAAALAACACCAGAAAA
AADAAAAAAAAARgAAAAAOhQAAAAAAAAMAAIAIIAYAAAAAAMAAAAAAAABGAAAAABiFAAAAAAAACwAA
gAggBgAAAAAAwAAAAAAAAEYAAAAAgoUAAAAAAAAfAACACCAGAAAAAADAAAAAAAAARgAAAADYhQAA
AQAAABIAAABJAFAATQAuAE4AbwB0AGUAAAAAAAMADTT9PwAAHwAAgIYDAgAAAAAAwAAAAAAAAEYB
AAAAIAAAAHgALQBtAHMALQBoAGEAcwAtAGEAdAB0AGEAYwBoAAAAAQAAAAIAAAAAAAAAHwAAgIYD
AgAAAAAAwAAAAAAAAEYBAAAAIgAAAHgALQBvAHIAaQBnAGkAbgBhAHQAaQBuAGcALQBpAHAAAAAA
AAEAAAAYAAAAWwAxADAALgAxAC4ANAAuADEAMABdAAAAR4s=

--_000_20B1A3CBD98F3845B3F5F56D8597EF59F84A79avmb2qlogicorg_--
