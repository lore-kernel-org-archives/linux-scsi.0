From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Re: qla2xxx - blocked FC remote port time out: removing target and
 saving 	binding
Date: Tue, 18 May 2010 09:56:36 -0700
Message-ID: <alpine.OSX.2.00.1005180950070.38012@gmmac.local>
References: <AANLkTinG6IYyKvYtNMBUpJcYslBmm2_h8iEwp-JYwIdR@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="140733193388032-1167210001-1274201797=:38012"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:28286 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569Ab0ERQ4i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2010 12:56:38 -0400
In-Reply-To: <AANLkTinG6IYyKvYtNMBUpJcYslBmm2_h8iEwp-JYwIdR@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eddie Williams <eddie.williams@steeleye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

--140733193388032-1167210001-1274201797=:38012
Content-Type: text/plain; charset="iso-8859-1"; format=flowed
Content-Transfer-Encoding: 8BIT



On Tue, 18 May 2010, Eddie Williams wrote:

> I upgraded an older EM64T server with 2 Qlogic controllers (QLA2340
> FW:v3.03.27 DVR:v8.03.01-k10) to SLES 11 and when a SCSI Bus Reset
> (Loop Reset) is issued I get this time out where the driver ends up
> removing all devices (causing IO failures for mounted file systems and
> the like) and then rescaning to add the devices back.  I verified that
> with the latest stable kernel (2.6.33.4) I see similar behavior
> (though the new kernel recovery much quicker).  If I go back to an
> older boot disk with Red Hat EL 4 that kernel/driver will issue a
> reset without any issues, aka no port time out or loss of connection
> to the storage.
>
> I have tried similar tests on different servers connected to the same
> FC switch/storage as well as servers connected to different storage
> without seeing this behavior.
>

Thanks for bringing this to attention. Is it possible to re-run the test
with extended logging (ql2xextended_error_logging=1). This will help to
debug further.

-- Giri


> output to /var/log/messages:
>
> May 14 11:18:14 goofy kernel: qla2xxx 0000:06:01.0: scsi(2:2:15): LOOP
> RESET ISSUED.
> May 14 11:18:34 goofy kernel:  rport-2:0-4: blocked FC remote port
> time out: removing target and saving binding
> May 14 11:18:34 goofy kernel: sd 2:0:2:1: [sdv] Synchronizing SCSI cache
> May 14 11:18:34 goofy multipathd: sdv: remove path (uevent)
> May 14 11:19:04 goofy kernel:  rport-2:0-2: blocked FC remote port
> time out: removing target and saving binding
> May 14 11:19:04 goofy kernel:  rport-2:0-3: blocked FC remote port
> time out: removing target and saving binding
> May 14 11:19:14 goofy kernel:  rport-2:0-6: blocked FC remote port
> time out: removing rport
> May 14 11:20:22 goofy LifeKeeper[8115]: RECOVERY class=disk
> event=inqfail name=3600508b300902930a83a23d1a2850036 STARTING AT: Fri
> May 14 11:20:22 EDT 2010
> May 14 11:20:23 goofy LifeKeeper[8115]: RECOVERY class=disk
> event=inqfail name=3600508b300902930a83a23d1a2850036 ENDING AT: Fri
> May 14 11:20:23 EDT 2010
> May 14 11:23:14 goofy kernel: qla2xxx 0000:06:01.0:
> qla2xxx_eh_bus_reset: reset succeded
>
>
> What is causing this time out and how can I avoid it?
>
> Eddie Williams
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
--140733193388032-1167210001-1274201797=:38012--
