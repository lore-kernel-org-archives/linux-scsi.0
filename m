From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] scsi: Use vzalloc instead of vmalloc/memset
Date: Wed, 8 Nov 2017 07:43:14 +0800 (CST)
Message-ID: <alpine.DEB.2.20.1711080741261.1984@hadrien>
References: <1509832586-1429-1-git-send-email-himanshujha199640@gmail.com> <20171107195136.GD22894@wotan.suse.de> <20171107210046.GA3948@himanshu-Vostro-3559>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171107210046.GA3948@himanshu-Vostro-3559>
Sender: linux-kernel-owner@vger.kernel.org
To: Himanshu Jha <himanshujha199640@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, qla2xxx-upstream@qlogic.com, kartilak@cisco.com, sebaddel@cisco.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On Wed, 8 Nov 2017, Himanshu Jha wrote:

> On Tue, Nov 07, 2017 at 08:51:36PM +0100, Luis R. Rodriguez wrote:
> > On Sun, Nov 05, 2017 at 03:26:26AM +0530, Himanshu Jha wrote:
> > > Use vzalloc instead of vmalloc/memset to allocate memory filled with 0
> > > value.
> > >
> > > Done using Coccinelle.
> > > Semantic patch used :
> > >
> > > @@
> > > expression x,a;
> > > statement S;
> > > @@
> > >
> > > - x = vmalloc(a);
> > > + x = vzalloc(a);
> > >   if (x == NULL || ...) S
> > > - memset(x, 0, a);
> >
> > How many false positives do you get? Have you identified any?
> > If not you should consider adding this SmPL rule to:
> >
> > scripts/coccinelle/api/
> >
> > Some maintainers may ask you for the SmPL rule to be upstream first,
> > not all though. So its good practice for you to strive for this.
> > Another reason for it to go upstream is then other maintainers
> > can / should be running coccicheck against their subsystem to avoid
> > stupid regressions.
> >
> > You may want to explain for patches like these that they have been
> > tested by 0-day without any issues found.
> >
> > Also add the tag:
> >
> > Generated-by: Coccinelle SmPL
> >
> > > Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
> > > ---
> > >  drivers/scsi/bfa/bfad.c            | 3 +--
> > >  drivers/scsi/bfa/bfad_debugfs.c    | 8 ++------
> > >  drivers/scsi/qla2xxx/qla_bsg.c     | 3 +--
> > >  drivers/scsi/qla2xxx/tcm_qla2xxx.c | 5 +----
> > >  drivers/scsi/scsi_debug.c          | 6 ++----
> > >  drivers/scsi/snic/snic_trc.c       | 3 +--
> > >  6 files changed, 8 insertions(+), 20 deletions(-)
> >
> > Split this up per driver, and resend by using ./scripts/get_maintainer.pl
> > foo.patch and ensuring the right folks get the email.  Right now you
> > just spammed tons of people and the changes may be preferred to go
> > upstream atomically per driver, always assume this first.

Depending on the subsystem, you may get similar pushback if you send one
patch per file - "why send so many patches for such a small change when
they are all going through my tree".  So consider grouping the patches by
set of maintainers.

julia

> >
> > Other than this, feel free to add to each of the patches you created:
> >
>
> Thanks for the feeedback! I will resend the patch with the necessary
> changes.
>
> > Acked-by: Luis R. Rodriguez <mcgrof@kernel.org>
>
>
> Thanks
> Himanshu Jha
>
