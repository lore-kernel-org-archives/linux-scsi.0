From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: What breaks aic7xxx in post 2.6.12-rc2 ?
Date: Mon, 06 Jun 2005 13:17:36 -0500
Message-ID: <1118081857.5045.49.camel@mulgrave>
References: <20050524153930.GA10911@gmail.com>
	 <1117113563.4967.17.camel@mulgrave> <20050526143516.GA9593@gmail.com>
	 <1117118766.4967.22.camel@mulgrave> <20050526173518.GA9132@gmail.com>
	 <1117463938.4913.3.camel@mulgrave> <20050530150950.GA14351@gmail.com>
	 <1117467248.4913.9.camel@mulgrave> <20050530160147.GD14351@gmail.com>
	 <1117477040.4913.12.camel@mulgrave>  <20050530190716.GA9239@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:3732 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261629AbVFFSR7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Jun 2005 14:17:59 -0400
In-Reply-To: <20050530190716.GA9239@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?Gr=E9goire?= Favre <gregoire.favre@gmail.com>
Cc: dino@in.ibm.com, Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2005-05-30 at 21:07 +0200, Gr=E9goire Favre wrote:
> Unfortunately it don't work :

Well, OK, three things spring to mind.

1. Try the attached patch, just in case it's a perpetual timer reset
issue.
2. You should be able to boot if you set the device speed to 10MHz in
the adaptec bios (since we should read the bios values for setting the
speed)
3. when the hang occurs, can you get an alt-sysrq-p to show the current
process on CPU?

Thanks,

James

--- a/drivers/scsi/aic7xxx/aic7xxx_osm.h
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.h
@@ -277,7 +277,9 @@ ahc_timer_reset(ahc_timer_t *timer, int=20
 static __inline void
 ahc_scb_timer_reset(struct scb *scb, u_int usec)
 {
+#if 0
 	mod_timer(&scb->io_ctx->eh_timeout, jiffies + (usec * HZ)/1000000);
+#endif
 }
=20
 /***************************** SMP support ***************************=
*********/


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
