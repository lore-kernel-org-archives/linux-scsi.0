From: Brian King <brking@us.ibm.com>
Subject: host_self_blocked question/bug?
Date: Tue, 25 Nov 2003 15:46:55 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FC3CDCF.4030105@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:53411 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263106AbTKYVrA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Nov 2003 16:47:00 -0500
Received: from northrelay04.pok.ibm.com (northrelay04.pok.ibm.com [9.56.224.206])
	by e6.ny.us.ibm.com (8.12.10/8.12.2) with ESMTP id hAPLkuDA229744
	for <linux-scsi@vger.kernel.org>; Tue, 25 Nov 2003 16:46:56 -0500
Received: from us.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by northrelay04.pok.ibm.com (8.12.9/NCO/VER6.6) with ESMTP id hAPLksTY059940
	for <linux-scsi@vger.kernel.org>; Tue, 25 Nov 2003 16:46:55 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I am writing an HBA driver for 2.6 and found that when host_self_blocked 
is true the error handler will still send Test Unit Ready. This seems 
like a bug. I would like to be able to use scsi_block_requests to stop 
anything from coming into queuecommand, as I may be running BIST on the 
adapter, downloading microcode, etc. in which case I cannot accept any 
commands. It seems to me like the solution might be to simply have 
scsi_eh_tur return success in if host_self_blocked is true. Thoughts?


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

