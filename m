From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mpt2sas: Fix &&/|| confusion in
 _scsih_sas_device_status_change_event()
Date: Tue, 12 Jan 2010 16:38:16 -0800
Message-ID: <20100112163816.97a2cbc4.akpm@linux-foundation.org>
References: <4B3B86CC.5010205@gmail.com>
	<4565AEA676113A449269C2F3A549520F04463B74@cosmail03.lsi.com>
	<25e057c01001071158n1755ee99iae17522e269aa1ff@mail.gmail.com>
	<20100112135410.1506be72.akpm@linux-foundation.org>
	<4565AEA676113A449269C2F3A549520F044646D4@cosmail03.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753598Ab0AMAjI@vger.kernel.org>
In-Reply-To: <4565AEA676113A449269C2F3A549520F044646D4@cosmail03.lsi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: roel kluin <roel.kluin@gmail.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 12 Jan 2010 17:23:41 -0700
"Moore, Eric" <Eric.Moore@lsi.com> wrote:

> > -----Original Message-----
> > From: Andrew Morton [mailto:akpm@linux-foundation.org] 
> > Sent: Tuesday, January 12, 2010 2:54 PM
> > To: roel kluin
> > Cc: Moore, Eric; James E.J. Bottomley; linux-scsi@vger.kernel.org; LKML; Desai, Kashyap
> > Subject: Re: [PATCH] mpt2sas: Fix &&/|| confusion in _scsih_sas_device_status_change_event()
> > 
> > On Thu, 7 Jan 2010 20:58:10 +0100
> > roel kluin <roel.kluin@gmail.com> wrote:
> > 
> > > On Thu, Jan 7, 2010 at 8:31 PM, Moore, Eric <Eric.Moore@lsi.com> wrote:
> > > > nack
> > > >
> > > > The code beyond this check is intended for either INTERNAL_DEVICE_RESET or CMP_DEVICE_RESET. __ If the reason code is something else, we will want to return. __There are 10 other types of reason codes besides these two. This proposed patch means we return only when the reason code is either INTERNAL_DEVICE_RESET or CMP_INTERNAL_RESET.
> > > >
> > > > Eric Moore
> > > 
> > > my patch is correct but my changelog was wrong. Sorry for the
> > > confusion. It should have been:
> > > 
> > > Even if the ReasonCode is not INTERNAL_DEVICE_RESET nor CMP_DEVICE_RESET
> > > this still evaluates to true.
> > > 
> > 
> > yup, the current code is wrong.
> > 
> > 	if (!(event_data->ReasonCode ==
> > 	    MPI2_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET &&
> > 	   event_data->ReasonCode ==
> > 	    MPI2_EVENT_SAS_DEV_STAT_RC_CMP_INTERNAL_DEV_RESET))
> > 		return;
> > 
> > ReasonCode cannot equal two different things at the same time.
> > 
> > This is what we want:
> > 
> > 	if (event_data->ReasonCode !=
> > 	      MPI2_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET &&
> > 	    event_data->ReasonCode !=
> > 	      MPI2_EVENT_SAS_DEV_STAT_RC_CMP_INTERNAL_DEV_RESET)
> > 		return;
> > 
> > Eric, the fix needs runtime testing please - it enables code which
> > hasn't been executed in a long time, if ever.
> > 
> > In fact the compiler wasn't even emitting any code for the second half
> > of _scsih_sas_device_status_change_event() because it worked out that
> > there was no path to it.
> > 
>
> Yes your patch will work.  I just have tested it by sending INTERNAL_DEVICE_RESETS events, and the code is getting executed.
> 

(top-posting and quoting fixed)

Thanks.  Was that an ack to merge?
