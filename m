From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] fc_transport: stop creating duplicate rport entries.
Date: Tue, 21 Feb 2006 17:11:56 -0500
Message-ID: <43FB902C.6060205@emulex.com>
References: <20060214222214.GJ2051@andrew-vasquezs-powerbook-g4-15.local> <43F332B2.4000901@emulex.com> <43FB8B89.3090702@sgi.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:15303 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932362AbWBUWMR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Feb 2006 17:12:17 -0500
In-Reply-To: <43FB8B89.3090702@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

Is it necessary - e.g. register w/o role, then update it ? No, if
the lldd wants to plogi then wait for prli to occur before registering
the rport - that's fine.

However, I've found it easier, especially for non-FCP entities, to
register the rport as soon as it was detected (works for anything, non-FCP
included), then when prli completes update the role (works only w/ FCP).

mptfc is fine to register once with the roles already known.

-- james


Michael Reed wrote:
> 
> James Smart wrote:
>> Good Catch!
>>
>> -- james s
>>
>> Andrew Vasquez wrote:
>>> Current fc_transport consumers initially register rports
>>> with an UNKNOWN role-state and follow-up with a call to
>>> fc_remote_port_rolechg(). 
> 
> So, is the above sequence necessary?  Why not just register
> the rport with appropriate role and state?  This is what
> LSI fusion driver (mptfc) does.  "roles" has target and
> initiator set.  (Is fusion broken?)
> 
> (Not saying the fix shouldn't be there.)
> 
> Mike
> 
> <...snip...>
> 
> 
