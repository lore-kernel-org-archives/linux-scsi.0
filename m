From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [BISECTED] Re: [BUG] Linux-2.6.31-rc1 Fails To Recognize Some USB Disks
Date: Fri, 24 Jul 2009 10:02:37 -0400
Message-ID: <yq1fxcmnpqa.fsf@sermon.lab.mkp.net>
References: <4A4472DF.1050900@turknet.net.tr>
	<yq1zlbrn2rj.fsf@sermon.lab.mkp.net> <4A4878AC.3050208@turknet.net.tr>
	<yq1fxdji03l.fsf@sermon.lab.mkp.net> <4A69932E.90906@turknet.net.tr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:45155 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbZGXODD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jul 2009 10:03:03 -0400
In-Reply-To: <4A69932E.90906@turknet.net.tr> (Tarkan Erimer's message of "Fri,
	24 Jul 2009 13:55:42 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>

>>>>> "Tarkan" == Tarkan Erimer <tarkan.erimer@turknet.net.tr> writes:

Tarkan> Today, I had time to bisect and you were right: The below commit
Tarkan> related to capacity detection changes in SCSI subsystem,as you
Tarkan> mentioned, seems the cause of the problem.

Thanks for bisecting this.


Tarkan>     Detect non-rotational devices and set the queue flag
Tarkan>     accordingly.

Aha, so you're getting USB resets because your USB-ATA bridge gets
confused when we ask it a simple question.  What a marvel of modern
engineering that thing is...

Please send me the output of:

sg_inq -e /dev/foo
sg_inq -l 16 /dev/foo
sg_inq -l 16 -e /dev/foo
sg_inq -l 36 /dev/foo
sg_inq -l 36 -e /dev/foo
sg_vpd -p sv /dev/foo
sg_vpd -p bl /dev/foo
sg_vpd -p bdc /dev/foo

-- 
Martin K. Petersen	Oracle Linux Engineering
