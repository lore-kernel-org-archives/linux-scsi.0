From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: SCSI persistent reservation terms
Date: Wed, 07 Apr 2010 11:47:57 -0700
Message-ID: <1270666077.3332.10.camel@haakon2.linux-iscsi.org>
References: <3BEB5F9B6605A140847DEEEDF7439C5D040A06C8@CORPUSMX50A.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp104.sbc.mail.gq1.yahoo.com ([67.195.15.63]:40472 "HELO
	smtp104.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752109Ab0DGSsE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Apr 2010 14:48:04 -0400
In-Reply-To: <3BEB5F9B6605A140847DEEEDF7439C5D040A06C8@CORPUSMX50A.corp.emc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lemons_terry@emc.com
Cc: linux-scsi@vger.kernel.org

On Wed, 2010-04-07 at 10:55 -0400, lemons_terry@emc.com wrote:
> Hi
> 
> I'm trying to understand one aspect of the SCSI persistent reservation functionality.
> SPC-4 mentions the terms 'All Registrants' and 'Registrants Only', and applies these
> to both 'Write Exclusive' and 'Exclusive Access'.  Nowhere can I find a definition
> of what these terms mean.  If you would, please point me in the right direction.
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

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=blob;f=drivers/target/target_core_pr.c

Best,

--nab



