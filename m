From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: scsi_block_requests() and retries
Date: Thu, 8 Jan 2004 13:31:21 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200401081331.21824.heiko.carstens@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:27615 "EHLO
	mtagate7.de.ibm.com") by vger.kernel.org with ESMTP id S264371AbUAHMhV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jan 2004 07:37:21 -0500
Received: from d12relay01.megacenter.de.ibm.com (d12relay01.megacenter.de.ibm.com [9.149.165.180])
	by mtagate7.de.ibm.com (8.12.10/8.12.10) with ESMTP id i08CbJ9p053922
	for <linux-scsi@vger.kernel.org>; Thu, 8 Jan 2004 12:37:19 GMT
Received: from osiris (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12relay01.megacenter.de.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id i08CbJT6261622
	for <linux-scsi@vger.kernel.org>; Thu, 8 Jan 2004 13:37:19 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I'm wondering if the behaviour of the scsi mid layer is correct: if an LLD
calls scsi_block_requests() and _afterwards_ returns outstanding requests
with DID_ERROR, these requests will be retried. Of course these requests
will be returned with DID_ERROR as well since the LLD is not expecting /
accepting any requests. This will be continued until the maximum retry count
will be reached. The final result will be an I/O error.
Actually I think that requests shouldn't be retried if
host_self_blocked == 1 is given for a host adapter.
Or am I wrong here?

Heiko

