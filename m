From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] - mpt fusion - mptspi - host reset, kick off
	domainvalidation again.
Date: Wed, 19 Apr 2006 18:45:21 -0400
Message-ID: <1145486721.4003.11.camel@mulgrave.il.steeleye.com>
References: <664A4EBB07F29743873A87CF62C26D700813E8@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:33958 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751303AbWDSWpb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Apr 2006 18:45:31 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D700813E8@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 2006-04-19 at 15:14 -0600, Moore, Eric wrote:
> -       if (mpt_reset_register(mptspiDoneCtx, mptscsih_ioc_reset) ==
> 0) {
> +       if (mpt_reset_register(mptspiDoneCtx, mptspi_ioc_reset) == 0)
> {

I haven't followed all the paths, but I'm fairly certain
mptspi_ioc_reset can be invoked from interrupt context, can't it?  In
which case it has to use spi_schedule_dv() to get the necessary user
context to perform the DV.

James


