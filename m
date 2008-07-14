From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] advansys: use request_firmware
Date: Mon, 14 Jul 2008 07:56:44 -0700
Message-ID: <1216047404.27455.31.camel@shinybook.infradead.org>
References: <1215770322.2733.12.camel@jaswinder.satnam>
	 <20080712162921.GZ14894@parisc-linux.org>
	 <1215882548.19076.57.camel@jaswinder.satnam>
	 <20080714145033.GD14894@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47237 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755694AbYGNO4t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jul 2008 10:56:49 -0400
In-Reply-To: <20080714145033.GD14894@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jaswinder Singh <jaswinder@infradead.org>, LKML <linux-kernel@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, kernel-janitors <kernel-janitors@vger.kernel.org>, kernelnewbies <kernelnewbies@nl.linux.org>, linux-scsi@vger.kernel.org, hch@infradead.org

On Mon, 2008-07-14 at 08:50 -0600, Matthew Wilcox wrote:
> I'm not quite sure whether my question was answered ...
> 
> When firmware is built in, does
> 1) request_firmware() make a copy of it and then release_firmware free
>    that copy?
> 2) request_firmware() return a pointer to the built-in firmware with
>    release_firmware() being a no-op?
> 3) request_firmware() return a pointer to the built-in firmware with
>    release_firmware() freeing the original?
> 
> Cases 1 and 2 are fine, case 3 is a problem.

Effectively (2).

Actually we do allocate and free the 'struct firmware' but fw->data is
just pointed to the original blob, and then that blob doesn't get freed.

-- 
dwmw2

