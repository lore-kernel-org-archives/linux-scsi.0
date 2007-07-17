From: Jeff Garzik <jeff@garzik.org>
Subject: Re: block/bsg.c
Date: Mon, 16 Jul 2007 21:47:21 -0400
Message-ID: <469C1FA9.3090809@garzik.org>
References: <20070716165706.348f6bbf.akpm@linux-foundation.org>	<469C11B1.8000302@garzik.org>	<20070716175347.bea345dd.akpm@linux-foundation.org>	<469C1423.3090908@garzik.org> <20070716180908.e15325bd.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:39037 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756081AbXGQBr0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 21:47:26 -0400
In-Reply-To: <20070716180908.e15325bd.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

hrm.  uninitialized_var(x) does not silence the warning, on my compiler=
:

[jgarzik@pretzel misc-2.6]$ rpm -q gcc
gcc-4.1.2-13.fc6

@@ -1358,6 +1358,8 @@ udf_load_partition(struct super_block *sb,=20
kernel_lb_addr
                         {
                                 kernel_lb_addr ino;

+=20
uninitialized_var(ino.partitionReferenceNum);
+
                                 if (!UDF_SB_LASTBLOCK(sb))

still yields

fs/udf/super.c: In function =91udf_fill_super=92:
fs/udf/super.c:1359: warning: =91ino.partitionReferenceNum=92 may be us=
ed=20
uninitialized in this function


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
