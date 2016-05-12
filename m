From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: RE: [PATCH] megaraid: add scsi_cmnd NULL check before use
Date: Thu, 12 May 2016 18:05:23 +0530
Message-ID: <410ee24683f9720077661b90b0472ce7@mail.gmail.com>
References: <1462668011.32105.7.camel@petros-ultrathin> <alpine.LNX.2.00.1605081235490.19865@nippy.intranet>
 <20160509080551.GH29510@mwanda> <3aced88f2434c8dd0a8aa4fd902445a9@mail.gmail.com>
 <1462829338.1873.4.camel@petroskoutoupis.com> <166e07c6f96724c0d1f972f2a65d0a65@mail.gmail.com>
 <1463017791.5827.4.camel@petros-ultrathin> <20160512062948.GG19274@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:32876 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbcELMfZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 May 2016 08:35:25 -0400
Received: by mail-oi0-f47.google.com with SMTP id v145so116680053oie.0
        for <linux-scsi@vger.kernel.org>; Thu, 12 May 2016 05:35:25 -0700 (PDT)
In-Reply-To: <20160512062948.GG19274@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Petros Koutoupis <petros@petroskoutoupis.com>
Cc: Finn Thain <fthain@telegraphics.com.au>, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Thursday, May 12, 2016 12:05 PM
> To: Petros Koutoupis
> Cc: Sumit Saxena; Finn Thain; kashyap.desai@avagotech.com;
> sumit.saxena@avagotech.com; uday.lingala@avagotech.com;
> megaraidlinux.pdl@avagotech.com; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH] megaraid: add scsi_cmnd NULL check before use
>
> On Wed, May 11, 2016 at 08:49:51PM -0500, Petros Koutoupis wrote:
> > Sumit,
> >
> > I will resubmit the patch with all the recommendations. Thank you. In
> > case you are interested, I have a crash file showcasing the error. I
> > can always provide this outside of this mailing thread.
> >
>
> Please send it to the thread.
>
> To be honest, I totally can't understand this thread.  Sumit says it is
impossible
> and you are saying that you have seen it happen in real life.
> Are you using out of tree code or something?  What are you doing that is
> unexpected?
>
> I don't see the point of adding a WARN_ON().  NULL derefs normally
generate a
> pretty clear stack trace already (unless they are caused by memory
corruption).
> Why are we not just fixing the bugs instead of warning and then
crashing.
Agree, if there scsi_cmnd is coming as NULL, please attach logs. I will
look into them.
>
> Also when I'm doing static analysis people always tell me that "that bug
is
> impossible, trust me." and instead of trusting people I really wish they
would just
> show me the relevant code that prevents it from happening.
Inside megasas_build_io_fusion() function,  driver sets "cmd->scmd"
pointer(SCSI command pointer received from SCSI mid layer). Functions
called inside megasas_build_io_fusion()(which actually builds frame to be
sent to firmware)
are setting Function type- MPI2_FUNCTION_SCSI_IO_REQUEST (or)
MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST. So in case Function type set to any
one these two, there must be valid "cmd->scmd".

Thanks,
Sumit

>
> regards,
> dan carpenter
