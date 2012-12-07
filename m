From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH][RFC] scsi_transport_fc: Implement I_T nexus reset
Date: Fri, 07 Dec 2012 15:20:37 -0600
Message-ID: <50C25DA5.6040508@cs.wisc.edu>
References: <1354891880-16159-1-git-send-email-hare@suse.de> <50C23C5A.9090907@cs.wisc.edu> <alpine.WNT.2.00.1212071451330.6432@N5102REMCQXM4BS.qlogic.org> <50C25A29.9030904@tributary.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:38951 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030866Ab2LGVVf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Dec 2012 16:21:35 -0500
In-Reply-To: <50C25A29.9030904@tributary.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jlinton@tributary.com>
Cc: chad.dupuis@qlogic.com, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 12/07/2012 03:05 PM, Jeremy Linton wrote:
> On 12/7/2012 1:58 PM, Chad Dupuis wrote:
>> Also, are there certain port types we wouldn't want to send this reset to 
>> such as tape?
> 
> 	AFAIK, for tape it shouldn't cause any more harm than the target reset which
> happens immediately before it. This patch is infinitely better than the
> previous "bus" reset behavior.
> 
> 	That said, its far from perfect. The code (as I understand it) isn't
> differentiating between isolating the failure, or bringing out the big
> hammer in an attempt to correct problems on a specific I_T_L. If you
> drop/reset the I_T because one of the LUN's is misbehaving before verifying
> the status of other LUN's on the target, you risk interrupting operations to
> functional devices.
> 

When this code is called the scsi eh has run the abort handler for each
outstanding command and that has failed, and it has run the lun/device
reset handler and that has failed (or the eh operations succeeded but
the TUR checkup the scsi eh does failed).

