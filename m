From: "Martin Peschke3" <MPESCHKE@de.ibm.com>
Subject: Re: Transport Attributes -- attempt#3
Date: Wed, 21 Jan 2004 00:20:37 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFCD4039B7.A0F8A1CD-ONC1256E21.007FF974@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:38391 "EHLO
	mtagate5.de.ibm.com") by vger.kernel.org with ESMTP id S265872AbUATXUq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jan 2004 18:20:46 -0500
List-Id: linux-scsi@vger.kernel.org
To: patmans@us.ibm.com
Cc: brking@us.ibm.com, Martin Hicks <mort@wildopensource.com>, linux-scsi@vger.kernel.org


Patrick Mansfield wrote:
> But we need something like this:
>
> `-- pcifoo
>     `-- host14
>         |-- host_attrs
>         `-- 14:0
>             |-- bus_fabric_attrs
>             `-- 14:0:0
>                 |-- target_attrs
>                 |-- 14:0:0:0
>                 |   `-- sdev_attrs
>                 `-- 14:0:0:1
>                     `-- sdev_attrs
>
> And then driver model class or bus code can be used with the above as
> needed.

And a rectified hierarchy of SCSI data structures should leave its mark
on other SCSI stack functions. I am particularly thinking of error
recovery, which should always be limited to the actual scope of failure=
,
i.e. lun, target, bus, adapter, and be enlarged on demand, i.e. from
lun to target, and so on, if some sort of escalation is needed.
I have seen (2.4) SCSI stacks recover for hours while there were
probably pretty operational devices blocked due to some recovery
going on the same adapter.
What about a more sophisticated blocking interface?
Or, various types of hotplug events, e.g. a FC port (=3D target)
appearing on an LLDD's radar.
Dreaming about 2.7 ...



Mit freundlichen Gr=FC=DFen / with kind regards

Martin Peschke

IBM Deutschland Entwicklung GmbH
Linux for eServer Development
Phone: +49-(0)7031-16-2349

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
