From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: mvsas: Replace pci_pool_alloc by pci_pool_zalloc
Date: Tue, 13 Dec 2016 20:52:30 -0500
Message-ID: <yq1oa0fe0pt.fsf@sermon.lab.mkp.net>
References: <20161128112626.GA31859@gnr743-HP-ZBook-15>
        <20161206132808.GD4818@linux-x5ow.site>
        <CAFqt6zZLJyDJzwQZ6U3T9XG2JwQEOrEQEMYL0yLrbOnjH=yO_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40063 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752185AbcLNBwn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2016 20:52:43 -0500
In-Reply-To: <CAFqt6zZLJyDJzwQZ6U3T9XG2JwQEOrEQEMYL0yLrbOnjH=yO_A@mail.gmail.com>
        (Souptick Joarder's message of "Mon, 12 Dec 2016 10:14:29 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Rameshwar Sahu <sahu.rameshwar73@gmail.com>, linux-scsi@vger.kernel.org

>>>>> "Souptick" == Souptick Joarder <jrdr.linux@gmail.com> writes:

Souptick,

Sorry about the delay. Been out for a few days.

>>> Inside mvs_task_prep(), pci_pool_alloc() followed by memset will be
>>> replaced by pci_pool_zalloc()

Souptick> Any further comment on this ?

I took one of your other patches because the driver maintainer acked it,
thus assuming responsibility for testing it and fixing any regressions
it may cause.

The failure rate on these "trivial" patches to old and unmaintained
drivers is very high. And since you are not fixing any bugs and your
change is functionally identical what the code already does, why would
we merge it and risk a regression? (for changes like this, a Tested-by:
from somebody with actual hardware is worth a thousand Reviewed-by:
tags).

Also, I'm not really convinced that this constant churn of new and
"improved" kernel interface helper functions is really solving anything.
Quite the contrary. Real bug fixes for drivers adopting the
pci_pool_zalloc() interface will now potentially be harder to backport
to stable releases predating 4.4 or whenever that call was introduced.

So in summary, I don't see any actual benefits to your proposed
change. It's probably fine, but why would I risk merging it?

Hope that all makes sense...

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
