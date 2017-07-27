From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] scsi: aacraid: Off by one NUL terminator
Date: Wed, 26 Jul 2017 23:08:15 -0400
Message-ID: <yq1wp6uwp9c.fsf@oracle.com>
References: <20170725195110.uwrzzkzvrbfqv7ld@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25780 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751423AbdG0DI1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jul 2017 23:08:27 -0400
In-Reply-To: <20170725195110.uwrzzkzvrbfqv7ld@mwanda> (Dan Carpenter's message
        of "Tue, 25 Jul 2017 22:51:10 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>, Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org


Dan,

> We're putting a NUL terminator one character beyond the end of the
> struct and that's obviously wrong.  On the other hand, I'm not positive
> this is the correct fix.  This change was added deliberately and was
> mentioned in the changlog of commit b836439faf04 ("aacraid: 4KB sector
> support").  The relevant section is "Also fix up a name truncation
> problem".  Can someone review this code and figure out the right thing
> to do?

I guess that's a feeble attempt to compensate for the fact it's not a C
string. The string coming from the controller firmware appears to be a
fixed 16-byte length. And so is the inquiry buffer that it's being
copied to.

If the code would just use the inquiry string verbatim instead of
removing leading spaces and padding it. But there was probably some
crappy device out there that broke something for someone...

Anyway. Terminating the string is not the right fix.

-- 
Martin K. Petersen	Oracle Linux Engineering
