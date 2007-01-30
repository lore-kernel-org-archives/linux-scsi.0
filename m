From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 0/4] Roll-up of libsas and aic94xx patches
Date: Tue, 30 Jan 2007 02:45:40 -0500
Message-ID: <200701300745.l0U7jehp014538@d01av04.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:60767 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965427AbXA3Hpm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Jan 2007 02:45:42 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0U7kJus024105
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 02:46:19 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0U7jfu7228234
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 02:45:41 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0U7jesn014559
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 02:45:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Alexis Bruemmer <alexisb@us.ibm.com>

Hi all,

This is a roll-up of all of my uncommitted patches against libsas
and aic94xx to date.  The first patch fixes a bug when connecting two
expanders to each other and there is a enough of a delay between the
phy-going-up broadcasts that each phy gets its own round of discovery.
The remaining patches move the phy reset code to the libsas default
bus reset handler, make the default device reset handler send a
LU RESET message instead, and make aic94xx not clobber TMF result codes
(so that LU RESET works properly).

These patches should apply in number order cleanly against 2.6.20-rc6 +
scsi_misc + scsi-rc-fixes.  I've been running fault injection tests
on x260, x206m and x366 machines for most of the day without problems 
Hopefully these patches are ready for more widespread testing in
scsi-misc, and thank you for any comments or feedback that you provide.

(Apologies for any stgit mail misconfiguration on my part.)

--D
