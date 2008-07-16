From: James.Smart@Emulex.Com
Subject: RE: [PATCH 1/1] libfc: fix queue command rport checks
Date: Wed, 16 Jul 2008 15:08:42 -0400
Message-ID: <D1D4C3FF75F9354393DB8314DF43DEF2E7F01C@xbl3.ma.emulex.com>
References: <1216234249-10812-1-git-send-email-michaelc@cs.wisc.edu> <487E4443.7090601@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:61491 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbYGPTIz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jul 2008 15:08:55 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, devel@open-fcoe.org

 

> michaelc@cs.wisc.edu wrote:
> Oh yeah, I ccd linux-scsi for this patch and not others, 
> because JamesS 
> and them are not on fcoe devel list, and it seems like all fc drivers 
> fail the sync cache command.
> 
> What happens is that we remove the rport which sets the rport state, 
> then the fc class removes the target. This causes the target and its 
> devices to be removed, which can cause a sync cache to be sent. But 
> because the the rport is not in the online state it will fail 
> the command.

Well, excepting detachment paths, if we're tearing the rport down, it's
because
we've already lost connectivity to the target, so there's no way a sync
cache would ever succeed. It's a suprise-removal scenario.

-- james

