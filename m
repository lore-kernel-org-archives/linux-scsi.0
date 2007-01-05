From: Michael Reed <mdr@sgi.com>
Subject: REGRESSION: 2.6.20-rc3-git4: EIO not returned to direct i/o application
 following disk error
Date: Fri, 05 Jan 2007 15:05:55 -0600
Message-ID: <459EBDB3.3080408@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:40352 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750772AbXAEVF7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Jan 2007 16:05:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Jeremy Higdon <jeremy@sgi.com>, Michael Reed <mdr@sgi.com>, James Bottomley <James.Bottomley@SteelEye.com>

Testing using 2.6.20-rc3-git4 I observed that my direct i/o test
application no longer receives an EIO when the fc transport deletes
a target following a fibre channel switch port disable.

With 2.6.19 EIO is returned and the application terminates.

With 2.6.20, the requested read length is returned with incorrect
data in the buffer.

(I was playing around with an error recovery patch when I first
discovered this, and do believe it is not limited in scope to
targets being removed by the transport.)

This is a serious regression which puts customer data at risk.

(Is there a formal mechanism for filing a bug?)

Mike
