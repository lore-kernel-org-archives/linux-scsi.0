From: Andrew Morton <akpm@osdl.org>
Subject: ips.c warnings
Date: Sun, 16 Oct 2005 14:08:17 -0700
Message-ID: <20051016140817.4de1cc19.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:63378 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751367AbVJPVIy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Oct 2005 17:08:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@steeleye.com>


Never seen this before.

drivers/scsi/ips.c: In function `ips_scmd_buf_write':
drivers/scsi/ips.c:3665: warning: null argument where non-null required (arg 1)
drivers/scsi/ips.c: In function `ips_scmd_buf_read':
drivers/scsi/ips.c:3697: warning: null argument where non-null required (arg 2)
drivers/scsi/ips.c: In function `ips_register_scsi':

Due to

                        memcpy(IPS_SG_ADDRESS(&sg[i]), &cdata[xfer_cnt],
                               min_cnt);

I guess the compiler is saying that if IPS_SG_ADDRESS indeed evaluates to
NULL (as it is designed to do), we have an oops.

That's an x86_64 allmodconfig build, btw.
