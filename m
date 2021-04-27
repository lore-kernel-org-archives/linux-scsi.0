Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94F83C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 10:52:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B4C2613B0
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 10:52:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235254AbhD0KxV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 06:53:21 -0400
Received: from mx4.uni-regensburg.de ([194.94.157.149]:36434 "EHLO
        mx4.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbhD0KxU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Apr 2021 06:53:20 -0400
Received: from mx4.uni-regensburg.de (localhost [127.0.0.1])
        by localhost (Postfix) with SMTP id 05756600004E
        for <linux-scsi@vger.kernel.org>; Tue, 27 Apr 2021 12:52:35 +0200 (CEST)
Received: from gwsmtp.uni-regensburg.de (gwsmtp1.uni-regensburg.de [132.199.5.51])
        by mx4.uni-regensburg.de (Postfix) with ESMTP id 20327600005F
        for <linux-scsi@vger.kernel.org>; Tue, 27 Apr 2021 12:52:34 +0200 (CEST)
Received: from uni-regensburg-smtp1-MTA by gwsmtp.uni-regensburg.de
        with Novell_GroupWise; Tue, 27 Apr 2021 12:52:34 +0200
Message-Id: <6087ECF1020000A100040C7F@gwsmtp.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 18.3.1 
Date:   Tue, 27 Apr 2021 12:52:33 +0200
From:   "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To:     <erwin@erwinvanlonden.net>, <martin.petersen@oracle.com>,
        <martin.wilck@suse.com>, <hare@suse.de>
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
 <15e1a6a493f55051eab844bab2a107f783dc27ee.camel@suse.com>
 <2a6903e4-ff2b-67d5-e772-6971db8448fb@suse.de>
In-Reply-To: <2a6903e4-ff2b-67d5-e772-6971db8448fb@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>>> Hannes Reinecke <hare@suse.de> schrieb am 27.04.2021 um 10:21 in Nachricht
<2a6903e4-ff2b-67d5-e772-6971db8448fb@suse.de>:
> On 4/27/21 10:10 AM, Martin Wilck wrote:
>> On Tue, 2021‑04‑27 at 13:48 +1000, Erwin van Londen wrote:
>>>>
>>>> Wrt 1), we can only hope that it's the case. But 2) and 3) need work,
>>>> afaics.
>>>>
>>> In my view the WWID should never change. 
>> 
>> In an ideal world, perhaps not. But in the dm‑multipath realm, we know
>> that WWID changes can happen with certain storage arrays. See 
>> https://listman.redhat.com/archives/dm‑devel/2021‑February/msg00116.html 
>> and follow‑ups, for example.
>> 
> And it's actually something which might happen quite easily.
> The storage array can unmap a LUN, delete it, create a new one, and map
> that one into the same LUN number than the old one.
> If we didn't do I/O during that interval upon the next I/O we will be
> getting the dreaded 'Power‑On/Reset' sense code.
> _And nothing else_, due to the arcane rules for sense code generation in
> SAM.
> But we end up with a completely different device.
> 
> The only way out of it is to do a rescan for every POR sense code, and
> disable the device eg via DID_NO_CONNECT whenever we find that the
> identification has changed. We already have a copy of the original VPD
> page 0x83 at hand, so that should be reasonably easy.

I don't know the depth of the SCSI or FC protocol, but storage systems
typically signal such events, maybe either via some unit attention or some FC
event. Older kernels logged that there was a change, but a manual SCSI bus scan
is needed, while newer kernels find new devices "automagically" for some
products. The HP EVA 6000 series wored that way, a 3PAR SotorServ 8000 series
also seems to work that way, but not Pure Storage X70 R3. FOr the latter you
need something like a FC LIP to make the kernel detect the new devices (LUNs).
I'm unsure where the problem is, but in principle the kernel can be
notified...

> 
> I had a rather lengthy discussion with Fred Knight @ NetApp about
> Power‑On/Reset handling, what with him complaining that we don't handle
> is correctly. So this really is something we should be looking into,
> even independently of multipathing.
> 
> But actually I like the idea from Martin Petersen to expose the parsed
> VPD identifiers to sysfs; that would allow us to drop sg_inq completely
> from the udev rules.

Talking of VPDs: Somewhere in the last 12 years (within SLES 11)there was a
kernel change regarding trailing blanks in VPD data. That change blew up
several configurations being unable to re-recognize the devices. In one case
the software even had bound a license to a specific device with serial number,
and that software found "new" devices while missing the "old" ones...

Regards,
Ulrich

> 
> Cheers,
> 
> Hannes
> ‑‑ 
> Dr. Hannes Reinecke		        Kernel Storage Architect
> hare@suse.de			               +49 911 74053 688
> SUSE Software Solutions Germany GmbH, 90409 Nürnberg
> GF: F. Imendörffer, HRB 36809 (AG Nürnberg)



