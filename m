From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [usb-storage] USB storage devices and SAT
Date: Tue, 05 Aug 2008 19:09:48 +0300
Message-ID: <48987B4C.7020901@panasas.com>
References: <Pine.LNX.4.44L0.0808051047130.2518-100000@iolanthe.rowland.org> <489872F7.8050703@torque.net> <48987856.9030804@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:1025 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752901AbYHEQKM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Aug 2008 12:10:12 -0400
In-Reply-To: <48987856.9030804@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Alan Stern <stern@rowland.harvard.edu>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Matthieu castet <castet.matthieu@free.fr>

Boaz Harrosh wrote:
> Douglas Gilbert wrote:
>> The "correct" maximum value (SPC-3 and draft SPC-4) is 252.
>> Since SPC-3 the recommended maximum length for the basic
>> SCSI commands that have a 1 byte allocation length field was
>> altered from 255 to 252. This is to be a little friendlier
>> to transports that move data in 4 byte units across their
>> transport. Guessing a bit here but SATA, SAS and FCP fall
>> into that group of transports.
> 
> 252 + 8 bytes header for REQUEST_SENSE command. So total
> 260 buffer size. (Last I look)
> 

OK you are right 252 allocation length max, specified at
REQUEST_SENSE CDB. The sense_buffer structure itself has 
252 + 8 restriction which got me confused. In OSD we
have large sense payload that can get truncated by these
values.

Boaz
