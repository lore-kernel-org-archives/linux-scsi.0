From: Olaf Hering <olh@suse.de>
Subject: how to get rid of scsi cdrom?
Date: Sat, 8 Jan 2005 22:19:29 +0100
Message-ID: <20050108211929.GA26318@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:43424 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S261549AbVAHVT3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Jan 2005 16:19:29 -0500
Received: from hermes.suse.de (hermes-ext.suse.de [195.135.221.8])
	(using TLSv1 with cipher EDH-RSA-DES-CBC3-SHA (168/168 bits))
	(No client certificate requested)
	by Cantor.suse.de (Postfix) with ESMTP id 679D912FFA20
	for <linux-scsi@vger.kernel.org>; Sat,  8 Jan 2005 22:19:29 +0100 (CET)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

What is the best way to fix this oops?
'rmmod -r ide-cd;modprobe ide-scsi;modprobe sr_mod;rmmod -r ide-scsi'

cdrom_mrw_exit() calls scsi_block_when_processing_errors() at some
point, that looks like the only exit before the oops, via SDEV_OFFLINE.
However, scsi_remove_host() sets SDEV_CANCEL first, so it looks like
SDEV_OFFLINE isnt a valid state anymore.

