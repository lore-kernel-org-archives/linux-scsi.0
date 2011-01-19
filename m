From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] [SCSI] megaraid_sas: Sanity check user supplied length
 before passing it to dma_alloc_coherent()
Date: Wed, 19 Jan 2011 17:12:00 +0900
Message-ID: <20110119165809X.fujita.tomonori@lab.ntt.co.jp>
References: <8739op51hr.fsf@nemi.mork.no>
	<4B6A08C587958942AA3002690DD4F8C30106FA7846@cosmail02.lsi.com>
	<87tyh52yi3.fsf@nemi.mork.no>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:41507 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753651Ab1ASIM0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Jan 2011 03:12:26 -0500
In-Reply-To: <87tyh52yi3.fsf@nemi.mork.no>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bjorn@mork.no
Cc: Bo.Yang@lsi.com, linux-scsi@vger.kernel.org, megaraidlinux@lsi.com, James.Bottomley@suse.de

On Wed, 19 Jan 2011 07:33:56 +0100
**UNKNOWN CHARSET** <bjorn@mork.no> wrote:

> Both users have confirmed that the patch fixes their problem. One could
> of course imagine a workaround in the smartctl application so that it
> never sent requests with a zero iov_len, but I still believe that
> actually fixing the driver to handle such requests is better.

The patch looks fine to me. dma_alloc_coherent() doesn't take zero for
the size argument (causes a kernel crash). The driver can't assume
that an applications is sane so it needs to check the size that an
application passed on.

Unfortunately, your patch can't be applied to the latest git. I think
that you need to submit the updated patch first. After it's merged,
you can send stable maintainers the modified patch that can be applied
to stable kernels.

Btw, about your patch, it's better to use "if (!hoge)" instead of "if
(hoge == 0)" and kbuff_arr[] is initialized so seems that you don't
need to reset it again. The updated patch would be something like:

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 5d6d07b..cee1d3b 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4611,6 +4611,9 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 	 * For each user buffer, create a mirror buffer and copy in
 	 */
 	for (i = 0; i < ioc->sge_count; i++) {
+		if (!ioc->sgl[i].iov_len)
+			continue;
+
 		kbuff_arr[i] = dma_alloc_coherent(&instance->pdev->dev,
 						    ioc->sgl[i].iov_len,
 						    &buf_handle, GFP_KERNEL);
