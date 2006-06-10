From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] Remove last page_address from dc395x.c
Date: Sat, 10 Jun 2006 03:54:25 +0200
Message-ID: <1149904465.3131.19.camel@laptopd505.fenrus.org>
References: <Pine.LNX.4.60.0606092216460.5256@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vbn.0050556.lodgenet.net ([216.142.194.234]:7334 "EHLO
	vbn.0050556.lodgenet.net") by vger.kernel.org with ESMTP
	id S1751320AbWFJByd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Jun 2006 21:54:33 -0400
In-Reply-To: <Pine.LNX.4.60.0606092216460.5256@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Jamie Lenehan <lenehan@twibble.org>, linux-scsi@vger.kernel.org

On Fri, 2006-06-09 at 22:25 +0200, Guennadi Liakhovetski wrote:
> +
> +		if (cmd->use_sg) {
> +			struct scatterlist* sg = (struct scatterlist *)cmd->request_buffer;
> +			size_t offset = 0, len = sizeof(struct ScsiInqData);
> +
> +			local_irq_save(flags);
> +			base = scsi_kmap_atomic_sg(sg, cmd->use_sg, &offset, &len);
> +			ptr = (struct ScsiInqData *)(base + offset);
> +		} else
> +			ptr = (struct ScsiInqData *)(cmd->request_buffer);

hmm I wonder if the non-use-sg case can ever happen?
(and if that irq_save isn't leaking here)


