From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 3/3] zfcp: Don't report device as LUN 0 to SCSI stack
Date: Sun, 17 Jun 2007 15:50:12 -0500
Message-ID: <1182113412.19498.7.camel@mulgrave.il.steeleye.com>
References: <200705291529.54785.swen@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:56724 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756075AbXFQUuU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Jun 2007 16:50:20 -0400
In-Reply-To: <200705291529.54785.swen@vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Swen Schillig <swen@vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schmichr@de.ibm.com

On Tue, 2007-05-29 at 15:29 +0200, Swen Schillig wrote: 
> From: Christof Schmitt <schmichr@de.ibm.com>
> 
> zfcp reported units to the SCSI stack starting
> with number 0. LUN 0 reported to the SCSI stack is usually 
> not the FCP LUN 0. When scanning for devices, 
> the SCSI stack tried to issue a REPORT LUN command to LUN 0. 
> The current design for zfcp does not want the SCSI stack to scan
> for devices, since they are configured explicitly via sysfs.
> This patch changes the numbering to always start with LUN 1 and therefore
> prevent the SCSI stack sending REPORT LUN command.

As a general principle, this does sound to be wrong (at least shifting
the LUNs).  Wouldn't something like the existing blacklist preventing
the REPORT LUN command from being sent be more appropriate?

James


