From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] pm8001: panics/lockups from asynchronous device removal.
Date: Wed, 18 Jan 2012 09:47:34 -0800
Message-ID: <CABE8wwvMx=51gM0Si4pAwKcgotC2+uTQd8QJhrJ1hMZDbm2_mQ@mail.gmail.com>
References: <09A902B5-56B8-46CB-82B7-0DF81E7BBC12@xyratex.com>
	<CAA9_cmeNHj=MwuG8zzh9tpJ8M-80WNOn-cAOGF9o3d2EsvEFxQ@mail.gmail.com>
	<D6D2776D-2AA8-461A-AA96-EB80B63CE625@xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:54800 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932200Ab2ARRrg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2012 12:47:36 -0500
Received: by iabz7 with SMTP id z7so315785iab.25
        for <linux-scsi@vger.kernel.org>; Wed, 18 Jan 2012 09:47:35 -0800 (PST)
In-Reply-To: <D6D2776D-2AA8-461A-AA96-EB80B63CE625@xyratex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <mark_salyzyn@xyratex.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, jack_wang Wang <jack_wang@usish.com>, crystal_yu <crystal_yu@usish.com>, lindar_liu <lindar_liu@usish.com>, James Bottomley <JBottomley@parallels.com>, Greg KH <greg@kroah.com>

On Wed, Jan 18, 2012 at 8:08 AM, Mark Salyzyn <mark_salyzyn@xyratex.com=
> wrote:
> Thanks, Comments inline
>
> On Jan 17, 2012, at 11:04 PM, Dan Williams wrote:
>
>> On Tue, Jan 17, 2012 at 10:29 AM, Mark Salyzyn <mark_salyzyn@xyratex=
=2Ecom> wrote:
>>> pm8001_query_task() and pm8001_abort_task() panic kernel when devic=
es asynchronously disappear, a possible scenario since these functions =
are generally called when errors are mounting. Some of the panics are a=
 direct result of a failure to NULL check some of the structure variabl=
es that are in certain states of teardown. One of the lockups was a dir=
ect result of returning an unexpected code to libsas' sas_scsi_find_tas=
k() function (creating a tight loop of an unexpected code 138 upstream =
to the scsi layer queue function).
>>>
>>> Signed-off-by: mark_salyzyn@xyratex.com
>>> Cc: jack_wang@usish.com
>>> Cc: JBottomley@parallels.com
>>> Cc: crystal_yu@usish.com
>>> Cc: john_gong@usish.com
>>> Cc: lindar_liu <lindar_liu@usish.com>
>>
>> While your in the area of libsas error handling, mind weighing in on=
 the pending libsas error handling rework backlog?
>>
>> http://git.kernel.org/?p=3Dlinux/kernel/git/djbw/isci.git;a=3Dshortl=
og;h=3Drefs/heads/libsas-eh-reworks-v4
>
> Xyratex has me focussed on 2.6.32 problems, I will look at these, but=
 will be off the reservation (and with no Q/A testing resource to keep =
me honest) when doing so ;-}. Pure Code Inspection thus trumps experime=
ntation ...
>
>> ...more notes below:
>>
>>> @@ -986,7 +997,8 @@ int pm8001_abort_task(struct sas_task *task)
>>> =A0 =A0 =A0 =A0struct pm8001_device *pm8001_dev;
>>> =A0 =A0 =A0 =A0struct pm8001_tmf_task tmf_task;
>>> =A0 =A0 =A0 =A0int rc =3D TMF_RESP_FUNC_FAILED;
>>> - =A0 =A0 =A0 if (unlikely(!task || !task->lldd_task || !task->dev)=
)
>>> + =A0 =A0 =A0 if (unlikely(!task || !task->lldd_task
>>> + =A0 =A0 =A0 =A0|| !task->dev || !task->dev->lldd_dev))
>>
>> Hmm some of these are "never can happen" checks, so if you are indee=
d
>> seeing !task or !task->dev something is very wrong in libsas. checki=
ng
>> task->lldd_task and task->dev->lldd_dev should be all that is
>> required.
>
> OK, point taken, these issues surface with careless abandon in the 2.=
6.32-vintage kernels; and may, or may not, be present in 3.2.1-vintage =
kernels.
>
> What this means is that maybe we should be submitting these stabiliza=
tion/band-aid patches to the stable trees rather than to the top-of-tre=
e?

2.6.32 pre-dates the libsas conversion to "new-style" libata error
handling, so a band aid that works there may now be invalid, like:
http://git.kernel.org/?p=3Dlinux/kernel/git/djbw/isci.git;a=3Dcommitdif=
f;h=3D030253ca

> I'd opt (not that I have the rights) for paranoia and adding these in=
 at top-of-tree, as band-aids against panics (in libsas or pm8001). The=
 checks are not costly IMHO (hopefully less-so as wrapped by unlikely()=
). My WAG is that this patch should be cancelled here, and placed into =
the 2.6.32-stable bucket ...

-stable needs the upstream commit as a reference and it is certainly
valid to add the  !task->dev->lldd_dev check to current upstream.  The
!task and !task->dev are paranoia, but they are already in the code,
so removing them is just a clean up to reduce confusion about the
guarantees that libsas makes to lldds.

In other words,
Acked-by: Dan Williams <dan.j.williams@intel.com>

=2E..and if you can reproduce a !task or !task->dev situation on curren=
t
upstream I'd like to see it.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
