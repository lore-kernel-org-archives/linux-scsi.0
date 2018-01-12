From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 17/19] qla2xxx: prevent bounds-check bypass via
 speculative execution
Date: Thu, 11 Jan 2018 21:38:18 -0800
Message-ID: <CAPcyv4gb8SpBEYnuc3hULLZdiuUM1Lhc33CBirmXtckD0CsLww@mail.gmail.com>
References: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151571807774.27429.7382333750792304971.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1515719956.3056.37.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ot0-f182.google.com ([74.125.82.182]:34507 "EHLO
        mail-ot0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751681AbeALFiU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jan 2018 00:38:20 -0500
Received: by mail-ot0-f182.google.com with SMTP id p16so4189361otf.1
        for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2018 21:38:19 -0800 (PST)
In-Reply-To: <1515719956.3056.37.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, kernel-hardening@lists.openwall.com, qla2xxx-upstream@qlogic.com, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Elena Reshetova <elena.reshetova@intel.com>, Alan Cox <alan@linux.intel.com>

On Thu, Jan 11, 2018 at 5:19 PM, James Bottomley
<jejb@linux.vnet.ibm.com> wrote:
> On Thu, 2018-01-11 at 16:47 -0800, Dan Williams wrote:
>> Static analysis reports that 'handle' may be a user controlled value
>> that is used as a data dependency to read 'sp' from the
>> 'req->outstanding_cmds' array.
>
> Greg already told you it comes from hardware, specifically the hardware
> response queue.  If you don't believe him, I can confirm it's quite
> definitely all copied from the iomem where the mailbox response is, so
> it can't be a user controlled value (well, unless the user has some
> influence over the firmware of the qla2xxx  controller, which probably
> means you have other things to worry about than speculative information
> leaks).

I do believe him, and I still submitted this. I'm trying to probe at
the meta question of where do we draw the line with these especially
when it costs us relatively little to apply a few line patch? We fix
theoretical lockdep races, why not theoretical data leak paths?
