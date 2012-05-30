From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH] scsi: fix hot unplug vs async scan race
Date: Tue, 29 May 2012 17:48:48 -0700
Message-ID: <CAA9_cmeuPNHQmOASVMC_9pULSJ+HXkRdYKM57GvYTQUTQE4H4A@mail.gmail.com>
References: <20120525075352.27883.81838.stgit@dwillia2-linux.jf.intel.com>
	<CAA9_cme9j7n726kOxOupJLd4Tajjic8QwLA_LXk21B7YEH15BA@mail.gmail.com>
	<4FC06185.10003@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54885 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842Ab2E3Ast convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 May 2012 20:48:49 -0400
Received: by obbtb18 with SMTP id tb18so7616338obb.19
        for <linux-scsi@vger.kernel.org>; Tue, 29 May 2012 17:48:48 -0700 (PDT)
In-Reply-To: <4FC06185.10003@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com, Robert Love <robert.w.love@intel.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Kashyap Desai <kashyap.desai@lsi.com>, Matthew Wilcox <matthew@wil.cx>, Dariusz Majchrzak <dariusz.majchrzak@intel.com>

On Fri, May 25, 2012 at 9:52 PM, Mike Christie <michaelc@cs.wisc.edu> w=
rote:
> On 05/25/2012 10:34 AM, Dan Williams wrote:
>>> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_=
transport_sas.c
>>> index f7565fc..3afb38d 100644
>>> --- a/drivers/scsi/scsi_transport_sas.c
>>> +++ b/drivers/scsi/scsi_transport_sas.c
>>> @@ -1592,7 +1592,7 @@ int sas_rphy_add(struct sas_rphy *rphy)
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0lun =3D 0;
>>>
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 scsi_scan_target(&rphy->dev, 0, rphy-=
>scsi_target_id, lun, 0);
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rphy->starget =3D scsi_scan_target(&r=
phy->dev, 0, rphy->scsi_target_id, lun, 0);
>>> =A0 =A0 =A0 =A0}
>>>
>>> =A0 =A0 =A0 =A0return 0;
>>> @@ -1669,7 +1669,8 @@ sas_rphy_remove(struct sas_rphy *rphy)
>>>
>>> =A0 =A0 =A0 =A0switch (rphy->identify.device_type) {
>>> =A0 =A0 =A0 =A0case SAS_END_DEVICE:
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 scsi_remove_target(dev);
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 __scsi_remove_target(rphy->starget);
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rphy->starget =3D NULL;
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
>
> I do not think it is safe to have the starget pointer on the phy and
> then pass it to scsi_remove_target. If you did
>
> for each device
> =A0 =A0 =A0 =A0echo 1 > /sys/..../remove
>
> then the target would get reaped/freed from under the transport class=
 right?

Where does that 'remove' attribute come from?  I can't seem to find it.

In any event I agree it's a bad precedent for the transport class to
start remembering scsi_targets especially without reference counting
them.  The problem is really that device_for_each_child() can't help
us in the async remove case.  So maybe a brute force "is the passed in
dev an ancestor for a scsi_target (registered or not) on
shost->__targets" is needed.  I'll give that a shot.

> It looks like the fc class needs a similar fix though too.
>
> iSCSI is ok since no iscsi driver does scsi_scan_host and does async
> scanning from userspace.

Ok, iscsi can never set shost->async_scan in that case.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
