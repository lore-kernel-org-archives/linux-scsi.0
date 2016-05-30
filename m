From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/5] scsi: add new async device reset support
Date: Mon, 30 May 2016 08:27:21 +0200
Message-ID: <574BDD49.6070205@suse.de>
References: <1464162903-14735-1-git-send-email-mchristi@redhat.com>
 <1464162903-14735-5-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1464162903-14735-5-git-send-email-mchristi@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: mchristi@redhat.com, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/25/2016 09:55 AM, mchristi@redhat.com wrote:
> From: Mike Christie <mchristi@redhat.com>
>=20
> Currently, if the SCSI eh runs then before we do a LUN_RESET
> we stop the host. This patch and the block layer one before it
> begin to add infrastructure to be able to do a LUN_RESET and
> eventually do a transport level recovery without having to stop the
> host.
>=20
> For LUn-reset, this patch adds a new callout, eh_async_device_reset_h=
andler,
> which works similar to how LLDs handle SG_SCSI_RESET_DEVICE where the
> LLD manages the commands that are affected.
>=20
> eh_async_device_reset_handler:
>=20
> The LLD should perform a LUN RESET that affects all commands
> that have been accepted by its queuecommand callout for the
> device passed in to the callout. While the reset handler is running,
> queuecommand will not be running or called for the device.
>=20
> Unlike eh_device_reset_handler, queuecommand may still be
> called for other devices, and the LLD must call scsi_done for the
> commands that have been affected by the reset.
>=20
> If SUCCESS or FAST_IO_FAIL is returned, the scsi_cmnds cleaned up
> must be failed with DID_ABORT.
>=20
Hmm. With this patch you essentially just replaced the existing
eh_device_reset_handler() with eh_async_device_request_handler().
So how does this differ from the original behaviour?
By the time we're calling it the SCSI host is already in EH, ie all
commands have been completed or failed, so why again do we need to
wait for the queue to be empty?

And how exactly can queuecommand be called for other devices, as the
host is already in EH?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
