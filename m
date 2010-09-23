From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC PATCH 4/7] fc class: don't return from fc_block_scsi_eh
 until IO has been cleaned up
Date: Thu, 23 Sep 2010 09:18:56 +0200
Message-ID: <4C9AFF60.5070008@suse.de>
References: <1285219045-14645-1-git-send-email-michaelc@cs.wisc.edu> <1285219045-14645-5-git-send-email-michaelc@cs.wisc.edu> <4C9AE9D4.4020305@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46819 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753359Ab0IWHS6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Sep 2010 03:18:58 -0400
In-Reply-To: <4C9AE9D4.4020305@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

Mike Christie wrote:
> On 09/23/2010 12:17 AM, michaelc@cs.wisc.edu wrote:
>> From: Mike Christie<michaelc@cs.wisc.edu>
>>
>> If a lld does:
>>
>>          ret =3D fc_block_scsi_eh(cmnd);
>>          if (ret)
>>                  return ret;
>>
>> in the eh callbacks, then it could cause the following race:
>>
>> 1 the LLD will call fc_block_scsi_eh from the scsi eh thread.
>> 2 From the FC class thread, the fast io fail tmo will fire and set
>> FC_RPORT_FAST_FAIL_TIMEDOUT, then begin to call terminate_rport_io.
>> 3 The scsi eh thread and the LLD will then break from the
>> fc_block_scsi_eh block and will return FAST_IO_FAIL.
>> 4 The scsi eh will then assume it owns the command and will start to
>> process it. It will call scsi_eh_flush_done_q which might fail it or
>> retry it.
>> 5 But then in the FC class thread, the LLD terminate_rport_io callba=
ck
>> could be processing the IO and possibly accessing a scsi_cmnd struct
>> that the scsi eh thread has now started to retry or failed and
>> reallocated to a new request in #4.
>>
>> This patch has fc_block_scsi_eh wait until the terminate_rport_io
>> callback has completed before returning. This allows LLDs to not
>> have to worry about the race.
>>
>=20
> I think this is not going to work. It looks like for drivers like lpf=
c
> and even qla2xxx in the ISP_ABORT case, because even after
> terminate_rport_io has completed the driver can still touch the scsi_=
cmnd.

It's even worse than that.
fc_block_scsi_eh() returns '0' (!) on success, which causes havoc in
some drivers as they expect 'ret' to be a proper SCSI result value.
And we're not handling 'FAST_IO_FAIL' in all places. And not all FC
drivers evaluate the return value of fc_block_scsi_eh().

I'll have a patchset for this; will be sending it shortly.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
