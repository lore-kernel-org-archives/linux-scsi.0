From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: 2.6.1: media change check fails for busy unplugged device
Date: Mon, 26 Jan 2004 22:16:42 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200401262216.42966.arvidjaar@mail.ru>
References: <200401182141.12468.arvidjaar@mail.ru> <20040119233641.GA1859@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hueytecuilhuitl.mtu.ru ([195.34.32.123]:55301 "EHLO
	hueymiccailhuitl.mtu.ru") by vger.kernel.org with ESMTP
	id S264476AbUAZTU6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jan 2004 14:20:58 -0500
In-Reply-To: <20040119233641.GA1859@beaverton.ibm.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On Tuesday 20 January 2004 02:36, Mike Anderson wrote:
> Andrey Borzenkov [arvidjaar@mail.ru] wrote:
> > If we unplug busy device (consider mounted USB stick) media change check
> > always returns true (no media change happened). It happens because
> >
> > - device state is set to SDEV_DEL and scsi_prep_fn silently kills any
> > request including TEST_UNIT_READY sent by sd_media_changed without
> > propagating any information back to caller
>
> The silently kill would appear to be the issue. The addition of any
> number of additional checks prior to calling scsi_ioctl would not ensure
> that as soon as the last check is done the device state has not changed.
>

But why sdev->online remains set after device has been deleted? It is 
definitely cannot accept any command after that point?

Is it possible to clear sdev->online in scsi_remove_device? That would solve 
the problem.

thank you

-andrey

> We need a change in scsi_wait_req to differentiate that we where not woken
> up from scsi_wait_done, but from end_that_request_last.
>
> One way would be to check if rq_status == RQ_SCSI_DONE. I did not see
> anything on the request to indicate it was BLKPREP_KILL'd.
>
> James has worked more on the scsi_prep_fn so maybe he has another
> suggestion.
>
> -andmike
> --
> Michael Anderson
> andmike@us.ibm.com

