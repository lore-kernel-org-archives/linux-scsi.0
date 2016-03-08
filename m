From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sg: fix dxferp in from_to case
Date: Mon, 07 Mar 2016 21:18:08 -0500
Message-ID: <yq1lh5tyaov.fsf@sermon.lab.mkp.net>
References: <56D7CC31.3070800@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22345 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185AbcCHCSU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2016 21:18:20 -0500
In-Reply-To: <56D7CC31.3070800@interlog.com> (Douglas Gilbert's message of
	"Thu, 3 Mar 2016 00:31:29 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, dvyukov@google.com

>>>>> "Doug" == Douglas Gilbert <dgilbert@interlog.com> writes:

Doug> This patch is in response to this report:
Doug> http://www.spinics.net/lists/linux-scsi/msg93456.html

Doug> One of the strange things that the original sg driver did was let
Doug> the user provide both a data-out buffer (it followed the
Doug> sg_header+cdb) _and_ specify a reply length greater than
Doug> zero. What happened was that the user data-out buffer was copied
Doug> into some kernel buffers and then the mid level was told a read
Doug> type operation would take place with the data from the device
Doug> overwriting the same kernel buffers. The user would then read
Doug> those kernel buffers back into the user space.

Doug> From what I can tell, the above action was broken by a change in
Doug> 2008 and syzkaller found that out recently.

Doug>    ChangeLog: make sure that a user space pointer is passed
Doug> through when data follows the sg_header structure and command.
Doug> Fix the abnormal case when a non-zero reply_len is also given.

Somebody please review.

-- 
Martin K. Petersen	Oracle Linux Engineering
