From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: Re: BUG in sas event handling mechanism???
Date: Fri, 22 Sep 2006 11:17:17 -0700
Message-ID: <1158949037.5718.3.camel@alexis>
References: <20060922174046.GA18715@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:65453 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S964846AbWIVSR1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Sep 2006 14:17:27 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id k8MIHMc1023433
	for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2006 14:17:22 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k8MIHM9J225326
	for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2006 14:17:22 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k8MIHMOZ025563
	for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2006 14:17:22 -0400
In-Reply-To: <20060922174046.GA18715@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: malahal@us.ibm.com
Cc: linux-scsi@vger.kernel.org

On Fri, 2006-09-22 at 10:40 -0700, malahal@us.ibm.com wrote: 
> I see a PORTE_BYTES_DMAED event, followed by a PHYE_LOSS_OF_SIGNAL event
> and then followed by a PORTE_BYTES_DMAED event on the same phy. The code
> seems to just drop the last event because of the not yet processed first
> event. So, it just processes the first two events in that order. In
> other words, the link doesn't get used at all!
I am seeing a very similar issue with hot-plugging on the x260 systems
with the internal expanders.  If a disk is pulled and plugged back in
right away then the  PORTE_BROADCAST_RCVD event that was triggered when
the disk is plugged back in is dropped, causing the disk to never be
rediscovered.  If there is enough of a delay between unplugging and
plugging then both PORTE_BROADCAST_RCVD events are processed correctly.

Any ideas on what would cause these events to be dropped?

--Alexis

> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

