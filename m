From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: RE: [PATCH] megaraid: add scsi_cmnd NULL check before use
Date: Mon, 9 May 2016 15:18:55 +0530
Message-ID: <3aced88f2434c8dd0a8aa4fd902445a9@mail.gmail.com>
References: <1462668011.32105.7.camel@petros-ultrathin> <alpine.LNX.2.00.1605081235490.19865@nippy.intranet>
 <20160509080551.GH29510@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:33327 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbcEIJs5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 May 2016 05:48:57 -0400
Received: by mail-oi0-f52.google.com with SMTP id v145so203797995oie.0
        for <linux-scsi@vger.kernel.org>; Mon, 09 May 2016 02:48:56 -0700 (PDT)
In-Reply-To: <20160509080551.GH29510@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Finn Thain <fthain@telegraphics.com.au>
Cc: Petros Koutoupis <petros@petroskoutoupis.com>, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Monday, May 09, 2016 1:36 PM
> To: Finn Thain
> Cc: Petros Koutoupis; kashyap.desai@avagotech.com;
> sumit.saxena@avagotech.com; uday.lingala@avagotech.com;
> megaraidlinux.pdl@avagotech.com; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH] megaraid: add scsi_cmnd NULL check before use
>
> Smatch doesn't quite catch it because we check "cmd_fusion->scmd" for
NULL
> then assign "scmd_local = cmd_fusion->scmd;" and dereference scmd_local
> unconditionally...
>
> It does catch part of the bug if you have cross function analysis:
>
>   drivers/scsi/megaraid/megaraid_sas_fusion.c:2318 complete_cmd_fusion()
>   error: we previously assumed 'cmd_fusion->scmd' could be null (see
line 2281)
>
> But that code was from 2010 so I never reported it to the original
author or the
> list.
"cmd_fusion->scmd" should not be NULL if scsi_io_req->Function is set to
MPI2_FUNCTION_SCSI_IO_REQUEST (OR) MEGASAS_MPI2_FUNCTION_LD_IO_REQUES
(inside these two cases only, cmd_fusion->scmd will be dereferenced). If
cmd_fusion->scmd is NULL for these "scsi_io_req->Function", that will a
BUG and
should not continue with other commands processing in that case.

>
> regards,
> dan carpenter
