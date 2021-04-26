Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17731C433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 11:20:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCA8C61249
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 11:20:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232520AbhDZLU7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Apr 2021 07:20:59 -0400
Received: from mx1.uni-regensburg.de ([194.94.157.146]:59160 "EHLO
        mx1.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbhDZLU7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Apr 2021 07:20:59 -0400
X-Greylist: delayed 311 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Apr 2021 07:20:59 EDT
Received: from mx1.uni-regensburg.de (localhost [127.0.0.1])
        by localhost (Postfix) with SMTP id 3B33C600004D
        for <linux-scsi@vger.kernel.org>; Mon, 26 Apr 2021 13:15:00 +0200 (CEST)
Received: from gwsmtp.uni-regensburg.de (gwsmtp1.uni-regensburg.de [132.199.5.51])
        by mx1.uni-regensburg.de (Postfix) with ESMTP id 0A4D76000059
        for <linux-scsi@vger.kernel.org>; Mon, 26 Apr 2021 13:15:00 +0200 (CEST)
Received: from uni-regensburg-smtp1-MTA by gwsmtp.uni-regensburg.de
        with Novell_GroupWise; Mon, 26 Apr 2021 13:14:59 +0200
Message-Id: <6086A0B2020000A100040BBE@gwsmtp.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 18.3.1 
Date:   Mon, 26 Apr 2021 13:14:58 +0200
From:   "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To:     <martin.petersen@oracle.com>, <martin.wilck@suse.com>
Cc:     <dgilbert@interlog.com>, <jejb@linux.vnet.ibm.com>,
        "systemd-devel@lists.freedesktop.org" 
        <systemd-devel@lists.freedesktop.org>, <hch@lst.de>,
        <bmarzins@redhat.com>, <dm-devel@redhat.com>, <hare@suse.com>,
        <linux-scsi@vger.kernel.org>
Subject: Antw: [EXT] Re: [systemd-devel] RFC: one more time: SCSI
 device identification
References: <c524ce68d9a9582732db8350f8a1def461a1a847.camel@suse.com>
 <yq135w4cam3.fsf@ca-mkp.ca.oracle.com>
 <06489ea37311fe7bf73b27a41b5209ee4cca85fe.camel@suse.com>
 <yq1pmynt6f6.fsf@ca-mkp.ca.oracle.com>
 <685c40341d2ddef2fe5a54dd656d10104b0c1bfa.camel@suse.com>
 <yq1im4dre94.fsf@ca-mkp.ca.oracle.com>
 <e3184501cbf23ab0ae94d664725e72b693c64ba9.camel@suse.com>
In-Reply-To: <e3184501cbf23ab0ae94d664725e72b693c64ba9.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>>> Martin Wilck <martin.wilck@suse.com> schrieb am 23.04.2021 um 12:28 in
Nachricht <e3184501cbf23ab0ae94d664725e72b693c64ba9.camel@suse.com>:
> On Thu, 2021‑04‑22 at 21:40 ‑0400, Martin K. Petersen wrote:
>> 
>> Martin,
>> 
>> > I suppose 99.9% of users never bother with customizing the udev
>> > rules.
>> 
>> Except for the other 99.9%, perhaps? :) We definitely have many users
>> that tweak udev storage rules for a variety of reasons. Including
>> being
>> able to use RII for LUN naming purposes.
>> 
>> > But we can actually combine both approaches. If "wwid" yields a
>> > good
>> > value most of the time (which is true IMO), we could make user
>> > space
>> > rely on it by default, and make it possible to set an udev property
>> > (e.g. ENV{ID_LEGACY}="1") to tell udev rules to determine WWID
>> > differently. User‑space apps like multipath could check the
>> > ID_LEGACY
>> > property to determine whether or not reading the "wwid" attribute
>> > would
>> > be consistent with udev. That would simplify matters a lot for us
>> > (Ben,
>> > do you agree?), without the need of adding endless BLIST entries.
>> 
>> That's fine with me.
>> 
>> > AFAICT, no major distribution uses "wwid" for this purpose (yet).
>> 
>> We definitely have users that currently rely on wwid, although
>> probably
>> not through standard distro scripts.
>> 
>> > In a recent discussion with Hannes, the idea came up that the
>> > priority
>> > of "SCSI name string" designators should actually depend on their
>> > subtype. "naa." name strings should map to the respective NAA
>> > descriptors, and "eui.", likewise (only "iqn." descriptors have no
>> > binary counterpart; we thought they should rather be put below NAA,
>> > prio‑wise).
>> 
>> I like what NVMe did wrt. to exporting eui, nguid, uuid separately
>> from
>> the best‑effort wwid. That's why I suggested separate sysfs files for
>> the various page 0x83 descriptors. I like the idea of being able to
>> explicitly ask for an eui if that's what I need. But that appears to
>> be
>> somewhat orthogonal to your request.
>> 
>> > I wonder if you'd agree with a change made that way for "wwid". I
>> > suppose you don't. I'd then propose to add a new attribute
>> > following
>> > this logic. It could simply be an additional attribute with a
>> > different
>> > name. Or this new attribute could be a property of the block device
>> > rather than the SCSI device, like NVMe does it
>> > (/sys/block/nvme0n2/wwid).
>> 
>> That's fine. I am not a big fan of the idea that block/foo/wwid and
>> block/foo/device/wwid could end up being different. But I do think
>> that
>> from a userland tooling perspective the consistency with NVMe is more
>> important.
> 
> OK, then here's the plan: Change SCSI (block) device identification to
> work similar to NVMe (in addition to what we have now).
> 
>  1. add a new sysfs attribute for SCSI block devices as
> /sys/block/sd$X/wwid, the value derived similar to the current "wwid"
> SCSI device attribute, but using the same prio for SCSI name strings as
> for their binary counterparts, as described above.
> 
>  2. add "naa" and "eui" attributes, too, for user‑space applications
> that are interested in these specific attributes. 
> Fixme: should we differentiate between different "naa" or eui subtypes,
> like "naa_regext", "eui64" or similar? If the device defines multiple
> "naa" designators, which one should we choose?
> 
>  3. Change udev rules such that they primarily look at the attribute in
> 1.) on new installments, and introduce a variable ID_LEGACY to tell the
> rules to fall back to the current algorithm. I suppose it makes sense
> to have at least ID_VENDOR and ID_PRODUCT available when making this
> decision, so that it doesn't have to be a global setting on a given
> host.
> 
> While we're at it, I'd like to mention another issue: WWID changes.
> 
> This is a big problem for multipathd. The gist is that the device
> identification attributes in sysfs only change after rescanning the
> device. Thus if a user changes LUN assignments on a storage system, 
> it can happen that a direct INQUIRY returns a different WWID as in
> sysfs, which is fatal. If we plan to rely more on sysfs for device
> identification in the future, the problem gets worse. 

I think many devices rely on the fact that they are identified by
Vendor/model/serial_nr, because in most professional SAN storage systems you
can pre-set the serial number to a custom value; so if you want a new disk
(maybe a snapshot) to be compatible with the old one, just assign the same
serial number. I guess that's the idea behind.

> 
> I wonder if there's a chance that future kernels would automatically
> update the attributes if a corresponding UNIT ATTENTION condition such
> as INQUIRY DATA HAS CHANGED is received (*), or if we can find some
> other way to avoid data corruption resulting from writing to the wrong
> device.
> 
> Regards,
> Martin
> 
> (*) I've been told that WWID changes can happen even without receiving
> an UA. But in that case I'm inclined to put the blame on the storage.
> 
> ‑‑ 
> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Software Solutions Germany GmbH
> HRB 36809, AG Nürnberg GF: Felix Imendörffer
> 
> 
> _______________________________________________
> systemd‑devel mailing list
> systemd‑devel@lists.freedesktop.org 
> https://lists.freedesktop.org/mailman/listinfo/systemd‑devel 



