From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] ibmvscsis: Initial IBM vSCSI Target merge for v3.2-rc1
Date: Sat, 22 Oct 2011 00:25:35 -0700
Message-ID: <1319268335.11135.50.camel@haakon2.linux-iscsi.org>
References: <1318585132-3618-1-git-send-email-nab@linux-iscsi.org>
	 <20111018090849.GA22131@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:60607 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab1JVHZv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2011 03:25:51 -0400
In-Reply-To: <20111018090849.GA22131@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Brian King <brking@linux.vnet.ibm.com>, James Bottomley <JBottomley@Parallels.com>

On Tue, 2011-10-18 at 11:08 +0200, Christoph Hellwig wrote:
> This needs a patch like the one below folded in.  In addition to not
> unessecarily offload new command mapping to the fabric thread this
> also fixes the currenly incorrect (outdated) handling of the return
> values from transport_generic_allocate_tasks.  I don't even have
> a ppc compiler at hand right now, so handle it with care.
> 
> ---
> From: Christoph Hellwig <hch@lst.de>
> Subject: ibmvscsis: do not offload new command processing to the fabric thread
> 
> tcm_queuecommand is always called from process context, so prepare the command
> in-process instead of offloading it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Hi Christoph,

Fixed some minor compile breakage with this patch.  Aside from that, I
think it looks like a reasonably safe conversion to perform the
necessary setup in tcm_queuecommand() process context instead of the
extra context switch into transport_generic_handle_cdb_map().

I've not heard Tomo-san or BR-King feedback on this for a v3.2 merge
yet, but will respin with this change included for them to review again
for next week.

Thanks,

--nab

