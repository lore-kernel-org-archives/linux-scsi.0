From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 2/2] Drivers: scsi: storvsc: Force discovery of LUNs
 that may have been removed.
Date: Fri, 29 Aug 2014 11:01:37 -0400
Message-ID: <1409324497.1223.383.camel@localhost.localdomain>
References: <1408244954-27417-1-git-send-email-kys@microsoft.com>
 <1408244988-27456-1-git-send-email-kys@microsoft.com>
 <1408244988-27456-2-git-send-email-kys@microsoft.com>
 <20140819175431.GA4617@infradead.org> <53FDEBB9.5070704@suse.de>
 <53FFE87B.9040802@cs.wisc.edu>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <53FFE87B.9040802@cs.wisc.edu>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, ohering@suse.com, jbottomley@parallels.com, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2014-08-28 at 21:42 -0500, Mike Christie wrote:
> On 08/27/2014 09:31 AM, Hannes Reinecke wrote:
> > On 08/19/2014 07:54 PM, Christoph Hellwig wrote:
> >> On Sat, Aug 16, 2014 at 08:09:48PM -0700, K. Y. Srinivasan wrote:
> >>> The host asks the guest to scan when a LUN is removed or added.
> >>> The only way a guest can identify the removed LUN is when an I/O is
> >>> attempted on a removed LUN - the SRB status code indicates that the LUN
> >>> is invalid. We currently handle this SRB status and remove the device.
> >>>
> >>> Rather than waiting for an I/O to remove the device, force the
> >>> discovery of
> >>> LUNs that may have been removed prior to discovering LUNs that may have
> >>> been added.
> >>
> >> This looks pretty reasonable to me, but I wonder if we should move this
> >> up to common code so that it happens for any host rescan triggered by
> >> sysfs or other drivers as well.
> >>
> > Not without proper testing.
> > Currently we cannot rescan existing devices; the inquiry string is
> > nailed to the sdev structure. The only way to really refresh the
> > information is to delete it and rescan it again.
> 
> How are distros handling 0x6/0x3f/0x0e (report luns changed) when it
> gets passed to userspace? Is everyone kicking off a new full (add and
> delete) scan to handle this or logging it? Is the driver returning this
> when the LUNs change?

Currently the udev rules we have to handle these events are installed
with a separate package, and only the REPORTED LUNS DATA HAS CHANGED
does anything, the others are commented out.  It turns out that e.g.
multipath stops using a path if it notices that the capacity has changed
and we need to do some more work there, it is under discussion.

We do not delete LUNs that disappear from the REPORT LUNS inventory,
although someone could write their own udev rule to do that if desired.

Beware the case where a LUN is remapped to a different LUN number, or
if LUN's WWID is used for a device with different data (e.g. a LUN
deleted and re-added and the WWID is the same although I don't know
if this actually happens).

Consider that the UA just provides notification to userspace of a
change -- lack of notification does not prevent someone from deciding
to rescan for new LUNs via sysfs any time they feel like it.  So
you can't just change the storage configuration and hope that no-one
notices until you are done making changes.

-Ewan

> 
> Also is the driver getting a 0x5/0x25/0 (invalid LUN) when the LUN does
> not exist, or is it just getting that SRB_STATUS_INVALID_LUN error code?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
