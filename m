From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] mpt2sas: Remove queuecommand wrapper
Date: Wed, 6 Jul 2011 11:00:33 -0700
Message-ID: <CAA9_cmdQJZUFijkbPXE64R0FAoUC+y02UX6ZEX0GsCAmaazVyw@mail.gmail.com>
References: <20110704192713.GZ4061@linux.intel.com>
	<B2FD678A64EAAD45B089B123FDFC3ED70157FE25D8@inbmail01.lsi.com>
	<20110705141434.GB389@parisc-linux.org>
	<B2FD678A64EAAD45B089B123FDFC3ED70157E70F4A@inbmail01.lsi.com>
	<20110705152143.GB4061@linux.intel.com>
	<B2FD678A64EAAD45B089B123FDFC3ED70157FE2667@inbmail01.lsi.com>
	<20110705202453.GC4061@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39173 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab1GFSAe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2011 14:00:34 -0400
Received: by iwn6 with SMTP id 6so130556iwn.19
        for <linux-scsi@vger.kernel.org>; Wed, 06 Jul 2011 11:00:33 -0700 (PDT)
In-Reply-To: <20110705202453.GC4061@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: "Desai, Kashyap" <Kashyap.Desai@lsi.com>, Matthew Wilcox <matthew@wil.cx>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, Doug Gilbert <dgilbert@interlog.com>

On Tue, Jul 5, 2011 at 1:24 PM, Matthew Wilcox <willy@linux.intel.com> =
wrote:
> On Tue, Jul 05, 2011 at 10:48:00PM +0530, Desai, Kashyap wrote:
>> I did below experiment.
>> Since now host_lock is removed from dispatch() callback.
>> I added sleep() inside scsih_qcmd().. Just to mimic preemption. And =
called Host reset using
>> "Sg_reset -h" at the sametime when driver is sleeping inside qcmd().=
 I see the kernel crash due to invalid scsi command pointer access afte=
r driver comes out from sleep().
>
> OK, but I don't think we've introduced a new race here, just expanded
> the window.
>
> If you follow the path down from userspace, we get to
> scsi_nonblockable_ioctl() (doesn't take the host_lock), then
> scsi_reset_provider (which takes and releases the host_lock to
> set tmf_in_progress), then scsi_try_host_reset() which calls
> eh_host_reset_handler() without holding the host_lock.
>
> So it's entirely possible to hit the same race on an SMP machine alre=
ady
> as there's nothing to synchronise the eh_host_reset_handler call with
> queuecommand.
>
> I think someone who uses sg_reset ought to be aware of the possibilit=
y
> that they can trash their system. =A0Doug, what do you think?
>

Shouldn't the reset ioctl wait for all outstanding commands to return
to the midlayer before forcing the reset?  If all tmf routines are
written under scsi_eh (all outstanding commands quiesced) assumptions
it seems the ioctl path must make the same guarantees before
triggering a tmf action in a driver?
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
