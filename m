From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/3] dm mpath: add support for using previously attached
 scsi_dh
Date: Tue, 08 May 2012 18:20:45 +0200
Message-ID: <4FA947DD.8060908@suse.de>
References: <1336447147-3830-1-git-send-email-snitzer@redhat.com> <1336447147-3830-2-git-send-email-snitzer@redhat.com> <4FA8BBA3.3030705@suse.de> <20120508140541.GB8383@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51171 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755839Ab2EHOUw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 May 2012 10:20:52 -0400
In-Reply-To: <20120508140541.GB8383@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, agk@redhat.com, babu.moger@netapp.com, sekharan@us.ibm.com, linux-scsi@vger.kernel.org

On 05/08/2012 04:05 PM, Mike Snitzer wrote:
> On Tue, May 08 2012 at  2:22am -0400,
> Hannes Reinecke<hare@suse.de>  wrote:
>
>> On 05/08/2012 05:19 AM, Mike Snitzer wrote:
>>> Use the previously attached scsi_dh if "default" is provided as the
>>> hardware handler name (the new 'use_default_hw_handler' flag is set=
 in
>>> the multipath structure).
>>>
>>> Leverage scsi_dh_attach's ability to increment the scsi_dh's refere=
nce
>>> count if the same scsi_dh name is provided when attaching -- curren=
tly
>>> attached scsi_dh name is determined with scsi_dh_attached_handler_n=
ame.
>>>
>> Not sure it that's the correct way.
>>
>> Using 'default' as the hardware handler name has the drawback that
>> the original information (ie the original hardware handler name)
>> is lost.
>
> BTW, on this point: How is the original handler's name lost with my
> patches?  I set m->hw_handler_name to the original (aka attached)
> handler's name (as returned scsi_dh_attached_handler_name).
>
> "default" is only used as a key to trigger the use of the attached
> handler (it causes m->use_default_hw_handler to be set).
>
What I meant is that within multipath you can only specify one hardware=
=20
handler. So if it's 'default' and no hardware handler is attached we=20
wouldn't know what to look for.

> Was my description or code somehow unclear?  Guess so... otherwise I'=
d
> not be clarifying this... unfortunately I'm not seeing where I fell
> short.
>
Meanwhile I've sent the patchset, Please check that for details.

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
