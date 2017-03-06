From: Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [RFC] hv_storvsc: error handling.
Date: Mon, 6 Mar 2017 09:57:05 -0800
Message-ID: <20170306095705.76931fc9@xeon-e3>
References: <c1949de0-8b95-e254-1bec-bcdae762890f@kernel.dk>
        <1488301573.3046.9.camel@linux.vnet.ibm.com>
        <20170228105741.6253bb8a@xeon-e3>
        <1488325732.11610.9.camel@linux.vnet.ibm.com>
        <20170228172532.280811ed@xeon-e3>
        <1488349258.20321.11.camel@linux.vnet.ibm.com>
        <20170228224845.1da358ee@xeon-e3>
        <20170301155057.GA13167@lst.de>
        <20170301075412.2e5f1e98@xeon-e3>
        <20170302000135.GA22886@lst.de>
        <20170302005615.GA23687@lst.de>
        <20170301174058.383da142@xeon-e3>
        <c8ff2b64-2421-ca45-1f89-afec0490c8b3@suse.de>
        <20170302102324.47dbe3ad@xeon-e3>
        <895c4f2e-7faa-41e1-b5de-eedb4ae0f882@email.android.com>
        <20170302110505.6ad2eb61@xeon-e3>
        <1b325703-b823-4304-9d9d-86071811e000@email.android.com>
        <20170303165011.53a38794@xeon-e3>
        <DM5PR03MB24906E9B50B16B8C567EE25BA02A0@DM5PR03MB2490.namprd03.prod.outlook.com>
        <20170306083619.6789f9ba@xeon-e3>
        <DM5PR03MB2490F80E2F703D6FD3F1AC4BA02C0@DM5PR03MB2490.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f47.google.com ([74.125.83.47]:36596 "EHLO
        mail-pg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753208AbdCFR53 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2017 12:57:29 -0500
Received: by mail-pg0-f47.google.com with SMTP id 187so14889720pgb.3
        for <linux-scsi@vger.kernel.org>; Mon, 06 Mar 2017 09:57:13 -0800 (PST)
In-Reply-To: <DM5PR03MB2490F80E2F703D6FD3F1AC4BA02C0@DM5PR03MB2490.namprd03.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>
Cc: James Bottomley <James.Bottomley@Hansenpartnership.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, Jens Axboe <axboe@kernel.dk>, Linus Torvalds <torvalds@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, Josh Poulson <jopoulso@microsoft.com>, "Adrian Suhov (Cloudbase Solutions SRL)" <v-adsuho@microsoft.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Haiyang Zhang <haiyangz@microsoft.com>


> > I will try it, but it can't work for two reasons.
> > First, the INVALID_LUN error is masked off on INQUIRY in current code.
> > Second, the scsi_device is instantiated already as part of scan probe process
> > before it gets here.  
> 
> Was the invalid LUN in the LUN0 position. Inquiry of LUN0 support (when LUN0 is not populated)
> was added only recently to address host side issue.

When probing the code probes with LUN 1, ...

There is a cause where kernel does INQUIRY on LUN0, it looks kernel is asking for
page code 80 which is optional "Unit Serial Number".  And then WS2016 is returning
an error and invalid sense data.  The old masking of errors caused kernel to
interpret sense data as Unit Serial Number which is also not good but looks harmless.

 
> > The best solution so far is:
> > 	- remove old INQUIRY/SENSE error masking
> > 	+ add new workaround for INQUIRY of device id on LUN 0
> > 	  which appears to be the reason for old masking
> > 	+ return errors on missing LUN
> > 	+ provide better transport services for hot remove (rather
> >           than detecting by failed I/O).  
> 
> This the mechanism used by the host for notifying LUN removal - invalid LUN error code.

This has a couple of problems. First, it means that hotplug doesn't occur until
an I/O is done. Second the current code was not being truthful to block layer.
If it has to handle hotplug in this manner, it should have still failed the I/O.
If application was using direct I/O it would want to know that write failed.

Perhaps the existing channel mechanism can be used as notification path.
