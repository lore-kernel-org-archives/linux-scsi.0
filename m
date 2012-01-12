From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] delay transition requeues for 2 seconds - alua
Date: Thu, 12 Jan 2012 23:13:43 +0100
Message-ID: <4F0F5B17.3090606@suse.de>
References: <1325618414-26992-1-git-send-email-revers@redhat.com> <4F0EAB53.7020404@suse.de> <4F0F124D.3000708@redhat.com> <4F0F4F43.2010902@suse.de> <4F0F3A73.9060602@cs.wisc.edu> <4F0F3BB1.7090902@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49721 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755208Ab2ALUNj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jan 2012 15:13:39 -0500
In-Reply-To: <4F0F3BB1.7090902@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Rob Evers <revers@redhat.com>, linux-scsi@vger.kernel.org

On 01/12/2012 08:59 PM, Mike Christie wrote:
> On 01/12/2012 01:54 PM, Mike Christie wrote:
>> alua_check_sense will return ADD_TO_MLQUEUE_DELAY then scsi_check_se=
nse
>> will pass that up and scsi_decide_disposition will return that right
>> away.
>
> I mean it is one of those weird ones where we do not do the goto
> maybe_retry in scsi_decide_disposition, so we do not see the fast fai=
l
> bit set. This happens for ADD_TO_MLQUEUE_DELAY and ADD_TO_MLQUEUE.
>
Hmm. Not sure here.
With the above reasoning SG_IO would be retried, too.
Which it most definitely isn't.

I'll be digging deeper here tomorrow.

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
