From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCH][RFC] scsi_transport_fc: Implement I_T nexus reset
Date: Fri, 7 Dec 2012 15:05:45 -0600
Message-ID: <50C25A29.9030904@tributary.com>
References: <1354891880-16159-1-git-send-email-hare@suse.de> <50C23C5A.9090907@cs.wisc.edu> <alpine.WNT.2.00.1212071451330.6432@N5102REMCQXM4BS.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.52]:55115 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424337Ab2LGVFs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Dec 2012 16:05:48 -0500
In-Reply-To: <alpine.WNT.2.00.1212071451330.6432@N5102REMCQXM4BS.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: chad.dupuis@qlogic.com, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 12/7/2012 1:58 PM, Chad Dupuis wrote:
> Also, are there certain port types we wouldn't want to send this reset to 
> such as tape?

	AFAIK, for tape it shouldn't cause any more harm than the target reset which
happens immediately before it. This patch is infinitely better than the
previous "bus" reset behavior.

	That said, its far from perfect. The code (as I understand it) isn't
differentiating between isolating the failure, or bringing out the big
hammer in an attempt to correct problems on a specific I_T_L. If you
drop/reset the I_T because one of the LUN's is misbehaving before verifying
the status of other LUN's on the target, you risk interrupting operations to
functional devices.






