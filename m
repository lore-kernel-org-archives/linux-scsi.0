From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: Proper handling of data underrun
Date: Fri, 8 Apr 2005 10:37:02 +0200
Message-ID: <20050408083702.GA6645@lion28.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:44207 "EHLO
	mtagate2.de.ibm.com") by vger.kernel.org with ESMTP id S262705AbVDHKhg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Apr 2005 06:37:36 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate2.de.ibm.com (8.12.10/8.12.10) with ESMTP id j38AbZ96159496
	for <linux-scsi@vger.kernel.org>; Fri, 8 Apr 2005 10:37:35 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j38AbZZL220688
	for <linux-scsi@vger.kernel.org>; Fri, 8 Apr 2005 12:37:35 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.12.11) with ESMTP id j38AbZPG014131
	for <linux-scsi@vger.kernel.org>; Fri, 8 Apr 2005 12:37:35 +0200
Received: from lion28.boeblingen.de.ibm.com (lion28.boeblingen.de.ibm.com [9.152.242.26])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.12.11) with ESMTP id j38AbZTf014128
	for <linux-scsi@vger.kernel.org>; Fri, 8 Apr 2005 12:37:35 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI <linux-scsi@vger.kernel.org>

Hi,

Documentation/scsi/scsi_mid_low_api.txt says:

    resid        - an LLD should set this signed integer to the ...

    <snip>

    underflow    - LLD should place (DID_ERROR << 16) in 'result' if ...

    <snip>

ZFCP is setting resid and DID_ERROR if an underrun is indicated in the
FCP-response.

In some error situations it occurs that the storage box reports a BUSY
or TASK_SET_FULL scsi state as well as data underrun in the
FCP-response.

Now zfcp sets DID_ERROR in host_byte as suggested in
scsi_mid_low_api.txt. And the BUSY/TASK_SET_FULL state is returned in
stauts_byte.

Problem is:
Due to the its fastfail-operation the scsi-stack won't do any
retry for this kind of failed commands because DID_ERROR is
evaluated before BUSY/TASK_SET_FULL.

What is the proper handling of situations where the device reports a
BUSY/TASK_SET_FULL and a data underrun?


Regards,

Andreas
