From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] scsi_mid_low_api.txt recommend resid usage
Date: Thu, 30 Dec 2010 09:50:30 -0800
Message-ID: <20101230095030.a647466d.rdunlap@xenotime.net>
References: <4D140825.6000704@interlog.com>
	<20101224094612.8056bbcd.rdunlap@xenotime.net>
	<4D1CAE74.10005@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([72.52.115.56]:36215 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754912Ab0L3Rug (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Dec 2010 12:50:36 -0500
Received: from chimera.site ([173.50.240.230]) by xenotime.net for <linux-scsi@vger.kernel.org>; Thu, 30 Dec 2010 09:50:31 -0800
In-Reply-To: <4D1CAE74.10005@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>

On Thu, 30 Dec 2010 11:08:20 -0500 Douglas Gilbert wrote:

> Randy,
> Add some extra words to define what is expected if
> a transport can do out-of-order data delivery
> (e.g. FCP_RESID, theoretically, is not precisely
> the resid we want).

Can James use your previous:
>> Signed-off-by: Douglas Gilbert<dgilbert@interlog.com>

for this patch?

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.


> diff --git a/Documentation/scsi/scsi_mid_low_api.txt 
> b/Documentation/scsi/scsi_mid_low_api.txt
> index df322c1..d998af0 100644
> --- a/Documentation/scsi/scsi_mid_low_api.txt
> +++ b/Documentation/scsi/scsi_mid_low_api.txt
> @@ -185,7 +185,7 @@ scsi_remove_host() ---------+
>   scsi_host_put()
>   ------------------------------------------------------------
> 
> -It may be useful for a LLD to keep track of struct Scsi_Host instances
> +It may be useful for an LLD to keep track of struct Scsi_Host instances
>   (a pointer is returned by scsi_host_alloc()). Such instances are "owned"
>   by the mid-level.  struct Scsi_Host instances are freed from
>   scsi_host_put() when the reference count hits zero.
> @@ -749,7 +749,7 @@ void scsi_unblock_requests(struct Scsi_Host * shost)
>    *
>    *      Notes: Should not be invoked if the "hotplug initialization
>    *      model" is being used. Called internally by exit_this_scsi_driver()
> - *      in the "passive initialization model". Hence a LLD has no need to
> + *      in the "passive initialization model". Hence an LLD has no need to
>    *      call this function directly.
>    *
>    *      Defined in: drivers/scsi/hosts.c .
> @@ -1343,7 +1343,7 @@ Members of interest:
>                      underruns (overruns should be rare). If possible an LLD
>                      should set 'resid' prior to invoking 'done'. The most
>                      interesting case is data transfers from a SCSI target
> -                   device device (i.e. READs) that underrun.
> +                   device (e.g. READs) that underrun.
>       underflow    - LLD should place (DID_ERROR << 16) in 'result' if
>                      actual number of bytes transferred is less than this
>                      figure. Not many LLDs implement this check and some that
> @@ -1351,6 +1351,22 @@ Members of interest:
>                      report a DID_ERROR. Better for an LLD to implement
>                      'resid'.
> 
> +It is recommended that an LLD set 'resid' on data transfers from a SCSI
> +target device (e.g. READs). It is especially important that 'resid' is set
> +when such data transfers have sense keys of MEDIUM ERROR and HARDWARE ERROR
> +(and possibly RECOVERED ERROR). In these cases if an LLD is in doubt how much
> +data has been received then the safest approach is to indicate no bytes have
> +been received. For example: to indicate that no valid data has been received
> +an LLD might use these helpers:
> +    scsi_set_resid(SCpnt, scsi_bufflen(SCpnt));
> +where 'SCpnt' is a pointer to a scsi_cmnd object. To indicate only three 512
> +bytes blocks has been received 'resid' could be set like this:
> +    scsi_set_resid(SCpnt, scsi_bufflen(SCpnt) - (3 * 512));
> +
> +For transports that can do "out of order" delivery of data from a SCSI target
> +device, the 'resid' should reflect the number of valid, consecutive bytes
> +from the start of the buffer.
> +
>   The scsi_cmnd structure is defined in include/scsi/scsi_cmnd.h
> 
> 
> Doug Gilbert
> 
> 
> On 10-12-24 12:46 PM, Randy Dunlap wrote:
> > On Thu, 23 Dec 2010 21:40:37 -0500 Douglas Gilbert wrote:
> >
> >> As discussed in a thread on this list titled:
> >>      "RFC: short reads on block devices"
> >> this patch adds recommendations for LLDs to set resid
> >> when there might be uncertainty about how much data
> >> has been returned by a device.
> >>
> >> This patch inline and attached] is against scsi-misc-2.6.git
> >>
> >>
> >> Signed-off-by: Douglas Gilbert<dgilbert@interlog.com>
> >>
> >>
> >> diff --git a/Documentation/scsi/scsi_mid_low_api.txt
> >> b/Documentation/scsi/scsi_mid_low_api.txt
> >> index df322c1..7bcdea7 100644
> >> --- a/Documentation/scsi/scsi_mid_low_api.txt
> >> +++ b/Documentation/scsi/scsi_mid_low_api.txt
> >
> >> @@ -1351,6 +1351,18 @@ Members of interest:
> >>                       report a DID_ERROR. Better for an LLD to implement
> >>                       'resid'.
> >>
> >> +It is recommended that a LLD set 'resid' on data transfers from a SCSI
> >> +target device (e.g. READs). It is especially important that 'resid' is set
> >> +when such data transfers have sense keys of MEDIUM ERROR and HARDWARE ERROR
> >> +(and possibly RECOVERED ERROR). In these cases if a LLD is in doubt how much
> >> +data has been received then the safest approach is to indicate no bytes have
> >> +been received. For example: to indicate that no valid data has been received
> >> +a LLD might use these helpers:
> >> +    scsi_set_resid(SCpnt, scsi_bufflen(SCpnt));
> >> +where 'SCpnt' is a pointer to a scsi_cmnd object. To indicate only three 512
> >> +bytes blocks has been received 'resid' could be set like this:
> >> +    scsi_set_resid(SCpnt, scsi_bufflen(SCpnt) - (3 * 512));
> >> +
> >>    The scsi_cmnd structure is defined in include/scsi/scsi_cmnd.h
> >
> >
> > Hi Doug,
> >
> > Using "an LLD" instead of "a LLD" would be more consistent with the rest
> > of this txt file (and read better to me).


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
desserts:  http://www.xenotime.net/linux/recipes/
