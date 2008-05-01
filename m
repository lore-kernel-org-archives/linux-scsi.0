From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 0/4] Use of new scsi_allocate_command
Date: Thu, 01 May 2008 16:47:07 +0300
Message-ID: <4819C9DB.60104__27955.1494088539$1209649720$gmane$org@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:21293 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753078AbYEANrn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 May 2008 09:47:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, USB list <linux-usb@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>
Cc: Andi Kleen <andi@firstfloor.org>

Submitted are two drivers that should use the new scsi_allocate_command
instead of kmalloc their own.

But first we need some changes. Since the GFP_DMA support is going away
(Submitted next) I would like to change the API a bit before any users
use this code.

Also I would like to snick in a gdth change that is related to this effort.

[PATCH 1/4] scsi_free_command API change - Don't support GFP_DMA
  ISA support is going away and is not needed by any potential clients
  of this code. So change the API now before it has any users.

[PATCH 2/4] isd200: Use new scsi_allocate_command()
  Use scsi_allocate_command in isd200 driver

[PATCH 3/4] gdth: consolidate __gdth_execute && gdth_execute
  Cleanup and optimization. Please see patch for detailed explanations

[PATCH 4/4] gdth: Use scsi_allocate_command for private command allocation

Boaz
