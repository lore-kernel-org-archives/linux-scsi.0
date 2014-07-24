From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: Re: mpt2sas and mpt3sas merge (again)
Date: Thu, 24 Jul 2014 17:55:44 +0530
Message-ID: <CAK=zhgqASRRVDYdSsQamjgeKrRVbO1d=WmATL+Gie70H5HQ7Wg@mail.gmail.com>
References: <20140714083547.GA6315@infradead.org>
	<53C3A170.1070101@suse.de>
	<1405347425.2395.5.camel@dabdike.int.hansenpartnership.com>
	<yq1bnsry69d.fsf@sermon.lab.mkp.net>
	<CAK=zhgoD9vVH0zCORTA2Mhu8Tf4m4VAih_hpig4PDdh-vgJmQg@mail.gmail.com>
	<yq14my8lupv.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og120.obsmtp.com ([64.18.2.18]:58552 "EHLO
	exprod7og120.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757015AbaGXMZp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jul 2014 08:25:45 -0400
Received: by mail-qa0-f49.google.com with SMTP id dc16so2811387qab.22
        for <linux-scsi@vger.kernel.org>; Thu, 24 Jul 2014 05:25:44 -0700 (PDT)
In-Reply-To: <yq14my8lupv.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, Sathya Prakash <Sathya.Prakash@avagotech.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@avagotech.com>, linux-scsi@vger.kernel.org

Hi Martin,

megaraid driver was a single driver for both SAS2 and SAS3 controller
because from day1 it was planned and developed that way.
But it also certain cons

-Sometimes, there may be different settings needs to be done for IO
for different type of controllers. In IO path, adding PNP id based
checks may degrade the performance
-Making any fix for one controller family may affect other controllers
code path as well, so code review and unit testing of fix has to done
for all supported controllers.
e.g. in megaraid_sas driver, to maintain MFI controllers original
design  untouched, we have to deal with many synchronization issues in
MPT controllers design. If there is some workaround for older
controllers in driver, it may be carried forward sometimes, even if
that issue can be fixed for new controllers.
-In case of megaraid_sas, all application and management commands  are
MFI frame based, so for legacy applications to work with MPT
controllers(MPT frames), driver cannot post same MFI frame to firmware
and has to internally allocate MPT frame corresponding to MFI frame,
maintain the mapping of MFI to MPT frame and the send to firmware.
Driver has to play as intermediate between apps and firmware, so
driver has to do conversion.

To overcome these kind of issues,  LSI has gone for separate drivers
for mpt2sas and mpt3sas.
In case of mpt2sas, mpt3sas drivers, the only con is maintenance of
separate drivers. Our SAS2 HBA is almost entering deep maintenance
mode. We will not be posting any more feature support patches for
mpt2sas.  Whereas mpt3sas is at its initial baseline with a healthy
road map ahead.

Regards,
Sreekanth

On Wed, Jul 23, 2014 at 7:09 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:
>
> Hey Sreekanth,
>
> Sreekanth> If we have single driver approach, making any changes in
> Sreekanth> driver require lots of regression and Q/A cycle so that
> Sreekanth> existing customer who are based on older controller does not
> Sreekanth> have any impact due some fixes/new features.
>
> Sreekanth> With all these HBA specific features, it is unmanageable to
> Sreekanth> have a common driver for SAS2 and SAS3 HBAs.
>
> But just as a counterexample to that: qla2xxx and lpfc are both capable
> of driving a wide range of chip generations and firmware interface
> versions with a single driver.
>
> The problem I have with the mpt2sas/mpt3sas split is that there are way
> more commonalities than there are differences. It is trivial to handle
> multiple scatterlist format and features in a single driver. You guys
> already do that in megaraid_sas.
>
> --
> Martin K. Petersen      Oracle Linux Engineering
