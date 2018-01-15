From: Max Kellermann <mk@cm4all.com>
Subject: Re: [PATCH] drivers/scsi/qla2xxx: fix double free bug after firmware
 timeout
Date: Mon, 15 Jan 2018 21:37:27 +0100
Message-ID: <20180115203726.b7igf7rajczllcv7@rabbit.intern.cm-ag>
References: <151603716189.28707.13105191089826357709.stgit@rabbit.intern.cm-ag>
 <13B82B86-8810-4722-97F9-EC5B862ECC76@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nibbler.cm4all.net ([82.165.145.151]:60562 "EHLO
        nibbler.cm4all.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750710AbeAOUhd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jan 2018 15:37:33 -0500
Received: from localhost (localhost [127.0.0.1])
        by nibbler.cm4all.net (Postfix) with ESMTP id A727FC0307
        for <linux-scsi@vger.kernel.org>; Mon, 15 Jan 2018 21:37:27 +0100 (CET)
Received: from nibbler.cm4all.net ([127.0.0.1])
        by localhost (nibbler.cm4all.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id 5abcTjEmA1lf for <linux-scsi@vger.kernel.org>;
        Mon, 15 Jan 2018 21:37:27 +0100 (CET)
Received: from zero.intern.cm-ag (zero.intern.cm-ag [172.30.16.10])
        by nibbler.cm4all.net (Postfix) with SMTP id 7F93CC032B
        for <linux-scsi@vger.kernel.org>; Mon, 15 Jan 2018 21:37:27 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <13B82B86-8810-4722-97F9-EC5B862ECC76@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Cc: Max Kellermann <mk@cm4all.com>, Greg KH <gregkh@linuxfoundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@cavium.com>, "max.kellermann@gmail.com" <max.kellermann@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On 2018/01/15 20:58, "Madhani, Himanshu" <Himanshu.Madhani@cavium.com> wrote:
> We have patch to prevent this double free in 4.16/scsi-queue
> already.

No, let me repeat: this is a different bug!

Your bug is about the free call after waiting for completion
synchronously in qla24xx_els_dcmd_iocb(), after it was already freed
by qla2x00_sp_timeout().

My bug is about free in qla2x00_*_sp_done() and again in
qla2x00_sp_timeout().  My patch description describes exactly that.

And you know what?  My patch fixes both bugs.  It is superior to the
one that was merged 4 weeks later, isn't it?

You NACKed my patch 5 weeks ago, and I explained to you that you were
talking about a different bug, but you never replied to that.

Max
