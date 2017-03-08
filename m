From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] storvsc: workaround for virtual DVD SCSI version
Date: Wed, 8 Mar 2017 08:00:32 +0100
Message-ID: <7b3fcc1f-e446-032c-d02b-b9ab1ee6512e@suse.de>
References: <20170307171553.13247-1-sthemmin@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20170307171553.13247-1-sthemmin@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Stephen Hemminger <stephen@networkplumber.org>, kys@microsoft.com, haiyangz@microsoft.com, longli@microsoft.com, martin.petersen@oracle.com, hch@lst.de
Cc: devel@linuxdriverproject.org, Stephen Hemminger <sthemmin@microsoft.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 03/07/2017 06:15 PM, Stephen Hemminger wrote:
> Hyper-V host emulation of SCSI for virtual DVD device reports SCSI
> version 0 (UNKNOWN) but is still capable of supporting REPORTLUN. =

> =

> Without this patch, a GEN2 Linux guest on Hyper-V will not boot 4.11
> successfully with virtual DVD ROM device. What happens is that the
> SCSI scan process falls back to doing sequential probing by INQUIRY.
> But the storvsc driver has a previous workaround that masks/blocks all
> errors reports from INQUIRY (or MODE_SENSE) commands.  This workaround
> causes the scan to then populate a full set of bogus LUN's on the
> target and then sends kernel spinning off into a death spiral doing
> block reads on the non-existent LUNs.
> =

> By setting the correct blacklist flags, the target with the
> DVD device is scanned with REPORTLUN and that works correctly.
> =

> Patch needs to go in current 4.11, it is safe but not necessary
> in older kernels.
> =

> Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
> ---
>  drivers/scsi/storvsc_drv.c | 27 +++++++++++++++++----------
>  1 file changed, 17 insertions(+), 10 deletions(-)
> =

> PS: The error handling does need to be fixed (have patches pending)
> but that is interrelated with hotplug and can wait.
> =

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
