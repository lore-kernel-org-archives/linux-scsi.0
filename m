From: Douglas Gilbert <dougg@torque.net>
Subject: Re: is it ok to receive SIGIO in the same context calling SG code?
Date: Tue, 20 May 2003 14:49:22 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EC9B3D2.9070009@torque.net>
References: <20030505194408.31127.qmail@web13808.mail.yahoo.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:25092 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S263549AbTETEfg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 May 2003 00:35:36 -0400
In-Reply-To: <20030505194408.31127.qmail@web13808.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: William Chow <lilbilchow@yahoo.com>
Cc: linux-scsi@vger.kernel.org

William Chow wrote:
> The documentation associated with the UNH target
> emulator project indicates that the thread which
> receives the SIGIO cannot also be the context which
> calls SG, e.g. for submitting the async I/O. It states
> that "there are certain sections of the SCSI generic
> code that do not expect to receive signals". Does
> anyone have any information, implementational or even
> empirical, that would confirm/refute this?

William,
Well I found the reference but I'm not sure exactly what
was meant by that. The reference was dated 2001 so things
may have improved since then (but I do not remember addressing
any problem in that area).

In a followup post to me you asked about async completion
callbacks. After looking at Jonathan Corbet's article about
async I/O in the lk 2.5 series, it should be relatively
simple to add a aio_write() entry point in sg. It would
have the same semantics as sg's normal write(). When the
response to the command is received the associated
aio_complete() could be called. The SCSI status byte could
even be placed in 'res2'.


[Aside: the SG_IO ioctl is synchronous. The asynchronous
interface offered by the sg driver (via write()/read())
does have its uses (and users).]

Doug Gilbert


