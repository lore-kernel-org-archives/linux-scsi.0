From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 7/8] qla2xxx: Stall mid-layer error handlers while rport
 is blocked.
Date: Fri, 06 Oct 2006 13:33:03 -0400
Message-ID: <4526934F.1020207@emulex.com>
References: <20061002185947.GF16536@andrew-vasquezs-computer.local> <11598156511007-git-send-email-andrew.vasquez@qlogic.com> <452167C8.3010401@emulex.com> <45252E1C.3000403@cs.wisc.edu> <452674E7.9080606@emulex.com> <45268BF9.10007@cs.wisc.edu>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:20642 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750705AbWJFRdd
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Oct 2006 13:33:33 -0400
In-Reply-To: <45268BF9.10007@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>

> In order to do diagnostics like TUR or fscheck you have to online the
> device first. If the device is offlined because the connection is down,
> multipathd does not want to touch the online state. It does not know why
> the device was offlined and does not think it can experiment there.
> Should it? ChristopheV does not feel it should so if iscsid knows the
> device was offlined because of a connection failure, we online it so
> multipathd can do its tests. If we are doing a FS directly on a disk
> then we need to online the device so a user can now do fscheck. So I am
> saying we are onlining devices because we have correct the problem on
> our side and now the user can do whatever tests they need to do.

Well, my last response was to say what I thought the purpose of offlining
was, and that we at least have some contradictions to it. Your point
above is yet another case where it doesn't serve much use. Lastly,
users/admins aren't getting the point, it's different from other OS's
they are used to, so they simply online it and then deal with the
residual errors.

I'm not seeing a win in offlining the device.

> Maybe we need to fix up the SDEV_QUIESCE so we can do diagnostic IOs
> with SG_IO. Userspace can at least set the device to this state and do
> some tests but all other IO will not get through and the upper layers do
> not have to do special things like set the device in READ only or set
> the path state as failed.
> 
> Or are you saying that even if we are able to relogin then there will be
> problems that cannot be handled with the current tools? Something like
> that one sense bug I was asking you about at OLS right? I am not sure
> what to do with that?

I'm questioning offlining, and wouldn't want to make a complicated
recovery path.

-- james s

