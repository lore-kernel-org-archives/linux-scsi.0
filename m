From: "S, Chandrakala (STSD)" <chandrakala.s@hp.com>
Subject: RE: [PATCH 0/7] blk_end_request: full I/O completion
	handler
Date: Tue, 5 Feb 2008 16:04:00 +0530
Message-ID: <77334B9413C72244AE1B51ADD4868D700AF902CF@BGEEXC02.asiapacific.cpqcorp.net>
References: <20070903074549.GJ4253@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20070903074549.GJ4253@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <jens.axboe@oracle.com>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: linux-scsi@vger.kernel.org, "Miller, Mike (OS Dev)" <mike.miller@hp.com>, linux-kernel@vger.kernel.org, grant.likely@secretlab.ca, linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com
List-Id: linux-scsi@vger.kernel.org

Hello,

We would like to know in which kernel version these patches are
available. =20
=20
Thanks,
Chandrakala

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Jens Axboe
Sent: Monday, September 03, 2007 1:16 PM
To: Kiyoshi Ueda
Cc: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org;
linux-ide@vger.kernel.org; Miller, Mike (OS Dev);
grant.likely@secretlab.ca; dm-devel@redhat.com; j-nomura@ce.jp.nec.com
Subject: Re: [PATCH 0/7] blk_end_request: full I/O completion handler

On Fri, Aug 31 2007, Kiyoshi Ueda wrote:
> Hello,
>=20
> This set of patches changes request completion interface between=20
> device drivers and block layer to 1 step procedure from current 2 step

> procedures using end_that_request_{first/chunk} and=20
> end_that_request_last().
>=20
> This change allows request-based multipath to hook in before=20
> completing each chunk of request, check errors for it and retry it=20
> using another path if error is detected.
>=20
> Summaries of each patch are below:
>   1/7: add new request completion interface, blk_end_request()
>   2/7: add some macros to get the size of request in bytes
>   3/7: convert normal drivers to use blk_end_request()
>   4/7: convert odd drivers like cciss/cpqarray/xsysace to use
>        blk_end_request()
>   5/7: convert ide-cd (cdrom_newpc_intr) to use blk_end_request()
>   6/7: remove/unexport no longer needed end_that_request_*
>   7/7: change rq->end_io to cover request completion as a whole
>=20
> I have tested the patch on two machines, ia64+QLA1280+QLA2200 and=20
> x86_64+SATA+IDE-CDROM.
> I can't test other device drivers for which I don't have hardware.
> So testing help and any comments would be very much appreciated.
>=20
> The interface change causes code modifications of *ALL DEVICE DRIVERS*

> which are using end_that_request_{first/chunk/last} to complete
request.
> But it should not affect the behavior.
>=20
> Please review and apply if no problem.
> This patch-set should be applied on top of 2.6.23-rc3-mm1.
>=20
>=20
> BACKGROUND
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> The patch is necessary to allow device stacking at request level, that

> is request-based device-mapper multipath.
> Currently, device-mapper is implemented as a stacking block device at=20
> BIO level.  OTOH, request-based DM will stack at request level to=20
> allow better multipathing decision.
> To allow device stacking at request level, the completion procedure=20
> need to provide a hook for it.
> For example, dm-multipath has to check errors and retry with other=20
> paths if necessary before returning the I/O result to upper layer.
> struct request has 'end_io' hook currently.  But it's called at the=20
> very late stage of completion handling where the I/O result is already

> returned to the upper layer.
> So we need something here.
>=20
> The first approach to hook in completion of each chunk of request was=20
> adding a new rq->end_io_first() hook and calling it on the top of=20
> __end_that_request_first().
>   - http://marc.theaimsgroup.com/?l=3Dlinux-scsi&m=3D115520444515914&w=3D=
2
>   - http://marc.theaimsgroup.com/?l=3Dlinux-kernel&m=3D116656637425880&=
w=3D2
> However, Jens pointed out that redesigning rq->end_io() as a full=20
> completion handler would be better:
>=20
> On Thu, 21 Dec 2006 08:49:47 +0100, Jens Axboe <jens.axboe@oracle.com>
wrote:
> > Ok, I see what you are getting at. The current ->end_io() is called=20
> > when the request has fully completed, you want notification for each

> > chunk potentially completed.
> >=20
> > I think a better design here would be to use ->end_io() as the full=20
> > completion handler, similar to how bio->bi_end_io() works. A request

> > originating from __make_request() would set something ala:
> .....
> > instead of calling the functions manually. That would allow you to=20
> > get notification right at the beginning and do what you need,=20
> > without adding a special hook for this.
>=20
> I thought his comment was reasonable.
> So I modified the patches based on his suggestion.
>=20
>=20
> WHAT IS CHANGED
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> The change is basically illustlated by the following pseudo code:
>=20
> [Before]
>   if (end_that_request_{first/chunk} succeeds) { <-- completes bios
>      <do something driver specific>
>      end_that_request_last() <-- calls end_io()
>      <the request is free from the driver>
>   } else {
>      <the request was incomplete, retry for leftover or ignoring>
>   }
>=20
> [After]
>   if (blk_end_request() succeeds) { <-- calls end_io(), completes bios
>      <the request is free from the driver>
>   } else {
>      <the request was incomplete, retry for leftover or ignoring>
>   }
>=20
>=20
> In detail, request completion procedures are changed like below.
>=20
> [Before]
>   o 2 steps completion using end_that_request_{first/chunk}
>     and end_that_request_last().
>   o Device drivers have ownership of a request until they
>     call end_that_request_last().
>   o rq->end_io() is called at the last stage of
>     end_that_request_last() for some block layer codes need
>     specific request handling when completing it.
>=20
> [After]
>   o 1 step completion using blk_end_request().
>     (end_that_request_* are no longer used from device drivers.)
>   o Device drivers give over ownership of a request
>     when calling blk_end_request().
>     If it returns 0, the request is completed.
>     If it returns 1, the request isn't completed and
>     the ownership is returned to the device driver again.
>   o rq->end_io() is called at the top of blk_end_request() to
>     allow to hook all parts of request completion.
>     Existing users of rq->end_io() must be changed to do
>     all parts of request completion.
>=20
>=20
> EXAMPLE CODE
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Request-based Device-mapper multipath patch-set is attached as=20
> appendix, although it still needs some work and isn't ready for
review.
> It checks error of a request and retries the request using other paths

> if error is detected, before completing bios in the request.
> (See clone_end_request() in appendix#1.)

This looks good, thanks for following up on this! I've replied with
comments on changes for the core bits, the interface I quite agree with.
So if you fix up the things I ask for, I'll merge this up.

--
Jens Axboe

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org More majordomo info
at  http://vger.kernel.org/majordomo-info.html
