From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 0/7] Roll-up of libsas and aic94xx patches
Date: Sat, 27 Jan 2007 00:33:40 -0500
Message-ID: <45BAE434.6090306@torque.net>
References: <200701262206.l0QM6iCb017066@d01av02.pok.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:35696 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbXA0Fdu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Jan 2007 00:33:50 -0500
In-Reply-To: <200701262206.l0QM6iCb017066@d01av02.pok.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>

Darrick J. Wong wrote:
> Hi all,
> 
> This is a roll-up of all of my uncommitted patches against libsas
> and aic94xx to date.  The first patch features an important fix for an
> incorrect port deformation after a phy reset event.  The next two
> patches in this set complete the reorganization of the
> sas_rphy_{delete,free} calls after errors during discovery.  The next
> two patches amend the SAS error handler to be able to handle scsi_cmnds
> that have completed successfully but with a failure code, first by
> trying START UNIT if the disk is not spinning, second by trying to
> reset the device, and finally offlining the device if nothing works.

Darrick,
The "reset the device" is a bit vague. Would that
be a LU reset (task management function) or a
"hard reset"? If the latter then it will cause
collateral damage if the target contains multiple
logical units (i.e. it will reset all of them,
not just the one failing to spin up).

Doug Gilbert
