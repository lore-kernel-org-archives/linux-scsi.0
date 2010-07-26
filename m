From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: improper use of the notifier API in scsi_dh_notifier()
Date: Mon, 26 Jul 2010 09:05:28 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1007260859380.9816@axis700.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:52960 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753503Ab0GZHFV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jul 2010 03:05:21 -0400
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1OdHke-0004lF-Nv
	for linux-scsi@vger.kernel.org; Mon, 26 Jul 2010 09:05:28 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi

There seem to be a couple of bogus notifier API uses in the kernel, 
specifically, wrong return codes from the notifier routine. One of them is 
in scsi_dh_notifier(), which can return a negative error code, which is 
not what you're supposed to return from a notifier routine. Apart from 
being just a wrong use of the API, this also will trigger the

	if ((ret & NOTIFY_STOP_MASK) == NOTIFY_STOP_MASK)

test in notifier_call_chain() and thus prevent further notifiers from 
being called. Am I missing something?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
