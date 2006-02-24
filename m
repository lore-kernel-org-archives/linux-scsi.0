From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH] fc_transport: stop creating duplicate rport entries.
Date: Fri, 24 Feb 2006 17:37:36 -0600
Message-ID: <43FF98C0.5000209@sgi.com>
References: <20060214222214.GJ2051@andrew-vasquezs-powerbook-g4-15.local> <43F332B2.4000901@emulex.com> <43FB8B89.3090702@sgi.com> <43FB902C.6060205@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:14545 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S964785AbWBXXhv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Feb 2006 18:37:51 -0500
In-Reply-To: <43FB902C.6060205@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

James Smart wrote:
> Is it necessary - e.g. register w/o role, then update it ? No, if
> the lldd wants to plogi then wait for prli to occur before registering
> the rport - that's fine.
> 
> However, I've found it easier, especially for non-FCP entities, to
> register the rport as soon as it was detected (works for anything, non-FCP
> included), then when prli completes update the role (works only w/ FCP).
> 
> mptfc is fine to register once with the roles already known.

I have figured out a significant difference between these two sequences

	rid->roles = FC_RPORT_ROLE_UNKNOWN | FC_RPORT_ROLE_FCP_TARGET;
	rport = fc_remote_port_add(host,channel,rid);

-and-

	rid->roles = FC_RPORT_ROLE_UNKNOWN;
	rport = fc_remote_port_add(host,channel,rid);
	rid->roles |= FC_RPORT_ROLE_FCP_TARGET;
	fc_remote_port_rolechg(rport,rid->roles);

The difference is that the former case will schedule rport->scan_work
IMMEDIATELY after the fc_remote_port_add() and the latter will wait
until the fc_remote_port_rolechg().

Why is this significant?  Because the fc_remote_port_add() clears the
dd_data.  In the first case it is possible for the scan_work to begin
prior to the driver filling in the dd_data and possibly causing a panic.
The second case allows for this sequence:

	rid->roles = FC_RPORT_ROLE_UNKNOWN;
	rport = fc_remote_port_add(host,channel,rid);

	rport->dd_data = some_important_data_item;

	rid->roles |= FC_RPORT_ROLE_FCP_TARGET;
	fc_remote_port_rolechg(rport,rid->roles);

It seems wrong, somehow, for the scan to be kicked off by the add.
Perhaps the driver should be responsible for kicking off the scan
after it knows its infrastructure is fully in place.

	fc_remote_port_initiate_target_scan(rport);

The proposed function would kick off a scan if the rport's role
include FCP_TARGET.  Otherwise, NOP.

Alternately, I suppose fc_remote_port_add() could be modified
to accept an argument pointing to the data to be placed in
dd_data (presuming dd_fcrport_size is non-zero).

	fc_remote_port_add(host,channel,rid,dd_data);

Thanks for thinking about this.

Mike

> 
> -- james
> 
> 
> Michael Reed wrote:
>>
>> James Smart wrote:
>>> Good Catch!
>>>
>>> -- james s
>>>
>>> Andrew Vasquez wrote:
>>>> Current fc_transport consumers initially register rports
>>>> with an UNKNOWN role-state and follow-up with a call to
>>>> fc_remote_port_rolechg(). 
>>
>> So, is the above sequence necessary?  Why not just register
>> the rport with appropriate role and state?  This is what
>> LSI fusion driver (mptfc) does.  "roles" has target and
>> initiator set.  (Is fusion broken?)
>>
>> (Not saying the fix shouldn't be there.)
>>
>> Mike
