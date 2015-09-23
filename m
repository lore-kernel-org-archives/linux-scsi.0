From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: Question about expected behavior of terminate_rport_io() in
 fc_function_template
Date: Wed, 23 Sep 2015 19:06:16 +0200
Message-ID: <20150923170616.GA16814@bblock-ThinkPad-W530>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp07.uk.ibm.com ([195.75.94.103]:41429 "EHLO
	e06smtp07.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934AbbIWRGW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Sep 2015 13:06:22 -0400
Received: from /spool/local
	by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <bblock@linux.vnet.ibm.com>;
	Wed, 23 Sep 2015 18:06:21 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
	by d06dlp02.portsmouth.uk.ibm.com (Postfix) with ESMTP id 118B1219005C
	for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2015 18:05:48 +0100 (BST)
Received: from d06av05.portsmouth.uk.ibm.com (d06av05.portsmouth.uk.ibm.com [9.149.37.229])
	by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8NH6HOv36896832
	for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2015 17:06:17 GMT
Received: from d06av05.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av05.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8NH6GCK030650
	for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2015 11:06:17 -0600
Received: from bblock-ThinkPad-W530 (dyn-9-152-222-85.boeblingen.de.ibm.com [9.152.222.85])
	by d06av05.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVin) with ESMTP id t8NH6GeC030645
	for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2015 11:06:16 -0600
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, "James E.J. Bottomley" <JBottomley@odin.com>, Hannes Reinecke <hare@suse.de>

Hello,

just a short question. If a low-level driver implements the function
`terminate_rport_io()` in `struct fc_function_template`, and it gets
called after IO failed, is the low-level driver expected to handle this
request synchronously or can it just schedule an action that is worked =
on
asynchronously to the call to the function?

Trouble is, we are seeing problems with SCSI-Commands being used by the
upper layers when we expect them to still be ours, after we got a call =
to
that function and didn't react upon it immediately. They do not contain
valid content anymore when they should.

I've looked into other implementations and it seems there are both
version, some LLDs explicitly wait upon completions of requests they
schedule and others just schedule work-items and return. That may
already be the answer, but I wanted to make sure I am not missing
something here. The documentation on it is not really existing, or I
missed it.


                                                    Beste Gr=FC=DFe / B=
est regards,
                                                      - Benjamin Block
--
Linux on z Systems Development         /         IBM Systems & Technolo=
gy Group
                  IBM Deutschland Research & Development GmbH
                Vorsitzende des Aufsichtsrats: Martina Koederitz
       Gesch=E4ftsf=FChrung: Dirk Wittkopp / Sitz der Gesellschaft: B=F6=
blingen
               Registergericht: Amtsgericht Stuttgart, HRB 243294

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
