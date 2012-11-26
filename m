From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/2] Change type-2 dif to use rq embedded 32 byte cdb
Date: Mon, 26 Nov 2012 18:58:03 -0500
Message-ID: <yq14nkbsyr8.fsf@sermon.lab.mkp.net>
References: <1353528468-5664-1-git-send-email-revers@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17965 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932594Ab2KZX7Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Nov 2012 18:59:24 -0500
In-Reply-To: <1353528468-5664-1-git-send-email-revers@redhat.com> (Rob Evers's
	message of "Wed, 21 Nov 2012 15:07:46 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Evers <revers@redhat.com>
Cc: linux-scsi@vger.kernel.org, chad.dupuis@qlogic.com, giridhar.malavali@qlogic.com, scameron@beardog.cce.hp.com, mike.miller@hp.com, fushun@marvell.com

>>>>> "Rob" == Rob Evers <revers@redhat.com> writes:

Rob> These patches replace the original t10 type 2 dif mempool
Rob> implementation by increasing the block and scsi cdb maximum sizes
Rob> from 16 to 32 bytes.  The cdb embedded in the request structure can
Rob> then be used for type 2 dif commands, or other 32 byte cdbs as
Rob> required.

Rob> Motivation for this is that type-2 dif commands should be treated
Rob> as any other read/writes generally, without any performance
Rob> penalty.

We did the mempool because we did not want to penalize everybody else by
always allocating 32-byte CDBs. Type 2 is a really rare corner case.

So while I agree we should handle the UA scenario correctly, I'm not
sure I agree with the fix. Why are you messing with Type 2 devices in
the first place? These should really only be used inside disk arrays.

-- 
Martin K. Petersen	Oracle Linux Engineering
