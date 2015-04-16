From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC] Simlify dif_verify routines and fixup fileio protection information code.
Date: Thu, 16 Apr 2015 11:30:20 -0400
Message-ID: <yq1oamo2ir7.fsf@sermon.lab.mkp.net>
References: <1428945575-30839-1-git-send-email-sagig@mellanox.com>
	<CAC5umygZ_qCu0x3RfTQs21R1Poa6A10FkhmGak7ccc2HvY4ROQ@mail.gmail.com>
	<552D4C7B.9000402@dev.mellanox.co.il>
	<CAC5umyj9FsnumRhvNrzqE=Rtpy3O32SBw43ZP9M8H5B3htbRpw@mail.gmail.com>
	<552E384F.3030203@dev.mellanox.co.il>
	<CAC5umygGG4BTs0u35eVi6dLhoDuDshGNPsQaWq2kO5YexWDP+Q@mail.gmail.com>
	<552E76D1.7040204@dev.mellanox.co.il>
	<552E7ED6.4080304@dev.mellanox.co.il>
	<yq1egnl4bjm.fsf@sermon.lab.mkp.net>
	<552F7840.2080804@dev.mellanox.co.il>
	<CAC5umygHt_LHyCWEhg9whhe7PfQBy=Y9uXbKAE6+1EL7MEzmrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48717 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbbDPPae (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Apr 2015 11:30:34 -0400
In-Reply-To: <CAC5umygHt_LHyCWEhg9whhe7PfQBy=Y9uXbKAE6+1EL7MEzmrg@mail.gmail.com>
	(Akinobu Mita's message of "Thu, 16 Apr 2015 22:46:15 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

>>>>> "Akinobu" == Akinobu Mita <akinobu.mita@gmail.com> writes:

>>> We don't issue WRITE SAME with PI so there is no prot SGL.

>> Is there a specific reason why we don't?

There really isn't much of a benefit when all you're doing is
replicating zeroes. So it hasn't been very high on my list.

Akinobu> It is not only for the WRITE SAME requests from block device
Akinobu> but also for READ/WRITE with PROTECT=0 requests by SG_IO.

Akinobu> So isn't is appropreate to allocate prot SGL in
Akinobu> target_write_prot_action() (and mark se_cmd->se_cmd_flags to
Akinobu> release it at deallocation time)?

Correct. Just because a target is formatted with PI does not mean that
every I/O it receives has PI attached. That's entirely driven by
RDPROTECT/WRPROTECT/VRPROTECT at the initiator's discretion.

It is an absolute requirement that the device, if formatted with PI,
will generate and write the correct protection information when
WRPROTECT is 0.

-- 
Martin K. Petersen	Oracle Linux Engineering
