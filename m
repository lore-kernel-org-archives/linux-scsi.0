From: Jeremy Higdon <jeremy@classic.engr.sgi.com>
Subject: Re: Sym53C8xx Driver Hardening
Date: Thu, 25 Jul 2002 15:33:13 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <10207251533.ZM1198000@classic.engr.sgi.com>
References: <20020725005122.I4924-100000@localhost.my.domain>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="PART-BOUNDARY=.110207251533.ZM1198000.engr.sgi.com"
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: =?iso-8859-1?Q?G=E9rard_Roudier_=3Cgroudier=40free=2Efr=3E
 _______=22Re=3A_Sym53C8xx_Driver_Hardening=22_=28Jul_25=2C__1=3A11am=29?=
List-Id: linux-scsi@vger.kernel.org
To: =?iso-8859-1?Q?G=E9rard_Roudier?= <groudier@free.fr>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Rogier Wolff <R.E.Wolff@BitWizard.nl>, "Isabelle, Francois" <Francois.Isabelle@ca.kontron.com>, linux-scsi@vger.kernel.org


--PART-BOUNDARY=.110207251533.ZM1198000.engr.sgi.com
Content-Description: Text
Content-Type: text/plain ; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
X-Zm-Decoding-Hint: mimencode -q -u 

On Jul 25,  1:11am, G=E9rard Roudier wrote:
> =

> By the way, the sym53c8xx_2 driver (and probably version 1 too) never
> intentionnaly panics the system on hardware failure detection.
> The couple of calls to panic you can see in the driver are related to
> software unexpected situations.
> In my opinion, serious high reliability requires special hardware suppo=
rt.
> =

> On serious harware error detected, the driver simply tries to reset
> everything it can in order to have a chance to restart operations
> properly. May-be it should count such events and give up in some way af=
ter
> some given number of retries. If you just suggest such 'give up'
> operations to disable the device this should be doable, but this will n=
ot
> make upper layers aware of the situation and certainly not be what most=

> users expect. This MEANS that serious high reliability ALSO requires
> special SOFTWARE support and USER utilities, and certainly NOT ONLY be
> based on some questionnable trivial tinking in device drivers, in my
> opinion.
> =

>   G=E9rard.


Also, with some sorts of errors, one might suspect that the device has
DMA'd data into the wrong place in memory.

Generally, I think a crash is preferable to data corruption (i.e. no
answer is better than a wrong answer), so in such cases, the driver
might want to panic.

If hardware can place a fence around DMA (such that DMA to unintended
locations is impossible), then you might not want to panic in such
situations, assuming that you can retry.

jeremy

--PART-BOUNDARY=.110207251533.ZM1198000.engr.sgi.com--

