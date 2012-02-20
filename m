From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [SCSI] mpt2sas: Fixed Big Indian Issues on 32 bit PPC
Date: Mon, 20 Feb 2012 16:15:40 -0700
Message-ID: <4565AEA676113A449269C2F3A549520FB5AE22B2@cosmail03.lsi.com>
References: <20120220140538.GA750@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:45020 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752698Ab2BTXUR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Feb 2012 18:20:17 -0500
In-Reply-To: <20120220140538.GA750@elgon.mountain>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Dan - I fixed the issue about a couple weeks ago in the in-house drivers.  From _base_get_ioc_facts, we should be memset'ing the "struct mpt2sas_facts" instead of "Mpi2IOCFactsReply_t ", because the its four bytes larger, the ioc->pfacts is getting set to NULL.   Nagalaksmi will pick it up this fix and post upstream in a future patch.

Thankyou,
Eric

________________________________________
From: linux-scsi-owner@vger.kernel.org [linux-scsi-owner@vger.kernel.org] On Behalf Of Dan Carpenter [dan.carpenter@oracle.com]
Sent: Monday, February 20, 2012 7:05 AM
To: Desai, Kashyap
Cc: linux-scsi@vger.kernel.org
Subject: re: [SCSI] mpt2sas: Fixed Big Indian Issues on 32 bit PPC

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

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
