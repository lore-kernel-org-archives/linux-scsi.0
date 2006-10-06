From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 7/8] qla2xxx: Stall mid-layer error handlers while rport
 is blocked.
Date: Fri, 06 Oct 2006 11:23:19 -0400
Message-ID: <452674E7.9080606@emulex.com>
References: <20061002185947.GF16536@andrew-vasquezs-computer.local> <11598156511007-git-send-email-andrew.vasquez@qlogic.com> <452167C8.3010401@emulex.com> <45252E1C.3000403@cs.wisc.edu>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:19079 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1751271AbWJFPX7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Oct 2006 11:23:59 -0400
In-Reply-To: <45252E1C.3000403@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>



Mike Christie wrote:
> James Smart wrote:
>> Given this is the 3rd instance of this (qla2xxxx, lpfc, mpt fusion),
>> we should either:
>>
>> - Fix the error handler. (but we all know this is a lot of work,
>>     of which none of us have the time to do, nor expect it to
>>     be complete in time for our next distro delivery).
> 
> I understand the bugs in the eh. I have worked around them in iscsi and
> tried to fix them in scsi-ml :) (still working on the queuecommand
> SCSI_ML_HOST/DEVICE_BUSY fix), but along with the problems in the eh
> where we could get the device offlined there could really be times when
> the device needs to be offlined and reonlined, right?

True...

 > For iscsi we do
> not really worry about either, in our userspace daemon we have code
> where if the device was offlined and the daemon has corrected the
> problem (or in qla4xxx case has been notified that the problem has been
> corrected), then we online the devices.

Ok - but that's not really the intent around offlining.  Offlining implies
that recovery steps were taken, but it didn't result in a functional device,
thus retries are likely to fail as well - which implies that device media
is corrupt and could use some user interaction to clean up (filesystem check
and the like). So - it's not always the best ideal to simply online after
resolving the link state for the device.

That said, there are scenarios in which we lose connectivity altogether
to the device, but never end up taking it offline (e.g. we fail the i/o
outright in queuecommand without going through the error handler). I would
assume the device media is as screwed up as when offline was justified.
Perhaps it's because we expect the upper layers to be preserving the data
that was contained in the retry (consider block cache data) and to
eventually attempt to resync this data when connectivity to the device is
restored. If we have this scenario, it implies that simply onlining after
the link state is ok, is all right..

 > Since FC, has added a netlink
> interface could we add something like fc_rport state changed event
> support to some daemom. The daemon could online the device when the
> rport state is back up if needed.

Well - this is similar to what we talked about in the storage bof at
OLS.  We decided to add kobject calls for block and unblock to the
block device. These are the events you could key off of. I'll complete
the patch for these events.

> I was also thinking that the iscsi code has some common features and
> maybe iscsi and fc could share something in some sort of blktool daemon.

Sounds useful - we just have to make sure it's keeping the system sane.

> Or do you think the userspace daemon is more of hack in userspace. I
> cannot tell when I am hacking around something in the kernel or doing
> something nifty in userspace anymore :)

As pointed out above, unconditionally onlining a device is not really
the right solution, although it is what users unconditionally do after
loosing connectivity and encountering the offline state. Anyone else
with some thoughts here. Users really don't understand the offline state
and the manual onlining once they believe they have restored connectivity
to the device.

-- james
