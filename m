From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Fw: [Bugme-new] [Bug 3753] New: multiple definition of
	`ST_partstat'
Date: 16 Nov 2004 13:37:06 -0600
Message-ID: <1100633837.2279.60.camel@mulgrave>
References: <20041116111905.0e0de864.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:47756 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262126AbUKPThf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Nov 2004 14:37:35 -0500
In-Reply-To: <20041116111905.0e0de864.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-11-16 at 13:19, Andrew Morton wrote:
> Problem Description:
>   LD      drivers/scsi/sd_mod.o
>   CC      drivers/scsi/sg.o
>   LD      drivers/scsi/built-in.o
> drivers/scsi/osst.o(.bss+0x0): multiple definition of `ST_partstat'
> drivers/scsi/st.o(.bss+0x0): first defined here
> make[2]: *** [drivers/scsi/built-in.o] Error 1
> make[1]: *** [drivers/scsi] Error 2
> make: *** [drivers] Error 2

Kai,

This looks like a missed piece in a typedef conversion in st.h from the
patch SCSI tape: remove remaining typedefs.

James

===== drivers/scsi/st.h 1.20 vs edited =====
--- 1.20/drivers/scsi/st.h	2004-10-25 13:32:30 -05:00
+++ edited/drivers/scsi/st.h	2004-11-16 13:30:48 -06:00
@@ -67,7 +67,7 @@
 	u32 last_block_visited;
 	int drv_block;		/* The block where the drive head is */
 	int drv_file;
-} ST_partstat;
+};
 
 #define ST_NBR_PARTITIONS 4
 

