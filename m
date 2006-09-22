From: malahal@us.ibm.com
Subject: BUG in sas event handling mechanism???
Date: Fri, 22 Sep 2006 10:40:46 -0700
Message-ID: <20060922174046.GA18715@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:11963 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S964820AbWIVRkz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Sep 2006 13:40:55 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id k8MHesD8021975
	for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2006 13:40:54 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k8MHesog278198
	for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2006 13:40:54 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k8MHesRH004622
	for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2006 13:40:54 -0400
Received: from malahal.beaverton.ibm.com (malahal.beaverton.ibm.com [9.47.17.93])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k8MHes6B004216
	for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2006 13:40:54 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I see a PORTE_BYTES_DMAED event, followed by a PHYE_LOSS_OF_SIGNAL event
and then followed by a PORTE_BYTES_DMAED event on the same phy. The code
seems to just drop the last event because of the not yet processed first
event. So, it just processes the first two events in that order. In
other words, the link doesn't get used at all!

Of course, I get timeouts because of Vitesse/AIC94xx combination while
doing discovery. :-(

Maybe, this is what Luben is talking about when he said,
"Priority Queue Without Duplication Implementation"?

Thanks, Malahal.
