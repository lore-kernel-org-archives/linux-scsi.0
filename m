From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 1/3] scsi: Convert everyone to scsi_sglist and scsi_sg_count
Date: Thu, 03 Jan 2008 11:26:13 +0200
Message-ID: <477CAA35.3020900@panasas.com>
References: <200801031800.02537.rusty@rustcorp.com.au> <200801031950.12090.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:10599 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754769AbYACJ0t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jan 2008 04:26:49 -0500
In-Reply-To: <200801031950.12090.rusty@rustcorp.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-scsi@vger.kernel.org

On Thu, Jan 03 2008 at 10:50 +0200, Rusty Russell <rusty@rustcorp.com.au> wrote:
> This patch simply converts direct uses of ->use_sg and ->request_buffer to
> use the wrapper macros.  This removes the assumption that the sg list is
> overloaded on request_buffer, and that there's an explicit use_sg field.
> 
> The ->request_buffer assumption is explicit in scsi_debug.c's paranoid
> checking, so that code had to be shuffled a little.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  drivers/scsi/NCR5380.c       |    6 +++---
>  drivers/scsi/NCR53C9x.c      |    6 +++---
>  drivers/scsi/aha1542.c       |   14 +++++++-------
>  drivers/scsi/atari_NCR5380.c |    2 +-
>  drivers/scsi/atp870u.c       |   22 +++++++++++-----------
>  drivers/scsi/eata_pio.c      |    6 +++---
>  drivers/scsi/fd_mcs.c        |    6 +++---
>  drivers/scsi/imm.c           |    5 ++---
>  drivers/scsi/in2000.c        |    6 +++---
>  drivers/scsi/libsrp.c        |   12 ++++++------
>  drivers/scsi/pcmcia/nsp_cs.c |    8 ++++----
>  drivers/scsi/ppa.c           |    4 ++--
>  drivers/scsi/qlogicpti.c     |   12 ++++++------
>  drivers/scsi/scsi_debug.c    |   14 +++++++-------
>  drivers/scsi/seagate.c       |    4 ++--
>  drivers/scsi/sr.c            |    6 +++---
>  drivers/scsi/sun3_NCR5380.c  |    6 +++---
>  drivers/scsi/sun3x_esp.c     |    4 ++--
>  drivers/scsi/wd33c93.c       |    6 +++---
>  21 files changed, 77 insertions(+), 76 deletions(-)
> 

All of these drivers are properly converted in current scsi-misc + scsi-pending.
If you are really serious about changing scsi-layer you better work ontop of
scsi git trees.

Also you can inspect -mm tree it has the scsi_data_buffer patches that does
4/5 what you want.

Boaz

