From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: linux-2.6.0-test11 [BUG] -- scsi_add/remove_device - out of memory
Date: Wed, 10 Dec 2003 10:12:17 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200312101012.17027.heiko.carstens@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.29.155]:15821 "EHLO
	mtagate6.de.ibm.com") by vger.kernel.org with ESMTP id S263472AbTLJJML convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Dec 2003 04:12:11 -0500
Received: from d12relay02.megacenter.de.ibm.com (d12relay02.megacenter.de.ibm.com [9.149.165.196] (may be forged))
	by mtagate6.de.ibm.com (8.12.10/8.12.10) with ESMTP id hBA9C9tM029144
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2003 09:12:09 GMT
Received: from osiris (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12relay02.megacenter.de.ibm.com (8.12.9/NCO/VER6.6) with ESMTP id hBA9C86j284370
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2003 10:12:09 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello all,

it looks to me as if the SCSI stack has a memory leak. If I have the following
endless loop in our ZFCP LLD we end up within a very short time in an out
of memory situation (tested on an S390 virtual machine with 128MB):

while(1) {
        scsi_add_device(...)
        scsi_remove_device(...);
}

It takes only about 40 iterations to reach the out of memory situation.
The device that gets added and removed does respond to Inquiry commands.
Since I'm not sure what are the pending fixes for the SCSI stack I'm wondering
if this is a known bug.

Heiko

