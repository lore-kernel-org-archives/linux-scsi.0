From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: 2.6.25-rc2-mm1 (cciss build error)
Date: Mon, 18 Feb 2008 09:13:57 -0800
Message-ID: <20080218091357.eb119a08.randy.dunlap@oracle.com>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:33906 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbYBRROS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Feb 2008 12:14:18 -0500
In-Reply-To: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, scsi <linux-scsi@vger.kernel.org>, mike.miller@hp.com

On Sat, 16 Feb 2008 00:25:22 -0800 Andrew Morton wrote:

> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc2/2.6.25-rc2-mm1/

cciss driver has a bad macro definition:

#else /* no CONFIG_CISS_SCSI_TAPE */

/* If no tape support, then these become defined out of existence */

#define cciss_scsi_setup(cntl_num)
#define cciss_unregister_scsi(ctlr)
#define cciss_register_scsi(ctlr)
#define cciss_seq_tape_report(struct seq_file *seq, int ctlr)

#endif /* CONFIG_CISS_SCSI_TAPE */

which causes this error:

In file included from /local/linsrc/linux-2.6.25-rc2-mm1/drivers/block/cciss.c:231:
/local/linsrc/linux-2.6.25-rc2-mm1/drivers/block/cciss_scsi.c:1498:38: error: macro parameters must be comma-separated
make[3]: *** [drivers/block/cciss.o] Error 1

---
~Randy
