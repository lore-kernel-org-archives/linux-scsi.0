From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: sd: protection difficulties
Date: Thu, 17 Nov 2011 12:01:42 -0500
Message-ID: <yq1vcqifzt5.fsf@sermon.lab.mkp.net>
References: <4EC536D1.6080501@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:51235 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab1KQRBy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Nov 2011 12:01:54 -0500
In-Reply-To: <4EC536D1.6080501@interlog.com> (Douglas Gilbert's message of
	"Thu, 17 Nov 2011 11:31:13 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: Linux SCSI Mailing list <linux-scsi@vger.kernel.org>

>>>>> "Doug" == Douglas Gilbert <dgilbert@interlog.com> writes:

Doug,

Doug> Now with zeros filling the user data part of each logical block
Doug> and a LB guard field of 0xffffffff that means any attempt to read
Doug> a LB before it is written will result in an error like this [lk
Doug> 3.1.0]:
Doug>  sd 6:0:0:0: [sdb]
Doug>    Target Data Integrity Failure
Doug>     Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE Sense Key :
Doug>     Aborted Command [current] Add. Sense: Logical block guard
Doug>     check failed CDB: Read(10): 28 20 00 00 00 00 00 00 08 00
Doug>     end_request: I/O error, dev sdb, sector 0

I'm guessing you are using an mpt2sas with recent firmware? LSI changed
behavior to always check PI even when the app tag contains 0xFFFF (which
means "don't check" this block).

I have some patches that LSI haven't signed off on yet. Which is why I
haven't posted them...

-- 
Martin K. Petersen	Oracle Linux Engineering
