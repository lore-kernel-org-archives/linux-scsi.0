From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] target: Prevent cmd->se_queue_node double add
Date: Sat, 8 Oct 2011 21:24:14 -0400
Message-ID: <20111009012414.GA32104@infradead.org>
References: <1317358511-10664-1-git-send-email-nab@linux-iscsi.org>
 <1317358511-10664-2-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:43006
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751170Ab1JIBYQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Oct 2011 21:24:16 -0400
Content-Disposition: inline
In-Reply-To: <1317358511-10664-2-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, Andy Grover <agrover@redhat.com>

> +	/* If the cmd is already on the list, remove it before we add it */
> +	if (!list_empty(&cmd->se_queue_node))
> +		list_del(&cmd->se_queue_node);
> +	else
> +		atomic_inc(&qobj->queue_cnt);
> +

This is not an overly useful comment, as it states the obvious, aka what
we are doing here.  It is much better to explain why the semingly
unexpected (re-adding the same cmd) might be valid under certain
circumstances.  Even better would be asserts that we only do it under
those circumstances.

