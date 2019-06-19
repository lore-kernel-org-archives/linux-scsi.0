From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: Re: [PATCH] scsi: scsi_sysfs.c: Hide wwid sdev attr if VPD is not
 supported
Date: Wed, 19 Jun 2019 06:52:09 -0300
Message-ID: <20190619095208.GB26980@continental>
References: <20190612020828.8140-1-marcos.souza.org@gmail.com>
 <yq1muieuu17.fsf@oracle.com>
 <850765d7-da85-3fc1-7bf4-f0edcb63f8d8@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <850765d7-da85-3fc1-7bf4-f0edcb63f8d8@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.ibm.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 19, 2019 at 08:34:56AM +0200, Hannes Reinecke wrote:
> On 6/19/19 5:35 AM, Martin K. Petersen wrote:
> > 
> > Marcos,
> > 
> >> WWID composed from VPD data from device, specifically page 0x83. So,
> >> when a device does not have VPD support, for example USB storage
> >> devices where VPD is specifically disabled, a read into <blk
> >> device>/device/wwid file will always return ENXIO. To avoid this,
> >> change the scsi_sdev_attr_is_visible function to hide wwid sysfs file
> >> when the devices does not support VPD.
> > 
> > Not a big fan of attribute files that come and go.
> > 
> > Why not just return an empty string? Hannes?
> > 
> Actually, the intention of the 'wwid' attribute was to have a common
> place where one could look up the global id.
> As such it actually serves a dual purpose, namely indicating that there
> _is_ a global ID _and_ that this kernel (version) has support for 'wwid'
> attribute. This is to resolve one big issue we have to udev nowadays,
> which is figuring out if a specific sysfs attribute is actually
> supported on this particular kernel.
> Dynamic attributes are 'nicer' on a conceptual level, but make the above
> test nearly impossible, as we now have _two_ possibilities why a
> specific attribute is not present.
> So making 'wwid' conditional would actually defeat its very purpose, and
> we should leave it blank if not supported.

My intention was to apply the same approach used for VPD pages, which currently
also hides the attributes if not supported by the device. So, if vpd pages are
hidden, there is no usage for wwid. But I also like the idea of the vpd pages
being blank if not supported by the device.

> 
> Cheers,
> 
> Hannes
> -- 
> Dr. Hannes Reinecke		               zSeries & Storage
> hare@suse.com			               +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
> GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
> HRB 21284 (AG Nürnberg)
