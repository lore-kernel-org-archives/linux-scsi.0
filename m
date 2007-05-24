From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH v2] add bidi support for block pc requests
Date: Thu, 24 May 2007 19:37:06 +0300
Message-ID: <4655BF32.2020403@panasas.com>
References: <20070517054811.GV23798@kernel.dk>	<20070517145958P.fujita.tomonori@lab.ntt.co.jp>	<464C1721.8030009@panasas.com> <20070517201243E.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:40768 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750728AbXEXQiT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 May 2007 12:38:19 -0400
In-Reply-To: <20070517201243E.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James.Bottomley@SteelEye.com
Cc: jens.axboe@oracle.com, linux-scsi@vger.kernel.org, bhalevy@panasas.com, hch@infradead.org, akpm@linux-foundation.org, michaelc@cs.wisc.edu

FUJITA Tomonori wrote:
>> FUJITA Tomonori wrote:
> 
> One thing that I found is:
> 
> +#define scsi_resid(cmd) ((cmd)->sg_table->resid)
> 
> 
> This doesn't work for some drivers (at least ipr) since they set
> cmd->resid even with commands without data transfer.
> 

James, Tomo.

the last accessor:
+#define scsi_resid(cmd) ((cmd)->resid)

used as an l-value in drivers does not serve our purpose, as seen by the test
implementation of scsi_sg_table. Now clearly this needs an accessor and it is a
bidi parameter (need 2 of them).

I would suggest doing a set_ inline accessor and using that in drivers:
+static inline void scsi_set_resid(struct scsi_cmnd *cmd, resid)
+{
+	cmd->resid = resid;
+}

I would even suggest to make all accessors inlines and not macros just to make sure
they are not used as l-value and modified. Though I have not seen such use in
Tomo's patchset.

example:
+static inline unsigned scsi_bufflen(struct scsi_cmnd *cmd)
+{
+	return cmd->request_bufflen;
+}

Boaz
