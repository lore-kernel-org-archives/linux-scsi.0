From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: [SCSI] mpt2sas: Fixed Big Indian Issues on 32 bit PPC
Date: Mon, 20 Feb 2012 17:05:38 +0300
Message-ID: <20120220140538.GA750@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:18386 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab2BTOFt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Feb 2012 09:05:49 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kashyap.desai@lsi.com
Cc: linux-scsi@vger.kernel.org

Hello Kashyap, Desai,

The patch c97951ec46d4: "[SCSI] mpt2sas: Fixed Big Indian Issues on 
32 bit PPC" from Jun 14, 2011, leads to the following static checker
warning:

drivers/scsi/mpt2sas/mpt2sas_base.c:3352 _base_get_port_facts()
	 warn: are we memsetting too much? 6 vs 28

We changed the size of certain data structures.

-       Mpi2IOCFactsReply_t facts;
-       Mpi2PortFactsReply_t *pfacts;
+       struct mpt2sas_facts facts;
+       struct mpt2sas_port_facts *pfacts;

But it's not done consistently.  We still memset it as if it were the
original size.

	memset(facts, 0, sizeof(Mpi2IOCFactsReply_t));

And we still allocate the original size data structure:

  4270          ioc->pfacts = kcalloc(ioc->facts.NumberOfPorts,
  4271              sizeof(Mpi2PortFactsReply_t), GFP_KERNEL);

There are a couple other warnings as well.
drivers/scsi/mpt2sas/mpt2sas_base.c:3394 _base_get_ioc_facts(24)
	warn: are we memsetting too much? 60 vs 64
drivers/scsi/mpt2sas/mpt2sas_base.c:4270 mpt2sas_base_attach(56)
	warn: double check that we're allocating correct size: 6 vs 28

Obviously the concern with a too big memset is that we're corrupting
the next element in the array or we're corrupting past the end of the
array.

regards,
dan carpenter

