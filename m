From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/2] dm mpath: attach scsi_dh during table resume
Date: Fri, 26 Apr 2013 08:05:30 +0200
Message-ID: <517A192A.1080400@suse.de>
References: <20130404131631.GA10208@redhat.com> <1365457816-31475-1-git-send-email-snitzer@redhat.com> <1365457816-31475-2-git-send-email-snitzer@redhat.com> <20130422223355.GA4803@redhat.com> <Pine.LNX.4.64.1304250938480.8307@file.rdu.redhat.com> <20130425141707.GA1947@redhat.com> <Pine.LNX.4.64.1304251037320.18633@file.rdu.redhat.com> <20130425153147.GA2488@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35647 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870Ab3DZGFc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Apr 2013 02:05:32 -0400
In-Reply-To: <20130425153147.GA2488@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org

On 04/25/2013 05:31 PM, Mike Snitzer wrote:
> On Thu, Apr 25 2013 at 10:50am -0400,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
>=20
>>
>>
>> On Thu, 25 Apr 2013, Mike Snitzer wrote:
>>
>>> On Thu, Apr 25 2013 at  9:48am -0400,
>>> Mikulas Patocka <mpatocka@redhat.com> wrote:
>>>
>>>>
>>>>
>>>> On Mon, 22 Apr 2013, Mike Snitzer wrote:
>>>>
>>>>> I spoke with Hannes at LSF, to address the potential crashes in t=
he
>>>>> endio path (e.g. stpg_endio) we'd have to bump the scsi_dh_data k=
ref
>>>>> where appropriate (e.g. for ALUA kref_get in submit_stpg and kref=
_put in
>>>>> stpg_endio).
>>>>>
>>>>> But that is just the tip of the iceberg relative to scsi_dh lifet=
ime.
>>>>> Seems we've been playing it pretty fast and loose with scsi_dh is=
sued
>>>>> requests vs detach for quite some time.
>>>>>
>>>>> I'm now inclined to not care about this issue.  Take away is: don=
't
>>>>> switch the device handler (attach the correct one from the start)=
=2E
>>>>
>>>> I did a patch that disables device handler switching and it was NA=
CKed by=20
>>>> Hannes. The problem that he pointed out was - when we load SCSI de=
vice=20
>>>> handler modules, they attach automatically to SCSI devices they th=
ink they=20
>>>> belong to. The user then can't set the desired device handler in m=
ultipath=20
>>>> configuration because a different handler is already attached.
>>>
>>> The handler that is automatically attached _should_ be the correct
>>> handler.  We now have the .match() hook for scsi_dh and it has made=
 for
>>> reliable scsi_dh attachment of the correct handler.
>>
>> The EMC devices work with both ALUA and EMC handlers - so there is n=
o one=20
>> "correct" handler, the correct handler is the one that the user spec=
ified=20
>> in multipath configuration.
>>
>>>> So we need a functionality to change device handlers.
>>>
>>> I really cannot think of a sequence where the scsi_dh .match() will
>>> attach the incorrect handler.  This is why I added the
>>> "retain_attached_hw_handler" feature to mpath (commit a58a935d5).
>>
>> The automatic handler assigment can't change existing handler.
>>
>> But if one handler was automatically selected and the user selects a=
=20
>> different handler in multipath configuration, the handler is changed=
=2E
>>
>>>> (or maybe stop the scsi device handlers from attaching automatical=
ly, but=20
>>>> it would surely generate a lot of other regressions)
>>>
>>> The need to support changing device handlers (via multipath table l=
oad)
>>> is overblown/historic.
>>
>> So - do you mean that we make "retain_attached_hw_handler" the defau=
lt=20
>> option and don't allow the user to change existing device handler in=
=20
>> multipath configuration?
>>
>> That's what my patch did and it was NACKed by Hannes. The problem th=
ere is=20
>> that behavior depends on module loading order - if you activate mult=
ipath=20
>> with "EMC" option, it activates the EMC handler. If you load the ALU=
A=20
>> module and activate multipath with "EMC" option, it stays with the A=
LUA=20
>> handler.
>=20
> .match allows for correct scsi_dh selection in the decision of alua v=
s
> emc (alua has the tpgs bit set) -- but both scsi_dh modules must be
> loaded.
>=20
> If the incorrect handler is getting attached then it is either a bug =
in
> the .match method (for the handler that should've been attached) or t=
he
> storage isn't configured how the user thought and they need to
> adjust/reconfigure to have it be like they expected.
>=20
> Either way we really _could_ impose not allowing the scsi_dh handler =
to
> be changed (by multipath) -- which is why I Acked your patch.  There =
is
> always the scsi_dh sysfs interface to allow the user to change the
> scsi_dh (and possibly shoot themselves in the foot).
>=20
Always providing there _is_ a correct way.
=46or eg RDAC might run in ALUA mode, but this is by no means
exclusively; the original 'rdac' mode will work there, too.

Plus some vendors / admins might prefer for whatever reasons
to continue to use the original mode.

So I don't think there is a 'correct' hardware handler.
Only a preferred one. And the preference is set by the user,
not the installation. Hence it would be a bad idea to
disallow scsi_dh changes.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
