From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mpt2sas: Fix &&/|| confusion in
 _scsih_sas_device_status_change_event()
Date: Tue, 12 Jan 2010 13:54:10 -0800
Message-ID: <20100112135410.1506be72.akpm@linux-foundation.org>
References: <4B3B86CC.5010205@gmail.com>
	<4565AEA676113A449269C2F3A549520F04463B74@cosmail03.lsi.com>
	<25e057c01001071158n1755ee99iae17522e269aa1ff@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752282Ab0ALVyW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jan 2010 16:54:22 -0500
In-Reply-To: <25e057c01001071158n1755ee99iae17522e269aa1ff@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: roel kluin <roel.kluin@gmail.com>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>

On Thu, 7 Jan 2010 20:58:10 +0100
roel kluin <roel.kluin@gmail.com> wrote:

> On Thu, Jan 7, 2010 at 8:31 PM, Moore, Eric <Eric.Moore@lsi.com> wrote:
> > nack
> >
> > The code beyond this check is intended for either INTERNAL_DEVICE_RESET or CMP_DEVICE_RESET. __ If the reason code is something else, we will want to return. __There are 10 other types of reason codes besides these two. This proposed patch means we return only when the reason code is either INTERNAL_DEVICE_RESET or CMP_INTERNAL_RESET.
> >
> > Eric Moore
> 
> my patch is correct but my changelog was wrong. Sorry for the
> confusion. It should have been:
> 
> Even if the ReasonCode is not INTERNAL_DEVICE_RESET nor CMP_DEVICE_RESET
> this still evaluates to true.
> 

yup, the current code is wrong.

	if (!(event_data->ReasonCode ==
	    MPI2_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET &&
	   event_data->ReasonCode ==
	    MPI2_EVENT_SAS_DEV_STAT_RC_CMP_INTERNAL_DEV_RESET))
		return;

ReasonCode cannot equal two different things at the same time.

This is what we want:

	if (event_data->ReasonCode !=
	      MPI2_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET &&
	    event_data->ReasonCode !=
	      MPI2_EVENT_SAS_DEV_STAT_RC_CMP_INTERNAL_DEV_RESET)
		return;

Eric, the fix needs runtime testing please - it enables code which
hasn't been executed in a long time, if ever.

In fact the compiler wasn't even emitting any code for the second half
of _scsih_sas_device_status_change_event() because it worked out that
there was no path to it.


