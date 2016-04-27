From: Johannes Thumshirn <jthmshirn@suse.de>
Subject: Re: [PATCH 06/10] aacraid: Fix for aac_command_thread hang
Date: Wed, 27 Apr 2016 11:32:13 +0200
Message-ID: <20160427093213.GI2820@c203.arch.suse.de>
References: <20160426062414.28402.69178.stgit@pmcuser-System-Product-Name>
 <20160426063157.28402.81341.stgit@pmcuser-System-Product-Name>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39851 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862AbcD0JcQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Apr 2016 05:32:16 -0400
Content-Disposition: inline
In-Reply-To: <20160426063157.28402.81341.stgit@pmcuser-System-Product-Name>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Cc: JBottomley@odin.com, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, aacraid@pmc-sierra.com, gana.sridaran@microsemi.com, scott.benesh@microsemi.com, vishal.josemannanal@microsemi.com

On Mon, Apr 25, 2016 at 11:31:57PM -0700, Raghava Aditya Renukunta wrot=
e:
> Typically under error conditions, it is possible for aac_command_thre=
ad()
> to miss the wakeup from kthread_stop() and go back to sleep, causing =
it
> to hang aac_shutdown.
>=20
> In the observed scenario, the adapter is not functioning correctly an=
d so
> aac_fib_send() never completes (or time-outs depending on how it was
> called). Shortly after aac_command_thread() starts it performs
> aac_fib_send(SendHostTime) which hangs. When aac_probe_one
> /aac_get_adapter_info send time outs, kthread_stop is called which br=
eaks
> the command thread out of it's hang.
>=20
> The code will still go back to sleep in schedule_timeout() without
> checking kthread_should_stop() so it causes aac_probe_one to hang unt=
il
> the schedule_timeout() which is 30 minutes.
>=20
> Fixed by: Adding another kthread_should_stop() before schedule_timeou=
t()
> Cc: stable@vger.kernel.org
>=20
> Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@micr=
osemi.com>

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
