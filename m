From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 3/3] target: Minor sparse warning fixes and annotations
Date: Mon, 24 Jan 2011 14:56:07 -0600
Message-ID: <1295902567.15425.13.camel@mulgrave.site>
References: <1295901446-17089-1-git-send-email-nab@linux-iscsi.org>
	 <1295901446-17089-4-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40444 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751892Ab1AXU4K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jan 2011 15:56:10 -0500
In-Reply-To: <1295901446-17089-4-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Fubo Chen <fubo.chen@gmail.com>, Christoph Hellwig <hch@lst.de>

On Mon, 2011-01-24 at 12:37 -0800, Nicholas A. Bellinger wrote:
> -#define TASK_CMD(task) ((struct se_cmd *)task->task_se_cmd)
> -#define TASK_DEV(task) ((struct se_device *)task->se_dev)
> +#define TASK_CMD(task) ((task)->task_se_cmd)
> +#define TASK_DEV(task) ((task)->se_dev)

If sparse is objecting to things like this then sparse needs fixing:
It's decreasing typesafety.  the things being cast are void * ... they'd
be depositable into any pointer whatsoever without the cast.  With the
cast in the #define, we pick up pointer mismatches (as we should).
Without it, we don't.  As long as the define is always a specific type,
it *should* cast to it.

James




