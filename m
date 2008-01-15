From: "Grant Grundler" <grundler@google.com>
Subject: Re: MPT Fusion initialization in 2.6.23.12
Date: Tue, 15 Jan 2008 08:53:05 -0800
Message-ID: <da824cf30801150853wbf64e5aj802ae12c96145247@mail.gmail.com>
References: <da824cf30801141641u7baac682haa1ff06dddc5da99@mail.gmail.com>
	 <664A4EBB07F29743873A87CF62C26D70C5D129@NAMAIL4.ad.lsil.com>
	 <20080115163749.GB12884@synapse.neuralscape.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:12980 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbYAOQxH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Jan 2008 11:53:07 -0500
Received: from zps19.corp.google.com (zps19.corp.google.com [172.25.146.19])
	by smtp-out.google.com with ESMTP id m0FGr6Eq027560
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jan 2008 08:53:06 -0800
Received: from rv-out-0910.google.com (rvbl15.prod.google.com [10.140.88.15])
	by zps19.corp.google.com with ESMTP id m0FGqguo028298
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jan 2008 08:53:05 -0800
Received: by rv-out-0910.google.com with SMTP id l15so2281093rvb.50
        for <linux-scsi@vger.kernel.org>; Tue, 15 Jan 2008 08:53:05 -0800 (PST)
In-Reply-To: <20080115163749.GB12884@synapse.neuralscape.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Karen Shaeffer <shaeffer@neuralscape.com>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, linux-scsi@vger.kernel.org

On Jan 15, 2008 8:37 AM, Karen Shaeffer <shaeffer@neuralscape.com> wrote:
> Hi Eric and Grant,
>
> These messages, all 15 of them only appear during the boot sequence. I
> never see them at any other time. The messages are in dmesg and syslog.
>
> This is a Sun X4200 M2 Netra server. The LSI SAS1064 "RAID enabled"
> Ultra320 SCSI controller supports RAID0, RAID1, and RAID1E modes. The
> implementation uses RAID1, so this chip is RAID-enabled.

http://www.sun.com/servers/netra/x4200/specs.xml says you only have SAS
and NOT u320 SCSI (unless an add-on u320 SCSI card is installed).
LSI u320 SCSI cards can  support RAID0/1 but HP-UX didn't ship with RAID
enabled because of Firmware bugs (which may have been fixed in the mean time).

If you post "lspci -vt" and/or "lspci" output, it would be clear
what's in the box.


> I will look into this more today and report back any useful information
> I learn. Thanks very much for your help in understanding this.

excellent - thanks,

grant
>
> Thanks,
> Karen
>
> On Mon, Jan 14, 2008 at 06:19:30PM -0700, Moore, Eric wrote:
> > On  Monday, January 14, 2008 5:42 PM, Grant Grundler wrote:
> > > > mptbase: ioc0: IOCStatus(0x0022): Config Page Invalid Page:
> > > type=08h, page=00h, action=01h, form=00000001h
> > >
> > > My interpretation of this (and Eric should know this alot better) is
> > > the host is attempting to
> > > read (action=01h) this page (type 08h ==
> > > MPI_CONFIG_PAGETYPE_RAID_VOLUME) and couldn't.
> > > ie maybe HW RAID isn't configured on the card?
> > >
> >
> > Grant - Your right that this is MPI_CONFIG_PAGETYPE_RAID_VOLUME(=0x8).
> > I responded too soon earlier, my thinking it was scanning the sas
> > topology, in which its expected to get Invalid pages.  In previous
> > email, the form being passed (1 thru 0xF) means someone is scaning the
> > target ids, from 1 thru 15.  I just checked my code, and there is no
> > place where I scan volumes. The only place I ask for the volume pages,
> > is in mpt_inactive_raid_volume, and I only ask for this page when I
> > already know the target_id.  Thus I think this must be application
> > driven thru mptctl interface.
> >
> > Eric
> ---end quoted text---
>
> --
>
>  Karen Shaeffer
>  Neuralscape, Palo Alto, Ca. 94306
>  shaeffer@neuralscape.com  http://www.neuralscape.com
>
