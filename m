From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 2/6] qla2xxx: Fix mailbox command timeout due to
 starvation
Date: Wed, 7 Dec 2016 10:49:21 -0800
Message-ID: <20161207184921.GA1408@infradead.org>
References: <1480715097-13611-1-git-send-email-himanshu.madhani@cavium.com>
 <1480715097-13611-3-git-send-email-himanshu.madhani@cavium.com>
 <20161205160350.GB11206@infradead.org>
 <E9A30DF7-B137-47DB-BAF9-0BE28B6CBB55@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44933 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932520AbcLGStY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Dec 2016 13:49:24 -0500
Content-Disposition: inline
In-Reply-To: <E9A30DF7-B137-47DB-BAF9-0BE28B6CBB55@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Cc: Christoph Hellwig <hch@infradead.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Dec 05, 2016 at 06:37:16PM +0000, Madhani, Himanshu wrote:
> The mailbox timeout was issue here where command submitted to mailbox
> could wait  for more than time allowed to wait_for_completion.

How so?

Note that your new code will always wait until the command is completed,
because cancel_work_sync will wait for the execution of the work item
to finish.  So in terms of blocking the submitter context it will
make things worse.
