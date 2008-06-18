From: Pete Wyckoff <pw@osc.edu>
Subject: Re: [PATCH/RFC v3] allow userspace to modify scsi command filter
	on per device basis
Date: Tue, 17 Jun 2008 21:13:31 -0400
Message-ID: <20080618011331.GA32633@osc.edu>
References: <6cf6b73e0806152249r19cb405ct9d5a33960e619348@mail.gmail.com> <20080616151328Q.fujita.tomonori@lab.ntt.co.jp> <6cf6b73e0806160222g19d7229dl6a650e13ab36c03b@mail.gmail.com> <20080618051447L.fujita.tomonori@lab.ntt.co.jp> <48583074.8010909@redhat.com> <48584252.5030901@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from marge.padd.com ([66.127.62.138]:37144 "EHLO marge.padd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758300AbYFRBNh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jun 2008 21:13:37 -0400
Content-Disposition: inline
In-Reply-To: <48584252.5030901@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: Peter Jones <pjones@redhat.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, adel.gadllah@gmail.com, matthew@wil.cx, linux-scsi@vger.kernel.org, jens.axboe@oracle.com

dgilbert@interlog.com wrote on Wed, 18 Jun 2008 01:01 +0200:
> IMO all command filtering should be dropped

To add fuel to the fire:  I carry a patch to hack around the SCSI
filtering invoked by bsg to be able to use an object-based storage
device (OSD).  These devices have a fairly comprehensive policy
framework that filters commands based on the object being accessed,
and how it is accessed.  User-space applications acquire credentials
from a server somewhere on the network and craft SCSI commands that
present these credentials to the device, which also likely sits
remotely and is accessed via iSCSI or similar.

OSD commands all have the same opcode 0x7f (variable length CDB),
and the "service action" (read, write, create, flush, ...) is deeper
in the CDB, along with the credentials.  Filtering on the single
byte 0x7f isn't useful, and the local kernel really has no role in
mediating device access.  Linux provides SCSI initiator services
including discovery, transport, etc. but has no role in
authenticating how applications use OSDs.

		-- Pete
