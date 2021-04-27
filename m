Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F829C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 07:02:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0613861076
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 07:02:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbhD0HC7 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 03:02:59 -0400
Received: from mx3.uni-regensburg.de ([194.94.157.148]:46896 "EHLO
        mx3.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbhD0HC6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Apr 2021 03:02:58 -0400
Received: from mx3.uni-regensburg.de (localhost [127.0.0.1])
        by localhost (Postfix) with SMTP id 4F22B6000062
        for <linux-scsi@vger.kernel.org>; Tue, 27 Apr 2021 09:02:14 +0200 (CEST)
Received: from gwsmtp.uni-regensburg.de (gwsmtp1.uni-regensburg.de [132.199.5.51])
        by mx3.uni-regensburg.de (Postfix) with ESMTP id 2B481600005E
        for <linux-scsi@vger.kernel.org>; Tue, 27 Apr 2021 09:02:13 +0200 (CEST)
Received: from uni-regensburg-smtp1-MTA by gwsmtp.uni-regensburg.de
        with Novell_GroupWise; Tue, 27 Apr 2021 09:02:12 +0200
Message-Id: <6087B6F2020000A100040C47@gwsmtp.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 18.3.1 
Date:   Tue, 27 Apr 2021 09:02:10 +0200
From:   "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To:     <erwin@erwinvanlonden.net>, <martin.petersen@oracle.com>,
        <martin.wilck@suse.com>
Cc:     <dgilbert@interlog.com>, <jejb@linux.vnet.ibm.com>,
        "systemd-devel@lists.freedesktop.org" 
        <systemd-devel@lists.freedesktop.org>, <hch@lst.de>,
        <dm-devel@redhat.com>, <hare@suse.com>,
        <linux-scsi@vger.kernel.org>
Subject: Antw: [EXT] Re: [dm-devel] RFC: one more time: SCSI device
 identification
References: <c524ce68d9a9582732db8350f8a1def461a1a847.camel@suse.com>
 <yq135w4cam3.fsf@ca-mkp.ca.oracle.com>
 <06489ea37311fe7bf73b27a41b5209ee4cca85fe.camel@suse.com>
 <yq1pmynt6f6.fsf@ca-mkp.ca.oracle.com>
 <685c40341d2ddef2fe5a54dd656d10104b0c1bfa.camel@suse.com>
 <yq1im4dre94.fsf@ca-mkp.ca.oracle.com>
 <e3184501cbf23ab0ae94d664725e72b693c64ba9.camel@suse.com>
 <6086A0B2020000A100040BBE@gwsmtp.uni-regensburg.de>
 <59dc346de26997a6b8e3ae3d86d84ada60b3d26b.camel@suse.com>
 <b5f288fb43bc79e0206794a901aef5b1761813de.camel@erwinvanlonden.net>
In-Reply-To: <b5f288fb43bc79e0206794a901aef5b1761813de.camel@erwinvanlonden.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>>> Erwin van Londen <erwin@erwinvanlonden.net> schrieb am 27.04.2021 um 05:48 in
Nachricht
<b5f288fb43bc79e0206794a901aef5b1761813de.camel@erwinvanlonden.net>:

> 
> On Mon, 2021-04-26 at 13:16 +0000, Martin Wilck wrote:
>> On Mon, 2021-04-26 at 13:14 +0200, Ulrich Windl wrote:
>> > > > 
>> > > 
>> > > While we're at it, I'd like to mention another issue: WWID
>> > > changes.
>> > > 
>> > > This is a big problem for multipathd. The gist is that the device
>> > > identification attributes in sysfs only change after rescanning
>> > > the
>> > > device. Thus if a user changes LUN assignments on a storage
>> > > system,
>> > > it can happen that a direct INQUIRY returns a different WWID as
>> > > in
>> > > sysfs, which is fatal. If we plan to rely more on sysfs for
>> > > device
>> > > identification in the future, the problem gets worse. 
>> > 
>> > I think many devices rely on the fact that they are identified by
>> > Vendor/model/serial_nr, because in most professional SAN storage
>> > systems you
>> > can pre-set the serial number to a custom value; so if you want a
>> > new
>> > disk
>> > (maybe a snapshot) to be compatible with the old one, just assign
>> > the
>> > same
>> > serial number. I guess that's the idea behind.
>> 
>> What you are saying sounds dangerous to me. If a snapshot has the
>> same
>> WWID as the device it's a snapshot of, it must not be exposed to any
>> host(s) at the same time with its origin, otherwise the host may
>> happily combine it with the origin into one multipath map, and data
>> corruption will almost certainly result. 
>> 
>> My argument is about how the host is supposed to deal with a WWID
>> change if it happens. Here, "WWID change" means that a given H:C:T:L
>> suddenly exposes different device designators than it used to, while
>> this device is in use by a host. Here, too, data corruption is
>> imminent, and can happen in a blink of an eye. To avoid this, several
>> things are needed:
>> 
>>  1) the host needs to get notified about the change (likely by an UA
>> of
>> some sort)
>>  2) the kernel needs to react to the notification immediately, e.g.
>> by
>> blocking IO to the device,
>>  3) userspace tooling such as udev or multipathd need to figure out
>> how
>> to  how to deal with the situation cleanly, and eventually unblock
>> it.
>> 
>> Wrt 1), we can only hope that it's the case. But 2) and 3) need work,
>> afaics.
>> 
> In my view the WWID should never change. If a snapshot is created it
> should either obtain a new WWID. An example out of a Hitachi array is
> 
> Device Identification VPD page:
> Addressed logical unit:
> designator type: T10 vendor identification, code set: ASCII
> vendor id: HITACHI 
> vendor specific: 50403B050709
> designator type: NAA, code set: Binary
> 0x60060e80123b050050403b0500000709
> 
> The majority of the naa wwid is tied to the storage subsystem and
> identifies the vendor oui, model, serial etc. The last 4 in this
> example indicate the LDEV ID (Sorry mainframe heritage here..). When a
> snapshot is taken these 4 will change as a new LDEV ID is assigned to
> the snapshot. This sort of behaviour should be consistent across all
> storage vendors imho.

It's getting off-topic, but in automatic desaster recovery scenarios one might want that the "new disk" (maybe a snapshot of the original disk before it got corrupted) looks like the "old disk", so that the OS can boot without needing any adjustments.

Regards,
Ulrich

> 
>> Martin
>> 




