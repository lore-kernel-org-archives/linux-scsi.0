From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 7/8] qla2xxx: Stall mid-layer error handlers while rport
 is blocked.
Date: Fri, 06 Oct 2006 12:01:45 -0500
Message-ID: <45268BF9.10007@cs.wisc.edu>
References: <20061002185947.GF16536@andrew-vasquezs-computer.local> <11598156511007-git-send-email-andrew.vasquez@qlogic.com> <452167C8.3010401@emulex.com> <45252E1C.3000403@cs.wisc.edu> <452674E7.9080606@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:28562 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1422747AbWJFRCB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Oct 2006 13:02:01 -0400
In-Reply-To: <452674E7.9080606@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>

James Smart wrote:
> 
> 
> Mike Christie wrote:
>> James Smart wrote:
>>> Given this is the 3rd instance of this (qla2xxxx, lpfc, mpt fusion),
>>> we should either:
>>>
>>> - Fix the error handler. (but we all know this is a lot of work,
>>>     of which none of us have the time to do, nor expect it to
>>>     be complete in time for our next distro delivery).
>>
>> I understand the bugs in the eh. I have worked around them in iscsi and
>> tried to fix them in scsi-ml :) (still working on the queuecommand
>> SCSI_ML_HOST/DEVICE_BUSY fix), but along with the problems in the eh
>> where we could get the device offlined there could really be times when
>> the device needs to be offlined and reonlined, right?
> 
> True...
> 
>> For iscsi we do
>> not really worry about either, in our userspace daemon we have code
>> where if the device was offlined and the daemon has corrected the
>> problem (or in qla4xxx case has been notified that the problem has been
>> corrected), then we online the devices.
> 
> Ok - but that's not really the intent around offlining.  Offlining implies
> that recovery steps were taken, but it didn't result in a functional
> device,
> thus retries are likely to fail as well - which implies that device media
> is corrupt and could use some user interaction to clean up (filesystem
> check
> and the like). So - it's not always the best ideal to simply online after
> resolving the link state for the device.

Yeah ok I can see your point but there are some problems with this
currently. Maybe I am thinking about this wrong too.

In order to do diagnostics like TUR or fscheck you have to online the
device first. If the device is offlined because the connection is down,
multipathd does not want to touch the online state. It does not know why
the device was offlined and does not think it can experiment there.
Should it? ChristopheV does not feel it should so if iscsid knows the
device was offlined because of a connection failure, we online it so
multipathd can do its tests. If we are doing a FS directly on a disk
then we need to online the device so a user can now do fscheck. So I am
saying we are onlining devices because we have correct the problem on
our side and now the user can do whatever tests they need to do.

Maybe we need to fix up the SDEV_QUIESCE so we can do diagnostic IOs
with SG_IO. Userspace can at least set the device to this state and do
some tests but all other IO will not get through and the upper layers do
not have to do special things like set the device in READ only or set
the path state as failed.

Or are you saying that even if we are able to relogin then there will be
problems that cannot be handled with the current tools? Something like
that one sense bug I was asking you about at OLS right? I am not sure
what to do with that?
