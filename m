From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: avoid use of reclaimed reference
Date: Tue, 12 Nov 2013 22:46:42 -0800
Message-ID: <1384325202.3149.8.camel@dabdike.int.hansenpartnership.com>
References: <cover.1384304973.git.decot@googlers.com>
	 <643cda2192c25962f37c8bba65e22f70a57167d0.1384304973.git.decot@googlers.com>
	 <1384307830.2248.17.camel@dabdike>
	 <CAG88wWZyodGU7AmTX=wYWn5igr-ySm_HLs0uA1iO+Fxq3msRnA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39772 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751383Ab3KMGqv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Nov 2013 01:46:51 -0500
In-Reply-To: <CAG88wWZyodGU7AmTX=wYWn5igr-ySm_HLs0uA1iO+Fxq3msRnA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Decotigny <decot@googlers.com>
Cc: linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Tue, 2013-11-12 at 18:09 -0800, David Decotigny wrote:
> I was considering the following scenario wherein the "if
> (scsi_device_created(sdev))" test at the end would test garbage at
> best (or unmapped data):

Well, no, the counting isn't right:

>        if (!(sdev = scsi_device_lookup_by_target(starget, 0))) {  // not found
>                sdev = scsi_alloc_sdev(starget, 0, NULL);    // -> ref cnt = 2

1

>                if (scsi_device_get(sdev)) {  // -> ref cnt = 3

2

>                }
>                ...
>        }
>       ...
>                        res = scsi_probe_and_add_lun(starget,    // ->
> ref cnt = 1

No idea what you think here, where were the other puts?  If starget,lun
is sdev, then the count goes to 3 here otherwise it stays at 2 if it
isn't reported in the scan.
      ...
>        scsi_device_put(sdev);  // -> reclaimed

No, it goes to either 2 or 1 here.  If it goes to 1 it's because the
sdev was never probed and thus it remains in the created state.

>        if (scsi_device_created(sdev))  // test on garbage or unmapped data (#PF)

Which means this test passes and it gets garbage collected by
__scsi_remove_device().  Otherwise we exit with refcount 2.

James


