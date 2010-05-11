From: Michael Stroucken <mxs@cmu.edu>
Subject: RE: Possible explanation for mptsas ATA pass-through hangs
Date: Tue, 11 May 2010 17:15:08 -0400
Message-ID: <4BE9C8DC.7060907@cmu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tamade.ascient.net ([65.99.219.195]:33656 "EHLO
	tamade.ascient.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab0EKVXb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 May 2010 17:23:31 -0400
Received: from stroop.wv.cc.cmu.edu (STROOP.WV.CC.CMU.EDU [128.237.236.97])
	by tamade.ascient.net (Postfix) with ESMTPSA id 00E39400F9
	for <linux-scsi@vger.kernel.org>; Tue, 11 May 2010 17:16:58 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have a research cluster of around 140 nodes, and have been affected by 
this problem since we put them online. The machines are Tyan boards with 
dual E54x0 CPUs and onboard SAS, with four SATA drives attached.

The half of the cluster with very high disk usage displayed this issue 
on perhaps one machine every two days, while the other half only had 
problems when SMART requests were issued. The bus would reset, and a 
drive would be logically ejected and reinserted (but at a different 
place, like /dev/sde).

Regardless of mptscsih.c being the correct place to enforce alignment, 
applying the patch Ryan Kuester provided to the kernel (2.6.32) running 
on the cluster has 1) stopped future occurrences of this problem, 2) 
made it immune against problems from running Ryan's bomb program and 3) 
remaining drive problems only occurred on unpatched nodes.

These messages still appear regularly though:-
[702162.202899] sd 4:0:3:0: [sdd] Sense Key : Recovered Error [current] 
[descriptor]
[702162.293329] Descriptor sense data with sense descriptors (in hex):
[702162.368629]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
[702162.447985]         00 4f 00 c2 40 50
[702162.494805] sd 4:0:3:0: [sdd] Add. Sense: ATA pass through 
information available

I haven't seen other messages yet from mptsas users that Ryan's patch 
works, so I provide my experience.

Greetings,
Michael.
