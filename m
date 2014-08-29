From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/2] Drivers: scsi: storvsc: Force discovery of LUNs that
 may have been removed.
Date: Fri, 29 Aug 2014 10:13:44 +0200
Message-ID: <54003638.5010301@suse.de>
References: <1408244954-27417-1-git-send-email-kys@microsoft.com>
 <1408244988-27456-1-git-send-email-kys@microsoft.com>
 <1408244988-27456-2-git-send-email-kys@microsoft.com>
 <20140819175431.GA4617@infradead.org> <53FDEBB9.5070704@suse.de>
 <53FFE87B.9040802@cs.wisc.edu> <54001B5F.9040506@suse.de>
 <54002E2E.7030301@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <54002E2E.7030301@acm.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: Bart Van Assche <bvanassche@acm.org>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@infradead.org>, "K. Y. Srinivasan" <kys@microsoft.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jbottomley@parallels.com, ohering@suse.com, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

On 08/29/2014 09:39 AM, Bart Van Assche wrote:
> On 08/29/14 08:19, Hannes Reinecke wrote:
>> On 08/29/2014 04:42 AM, Mike Christie wrote:
>>> How are distros handling 0x6/0x3f/0x0e (report luns changed) when it
>>> gets passed to userspace? Is everyone kicking off a new full (add and
>>> delete) scan to handle this or logging it? Is the driver returning this
>>> when the LUNs change?
>>>
>> Currently it's logged to userspace and ignored.
>> Doing an automated rescan has proven to be dangerous, as it
>> might disconnect any LUNs which are still in use by applications.
>> Especially HA or database setups tends to become very annoyed
>> when you do an automated rescan.
>
> Has it already been considered to add newly discovered LUNs
> automatically and to leave it to the user to remove stale LUNs manually
> ? That would be similar to what the rescan-scsi-bus.sh script does
> without option -r/--remove.
>

As of now we're still missing an in-kernel infrastructure which =

would allow us to react on any sense codes; currently we're relying =

on the administrator to setup a udev rule here.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
