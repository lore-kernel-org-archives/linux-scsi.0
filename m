From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/2] Drivers: scsi: storvsc: Force discovery of LUNs that
 may have been removed.
Date: Wed, 27 Aug 2014 16:31:21 +0200
Message-ID: <53FDEBB9.5070704@suse.de>
References: <1408244954-27417-1-git-send-email-kys@microsoft.com>
 <1408244988-27456-1-git-send-email-kys@microsoft.com>
 <1408244988-27456-2-git-send-email-kys@microsoft.com>
 <20140819175431.GA4617@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20140819175431.GA4617@infradead.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: Christoph Hellwig <hch@infradead.org>, "K. Y. Srinivasan" <kys@microsoft.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jbottomley@parallels.com, ohering@suse.com, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

On 08/19/2014 07:54 PM, Christoph Hellwig wrote:
> On Sat, Aug 16, 2014 at 08:09:48PM -0700, K. Y. Srinivasan wrote:
>> The host asks the guest to scan when a LUN is removed or added.
>> The only way a guest can identify the removed LUN is when an I/O is
>> attempted on a removed LUN - the SRB status code indicates that the LUN
>> is invalid. We currently handle this SRB status and remove the device.
>>
>> Rather than waiting for an I/O to remove the device, force the discovery=
 of
>> LUNs that may have been removed prior to discovering LUNs that may have
>> been added.
>
> This looks pretty reasonable to me, but I wonder if we should move this
> up to common code so that it happens for any host rescan triggered by
> sysfs or other drivers as well.
>
Not without proper testing.
Currently we cannot rescan existing devices; the inquiry string is =

nailed to the sdev structure. The only way to really refresh the =

information is to delete it and rescan it again.

And I really do _not_ want to do this automatically as the device =

might be busy due to various reasons (think of multipathing).
It tooks us ages to get this working with FC, and we finally settled =

to have a soft-remove implemented in the transport class.
And we still have issues with SAS HBAs, where at least the standard =

defines a mechanism. Trying this in the SCSI midlayer itself
is the road to disaster.

If we were to attempt this we would need to lift the dev_loss_tmo =

mechanism from the FC transport layer and make this a generic
facility for every HBA. But this is quite some work.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
