From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: [PATCH] qla2xxx data transfer direction
Date: Thu, 13 May 2004 07:49:38 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B0DD015B@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:38833 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S264093AbUEMOus convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 May 2004 10:50:48 -0400
Content-Class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: tonyb@cybernetics.com
Cc: linux-scsi@vger.kernel.org


On Thursday, May 13, 2004 7:13 AM, Tony Battersby wrote:

> I am using a QLogic QLA2200 under Linux 2.4.26 with qla2200.o
> version 6.06.10 from QLogic's website.
> 
> The qla2200 driver doesn't do auto-sense if the sense length is
> greater than 32 bytes.  When a command fails with check condition
> and the driver doesn't do auto-sense, the SCSI midlayer sends a
> request sense command with scsi_cmnd::cmnd holding the request sense
> CDB and scsi_cmnd::data_cmnd holding the CDB of the failed command.
> The qla2200 driver determines the expected data direction by looking
> at scsi_cmnd::data_cmd[0].  If the original command was a data out
> command (e.g. mode select), then the qla2200 driver sets the data
> direction for the request sense command incorrectly, causing it to
> fail.  The midlayer gets into an endless loop trying to retrieve the
> sense data.
> 

Yes -- this interrogation of the the CDB to determinine the
data-direction, should _really_ not be in the driver.  Unfortunately,
we have encountered numerous cases of SG callers never even bothering
to set the direction properly for the commands they send down.

> The following patch fixes the problem.  Note that there are a few
> other uses of scsi_cmnd::data_cmnd in qla2x00.c under #if VSA, but
> I'm not sure if they are correct or not.  Someone else will have to
> determine that. 
>

Thanks for the patch and your efforts at refining (fixing :) the
driver logic.  Neither the 6.x or 7.x series drivers (those for 2.4.x)
are integrated into the mainline kernels, so you don't necessarily
need to CC linux-scsi.  Just send either myself the patches and/or
support@qlogic.com -- and they will get properly routed.

Regards,
Andrew Vasquez
