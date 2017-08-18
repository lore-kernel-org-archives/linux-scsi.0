From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] Revert "scsi-mq: Always unprepare before requeuing a request"
Date: Fri, 18 Aug 2017 22:06:32 +1000
Message-ID: <87wp61ozav.fsf@concordia.ellerman.id.au>
References: <20170816174324.29276-1-bart.vanassche@wdc.com> <yq1fucrqchu.fsf@oracle.com> <a757a93a-0052-e22f-b035-b8cc27256dc5@wdc.com> <3401ef29-7450-eb15-9dd1-2f021354286d@wdc.com> <yq18tijow0o.fsf@oracle.com> <1502933351.14158.3.camel@wdc.com> <yq1a82znec9.fsf@oracle.com> <1502937699.2763.1.camel@wdc.com> <yq1tw16nbzf.fsf@oracle.com> <1502983764.2615.3.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:52349 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751644AbdHRMGf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Aug 2017 08:06:35 -0400
In-Reply-To: <1502983764.2615.3.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "jthumshirn@suse.de" <jthumshirn@suse.de>, Damien Le Moal <Damien.LeMoal@wdc.com>, "hch@lst.de" <hch@lst.de>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "brking@linux.vnet.ibm.com" <brking@linux.vnet.ibm.com>, "abdhalee@linux.vnet.ibm.com" <abdhalee@linux.vnet.ibm.com>, "hare@suse.com" <hare@suse.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>

Bart Van Assche <Bart.VanAssche@wdc.com> writes:

> On Wed, 2017-08-16 at 22:51 -0400, Martin K. Petersen wrote:
>> > When I checked earlier today the ipr patch was not yet in linux-next
>> 
>> That's weird. They were both committed two weeks ago.
>> 
>> They appear to be in there now, though:
>> 
>> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/log/drivers/scsi?ofs=50
>
> Hello Martin,
>
> As far as I can see commit 270065e92c31 ("scsi-mq: Always unprepare before
> requeuing a request") was yesterday in linux-next but not the ipr fix
> (commit b0e17a9b0df2 ("scsi: ipr: Fix scsi-mq lockdep issue")). The
> ipr fix is in today's linux-next but was not in linux-next yesterday (the
> Australian time zone applies to the linux-next date labels):
> $ git tag --contains 270065e92c31
> next-20170816
> $ git tag --contains b0e17a9b0df2
> next-20170817
> $ git show next-20170816 | head -3
> tag next-20170816
> Tagger: Stephen Rothwell <sfr@canb.auug.org.au>
> Date:   Wed Aug 16 15:26:43 2017 +1000
> $ git show next-20170817 | head -3  
> tag next-20170817
> Tagger: Stephen Rothwell <sfr@canb.auug.org.au>
> Date:   Thu Aug 17 16:34:30 2017 +1000
>
> I think this means that the ipr fix went upstream before it ended up in
> linux-next.

It was in linux-next, but as a different commit. I don't know why.

$ git log -1 --format=oneline next-20170816 drivers/scsi/ipr.c
48b580cacfae123471f8cd43ca81b0e53c9cf702 scsi: ipr: Fix scsi-mq lockdep issue


$ git tag --contains 48b580cacfae123471f8cd43ca81b0e53c9cf702
next-20170809
next-20170810
next-20170811
next-20170815
next-20170816


cheers
