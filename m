From: Oliver Neukum <oneukum@suse.de>
Subject: [PATCH 0/3]error handling in sd suspend
Date: Fri, 5 Nov 2010 11:09:05 +0100
Message-ID: <201011051109.05730.oneukum@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:36795 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623Ab0KEKIp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Nov 2010 06:08:45 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.221.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 3BC7893F46
	for <linux-scsi@vger.kernel.org>; Fri,  5 Nov 2010 11:08:44 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>, hare@suse.de, linux-scsi@vger.kernel.org

Hi,

this patch series introduces proper error handling into sd suspend handling.
This fixes several issue:

- errror codes are sanitized so that SCSI errors don't get into generic PM code
- the error returns from synchronizing the cache are evaluated and translated
  for the upper layer, this particularly helps when unplug races suspend
  eSATA is likely to do this, as it takes very long to handle an unplug.
- the error returns for stopping the unit are likewise sanitized

	Regards
		Oliver
