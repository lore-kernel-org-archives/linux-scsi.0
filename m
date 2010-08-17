From: Dave Jones <davej@redhat.com>
Subject: odd debug spew while reading a CD.
Date: Tue, 17 Aug 2010 17:08:58 -0400
Message-ID: <20100817210858.GA30880@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501Ab0HQVJB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Aug 2010 17:09:01 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o7HL91sA031145
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Tue, 17 Aug 2010 17:09:01 -0400
Received: from localhost.localdomain ([10.3.113.13])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o7HL90P0014321
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 17 Aug 2010 17:09:01 -0400
Received: from localhost.localdomain (gelk [127.0.0.1])
	by localhost.localdomain (8.14.4/8.14.3) with ESMTP id o7HL8xbn009075
	for <linux-scsi@vger.kernel.org>; Tue, 17 Aug 2010 17:08:59 -0400
Received: (from davej@localhost)
	by localhost.localdomain (8.14.4/8.14.4/Submit) id o7HL8wFQ009073
	for linux-scsi@vger.kernel.org; Tue, 17 Aug 2010 17:08:58 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

When ripping an audio CD earlier, I got a bunch of these messages in dmesg,
even though the CD read just fine..

[ 8669.821077] sr 4:0:0:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[ 8669.821083] sr 4:0:0:0: [sr0] Sense Key : Illegal Request [current] 
[ 8669.821090] ILI
[ 8669.821093] sr 4:0:0:0: [sr0] Add. Sense: Illegal mode for this track
[ 8669.821101] sr 4:0:0:0: [sr0] CDB: Read(10): 28 00 00 00 00 00 00 00 02 00
[ 8669.821116] end_request: I/O error, dev sr0, sector 0
[ 8669.821121] Buffer I/O error on device sr0, logical block 0
[ 8669.821128] Buffer I/O error on device sr0, logical block 1

the "ILI" message on its own caught my eye.
In constants.c, we print a prefix before that message in this case..

1345                 if (fixed_valid)
1346                         res += snprintf(buff + res, blen - res,
1347                                         "Info fld=0x%x", info);

But if fixed_valid (sense_buffer[0] & 0x80;) is not true, we end up printing
status codes with no prefix, which looks odd.  Is this the desired behaviour ?

	Dave

