From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: increasing scsi_max_sg / max_segments for scsi writes/reads
Date: Sun, 10 Apr 2005 18:41:56 -0700
Message-ID: <20050410184156.3014a2ea.rddunlap@osdl.org>
References: <20050410023552.2545.qmail@web54101.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:58086 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261306AbVDKBmE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Apr 2005 21:42:04 -0400
In-Reply-To: <20050410023552.2545.qmail@web54101.mail.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sai narasimhamurthy <sai_narasi@yahoo.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sat, 9 Apr 2005 19:35:52 -0700 (PDT) sai narasimhamurthy wrote:

| Hi, 
| I had posted a question on increasing the scsi
| read/write sectors  per command. I figured out some of
| the things, but many questions still exist. 
| 
| I was wondering why the maximum writes I could get
| from a single scsi write command could never exceed
| 204 
| 4096B  segments . I traced it to :  
| 
| static const int scsi_max_sg = PAGE_SIZE /
| sizeof(struct scatterlist)
| 
| in scsi_merge.c .(which amounts to 204)  
| 
| Is this the limit of the maximum blocks we can
| read/write through a single scsi command, atleast for
| the given kernel (2.4.29) ? How can I increase
| it??????
| 
| I am on a P3 Dell poweredgde 2400 . 

Did you read the comment immediately above that
calculation?

/*
 * scsi_malloc() can only dish out items of PAGE_SIZE or less, so we cannot
 * build a request that requires an sg table allocation of more than that.
 */

so scsi_malloc() would need some reworking to handle more.

OTOH, it appears that this is all removed in 2.6.10++, so moving to
2.6.recent is probably your best choice.

---
~Randy
