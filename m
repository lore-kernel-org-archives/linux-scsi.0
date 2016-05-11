From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: RE: [PATCH] megaraid: add scsi_cmnd NULL check before use
Date: Wed, 11 May 2016 15:11:19 +0530
Message-ID: <166e07c6f96724c0d1f972f2a65d0a65@mail.gmail.com>
References: <1462668011.32105.7.camel@petros-ultrathin>	 <alpine.LNX.2.00.1605081235490.19865@nippy.intranet>
	 <20160509080551.GH29510@mwanda>	 <3aced88f2434c8dd0a8aa4fd902445a9@mail.gmail.com>
 <1462829338.1873.4.camel@petroskoutoupis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:33645 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131AbcEKJlW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 May 2016 05:41:22 -0400
Received: by mail-oi0-f49.google.com with SMTP id v145so58495642oie.0
        for <linux-scsi@vger.kernel.org>; Wed, 11 May 2016 02:41:22 -0700 (PDT)
In-Reply-To: <1462829338.1873.4.camel@petroskoutoupis.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Petros Koutoupis <petros@petroskoutoupis.com>, Dan Carpenter <dan.carpenter@oracle.com>, Finn Thain <fthain@telegraphics.com.au>
Cc: kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Petros Koutoupis [mailto:petros@petroskoutoupis.com]
> Sent: Tuesday, May 10, 2016 2:59 AM
> To: Sumit Saxena; Dan Carpenter; Finn Thain
> Cc: kashyap.desai@avagotech.com; sumit.saxena@avagotech.com;
> uday.lingala@avagotech.com; megaraidlinux.pdl@avagotech.com; linux-
> scsi@vger.kernel.org
> Subject: Re: [PATCH] megaraid: add scsi_cmnd NULL check before use
>
> On Mon, 2016-05-09 at 15:18 +0530, Sumit Saxena wrote:
> > >
> > > -----Original Message-----
> > > From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> > > Sent: Monday, May 09, 2016 1:36 PM
> > > To: Finn Thain
> > > Cc: Petros Koutoupis; kashyap.desai@avagotech.com;
> > > sumit.saxena@avagotech.com; uday.lingala@avagotech.com;
> > > megaraidlinux.pdl@avagotech.com; linux-scsi@vger.kernel.org
> > > Subject: Re: [PATCH] megaraid: add scsi_cmnd NULL check before use
> > >
> > > Smatch doesn't quite catch it because we check "cmd_fusion->scmd"
> > > for
> > NULL
> > >
> > > then assign "scmd_local = cmd_fusion->scmd;" and dereference
> > > scmd_local unconditionally...
> > >
> > > It does catch part of the bug if you have cross function analysis:
> > >
> > >   drivers/scsi/megaraid/megaraid_sas_fusion.c:2318
> > > complete_cmd_fusion()
> > >   error: we previously assumed 'cmd_fusion->scmd' could be null (see
> > line 2281)
> > >
> > >
> > > But that code was from 2010 so I never reported it to the original
> > author or the
> > >
> > > list.
> > "cmd_fusion->scmd" should not be NULL if scsi_io_req->Function is set
> > to MPI2_FUNCTION_SCSI_IO_REQUEST (OR)
> > MEGASAS_MPI2_FUNCTION_LD_IO_REQUES
> > (inside these two cases only, cmd_fusion->scmd will be dereferenced).
> > If cmd_fusion->scmd is NULL for these "scsi_io_req->Function", that
> > will a BUG and should not continue with other commands processing in
> > that case.
> >
>
> Sumit,
>
> To clarify, a detection of cmd_fusion->scmd being NULL with scsi_io_req-
> >Function set to MPI2_FUNCTION_SCSI_IO_REQUEST or
> MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST should instead trigger a
> BUG() and not attempt to iterate to the next command in the list. Thank
> you.

Petros,

WARN_ON() can be used in this case. Upstream may have concerns on using
BUG_ON() and also BUG_ON() won't help in this case. In production
environment we never encountered this.

Thanks,
Sumit
>
> --
> Petros
