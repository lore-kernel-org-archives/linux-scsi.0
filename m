From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: scsi.h: please rename the status_byte() macro
Date: Thu, 16 Sep 2010 16:46:21 -0400
Message-ID: <4C92821D.1000903@interlog.com>
References: <4C912F14.8000706@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:55003 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754626Ab0IPUqd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Sep 2010 16:46:33 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp.infotech.no (Postfix) with ESMTP id 9C86C31722
	for <linux-scsi@vger.kernel.org>; Thu, 16 Sep 2010 22:46:30 +0200 (CEST)
Received: from smtp.infotech.no ([127.0.0.1])
	by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hB6hUKhCflEk for <linux-scsi@vger.kernel.org>;
	Thu, 16 Sep 2010 22:46:30 +0200 (CEST)
Received: from [10.7.0.10] (unknown [10.7.0.10])
	by smtp.infotech.no (Postfix) with ESMTPA id 267A031721
	for <linux-scsi@vger.kernel.org>; Thu, 16 Sep 2010 22:46:29 +0200 (CEST)
In-Reply-To: <4C912F14.8000706@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

On 10-09-15 04:39 PM, Douglas Gilbert wrote:
> ... to something like:
> scsi_status_byte_div2()
> or:
> scsi_broken_status_byte()

The bug in the bsg driver with its SCSI status byte
brought this to my attention. If memory serves about
10 years ago some of us tried to kill the status_byte()
macro.

But it is still there in the kernel's scsi/scsi.h
ready to trip up another generation of programmers:
#define status_byte(result) (((result) >> 1) & 0x7f)

with no explanation that it does NOT yield the SCSI
status byte but the right shifted (once) equivalent.

The correct macro (or inline function) for obtaining the
SCSI status byte from the 32 bit "result" from a LLD would
be:
#define scsi_status_byte(result) ((result) & 0xff)

[Long ago (20 years) something silly was put in bit 0
  so masking with 0xfe would work as well.]

Another thought, these macros are associated with the
mid-level or a ULD deciding whether a SCSI command has
succeeded; so scsi_cmnd.h would be a more appropriate
header.

Happily the version of scsi.h shown to the user space
(typically /usr/include/scsi/scsi.h) does not include
these defective macros. So any API breakage is limited
to the kernel.

Doug Gilbert


