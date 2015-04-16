From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/3] target/file: Fix UNMAP with DIF protection support
Date: Wed, 15 Apr 2015 22:21:30 -0700
Message-ID: <1429161690.26182.28.camel@haakon3.risingtidesystems.com>
References: <1428934918-4004-1-git-send-email-akinobu.mita@gmail.com>
	 <1428934918-4004-3-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:59063 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbbDPFVa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Apr 2015 01:21:30 -0400
In-Reply-To: <1428934918-4004-3-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: target-devel@vger.kernel.org, Sagi Grimberg <sagig@mellanox.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

On Mon, 2015-04-13 at 23:21 +0900, Akinobu Mita wrote:
> When UNMAP command is issued with DIF protection support enabled,
> the protection info for the unmapped region is remain unchanged.
> So READ command for the region causes data integrity failure.
> 
> This fixes it by invalidating protection info for the unmapped region
> by filling with 0xff pattern.  This change also adds helper function
> fd_do_prot_fill() in order to reduce code duplication with existing
> fd_format_prot().
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> Cc: target-devel@vger.kernel.org
> Cc: linux-scsi@vger.kernel.org
> ---
>  drivers/target/target_core_file.c | 86 +++++++++++++++++++++++++++------------
>  1 file changed, 61 insertions(+), 25 deletions(-)
> 

Applied to for-next with CC' for v3.14.y stable.

Nice work on this series, and thanks for including detailed changelog
messages.

Thanks Akinobu!

--nab

