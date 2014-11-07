From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [RFC] Discard update for 3.19
Date: Fri,  7 Nov 2014 00:08:11 -0500
Message-ID: <1415336894-15327-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20757 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaKGFId (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Nov 2014 00:08:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-fsdevel@vger.kernel.org, neilb@suse.de

This update is mainly motivated by an attempt to make the
discard_zeroes_data reporting more accurate. As we have discussed
several times in the past we are stuck with pretty weak guarantees from
the T10/T13 standards. And as a result we feel compelled to tighten up
the scenarios under which we advertise discard_zeroes_data since several
applications and subsystems depend on it being accurate.

The first patch is the most controversial. It disables
discard_zeroes_data for libata devices unless they explicitly have been
whitelisted. I had hoped to have a more comprehensive list of drives but
I didn't have much luck in procuring the identify strings that would
allow me to generate the whitelist matching patterns. I could use some
help here.

The second patch tweaks the SCSI disk driver to prefer WRITE SAME w/
UNMAP instead of the UNMAP command since the former has deterministic
behavior.

The lack of a hard discard_zeroes_data guarantees has also prevented us
from having a variant of blkdev_issue_zeroout() that discards if
possible. The last patch in this series will add such a call that the
filesystems and virt block drivers can use to clear and deprovision
block ranges.

-- 
Martin K. Petersen	Oracle Linux Engineering

