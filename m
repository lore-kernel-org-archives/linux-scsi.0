From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 7/7] aacraid: sgraw command support
Date: Thu, 04 Aug 2005 10:17:05 +0200
Message-ID: <1123143426.3318.5.camel@laptopd505.fenrus.org>
References: <1123108789.24945.41.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:38346 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261973AbVHDISF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2005 04:18:05 -0400
In-Reply-To: <1123108789.24945.41.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

On Wed, 2005-08-03 at 15:39 -0700, Mark Haverkamp wrote:
> +               psg->sg[0].addr[1] = cpu_to_le32((u32)(addr>>32));

this is very risky code; if addr is a 32 bit entity, then this is
undefined behavior (which due to the vagities of x86 asm might get
optimized out entirely). It is a lot safer to do (addr>>16)>>16

gcc will optimize that just fine, the difference is that it's still
defined C behavior regardless of the type of addr.


