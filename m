From: Roman Zippel <zippel@linux-m68k.org>
Subject: RE: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Mon, 1 Dec 2003 17:20:18 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0312011655240.26106@serv>
References: <03120118001300.08627@naveenb-lnx.cisco.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from scrub.xs4all.nl ([194.109.195.176]:28425 "EHLO scrub.xs4all.nl")
	by vger.kernel.org with ESMTP id S262955AbTLAQUl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Dec 2003 11:20:41 -0500
In-Reply-To: <03120118001300.08627@naveenb-lnx.cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: Naveen Burmi <naveenb@cisco.com>
Cc: hch@infradead.org, linux-scsi@vger.kernel.org

Hi,

On Mon, 1 Dec 2003, Naveen Burmi wrote:

> In linux kernel there is a rare occurrence of data corruption. This data can
> be buffer cache data as well as raw I/O data. Don't know the actual root
> cause of the problem, but the fix that we put under macro
> "PREVENT_DATA_CORRUPTION" is capable of resolving this problem.

You probably mean the page cache and it's normal that a page can be
modified, while it's written out.

> On iSCSI target, 5428-2, upon detecting the CRC data error by the QlogicFC
> card it generates  the sense data with sense key as HARDWARE ERROR
> and Additional sense data as LOGICAL UNIT COMMUNICATION FAILURE.
> Upon receving this sense data iSCSI initiator driver is not retrying this
> command and failing the command to the upper layers of SCSI subsystem.
> But linux SCSI subsystem does not perform any error recovery for this kind of
> sense data.

The answer from the target is weird, why does it react with a scsi error
to an iSCSI transport problem?
At ERL0 the target should just drop the packet and/or close the
connection. Recovery of such case would require ERL1, where the target
could request to retransmit the corrupted data pdu or send a CHECK
CONDITION (but also with a different sense data).

bye, Roman
