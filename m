From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: Yet another hot unplug NULL pointer dereference (was Re: status
 of oops in sd_revalidate_disk?)
Date: Tue, 14 Feb 2012 12:54:42 +0100
Message-ID: <CAO+b5-pCW-F1nD365TnEiAfoN7zKB4zXkk3uO6p5QyUPY2icsA@mail.gmail.com>
References: <4EE8E419.8010000@pre-sense.de>
	<CA+v9cxZFUC45WD0=+8mvH2Tq_xvX3PgaW4ttzPep0jqvqab_6w@mail.gmail.com>
	<20111225215804.03ef9402@stein>
	<4F3A46DD.8030305@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:60485 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab2BNLyo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Feb 2012 06:54:44 -0500
In-Reply-To: <4F3A46DD.8030305@ce.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, jbottomley@parallels.com, linux-scsi@vger.kernel.org, Huajun Li <huajun.li.lee@gmail.com>, Axel Theilmann <theilmann@pre-sense.de>, linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 12:34 PM, Jun'ichi Nomura
<j-nomura@ce.jp.nec.com> wrote:
> While scsi_device is propery refcounted object,
> q->queuedata is set to NULL by scsi_remove_device() asynchronously.
> So every reader of scsi_device's q->queuedata should always check it.

As far as I can see this patch narrows the race window but doesn't fix
the race. At least sd_prep_fn() still reads queuedata and if I'm not
mistaken that read races with scsi_remove_device(). Has it been
considered to modify scsi_remove_device() and scsi_request_fn() such
that device removal is communicated from the former to the latter in
another way than by clearing queuedata ?

Bart.
