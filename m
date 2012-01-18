From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] pm8001: panics/lockups from asynchronous device removal.
Date: Tue, 17 Jan 2012 20:04:48 -0800
Message-ID: <CAA9_cmeNHj=MwuG8zzh9tpJ8M-80WNOn-cAOGF9o3d2EsvEFxQ@mail.gmail.com>
References: <09A902B5-56B8-46CB-82B7-0DF81E7BBC12@xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:56622 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756760Ab2AREEt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2012 23:04:49 -0500
Received: by vcbfo1 with SMTP id fo1so2397823vcb.19
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2012 20:04:48 -0800 (PST)
In-Reply-To: <09A902B5-56B8-46CB-82B7-0DF81E7BBC12@xyratex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <mark_salyzyn@xyratex.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, jack_wang Wang <jack_wang@usish.com>, crystal_yu <crystal_yu@usish.com>, lindar_liu <lindar_liu@usish.com>, James Bottomley <JBottomley@parallels.com>

On Tue, Jan 17, 2012 at 10:29 AM, Mark Salyzyn <mark_salyzyn@xyratex.co=
m> wrote:
> pm8001_query_task() and pm8001_abort_task() panic kernel when devices=
 asynchronously disappear, a possible scenario since these functions ar=
e generally called when errors are mounting. Some of the panics are a d=
irect result of a failure to NULL check some of the structure variables=
 that are in certain states of teardown. One of the lockups was a direc=
t result of returning an unexpected code to libsas' sas_scsi_find_task(=
) function (creating a tight loop of an unexpected code 138 upstream to=
 the scsi layer queue function).
>
> Signed-off-by: mark_salyzyn@xyratex.com
> Cc: jack_wang@usish.com
> Cc: JBottomley@parallels.com
> Cc: crystal_yu@usish.com
> Cc: john_gong@usish.com
> Cc: lindar_liu <lindar_liu@usish.com>

While your in the area of libsas error handling, mind weighing in on
the pending libsas error handling rework backlog?

http://git.kernel.org/?p=3Dlinux/kernel/git/djbw/isci.git;a=3Dshortlog;=
h=3Drefs/heads/libsas-eh-reworks-v4


=2E..more notes below:

> @@ -986,7 +997,8 @@ int pm8001_abort_task(struct sas_task *task)
> =A0 =A0 =A0 =A0struct pm8001_device *pm8001_dev;
> =A0 =A0 =A0 =A0struct pm8001_tmf_task tmf_task;
> =A0 =A0 =A0 =A0int rc =3D TMF_RESP_FUNC_FAILED;
> - =A0 =A0 =A0 if (unlikely(!task || !task->lldd_task || !task->dev))
> + =A0 =A0 =A0 if (unlikely(!task || !task->lldd_task
> + =A0 =A0 =A0 =A0|| !task->dev || !task->dev->lldd_dev))

Hmm some of these are "never can happen" checks, so if you are indeed
seeing !task or !task->dev something is very wrong in libsas. checking
task->lldd_task and task->dev->lldd_dev should be all that is
required.

Also, I think it confuses the situation to return TMF_RESP_FUNC_FAILED
in this case because the truth of the matter, as far as error handling
is concerned, is that the lldd has forgotten the task, but you would
need to check that the lldd does not subsequently call task->task_done
in some other path.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
