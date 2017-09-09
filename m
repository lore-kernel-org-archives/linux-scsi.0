From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH] sd: preserve sysfs updates to max_sectors_kb
Date: Sat, 09 Sep 2017 12:32:22 +0200
Message-ID: <1504953142.5442.1.camel@suse.com>
References: <150309002518.8999.15900049133748830764.stgit@brunhilda>
         <1503090353.2622.15.camel@wdc.com>
         <4993A297653ECB4581FA5C3C31323D195B8D825D@avsrvexchmbx2.microsemi.net>
         <1503092817.2622.19.camel@wdc.com>
         <4993A297653ECB4581FA5C3C31323D195B8DBDE4@avsrvexchmbx2.microsemi.net>
         <1503345191.2571.13.camel@wdc.com>
         <4993A297653ECB4581FA5C3C31323D195B8DBE34@avsrvexchmbx2.microsemi.net>
         <4993A297653ECB4581FA5C3C31323D195B8E9103@avsrvexchmbx1.microsemi.net>
         <1504030401.2653.43.camel@wdc.com>
         <4993A297653ECB4581FA5C3C31323D195B8E9143@avsrvexchmbx1.microsemi.net>
         <4993A297653ECB4581FA5C3C31323D195B8E9191@avsrvexchmbx1.microsemi.net>
         <1504045532.2653.68.camel@wdc.com>
         <4993A297653ECB4581FA5C3C31323D195B8E9288@avsrvexchmbx1.microsemi.net>
         <1504047619.2653.75.camel@wdc.com> <yq1d17d26gz.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:48925 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756989AbdIIKco (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Sat, 9 Sep 2017 06:32:44 -0400
In-Reply-To: <yq1d17d26gz.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "viswas.g@microsemi.com" <viswas.g@microsemi.com>, "gerry.morong@microsemi.com" <gerry.morong@microsemi.com>, "mahesh.rajashekhara@microsemi.com" <mahesh.rajashekhara@microsemi.com>, "POSWALD@suse.com" <POSWALD@suse.com>, "scott.benesh@microsemi.com" <scott.benesh@microsemi.com>, "don.brace@microsemi.com" <don.brace@microsemi.com>, "bader.alisaleh@microsemi.com" <bader.alisaleh@microsemi.com>, "kevin.barnett@microsemi.com" <kevin.barnett@microsemi.com>, "joseph.szczypek@hpe.com" <joseph.szczypek@hpe.com>, "scott.teel@microsemi.com" <scott.teel@microsemi.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "justin.lindley@microsemi.com" <justin.lindley@microsemi.com>, "John.Hall@microsemi.com" <John.Hall@microsemi.com>

Hello Martin,

On Tue, 2017-08-29 at 21:24 -0400, Martin K. Petersen wrote:

> I looked at this for a bit last week to see if I could come up with
> an
> elegant way to accommodate values overridden in sysfs and at the same
> time honor hardware limits changing. However, it quickly gets messy
> since some parameters are under the request_queue and some are
> scsi_disk
> specific. So that involves having override flags several places. Plus
> there also the whole re-stacking debacle.
> 
> So I think I prefer udev for this.

Could you please explain why you think Don's patch is wrong? User
settings being discarded because of a BLKRRPART ioctl violates the
principle of least surprise. With Don's patch, that won't happen any
more. If hardware limits change, whether they increase or decrease, the
patch will also do the Right Thing, AFAICS. Increasing hw limits will
not automatically increase the sw limit, but IMO that's actually
expected.

Best Regards,
Martin

-- 
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
