From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH V2 3/3] scsi: mptxsas: offload IRQ execution
Date: Mon, 09 Nov 2015 08:15:40 +0100
Message-ID: <5640481C.9000505@suse.de>
References: <1447034266-28003-1-git-send-email-okaya@codeaurora.org> <1447034266-28003-4-git-send-email-okaya@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447034266-28003-4-git-send-email-okaya@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sinan Kaya <okaya@codeaurora.org>, linux-scsi@vger.kernel.org, timur@codeaurora.org, cov@codeaurora.org, jcm@redhat.com
Cc: agross@codeaurora.org, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>, MPT-FusionLinux.pdl@avagotech.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/09/2015 02:57 AM, Sinan Kaya wrote:
> The mpt2sas and mpt3sas drivers are spinning forever in
> their IRQ handlers if there are a lot of jobs queued up
> by the PCIe card. This handler is causing spikes for
> the rest of the system and sluggish behavior.
>=20
> Marking all MSI interrupts as non-shared and moving the
> MSI interrupts to thread context. This relexes the rest
> of the system execution.
>=20
NACK.

If there is a scalability issue when handling interrupts
it should be fixed in the driver directly.

Looking at the driver is should be possible to implement
a worker thread handling the reply descriptor, and having the
interrupt only to fetch the reply descriptor.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
