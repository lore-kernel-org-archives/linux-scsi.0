From: Martin Peschke <mp3@de.ibm.com>
Subject: question on scsi_alloc_sdev()
Date: Thu, 10 Aug 2006 16:37:43 +0200
Message-ID: <44DB44B7.9080708@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:65506 "EHLO
	mtagate6.uk.ibm.com") by vger.kernel.org with ESMTP
	id S1161279AbWHJOht (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Aug 2006 10:37:49 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate6.uk.ibm.com (8.13.7/8.13.7) with ESMTP id k7AEbmbc047822
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Thu, 10 Aug 2006 14:37:48 GMT
Received: from d06av03.portsmouth.uk.ibm.com (d06av03.portsmouth.uk.ibm.com [9.149.37.213])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k7AEdbtF140616
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 10 Aug 2006 15:39:37 +0100
Received: from d06av03.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av03.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k7AEblce007604
	for <linux-scsi@vger.kernel.org>; Thu, 10 Aug 2006 15:37:47 +0100
Received: from [127.0.0.1] (dyn-9-152-230-71.boeblingen.de.ibm.com [9.152.230.71])
	by d06av03.portsmouth.uk.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k7AEbllL007593
	for <linux-scsi@vger.kernel.org>; Thu, 10 Aug 2006 15:37:47 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Does anybody know for sure whether scsi_alloc_sdev() is guaranteed to
be called in process context or not?

There seem to be contradictory signs in scsi_scan.c:
scsi_alloc_sdev() uses GFP_ATOMIC, as related functions do.
It might be called in a section protected by a mutex.

I conducted a little experiment using might_sleep() in scsi_alloc_sdev()
- no backtrace on the console, hence process context.

Or, is the purpose of GFP_ATOMIC just (SCSI) I/O avoidance, and sleeping
isn't an issue?

Thanks,
Martin

