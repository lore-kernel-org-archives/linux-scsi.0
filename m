From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH RFC 0/3] SCSI Userspace Target
Date: Tue, 24 Jan 2006 20:58:02 -0600
Message-ID: <1138157882.11692.31.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:4481 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1750974AbWAYC6J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jan 2006 21:58:09 -0500
Received: from max (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id k0P2w8pb023596
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2006 20:58:08 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following patches begin to add the infrastructure for the SCSI
Userspace target framework. We were not sure about what James meant by
some of his comments, so rather than getting to far we want to post a
early.

As the email subject hints, the goal of the project is to push most of
the target code to userspace. The only parts we kept in the kernel were
for transferring data between the LLD and userpsace and the netlink
interface. We included the relevant parts of a software iscsi target as
an example.

We also just based ourselves off the scsi_host. This has the benefit of
being able to reuse the scsi-ml host code and for HBAs that have a
initiator and target mode, they only need to allocate a single scsi_host
that corresponds to the PCI device, iscsi session, or whatever your LLD
allocates it for. In theory, a single scsi_host can be used by the LLD
for running both the target and initiator at the same time. The drawback
is it prevents us from doing a more generic target framework that works
for any block device (well, someone could do a libata type of target for
any transport).

Just to be clear, so people do not pee their pants :) These patches are
not ready for prime time. We feel we are at a good point, where we think
we can continue building and allow others to help in the development if
this basic infrastructure is ok.

There is no error handling yet (since we push so much to userspace it
will not be much kernel code), the userspce code is still being reworked
to tweak performance (the kernel code is too), we still need build
proper scatterlists for HW LLDs (although we can do this with the scsi
stuff that was just merged it is not very efficient (see commented code
in scsi_tgt_lib.c)). We just want to make sure we are heading in the
right direction. For example, should we be using the scsi_host or should
we add our own data structure, is the perfomance drop Tomo reported
earlier (he has new numbers and has more tweaks up his sleeve) really
that acceptable or should we go to scst.

We are also up for discussing making the interface more generic, so we
can one day do the scsi scanning and async event handling through it.

Thanks

Mike and Tomo

