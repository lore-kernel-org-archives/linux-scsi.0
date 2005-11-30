From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 3/5] aacraid: update dma mapping
Date: Wed, 30 Nov 2005 12:45:27 -0600
Message-ID: <1133376327.3312.43.camel@mulgrave>
References: <1133375778.2288.23.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:15768 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751489AbVK3Spf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 13:45:35 -0500
In-Reply-To: <1133375778.2288.23.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Wed, 2005-11-30 at 10:36 -0800, Mark Haverkamp wrote:
> This patch changes map_single to map_page in compliance with
> recommendations made in the IO-Perf howto document to prevent bounce
> buffering of DMA requests.

Erm, there's a misunderstanding somewhere.  You're replacing correct
pci_map_single calls with its more difficult to use pci_map_page.  This
has absolutely zero performance impact and adds the risk that because
pci_map_page is more complex to use, someone gets it wrong somewhere.
Really, for block devices pci_map_single is the absolutely correct
interface.  pci_map_page should really only be used by the net stack for
packet fragment mapping.

James


