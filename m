From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v8 08/13] libsas: libsas.force_hard_reset module parameter
Date: Wed, 29 Feb 2012 15:27:54 -0800
Message-ID: <CABE8wwsQdhg-LhEN=sLoZAsNpOmfMVzHCpvaW5E3A1LuXzTKkw@mail.gmail.com>
References: <20120210084411.25701.94502.stgit@dwillia2-linux.jf.intel.com>
	<20120210084520.25701.83280.stgit@dwillia2-linux.jf.intel.com>
	<1330552551.8846.24.camel@dabdike>
	<4F4EA976.4010607@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:34265 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752184Ab2B2X1z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Feb 2012 18:27:55 -0500
Received: by obbwd18 with SMTP id wd18so4438971obb.25
        for <linux-scsi@vger.kernel.org>; Wed, 29 Feb 2012 15:27:54 -0800 (PST)
In-Reply-To: <4F4EA976.4010607@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Jack Wang <jack_wang@usish.com>, Luben Tuikov <ltuikov@yahoo.com>, Xiangliang Yu <yuxiangl@marvell.com>

On Wed, Feb 29, 2012 at 2:40 PM, Douglas Gilbert <dgilbert@interlog.com=
> wrote:
> On 12-02-29 04:55 PM, James Bottomley wrote:
>>
>> On Fri, 2012-02-10 at 00:45 -0800, Dan Williams wrote:
>>>
>>> It is possible for a host to get "locked out" from talking to sata
>>> devices in the domain if, for example, its sas address changes but =
the
>>> expander topology has existing affiliations with the old address. =A0=
If
>>> the system is booted userspace can write to
>>> /sys/class/sas_phy/<phy-X>/hard_reset to clear the affiliation, how=
ever
>>> if this condition exists for the root device the module parameter c=
an be
>>> used to promote all ata resets to hard resets.
>
>
> A point of order: SAS has link resets and hard resets. The
> hard reset is a superset of link reset. A "link reset sequence
> serves as a hard reset for SATA devices" and hence is
> sufficient to reset a SATA device. To reset a SAS device
> (e.g. a SAS disk) you need a SAS hard reset. Therefore a link
> reset is the appropriately sized "gun" to reset a SATA device.
>
> I have a SAS-2 expander that annoyingly powers up with the
> programmed maximum physical link rate of its phys at 3 Gbps
> even though its hardware maximum rate is 6 Gbps. For expander
> phys connected to SAS-2 disks I can up the programmed maximum
> value to 6 Gbps on the expander phy then do a link reset on
> that phy. So without upsetting Linux (or any other OS) I can
> switch that path from 3 Gbps to 6 Gbps. Can't do that with a
> SATA disk without the OS finding out.

At least now (with these pending patches) if you trigger a link-reset
via the sysfs interface libsas will manage the link recovery like any
other error-recovery initiated reset.

Something like a libsas.force_max_phys_link_rate module parameter
might not be a bad idea for this scenario, since libsas sata discovery
always forces at least one reset of the disk after the phy reports
"attached sata device".

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
