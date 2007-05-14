From: Benny Halevy <bhalevy@panasas.com>
Subject: Re: [PATCH 1/19] add data buffer accessors
Date: Mon, 14 May 2007 10:57:08 +0300
Message-ID: <46481654.7060101@panasas.com>
References: <20070512182805L.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:33064 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754550AbXENH50 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 May 2007 03:57:26 -0400
In-Reply-To: <20070512182805L.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, hch@infradead.org

FUJITA Tomonori wrote:
> +#define scsi_for_each_sg(cmd, sg, nseg, __i)			\
> +	for (__i = 0, sg = scsi_sglist(cmd); __i < (nseg); __i++, (sg)++)
> +

This feels like a layering violation, why not use for_each_sg()?

+#define scsi_for_each_sg(cmd, sg, nseg, __i)			\
	for_each_sg(scsi_sglist(cmd), (sg), (nseg), (__i))	\

That said, I'm not sure that scsi_for_each_sg() is worth abstracting
since the caller can just as well do for_each_sg() directly
as sketched above...

Benny
