From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [PATCH 2/5] zfcp: Fix deadlock between zfcp ERP and SCSI
Date: Tue, 8 May 2007 17:32:54 +0200
Message-ID: <20070508153254.GA20009@schmichrtp>
References: <200705081116.53021.swen@vnet.ibm.com> <4640907B.3080409@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:41831 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968146AbXEHPcy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 May 2007 11:32:54 -0400
Content-Disposition: inline
In-Reply-To: <4640907B.3080409@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: Swen Schillig <swen@vnet.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org

On Tue, May 08, 2007 at 11:00:11AM -0400, James Smart wrote:
> Curious why you are calling scsi_scan_target() or
> scsi_target_block()/scsi_target_unblock() directly. I would have
> thought the add/remove rport code would have done this for you,
> and it deals with all the flush conditions, etc.

fc_remote_port_add issues a scsi_scan_target with SCAN_WILD_CARD. This tries to
get all LUNs for the target via REPORT LUNS for LUN 0. The current design for
zfcp is to prevent the wildcard scan from the SCSI layer by not allocating a
device for LUN 0. When a FCP adapter does not support NPIV, the adapter can
still be shared among multiple Linux systems. Each Linux system can access
different LUNs, that are activated manually via sysfs. So, the wildcard scan
from the FC transport class does nothing and zfcp activates the LUNs it wants
to use via direct calls to scsi_scan_target. If every adapter would support
NPIV, zfcp could rely on the scan by the FC transport class, unfortunately,
this is not the case.

Christof Schmitt
