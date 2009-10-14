From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [patch 2/5] zfcp: Handle WWPN mismatch in PLOGI payload
Date: Wed, 14 Oct 2009 10:42:49 +0200
Message-ID: <20091014084249.GA3874@schmichrtp.de.ibm.com>
References: <20091013084406.630890000@de.ibm.com> <20091013084944.777367000@de.ibm.com> <4AD4B01B.2010100@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.17.163]:47558 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757936AbZJNIna (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Oct 2009 04:43:30 -0400
Content-Disposition: inline
In-Reply-To: <4AD4B01B.2010100@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <jeykholt@cisco.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com

On Tue, Oct 13, 2009 at 09:51:39AM -0700, Joe Eykholt wrote:
>> For ports, zfcp gets the DID from the FC nameserver and tries to open
>> the port. If the open succeeds, zfcp compares the WWPN from the
>> nameserver with the WWPN in the PLOGI payload. In case of a mismatch,
>> zfcp assumes that the DID of the port just changed and we opened the
>> wrong port. This means that zfcp has to forget the DID, lookup the DID
>> again and retry.
>
> Does this happen very often?  Would you get an RSCN if a target's WWPN changed?
> Just wondering how this happens and whether libfc needs similar defenses.
> Is it due to a broken target?

zfcp first gets all DIDs from the nameserver and then triggers to
login to all ports. A change could happen at any time. With the RSCNs
being asynchronous to the login, we have to check if the port is
really the one we wanted to login to. James S. pointed out some more
details.

In this particular case i am seeing in out test environment, the
storage target always returns a wrong WWPN. I would recommend that any
check being done also considers targets that return wrong data to
avoid endless loops and such.

> See below for a minor typo.

[...]

>> diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fc.c linux-2.6-patched/drivers/s390/scsi/zfcp_fc.c
>> --- linux-2.6/drivers/s390/scsi/zfcp_fc.c	2009-10-07 10:16:33.000000000 +0200
>> +++ linux-2.6-patched/drivers/s390/scsi/zfcp_fc.c	2009-10-07 10:17:01.000000000 +0200
>> @@ -361,6 +361,17 @@ out:
>>  }
>>   /**
>> + * zfcp_fc_trigger_did_ookup - trigger the d_id lookup using a GPN_FT request
>
> s/ook/look/
>
> I just happened to notice that.  I didn't review the rest.

Thanks for catching this. And looking at the line, it is supposed to
read GID_PN and not GPN_FT.

I will resend the patch with the updated comment.

--
Christof
