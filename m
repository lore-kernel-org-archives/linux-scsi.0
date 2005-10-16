From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: ips.c warnings
Date: Sun, 16 Oct 2005 17:44:48 -0500
Message-ID: <1129502688.9388.1.camel@mulgrave>
References: <20051016140817.4de1cc19.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:40365 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932078AbVJPWo5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Oct 2005 18:44:57 -0400
In-Reply-To: <20051016140817.4de1cc19.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org

On Sun, 2005-10-16 at 14:08 -0700, Andrew Morton wrote:
> drivers/scsi/ips.c: In function `ips_scmd_buf_write':
> drivers/scsi/ips.c:3665: warning: null argument where non-null required (arg 1)
> drivers/scsi/ips.c: In function `ips_scmd_buf_read':
> drivers/scsi/ips.c:3697: warning: null argument where non-null required (arg 2)
> drivers/scsi/ips.c: In function `ips_register_scsi':
> 
> Due to
> 
>                         memcpy(IPS_SG_ADDRESS(&sg[i]), &cdata[xfer_cnt],
>                                min_cnt);
> 
> I guess the compiler is saying that if IPS_SG_ADDRESS indeed evaluates to
> NULL (as it is designed to do), we have an oops.

That's weird ... the compiler can't possibly be in a position to make
that judgement call.  We have lots of places where we return null if
something goes wrong and the kernel oopses.  The compiler certainly
isn't warning about all of them.

James


