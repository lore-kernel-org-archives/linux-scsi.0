From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH] thaw FC local port
Date: Fri, 17 Dec 2010 21:46:27 +0800
Message-ID: <AANLkTi=m7gKFdYasPvq=2QYqC9A5BycqHYgQ7DZxWh4=@mail.gmail.com>
References: <AANLkTi=4waDVnmLg9VRvrwRej+TLe4KGsL58XdWdG091@mail.gmail.com>
	<1292541521.1346.20.camel@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54258 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab0LQNq2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Dec 2010 08:46:28 -0500
Received: by wyb28 with SMTP id 28so629667wyb.19
        for <linux-scsi@vger.kernel.org>; Fri, 17 Dec 2010 05:46:27 -0800 (PST)
In-Reply-To: <1292541521.1346.20.camel@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: "devel@open-fcoe.org" <devel@open-fcoe.org>, Joe Eykholt <jeykholt@cisco.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, Dec 17, 2010 at 7:18 AM, Robert Love <robert.w.love@intel.com> =
wrote:
> On Thu, 2010-12-16 at 08:07 -0800, Hillf Danton wrote:
>> The state machine of local port is freezed if it could not get ready=
,
>> so thawing is necessary.
>>
> Please start putting a prefix "fcoe: ", "libfc: " or "libfcoe: " on y=
our
> patch titles. Also, please provide more meaningful commit messages. I
> believe that I've pointed out these two issues with your patches befo=
re.
>
>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>> ---
>>
>> --- a/drivers/scsi/libfc/fc_lport.c =C2=A0 2010-11-01 19:54:12.00000=
0000 +0800
>> +++ b/drivers/scsi/libfc/fc_lport.c =C2=A0 2010-12-17 00:08:06.00000=
0000 +0800
>> @@ -1514,11 +1514,11 @@ void fc_lport_enter_flogi(struct fc_lpor
>>
>> =C2=A0 =C2=A0 =C2=A0 fc_lport_state_enter(lport, LPORT_ST_FLOGI);
>>
>> - =C2=A0 =C2=A0 if (lport->point_to_multipoint) {
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (lport->port_id)
>> + =C2=A0 =C2=A0 if (lport->point_to_multipoint)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (lport->port_id) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 fc_lport_enter_ready(lport);
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
>> - =C2=A0 =C2=A0 }
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 return;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>>
>> =C2=A0 =C2=A0 =C2=A0 fp =3D fc_frame_alloc(lport, sizeof(struct fc_e=
ls_flogi));
>> =C2=A0 =C2=A0 =C2=A0 if (!fp)
>
> We do not want to proceed with sending a FLOGI here when we're in
> point-to-multipoint (VN2VN) mode. VN2VN is a mode where there is no
> fabric and we FLOGI directly into the remote port. So for VN2VN the
> FLOGI happens in the rport layer.

How will lport get out of the LPORT_ST_FLOGI state then?

Thanks

Hillf
>
> //Rob
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
