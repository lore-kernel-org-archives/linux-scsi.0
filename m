From: Joe Eykholt <jeykholt@cisco.com>
Subject: Re: [PATCH] thaw FC local port
Date: Fri, 17 Dec 2010 11:33:22 -0800
Message-ID: <4D0BBB02.4090701@cisco.com>
References: <AANLkTi=4waDVnmLg9VRvrwRej+TLe4KGsL58XdWdG091@mail.gmail.com>	<1292541521.1346.20.camel@fritz> <AANLkTi=m7gKFdYasPvq=2QYqC9A5BycqHYgQ7DZxWh4=@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-6.cisco.com ([171.71.176.117]:54295 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab0LQTdR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Dec 2010 14:33:17 -0500
In-Reply-To: <AANLkTi=m7gKFdYasPvq=2QYqC9A5BycqHYgQ7DZxWh4=@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hillf Danton <dhillf@gmail.com>
Cc: Robert Love <robert.w.love@intel.com>, "devel@open-fcoe.org" <devel@open-fcoe.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



On 12/17/10 5:46 AM, Hillf Danton wrote:
> On Fri, Dec 17, 2010 at 7:18 AM, Robert Love <robert.w.love@intel.com> wrote:
>> On Thu, 2010-12-16 at 08:07 -0800, Hillf Danton wrote:
>>> The state machine of local port is freezed if it could not get ready,
>>> so thawing is necessary.
>>>
>> Please start putting a prefix "fcoe: ", "libfc: " or "libfcoe: " on your
>> patch titles. Also, please provide more meaningful commit messages. I
>> believe that I've pointed out these two issues with your patches before.
>>
>>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>>> ---
>>>
>>> --- a/drivers/scsi/libfc/fc_lport.c   2010-11-01 19:54:12.000000000 +0800
>>> +++ b/drivers/scsi/libfc/fc_lport.c   2010-12-17 00:08:06.000000000 +0800
>>> @@ -1514,11 +1514,11 @@ void fc_lport_enter_flogi(struct fc_lpor
>>>
>>>       fc_lport_state_enter(lport, LPORT_ST_FLOGI);
>>>
>>> -     if (lport->point_to_multipoint) {
>>> -             if (lport->port_id)
>>> +     if (lport->point_to_multipoint)
>>> +             if (lport->port_id) {
>>>                       fc_lport_enter_ready(lport);
>>> -             return;
>>> -     }
>>> +                     return;
>>> +             }
>>>
>>>       fp = fc_frame_alloc(lport, sizeof(struct fc_els_flogi));
>>>       if (!fp)
>>
>> We do not want to proceed with sending a FLOGI here when we're in
>> point-to-multipoint (VN2VN) mode. VN2VN is a mode where there is no
>> fabric and we FLOGI directly into the remote port. So for VN2VN the
>> FLOGI happens in the rport layer.
> 
> How will lport get out of the LPORT_ST_FLOGI state then?

By getting a FLOGI accept.  Why else would it need to?
What end-user problem are you trying to solve.

Also, I suggest *not* copying linux-scsi.  This can be handled by
those subscribed to devel@open-fcoe.org.

	Joe

