From: <lemons_terry@emc.com>
Subject: RE: SCSI persistent reservation terms
Date: Mon, 12 Apr 2010 09:37:38 -0400
Message-ID: <3BEB5F9B6605A140847DEEEDF7439C5D04125E92@CORPUSMX50A.corp.emc.com>
References: <3BEB5F9B6605A140847DEEEDF7439C5D040A06C8@CORPUSMX50A.corp.emc.com> <1270666077.3332.10.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mexforward.lss.emc.com ([128.222.32.20]:20673 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab0DLNi1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Apr 2010 09:38:27 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1270666077.3332.10.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org

Hi

Thanks very much for the reply!  The difference between those terms make
sense now.

I took a look at these comments in the code:

303         switch (pr_reg_type) { 
304         case PR_TYPE_WRITE_EXCLUSIVE: 
305                 we = 1; 
306         case PR_TYPE_EXCLUSIVE_ACCESS: 
307                 /* 
308                  * Some commands are only allowed for the persistent
reservation 
309                  * holder. 
310                  */ 
311                 if (se_deve->deve_flags & DEF_PR_REGISTERED) 
312                         registered_nexus = 1; 
313                 break; 
314         case PR_TYPE_WRITE_EXCLUSIVE_REGONLY: 
315                 we = 1; 
316         case PR_TYPE_EXCLUSIVE_ACCESS_REGONLY: 
317                 /* 
318                  * Some commands are only allowed for registered I_T
Nexuses. 
319                  */ 
320                 reg_only = 1; 
321                 if (se_deve->deve_flags & DEF_PR_REGISTERED) 
322                         registered_nexus = 1; 
323                 break; 
324         case PR_TYPE_WRITE_EXCLUSIVE_ALLREG: 
325                 we = 1; 
326         case PR_TYPE_EXCLUSIVE_ACCESS_ALLREG: 
327                 /* 
328                  * Each registered I_T Nexus is a reservation
holder. 
329                  */ 
330                 all_reg = 1; 
331                 if (se_deve->deve_flags & DEF_PR_REGISTERED) 
332                         registered_nexus = 1; 
333                 break; 
334         default: 
335                 return -1; 
336         }

But I'm not able to devine the difference between 'write_exclusive' and
'write_exclusive_registrants_only'.  Given that a registration must
exist before a reservation can be done, what is the difference between
these two?  I just, again, looked for information describing these in
SPC-4, and didn't find any.

Thanks!
tl

-----Original Message-----
From: Nicholas A. Bellinger [mailto:nab@linux-iscsi.org] 
Sent: Wednesday, April 07, 2010 2:48 PM
To: Lemons, Terry
Cc: linux-scsi@vger.kernel.org
Subject: Re: SCSI persistent reservation terms

On Wed, 2010-04-07 at 10:55 -0400, lemons_terry@emc.com wrote:
> Hi
> 
> I'm trying to understand one aspect of the SCSI persistent reservation
functionality.
> SPC-4 mentions the terms 'All Registrants' and 'Registrants Only', and
applies these
> to both 'Write Exclusive' and 'Exclusive Access'.  Nowhere can I find
a definition
> of what these terms mean.  If you would, please point me in the right
direction.
> 

Greetings Terry,

'All Registrants' means that the persistent reservation holder is any
registstered I_T Nexus (eg: multiple reservation holders)

'Registrants Only' means that the persistent reservation holder is the
single registered I_T Nexus that has obtained the reservation via
RESERVE, PREEMPT, PREEMPT_AND_ABORT, or via another I_T Nexus with
REGISTER_AND_MOVE. (eg: single reservation holder)

You can find how this logic works for multi-fabric target mode by
grepping '_ALLREG' and '_REGONLY' in TCM code at:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=blob;f=
drivers/target/target_core_pr.c

Best,

--nab




