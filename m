From: Tommy Apel <tommyapeldk@gmail.com>
Subject: Re: [Scst-devel] OSS target - VMware SCSI reservation bug conformity.
Date: Thu, 27 Mar 2014 21:22:04 +0100
Message-ID: <CAGA4a+ELcy7_CbJyq-F0L3qZiG=SEGLjeo6j4jwhTCerLbkUmQ@mail.gmail.com>
References: <201403271821.s2RILEXd024935@wind.enjellic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:40986 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166AbaC0UWF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Mar 2014 16:22:05 -0400
Received: by mail-oa0-f41.google.com with SMTP id j17so5071998oag.28
        for <linux-scsi@vger.kernel.org>; Thu, 27 Mar 2014 13:22:04 -0700 (PDT)
In-Reply-To: <201403271821.s2RILEXd024935@wind.enjellic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: greg@enjellic.com
Cc: scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

2014-03-27 19:21 GMT+01:00 Dr. Greg Wettstein <greg@wind.enjellic.com>:
> Hi, hope the week is going well for everyone.
>
> There appears to be evidence that VMware has an issue with exact SCSI
> standards compliance when it comes to handling corner cases with SCSI
> reservation requests.  It appears as if Dell is pushing firmware hot
> fixes for the EqualLogic controllers to work around the issue.
>
> We may have actually caught this one in the wild with SCST.  I'm
> including the linux-scsi list since it may affect any target code
> which is written strictly to the SCSI standards.  Dell appears to be
> handling it with a custom mode page and if the rumor is true it would
> seem the OSS targets may need to consider something similar given the
> importance of VMware as a client.
>
> VMware was being fed storage from a RAID1 mirror on a software defined
> storage (SDS) appliance based on SCST.  The two RAID1 block devices
> were being supplied from two geographically isolated data-centers.  So
> technically VMware should not see an I/O error as long as the RAID1
> layer is running properly, and none of the VMware initiators did.
>
> All target systems were the top of the SCST 2.2.x tree.  The in-kernel
> Qlogic target driver was being used along with our SCST/Qlogic
> interface driver.  The SDS node was connected with 4 GBPS FC into a
> Nexus 5500 which fed a Nexus 7010 which linked to the remote
> data-center through a 20 GBPS FCOE ISL link to a Nexus 7009 which
> downstreamed into another Nexus 5500 and then into the backing target
> with 8 GBPS fibre-channel.
>
> One data-center took a hit which instantly knocked out one of the
> RAID1 devices.  The Qlogic card talking to that data-center went into
> a DTB nexus reset followed by a full adapter reset.
>
> That caused the VMware initiators to begin to timeout and abort
> I/O's.  The relative timeline was as follows:
>
>         00:00:00 ->     Qlogic adapter reset.
>
>         00:00:02 ->     VMware Qlogic I/O abort succeeded.
>
>         00:00:24 ->     VMware SCSI cmd RESERVE failed.
>
>         00:01:00 ->     VMware corrupt heartbeat detected.
>
> So it was all over with, except for the restores from tape, in about 1
> minute... :-(
>
> The storage system is obviously designed for high availability and has
> seen hundreds of aborted I/O's by the VMware initiators due to wide
> area fabric issues and the like.  The SDS proxy had been running for
> almost two years with no issues so we obviously hit some edge case in
> this instance.
>
> There were nine other big LUN's being fed from the SDS node to
> non-VMware initiators and no issues were noted on any of those so the
> regression appears to be tied specifically to VMware.  Some of the
> 'rumors' floating around is that the SCSI reservation regression is
> linked to aborted I/O's during a tight race window so that would add
> additional credence to the notion we provoked this issue.
>
> I'm assuming if there is the chance to fix this at the target level
> there has to be interest within the community.  There isn't a lot
> which can be done to protect an installation, other then hot snapshots
> at the SDS proxy level, since one has to pretty much trust initiators
> to 'do the right thing' which is of course always an issue in
> SCSI-land, particulary with clustered filesystem locking.
>
> We would be interested in any thoughts/reflections that people might
> have.
>
> Have a good remainder of the week.
>
> As always,
> Dr. G.W. Wettstein, Ph.D.   IDfusion.org
> 4206 N. 19th Ave.           Unified health identity architecture.
> Fargo, ND  58102
> PH: 701-281-1686
> FAX: 701-281-3949           EMAIL: greg@idfusion.org
> ------------------------------------------------------------------------------
> "Man, despite his artistic pretensions, his sophistication and many
>  accomplishments, owes the fact of his existence to a six-inch layer of
>  topsoil and the fact that it rains."
>                                 -- Anonymous writer on perspective.
>                                    GAUSSIAN quote.
>
> ------------------------------------------------------------------------------
> _______________________________________________
> Scst-devel mailing list
> https://lists.sourceforge.net/lists/listinfo/scst-devel

Hello lists, excuse me for being a little blunt here, but if what Dr.
Greg is telling here is correct, shouldn't it be vmware that fixed
their BUG in their software rather that everybody else asking "how
high" when vmware says jump ?
I mean, implementing non-standard things to a standard compliant stack
is sort of the wrong path to take I should think, the fact that vmware
has a but in their software, closed source I might add, they should
fix it not the OSS community.

Maybe I'm wrong here, but I believe that standards were made so that
everybody could implement a look-the-same / feel-the-same interface
instead of inventing the wheel over and over again for every brand
known to man kind.

-- 

/Tommy
