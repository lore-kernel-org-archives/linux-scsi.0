From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: merge megaraid 2.20.x in kernel 2.6?
Date: 17 Aug 2004 12:40:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1092760835.1775.303.camel@mulgrave>
References: <20040817160128.GA7127@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:21420 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268337AbUHQQkn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Aug 2004 12:40:43 -0400
In-Reply-To: <20040817160128.GA7127@lists.us.dell.com>
List-Id: linux-scsi@vger.kernel.org
To: Matt Domsch <Matt_Domsch@Dell.com>, atulm@lsil.com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-08-17 at 12:01, Matt Domsch wrote:
> James, is there anything you're still waiting on before merging the
> LSI megaraid 2.20.x driver into your scsi-misc-2.6 tree?  I thought
> the agreement by you, Christoph, and Atul was to get it merged, and
> then fix up the few outstanding concerns post-merge.

OK, I forgot in the rush of conferences.

I did put it in, but it fails to compile on parisc:

In file included from drivers/scsi/megaraid/megaraid_mm.c:18:
drivers/scsi/megaraid/megaraid_mm.h:51:25: asm/ioctl32.h: No such file
or directory
drivers/scsi/megaraid/megaraid_mm.c: In function `mraid_mm_init':
drivers/scsi/megaraid/megaraid_mm.c:1069: warning: implicit declaration
of function `register_ioctl32_conversion'
drivers/scsi/megaraid/megaraid_mm.c: In function `mraid_mm_exit':
drivers/scsi/megaraid/megaraid_mm.c:1098: warning: implicit declaration
of function `unregister_ioctl32_conversion'
make[3]: *** [drivers/scsi/megaraid/megaraid_mm.o] Error 1
make[2]: *** [drivers/scsi/megaraid] Error 2
make[1]: *** [drivers/scsi] Error 2
make: *** [drivers] Error 2

It looks like the compat ioctl infrastructure is incorrect.

James


