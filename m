Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC0F3C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 18:43:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E5C264F01
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 18:43:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbhCRSmk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 14:42:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:44844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232666AbhCRSmO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Mar 2021 14:42:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8C50E64F2B
        for <linux-scsi@vger.kernel.org>; Thu, 18 Mar 2021 18:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616092934;
        bh=DdR/sES9nK4epp8ubS0p7TLvSeYPJ8n70SUxelBpZYA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=tnTW3q8VQi/tMsxqg378HfvTf29oA0vIuCV3oIT7hRd3XsDN1ecJTBcjOXu/GzkzS
         0edFSxTnoCEZ5ggXwSNnGaigqsJWuEfXpQ/na63Bp4Omc9e9S9NCU2Q+GfiMYOZLlt
         fqowlowg/A2+yW9qetzB3KaxnqkMQilioxIjbT1C6lvE/HnIqEHU8huZgSdjAIfqev
         d97k/eIq1reyuRxuXcN7nJWDjXH85GcnM6wgihQRqa3JceDSMxxSMjxGm+eM46tVvt
         oczjUTtZAUeB7WTS77byGgavin4e/tyepOWiFHUQ45xfZVez6WcGL3LIUZ+qZiutoS
         0jDj4TC3Hrf4Q==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 212337] scsi_debug: race at module load and module unload
Date:   Thu, 18 Mar 2021 18:42:14 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: dgilbert@interlog.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: WILL_NOT_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-212337-11613-npoqJ3d8Uh@https.bugzilla.kernel.org/>
In-Reply-To: <bug-212337-11613@https.bugzilla.kernel.org/>
References: <bug-212337-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D212337

--- Comment #3 from d gilbert (dgilbert@interlog.com) ---
On 2021-03-18 1:38 p.m., bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D212337
>=20
> Luis Chamberlain (mcgrof@kernel.org) changed:
>=20
>             What    |Removed                     |Added
> -------------------------------------------------------------------------=
---
>               Status|NEW                         |RESOLVED
>           Resolution|---                         |WILL_NOT_FIX
>=20
> --- Comment #1 from Luis Chamberlain (mcgrof@kernel.org) ---
>=20
> At first glance this might seem like a problem with scsi's async probe, a=
nd
> so
> one might believe disabling CONFIG_SCSI_SCAN_ASYNC could help, however it
> does
> not. Linux scsi doesn't have semantics to allow only one driver to prefer=
 to
> probe asynchronously, but we can shoe-horn this in as follows:
>=20
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 3cdeaeb92933..d970050ae866 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -857,6 +857,8 @@ static const int device_qfull_result =3D
>=20
>   static const int condition_met_result =3D SAM_STAT_CONDITION_MET;
>=20
> +MODULE_IMPORT_NS(SCSI_PRIVATE);
> +int scsi_complete_async_scans(void);
>=20
>   /* Only do the extra work involved in logical block provisioning if one=
 or
>    * more of the lbpu, lbpws or lbpws10 parameters are given and we are d=
oing
> @@ -6851,6 +6853,7 @@ static int __init scsi_debug_init(void)
>                          }
>                  }
>          }
> +       scsi_complete_async_scans();
>          if (sdebug_verbose)
>                  pr_info("built %d host(s)\n", sdebug_num_hosts);
>=20
> Even with this present though we still have he refcnt issue. A better way=
 to
> see what is going on is to trace the kernel module calls after boot and s=
ee
> why
> perhaps certain refcounts for the module are high at times and why they a=
re
> not
> in most other cases.

Hi,
Interesting analysis. There have been many changes to the scsi_debug driver
during the last 6 months, but none that I can remember in module
initialization area. Do you think this is a problem introduced by those
changes or may it have been there for a longer period? Could it be that
the scsi_debug driver is exposing the async nature of the scanning code.
Of course, commencing device teardown during an async scan is stress testing
that code. It would be an improvement IMO, if rmmod alerted the module
in question when it rejects a removal attempt with "device busy".

To stop any higher levels setting up SCSI devices before the async scans
are complete, the scsi_debug can set TEST UNIT READY to return an error
along the lines of: not ready, device in process of becoming ready
BTW that is what real devices do, but scsi_debug does not do that by defaul=
t.

The scsi_debug module option that is already in place is:
   tur_ms_to_ready: TEST UNIT READY millisecs before initial good status
(def=3D0)

So it's just a fixed delay at the moment. Perhaps you could experiment with
that
option to see if it improves things.

The post is cc-ed to Hannes Reinecke who does most of the work in the async
scanning area.

Doug Gilbert


> Enable module tracing
>=20
> # for i in $(sudo find /sys/kernel/debug/tracing/events/module/ -name
> "enable"); do echo 1 > $i; done
>=20
> Run a loop to test modprobe / rmmod, and fail if either fails. In this ca=
se
> let's assume a success of rmmod once and then a failure on the second
> removal.
> We get the following ftrace, I'll provide some comments in areas where th=
is
> may
> be useful
>=20
> # cat trace /sys/kernel/tracing
> # tracer: nop
> #
> # entries-in-buffer/entries-written: 355/355   #P:8
> #
> #                                _-----=3D> irqs-off
> #                               / _----=3D> need-resched
> #                              | / _---=3D> hardirq/softirq
> #                              || / _--=3D> preempt-depth
> #                              ||| /     delay
> #           TASK-PID     CPU#  ||||   TIMESTAMP  FUNCTION
> #              | |         |   ||||      |         |
>          modprobe-902     [005] ....    45.731217: module_get: scsi_mod
> call_site=3Dresolve_symbol refcnt=3D6
>          modprobe-902     [005] ....    45.732844: module_load: scsi_debu=
g E
>          modprobe-902     [005] ....    45.732850: module_get: scsi_debug
> call_site=3Dsdebug_add_store [scsi_debug] refcnt=3D3
>          modprobe-902     [005] ....    45.733589: module_put: scsi_debug
> call_site=3Dsdebug_add_store [scsi_debug] refcnt=3D2
>          modprobe-902     [005] ....    45.733963: module_get: scsi_debug
> call_site=3Dsdebug_driver_probe [scsi_debug] refcnt=3D3
>          modprobe-902     [001] ....    45.738246: module_put: scsi_debug
> call_site=3Dsdebug_driver_probe [scsi_debug] refcnt=3D2
>     kworker/u16:3-173     [002] ....    45.738790: module_get: scsi_debug
> call_site=3Dscsi_debug_slave_alloc [scsi_debug] refcnt=3D3
>     kworker/u16:3-173     [002] ....    45.739943: module_put: scsi_debug
> call_site=3Dscsi_debug_slave_alloc [scsi_debug] refcnt=3D2
>     kworker/u16:3-173     [007] ....    45.748555: module_get: scsi_debug
> call_site=3Dscsi_debug_slave_configure [scsi_debug] refcnt=3D3
>     kworker/u16:3-173     [007] .N..    45.749962: module_put: scsi_debug
> call_site=3Dscsi_debug_slave_configure [scsi_debug] refcnt=3D2
>     kworker/u16:3-173     [000] d...    45.766235: module_get: scsi_debug
> call_site=3Dscsi_device_get [scsi_mod] refcnt=3D3
>     kworker/u16:3-173     [000] d...    45.769197: module_get: scsi_debug
> call_site=3Dscsi_device_get [scsi_mod] refcnt=3D4
>     kworker/u16:3-173     [000] ....    45.769197: module_put: scsi_debug
> call_site=3Dscsi_device_put [scsi_mod] refcnt=3D3
>     kworker/u16:3-173     [000] ....    45.769198: module_put: scsi_debug
> call_site=3Dscsi_device_put [scsi_mod] refcnt=3D2
>     kworker/u16:3-173     [000] d...    45.769199: module_get: scsi_debug
> call_site=3Dscsi_device_get [scsi_mod] refcnt=3D3
>     kworker/u16:3-173     [000] ....    45.769785: module_put: scsi_debug
> call_site=3D__scsi_iterate_devices [scsi_mod] refcnt=3D2
>          modprobe-902     [001] ....    45.773492: module_put: scsi_debug
> call_site=3Ddo_init_module refcnt=3D1
>=20
> So we can escape initialization early in one case as sg module is not yet
> available.
>=20
>     systemd-udevd-907     [001] ....    45.773818: module_get: scsi_mod
> call_site=3Dresolve_symbol refcnt=3D7
>     systemd-udevd-907     [001] ....    45.774708: module_load: sg E
>     systemd-udevd-907     [001] ....    45.776173: module_put: sg
> call_site=3Ddo_init_module refcnt=3D1
>     systemd-udevd-907     [001] ....    45.778501: module_get: scsi_mod
> call_site=3Dresolve_symbol refcnt=3D8
>     systemd-udevd-907     [001] ....    45.778569: module_get: t10_pi
> call_site=3Dresolve_symbol refcnt=3D3
>     systemd-udevd-907     [001] ....    45.779733: module_load: sd_mod E
>     systemd-udevd-907     [001] ....    45.828660: module_put: sd_mod
> call_site=3Ddo_init_module refcnt=3D1
>             rmmod-908     [003] ....    45.921238: module_free: scsi_debug
>=20
> We remove the scsi_debug module here fine before systemd-udevd has opened=
 the
> device.
>=20
>             rmmod-908     [003] ....    45.921442: module_put: scsi_mod
> call_site=3Dmodule_unload_free refcnt=3D7
>          modprobe-914     [006] ....    45.944276: module_get: scsi_mod
> call_site=3Dresolve_symbol refcnt=3D8
>=20
>          modprobe-914     [006] ....    45.945820: module_load: scsi_debu=
g E
>          modprobe-914     [006] ....    45.945825: module_get: scsi_debug
> call_site=3Dsdebug_add_store [scsi_debug] refcnt=3D3
>          modprobe-914     [006] ....    45.946553: module_put: scsi_debug
> call_site=3Dsdebug_add_store [scsi_debug] refcnt=3D2
>          modprobe-914     [006] ....    45.947044: module_get: scsi_debug
> call_site=3Dsdebug_driver_probe [scsi_debug] refcnt=3D3
>          modprobe-914     [006] ....    45.952509: module_put: scsi_debug
> call_site=3Dsdebug_driver_probe [scsi_debug] refcnt=3D2
>     kworker/u16:3-173     [006] ....    45.953257: module_get: scsi_debug
> call_site=3Dscsi_debug_slave_alloc [scsi_debug] refcnt=3D3
>     kworker/u16:3-173     [006] .N..    45.954616: module_put: scsi_debug
> call_site=3Dscsi_debug_slave_alloc [scsi_debug] refcnt=3D2
>     kworker/u16:3-173     [006] ....    45.964402: module_get: scsi_debug
> call_site=3Dscsi_debug_slave_configure [scsi_debug] refcnt=3D3
>     kworker/u16:3-173     [006] .N..    45.965695: module_put: scsi_debug
> call_site=3Dscsi_debug_slave_configure [scsi_debug] refcnt=3D2
>     kworker/u16:3-173     [005] d...    46.213491: module_get: scsi_debug
> call_site=3Dscsi_device_get [scsi_mod] refcnt=3D3
>     kworker/u16:3-173     [005] d...    46.215346: module_get: scsi_debug
> call_site=3Dscsi_device_get [scsi_mod] refcnt=3D4
>     kworker/u16:3-173     [005] ....    46.215347: module_put: scsi_debug
> call_site=3Dscsi_device_put [scsi_mod] refcnt=3D3
>     kworker/u16:3-173     [005] ....    46.215348: module_put: scsi_debug
> call_site=3Dscsi_device_put [scsi_mod] refcnt=3D2
>     kworker/u16:3-173     [005] d...    46.215350: module_get: scsi_debug
> call_site=3Dscsi_device_get [scsi_mod] refcnt=3D3
>     kworker/u16:3-173     [005] ....    46.220794: module_put: scsi_debug
> call_site=3D__scsi_iterate_devices [scsi_mod] refcnt=3D2
>     kworker/u16:4-174     [004] ....    46.224892: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D3
>     kworker/u16:4-174     [004] ....    46.224893: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>     kworker/u16:4-174     [004] ....    46.224894: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D3
>            <idle>-0       [004] d.h.    46.228906: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D4
>            <idle>-0       [004] d.h.    46.228907: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D3
>            <idle>-0       [004] d.h.    46.228907: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D2
>     kworker/u16:4-174     [004] ....    46.230926: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D3
>     kworker/u16:4-174     [004] ....    46.230926: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>     kworker/u16:4-174     [004] ....    46.230927: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D3
>            <idle>-0       [004] d.h.    46.234937: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D4
>            <idle>-0       [004] d.h.    46.234938: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D3
>            <idle>-0       [004] d.h.    46.234938: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D2
>     kworker/u16:4-174     [004] .N..    46.246062: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D3
>     kworker/u16:4-174     [004] .N..    46.246064: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>     kworker/u16:4-174     [004] .N..    46.246065: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D3
>            <idle>-0       [004] d.h.    46.250071: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D4
>            <idle>-0       [004] d.h.    46.250072: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D3
>            <idle>-0       [004] d.h.    46.250072: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D2
>     kworker/u16:4-174     [004] ....    46.252943: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D3
>     kworker/u16:4-174     [004] ....    46.252943: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>     kworker/u16:4-174     [004] ....    46.252944: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D3
>            <idle>-0       [004] d.h.    46.256956: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D4
>            <idle>-0       [004] d.h.    46.256957: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D3
>            <idle>-0       [004] d.h.    46.256957: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D2
>     kworker/u16:4-174     [004] ....    46.258547: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D3
>     kworker/u16:4-174     [004] ....    46.258547: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>     kworker/u16:4-174     [004] ....    46.258548: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D3
>            <idle>-0       [004] d.h.    46.262558: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D4
>            <idle>-0       [004] d.h.    46.262558: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D3
>            <idle>-0       [004] d.h.    46.262559: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D2
>     kworker/u16:4-174     [004] .N..    46.266484: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D3
>     kworker/u16:4-174     [004] .N..    46.266484: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>     kworker/u16:4-174     [004] .N..    46.266485: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D3
>            <idle>-0       [004] d.h.    46.270492: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D4
>            <idle>-0       [004] d.h.    46.270492: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D3
>            <idle>-0       [004] d.h.    46.270493: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D2
>     kworker/u16:4-174     [004] ....    46.272381: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D3
>     kworker/u16:4-174     [004] ....    46.272382: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>     kworker/u16:4-174     [004] ....    46.272382: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D3
>            <idle>-0       [004] d.h.    46.276393: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D4
>            <idle>-0       [004] d.h.    46.276393: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D3
>            <idle>-0       [004] d.h.    46.276394: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D2
>     kworker/u16:4-174     [004] ....    46.278258: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D3
>     kworker/u16:4-174     [004] ....    46.278259: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>     kworker/u16:4-174     [004] ....    46.278259: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D3
>            <idle>-0       [004] d.h.    46.282269: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D4
>            <idle>-0       [004] d.h.    46.282270: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D3
>            <idle>-0       [004] d.h.    46.282270: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D2
>     kworker/u16:4-174     [004] ....    46.374616: module_get: sd_mod
> call_site=3Dblkdev_get_no_open refcnt=3D2
>     kworker/u16:4-174     [004] ....    46.374617: module_get: scsi_debug
> call_site=3Dscsi_device_get [scsi_mod] refcnt=3D3
>      kworker/4:1H-189     [004] ....    46.376457: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>      kworker/4:1H-189     [004] ....    46.376457: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>      kworker/4:1H-189     [004] ....    46.376458: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>       kworker/4:1-62      [004] d.h.    46.380469: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D5
>       kworker/4:1-62      [004] d.h.    46.380470: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D4
>       kworker/4:1-62      [004] d.h.    46.380470: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D3
>      kworker/0:1H-89      [000] ....    46.383278: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>      kworker/0:1H-89      [000] ....    46.383279: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>      kworker/0:1H-89      [000] ....    46.383280: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>            <idle>-0       [000] d.h.    46.387291: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D5
>            <idle>-0       [000] d.h.    46.387292: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D4
>            <idle>-0       [000] d.h.    46.387292: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D3
>      kworker/0:1H-89      [000] ....    46.389080: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>      kworker/0:1H-89      [000] ....    46.389081: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>      kworker/0:1H-89      [000] ....    46.389081: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>            <idle>-0       [000] d.h.    46.393090: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D5
>            <idle>-0       [000] d.h.    46.393091: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D4
>            <idle>-0       [000] d.h.    46.393091: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D3
>     kworker/u16:4-174     [000] ....    46.393170: module_put: scsi_debug
> call_site=3Dscsi_device_put [scsi_mod] refcnt=3D2
>     kworker/u16:4-174     [000] ....    46.393171: module_put: sd_mod
> call_site=3Dblkdev_put refcnt=3D1
>     systemd-udevd-907     [003] ....    46.393476: module_get: sd_mod
> call_site=3Dblkdev_get_no_open refcnt=3D2
>     systemd-udevd-907     [003] ....    46.393477: module_get: scsi_debug
> call_site=3Dscsi_device_get [scsi_mod] refcnt=3D3
>     kworker/u16:4-174     [000] ....    46.395771: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>     kworker/u16:4-174     [000] ....    46.395772: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>     kworker/u16:4-174     [000] ....    46.395773: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>            <idle>-0       [000] d.h.    46.399789: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D5
>            <idle>-0       [000] d.h.    46.399790: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D4
>            <idle>-0       [000] d.h.    46.399790: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D3
>     kworker/u16:4-174     [000] ....    46.402067: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>     kworker/u16:4-174     [000] ....    46.402068: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>     kworker/u16:4-174     [000] ....    46.402069: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>            <idle>-0       [000] d.h.    46.406078: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D5
>            <idle>-0       [000] d.h.    46.406079: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D4
>            <idle>-0       [000] d.h.    46.406079: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D3
>         multipath-926     [005] ....    46.409545: module_get: sd_mod
> call_site=3Dblkdev_get_no_open refcnt=3D3
>         multipath-926     [005] ....    46.409547: module_get: scsi_debug
> call_site=3Dscsi_device_get [scsi_mod] refcnt=3D4
>         multipath-926     [005] ....    46.409649: module_get: dm_mod
> call_site=3Dmisc_open refcnt=3D2
>         multipath-926     [005] ....    46.409773: module_put: dm_mod
> call_site=3D__fput refcnt=3D1
>         multipath-926     [005] ....    46.410096: module_put: scsi_debug
> call_site=3Dscsi_device_put [scsi_mod] refcnt=3D3
>         multipath-926     [005] ....    46.410097: module_put: sd_mod
> call_site=3Dblkdev_put refcnt=3D2
>     systemd-udevd-907     [003] ....    46.410279: module_get: sd_mod
> call_site=3Dblkdev_get_no_open refcnt=3D3
>     systemd-udevd-907     [003] ....    46.410280: module_get: scsi_debug
> call_site=3Dscsi_device_get [scsi_mod] refcnt=3D4
>     systemd-udevd-907     [003] ....    46.413760: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>     systemd-udevd-907     [003] ....    46.413760: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D6
>     systemd-udevd-907     [003] ....    46.413760: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>            <idle>-0       [003] d.h.    46.417764: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D6
>            <idle>-0       [003] d.h.    46.417764: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D5
>            <idle>-0       [003] d.h.    46.417764: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D4
>     kworker/u16:4-174     [000] ....    46.438981: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>     kworker/u16:4-174     [000] ....    46.438981: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D6
>     kworker/u16:4-174     [000] ....    46.438982: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>     systemd-udevd-907     [003] ....    46.439875: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D6
>     systemd-udevd-907     [003] ....    46.439875: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D7
>     systemd-udevd-907     [003] ....    46.439876: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D6
>            <idle>-0       [000] d.h.    46.442992: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D7
>            <idle>-0       [000] d.h.    46.442993: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D6
>            <idle>-0       [000] d.h.    46.442994: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D5
>            <idle>-0       [003] d.h.    46.443880: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D6
>            <idle>-0       [003] d.h.    46.443880: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D5
>            <idle>-0       [003] d.h.    46.443880: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D4
>     kworker/u16:4-174     [000] ....    46.444546: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>     kworker/u16:4-174     [000] ....    46.444547: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D6
>     kworker/u16:4-174     [000] ....    46.444548: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>     systemd-udevd-907     [003] ....    46.445450: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D6
>     systemd-udevd-907     [003] ....    46.445450: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D7
>     systemd-udevd-907     [003] ....    46.445450: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D6
>            <idle>-0       [000] d.h.    46.448558: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D7
>            <idle>-0       [000] d.h.    46.448559: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D6
>            <idle>-0       [000] d.h.    46.448559: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D5
>            <idle>-0       [003] d.h.    46.449452: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D6
>            <idle>-0       [003] d.h.    46.449453: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D5
>            <idle>-0       [003] d.h.    46.449453: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D4
>     kworker/u16:4-174     [000] ....    46.450135: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>     kworker/u16:4-174     [000] ....    46.450136: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D6
>     kworker/u16:4-174     [000] ....    46.450136: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>     systemd-udevd-907     [003] ....    46.451003: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D6
>     systemd-udevd-907     [003] ....    46.451003: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D7
>     systemd-udevd-907     [003] ....    46.451004: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D6
>            <idle>-0       [000] d.h.    46.454147: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D7
>            <idle>-0       [000] d.h.    46.454148: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D6
>            <idle>-0       [000] d.h.    46.454148: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D5
>            <idle>-0       [003] d.h.    46.455008: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D6
>            <idle>-0       [003] d.h.    46.455008: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D5
>            <idle>-0       [003] d.h.    46.455008: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D4
>     kworker/u16:4-174     [000] ....    46.455910: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>     kworker/u16:4-174     [000] ....    46.455910: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D6
>     kworker/u16:4-174     [000] ....    46.455911: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>     systemd-udevd-907     [003] ....    46.456804: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D6
>     systemd-udevd-907     [003] ....    46.456805: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D7
>     systemd-udevd-907     [003] ....    46.456805: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D6
>            <idle>-0       [000] d.h.    46.459920: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D7
>            <idle>-0       [000] d.h.    46.459921: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D6
>            <idle>-0       [000] d.h.    46.459921: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D5
>            <idle>-0       [003] d.h.    46.460808: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D6
>            <idle>-0       [003] d.h.    46.460809: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D5
>            <idle>-0       [003] d.h.    46.460809: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D4
>     kworker/u16:4-174     [000] ....    46.461664: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>     kworker/u16:4-174     [000] ....    46.461664: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D6
>     kworker/u16:4-174     [000] ....    46.461665: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>     systemd-udevd-907     [003] ....    46.462544: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D6
>     systemd-udevd-907     [003] ....    46.462545: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D7
>     systemd-udevd-907     [003] ....    46.462545: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D6
>            <idle>-0       [000] d.h.    46.465674: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D7
>            <idle>-0       [000] d.h.    46.465675: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D6
>            <idle>-0       [000] d.h.    46.465675: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D5
>            <idle>-0       [003] d.h.    46.466547: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D6
>            <idle>-0       [003] d.h.    46.466548: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D5
>            <idle>-0       [003] d.h.    46.466548: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D4
>     kworker/u16:4-174     [000] ....    46.467413: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>     kworker/u16:4-174     [000] ....    46.467413: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D6
>     kworker/u16:4-174     [000] ....    46.467414: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>     systemd-udevd-907     [003] ....    46.468319: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D6
>     systemd-udevd-907     [003] ....    46.468319: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D7
>     systemd-udevd-907     [003] ....    46.468319: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D6
>            <idle>-0       [000] d.h.    46.471425: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D7
>            <idle>-0       [000] d.h.    46.471426: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D6
>            <idle>-0       [000] d.h.    46.471426: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D5
>            <idle>-0       [003] d.h.    46.472322: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D6
>            <idle>-0       [003] d.h.    46.472323: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D5
>            <idle>-0       [003] d.h.    46.472323: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D4
>     systemd-udevd-907     [003] ....    46.473538: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>     systemd-udevd-907     [003] ....    46.473538: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D6
>     systemd-udevd-907     [003] ....    46.473538: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>          modprobe-914     [006] ....    46.474870: module_put: scsi_debug
> call_site=3Ddo_init_module refcnt=3D4
>=20
>            <idle>-0       [003] d.h.    46.477540: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D5
>            <idle>-0       [003] d.h.    46.477541: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.477541: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D3
>     systemd-udevd-907     [003] ....    46.478789: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>     systemd-udevd-907     [003] ....    46.478789: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>     systemd-udevd-907     [003] ....    46.478790: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.482795: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D5
>            <idle>-0       [003] d.h.    46.482796: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.482796: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D3
>     systemd-udevd-907     [003] ....    46.483713: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>     systemd-udevd-907     [003] ....    46.483713: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>     systemd-udevd-907     [003] ....    46.483714: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.487723: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D5
>            <idle>-0       [003] d.h.    46.487723: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.487724: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D3
>     systemd-udevd-907     [003] ....    46.488736: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>     systemd-udevd-907     [003] ....    46.488737: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>     systemd-udevd-907     [003] ....    46.488737: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.492740: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D5
>            <idle>-0       [003] d.h.    46.492741: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.492741: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D3
>     systemd-udevd-907     [003] ....    46.493621: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>     systemd-udevd-907     [003] ....    46.493621: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>     systemd-udevd-907     [003] ....    46.493621: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.497627: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D5
>            <idle>-0       [003] d.h.    46.497628: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.497628: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D3
>     systemd-udevd-907     [003] ....    46.498631: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>     systemd-udevd-907     [003] ....    46.498632: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>     systemd-udevd-907     [003] ....    46.498632: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.502634: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D5
>            <idle>-0       [003] d.h.    46.502635: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.502635: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D3
>     systemd-udevd-907     [003] ....    46.503506: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>     systemd-udevd-907     [003] ....    46.503507: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>     systemd-udevd-907     [003] ....    46.503507: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.507513: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D5
>            <idle>-0       [003] d.h.    46.507513: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.507514: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D3
>     systemd-udevd-907     [003] ....    46.508540: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>     systemd-udevd-907     [003] ....    46.508540: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>     systemd-udevd-907     [003] ....    46.508541: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.512543: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D5
>            <idle>-0       [003] d.h.    46.512543: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.512543: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D3
>     systemd-udevd-907     [003] ....    46.513421: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>     systemd-udevd-907     [003] ....    46.513421: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>     systemd-udevd-907     [003] ....    46.513421: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.517425: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D5
>            <idle>-0       [003] d.h.    46.517425: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.517425: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D3
>     systemd-udevd-907     [003] ....    46.518504: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>     systemd-udevd-907     [003] ....    46.518505: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>     systemd-udevd-907     [003] ....    46.518505: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.522509: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D5
>            <idle>-0       [003] d.h.    46.522509: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.522509: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D3
>     systemd-udevd-907     [003] ....    46.523418: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>     systemd-udevd-907     [003] ....    46.523418: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>     systemd-udevd-907     [003] ....    46.523418: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.527420: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D5
>            <idle>-0       [003] d.h.    46.527420: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.527420: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D3
>     systemd-udevd-907     [003] ....    46.528436: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>     systemd-udevd-907     [003] ....    46.528437: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>     systemd-udevd-907     [003] ....    46.528437: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.532440: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D5
>            <idle>-0       [003] d.h.    46.532441: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.532441: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D3
>     systemd-udevd-907     [003] ....    46.533324: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>     systemd-udevd-907     [003] ....    46.533324: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>     systemd-udevd-907     [003] ....    46.533324: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.537329: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D5
>            <idle>-0       [003] d.h.    46.537330: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.537330: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D3
>     systemd-udevd-907     [003] ....    46.538373: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>     systemd-udevd-907     [003] ....    46.538374: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>     systemd-udevd-907     [003] ....    46.538374: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.542376: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D5
>            <idle>-0       [003] d.h.    46.542377: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.542377: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D3
>     systemd-udevd-907     [003] ....    46.543259: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>     systemd-udevd-907     [003] ....    46.543260: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>     systemd-udevd-907     [003] ....    46.543260: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.547268: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D5
>            <idle>-0       [003] d.h.    46.547269: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.547269: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D3
>     systemd-udevd-907     [003] ....    46.548246: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>     systemd-udevd-907     [003] ....    46.548246: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>     systemd-udevd-907     [003] ....    46.548247: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.552251: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D5
>            <idle>-0       [003] d.h.    46.552251: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.552251: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D3
>     systemd-udevd-907     [003] ....    46.553258: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>     systemd-udevd-907     [003] ....    46.553258: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>     systemd-udevd-907     [003] ....    46.553258: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.557264: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D5
>            <idle>-0       [003] d.h.    46.557264: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.557264: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D3
>     systemd-udevd-907     [003] ....    46.558294: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>     systemd-udevd-907     [003] ....    46.558295: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>     systemd-udevd-907     [003] ....    46.558295: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.562299: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D5
>            <idle>-0       [003] d.h.    46.562300: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.562300: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D3
>     systemd-udevd-907     [003] ....    46.563242: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>     systemd-udevd-907     [003] ....    46.563242: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>     systemd-udevd-907     [003] ....    46.563242: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.567248: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D5
>            <idle>-0       [003] d.h.    46.567248: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.567249: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D3
>     systemd-udevd-907     [003] ....    46.568196: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>     systemd-udevd-907     [003] ....    46.568196: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>     systemd-udevd-907     [003] ....    46.568197: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.572204: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D5
>            <idle>-0       [003] d.h.    46.572205: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.572205: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D3
>     systemd-udevd-907     [003] ....    46.573125: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>     systemd-udevd-907     [003] ....    46.573125: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>     systemd-udevd-907     [003] ....    46.573126: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.577132: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D5
>            <idle>-0       [003] d.h.    46.577133: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.577133: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D3
>     systemd-udevd-907     [003] ....    46.578070: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>     systemd-udevd-907     [003] ....    46.578071: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>     systemd-udevd-907     [003] ....    46.578071: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.582079: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D5
>            <idle>-0       [003] d.h.    46.582080: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.582080: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D3
>     systemd-udevd-907     [003] ....    46.583013: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>     systemd-udevd-907     [003] ....    46.583013: module_get: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D5
>     systemd-udevd-907     [003] ....    46.583014: module_put: scsi_debug
> call_site=3Dschedule_resp [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.587025: module_get: scsi_debug
> call_site=3Dsdebug_q_cmd_complete [scsi_debug] refcnt=3D5
>            <idle>-0       [003] d.h.    46.587026: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D4
>            <idle>-0       [003] d.h.    46.587026: module_put: scsi_debug
> call_site=3Dsdebug_q_cmd_hrt_complete [scsi_debug] refcnt=3D3
>     systemd-udevd-907     [003] ....    46.587080: module_put: scsi_debug
> call_site=3Dscsi_device_put [scsi_mod] refcnt=3D2
>     systemd-udevd-907     [003] ....    46.587081: module_put: sd_mod
> call_site=3Dblkdev_put refcnt=3D2
>     systemd-udevd-907     [003] ....    46.588154: module_put: scsi_debug
> call_site=3Dscsi_device_put [scsi_mod] refcnt=3D1
>     systemd-udevd-907     [003] ....    46.588155: module_put: sd_mod
> call_site=3Dblkdev_put refcnt=3D1
>=20
> One might be at first motivated to implment sledge hammers as follows:
>=20
> static void sdebug_wait_empty_num_in_q(void)
> {
>          struct sdebug_host_info *sdbg_host;
>          struct Scsi_Host *shost;
>          struct scsi_device *sdev;
>          struct sdebug_dev_info *devip;
>          int count, max_wait =3D 5, k;
>          bool busy;
>=20
>          while (true) {
>                  busy =3D false;
>                  spin_lock(&sdebug_host_list_lock);
>                  list_for_each_entry(sdbg_host, &sdebug_host_list, host_l=
ist)
>                  {
>                          shost =3D sdbg_host->shost;
>                          shost_for_each_device(sdev, shost) {
>                                  devip =3D (struct sdebug_dev_info
> *)sdev->hostdata;
>                                  if (atomic_read(&devip->num_in_q) !=3D 0)
>                                          busy =3D true;
>                                  k =3D find_first_bit(devip->uas_bm,
> SDEBUG_NUM_UAS);
>                                  if (k !=3D SDEBUG_NUM_UAS)
>                                          busy =3D true;
>                          }
>                  }
>                  spin_unlock(&sdebug_host_list_lock);
>                  if (!busy || count >=3D max_wait) {
>                          break;
>                  }
>                  ssleep(1);
>                  count++;
>          }
> }
>=20
> /* Waits for all pending commands to complete. */
> static void wait_all_queued(void)
> {
>          int j, k;
>          struct sdebug_queue *sqp;
>          bool busy;
>=20
>          while (true) {
>                  busy =3D false;
>                  for (j =3D 0, sqp =3D sdebug_q_arr; j < submit_queues; +=
+j,
>                  ++sqp)
> {
>                          k =3D find_first_bit(sqp->in_use_bm,
>                          sdebug_max_queue);
>                          if (k !=3D sdebug_max_queue)
>                                  busy =3D true;
>                  }
>                  if (!busy)
>                          break;
>                  ssleep(1);
>          }
> }
>=20
> static void sync_qc_helper(struct sdebug_defer *sd_dp,
>                             enum sdeb_defer_type defer_t)
> {
>          if (!sd_dp)
>                  return;
>          if (defer_t =3D=3D SDEB_DEFER_HRT) {
>                  hrtimer_forward_now(&sd_dp->hrt, 2 *
> hrtimer_get_remaining(&sd_dp->hrt));
>          } else if (defer_t =3D=3D SDEB_DEFER_WQ) {
>                  flush_work(&sd_dp->ew.work);
>          }
> }
>=20
> static void scsi_debug_sync_queued_cmnd(void)
> {
>          unsigned long iflags;
>          int j, k, qmax, r_qmax;
>          enum sdeb_defer_type l_defer_t;
>          struct sdebug_queue *sqp;
>          struct sdebug_queued_cmd *sqcp;
>          struct sdebug_defer *sd_dp;
>=20
>          for (j =3D 0, sqp =3D sdebug_q_arr; j < submit_queues; ++j, ++sq=
p) {
>                  spin_lock_irqsave(&sqp->qc_lock, iflags);
>                  qmax =3D sdebug_max_queue;
>                  r_qmax =3D atomic_read(&retired_max_queue);
>                  if (r_qmax > qmax)
>                          qmax =3D r_qmax;
>                  for (k =3D 0; k < qmax; ++k) {
>                          if (test_bit(k, sqp->in_use_bm)) {
>                                  sqcp =3D &sqp->qc_arr[k];
>                                  sd_dp =3D sqcp->sd_dp;
>                                  if (sd_dp)
>                                          l_defer_t =3D sd_dp->defer_t;
>                                  else
>                                          l_defer_t =3D SDEB_DEFER_NONE;
>                                  spin_unlock_irqrestore(&sqp->qc_lock,
>                                  iflags);
>                                  sync_qc_helper(sd_dp, l_defer_t);
>                                  spin_lock_irqsave(&sqp->qc_lock, iflags);
>                          }
>                  }
>                  spin_unlock_irqrestore(&sqp->qc_lock, iflags);
>          }
> }
>=20
> static void wait_for_ready(void)
> {
>          struct scsi_sense_hdr sense_hdr;
>          struct sdebug_host_info *sdbg_host;
>          struct Scsi_Host *shost;
>          struct scsi_device *sdev;
>          int ret;
>          bool all_ready;
>=20
>          spin_lock(&sdebug_host_list_lock);
>          while (true) {
>                  all_ready =3D true;
>                  list_for_each_entry(sdbg_host, &sdebug_host_list, host_l=
ist)
>                  {
>                          shost =3D sdbg_host->shost;
>                          shost_for_each_device(sdev, shost) {
>                                  ret =3D
>                                  scsi_internal_device_block_nowait(sdev);
>                                  if (ret)
>                                          all_ready =3D false;
>                                  ret =3D
>                                  scsi_internal_device_unblock_nowait(sdev,
> SDEV_RUNNING);
>                                  if (ret)
>                                          all_ready =3D false;
>                                  ret =3D scsi_test_unit_ready(sdev, 5 * H=
Z,
>                                  100,
> &sense_hdr);
>                                  if (ret !=3D 0)
>                                          all_ready =3D false;
>                          }
>                  }
>                  if (all_ready)
>                          break;
>                  ssleep(1);
>          }
>          spin_unlock(&sdebug_host_list_lock);
> }
>=20
> And use these on scsi_debug_init() but that does not suffice, and the rea=
son
> is
> that userspace can open the scsi devices after initialization, namely in =
this
> case we see evidence of userspace processes such as systemd-udevd and
> multipath
> which will try to open the device.
>=20
> There are a few solutions possible, using sync, or sg_sync is not one of =
them
> as we have to ensure we have no userspace application accessing the devic=
es
> still.
>=20
> You can use lsof for this purpose. Below is an example script which can be
> used.
>=20
> #!/bin/bash
>=20
> LOOP=3D1
>=20
> while true; do
>          modprobe scsi_debug
>          if [[ $? -ne 0 ]]; then
>                  echo "scsi_debug modprobe failed at count $LOOP"
>                  exit 1
>          fi
>          while true; do
>                  # Let other modules which scsi_debug depends on like sg
>                  # and t10_pi load first to ensure any commands sent to
>                  # the device are sent.
>                  sleep 1
>=20
>                  # Now wait until userspace such as systemd-udevd and
>                  multipath
>                  # are done inspecting the newly exposed devices.
>                  COUNT=3D$(lsof /dev/sda | wc -l)
>                  if [[ $COUNT -ne 0 ]]; then
>                          echo "Sleeping ..."
>                          sleep 1;
>                  fi
>                  break
>          done
>          # Now you are safe to use scsi_debug exposed devices.
>=20
>          # You are also free to remove it.
>          rmmod scsi_debug
>          if [[ $? -ne 0 ]]; then
>                  echo "scsi_debug rmmod failed at count $LOOP"
>                  exit 1
>          else
>                  echo "Loop $LOOP: OK!"
>          fi
>          let LOOP=3D$LOOP+1
> done
>=20
>=20
> Marking this bug as resolved and won't fix as this should hopefully suffi=
ce
> to
> document why we can't wait on scsi_debug_init() to fix this issue, and it
> must
> be addressed in userspace.
>

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
