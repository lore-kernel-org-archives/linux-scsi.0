From: Hannes Reinecke <hare@suse.de>
Subject: Re: virtio-scsi issues duplicate tags when async_abort is enabled
Date: Fri, 13 Jun 2014 20:37:43 +0200
Message-ID: <539B44F7.6050803@suse.de>
References: <CAHdzE-8k6A6kVB7DnOc6_XKg6DANLRFmP9+f4oXE1vPoLhOK=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53668 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbaFMShs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jun 2014 14:37:48 -0400
In-Reply-To: <CAHdzE-8k6A6kVB7DnOc6_XKg6DANLRFmP9+f4oXE1vPoLhOK=g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Venkatesh Srinivas <venkateshs@google.com>, hch@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, JBottomley@parallels.com, linux-scsi@vger.kernel.org, stable@vger.kernel.org

On 06/13/2014 07:58 PM, Venkatesh Srinivas wrote:
> Hi,
>
> In Linux 3.14+, SCSI timeouts are handled first without invoking EH;
> this behavior is on by default but can be disabled with the
> per-shost-template no_async_abort flag.
>
> When a SCSI target is attached to a virtio-scsi HBA and is under I/O
> stress (lots of concurrent I/O + some I/O running slowly), we see
> Linux issue commands with duplicate tags, sometimes with tags matchin=
g
> commands which are in the process of being aborted; we see this
> readily in the Google Compute Engine hypervisor.
>
> This behaviour is not seen on Linux <=3D 3.13 and is not seen if 3.14=
's
> virtio_scsi driver has no_async_abort set to 1.
>
> An ordering we have seen, from the device perspective:
> t0: I/O with tag 18446612135224154432 issued
> t1: TMF Abort for tag 18446612135224154432
> t2: Another I/O with the same tag, 18446612135224154432, issued; same
> offset/size as at t0
> [neither the t0 I/O nor the TMF ABORT have yet returned!]
>
> Another ordering we have seen, from the device perspective:
> t0: I/O with tag 18446612135454768576 issued
> t1: TMF ABORT for tag 18446612135454768576
> t2: I/O 18446612135454768576 completes with appropriate cancelled sta=
tus
> t3: TMF ABORT completes with OK status
> t4: New I/O with tag 18446612135454768576, matching size/offset as t0
> t5...: [Some other I/Os issued to the same SCSI target]
> t6...: [TMF ABORT for one of the new I/Os; proper return sequence]
> t7...: New I/O with tag 18446612135454768576.
>    [Tag 18446612135454768576 has neither completed nor has it been
> aborted by Linux.]
>
> CC-ing stable as 3.14 and 3.15 are affected; a conservative fix is to
> enable no_async_abort until the problem is better-understood.
>
Paolo, you had some fixes for virtio_scsi which should solve this, righ=
t?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
