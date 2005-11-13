From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: 2nd question on highmem in lldd
Date: Sun, 13 Nov 2005 08:53:16 -0600
Message-ID: <1131893596.3536.1.camel@mulgrave>
References: <200511131528.41121.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:28338 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932512AbVKMOxV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Nov 2005 09:53:21 -0500
In-Reply-To: <200511131528.41121.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-scsi@vger.kernel.org

On Sun, 2005-11-13 at 15:28 +0100, Oliver Neukum wrote:
> how are failures of dma_map_sg supposed to be reported to higher layers?

return DID_REQUEUE in the host byte of the command result is probably
closest to the behaviour you want: it will requeue until another command
returns for the host which (presumably) frees up some IOMMU resources.

James


