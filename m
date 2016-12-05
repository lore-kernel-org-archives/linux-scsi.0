From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 2/6] qla2xxx: Fix mailbox command timeout due to
 starvation
Date: Mon, 5 Dec 2016 08:03:50 -0800
Message-ID: <20161205160350.GB11206@infradead.org>
References: <1480715097-13611-1-git-send-email-himanshu.madhani@cavium.com>
 <1480715097-13611-3-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44973 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751496AbcLEQFQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2016 11:05:16 -0500
Content-Disposition: inline
In-Reply-To: <1480715097-13611-3-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org

On Fri, Dec 02, 2016 at 01:44:53PM -0800, Himanshu Madhani wrote:
> From: Samy <samy@purestorage.com>
> 
> This patch helps resolve some of the mailbox timeout issue discovered
> during large SAN emulation testing where 1000+ initiators are trying
> to log into target mode personality. Since current mailbox interface
> handles submission and processing of commands in a sequential order,
> command could timeout resulting in some initiator not being able to
> log into target.

How does the patch hange anything?  You're still synchronously
waiting for the command, it's just that the command processing
is offloaded to a workqueue now.
