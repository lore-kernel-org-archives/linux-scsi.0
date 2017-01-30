From: Christoph Hellwig <hch@lst.de>
Subject: sort out the ->eh_timed_out mess
Date: Mon, 30 Jan 2017 13:18:55 +0100
Message-ID: <1485778739-29036-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:53924 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751621AbdA3MTW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jan 2017 07:19:22 -0500
Received: from 80-109-146-114.cable.dynamic.surfer.at ([80.109.146.114] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cYAvI-0003oJ-Jb
        for linux-scsi@vger.kernel.org; Mon, 30 Jan 2017 12:19:05 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

We originally only supported the methods in the transport_template,
which led to problems with drivers needing it and having to fake
up a template.  Then we added it to the host to avoid that issue,
but because the transport template takes precedence we still have
various placed that need to hack around it.

This series removes the transport_template instance and switches
everyone to use the host method, similar to how we supply generic
helpers elsewhere.

In addition it removes a bit of cruft in the same area.

