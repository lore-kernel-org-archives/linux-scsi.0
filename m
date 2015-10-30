From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 RESEND] scsi: report 'INQUIRY result too short' once
 per host
Date: Fri, 30 Oct 2015 12:55:25 +0100
Message-ID: <56335AAD.4040506@suse.de>
References: <1446205211-12874-1-git-send-email-vkuznets@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446205211-12874-1-git-send-email-vkuznets@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vitaly Kuznetsov <vkuznets@redhat.com>, James Bottomley <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "K. Y. Srinivasan\"" <kys@microsoft.com>, Long Li <longli@microsoft.com>, Dexuan Cui <decui@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

On 10/30/2015 12:40 PM, Vitaly Kuznetsov wrote:
> Some host adapters (e.g. Hyper-V storvsc) are known for not respectin=
g the
> SPC-2/3/4 requirement for 'INQUIRY data (see table ...) shall contain=
 at
> least 36 bytes'. As a result we get tons on 'scsi 0:7:1:1: scsi scan:
> INQUIRY result too short (5), using 36' messages on console. This can=
 be
> problematic for slow consoles. Introduce short_inquiry flag in struct
> Scsi_Host to print the message once per host.
>=20
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
> Changes since v3 RESEND:
> - Sorry, I screwed up James address when sending 'v3 RESEND'.
>=20
> Changes since v3:
> - no changes, this is just a RESEND.
>=20
> Changes since v2:
> - This is a successor of previously sent (and still not merged) "scsi=
:
>   introduce short_inquiry flag for broken host adapters" patch. I'm n=
ot
>   particularly sure which solution is better but I'm leaning towards =
this
>   one as it doesn't require changes to adapter drivers.
> ---
>  drivers/scsi/scsi_scan.c | 9 ++++++---
>  include/scsi/scsi_host.h | 3 +++
>  2 files changed, 9 insertions(+), 3 deletions(-)
>=20
Why not printk_once?
Should achieve the same result, and we're saving yet another flag...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
