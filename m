From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [dm-devel] [multipath] SCSI device capacity mess
Date: Tue, 2 Nov 2004 16:23:16 +0100
Message-ID: <20041102152316.GX32712@marowsky-bree.de>
References: <1098833278.4914.24.camel@zezette> <20041027081713.GC32712@marowsky-bree.de> <1098903759.12464.32.camel@zezette> <1098914250.1588.1.camel@mulgrave> <20041028113728.GT32712@marowsky-bree.de> <20041028181436.GA18874@beaverton.ibm.com> <20041028182154.GY32712@marowsky-bree.de> <20041030004131.GA29908@beaverton.ibm.com> <1099120870.27274.37.camel@zezette>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.in-addr.de ([212.8.193.158]:59851 "EHLO mx.in-addr.de")
	by vger.kernel.org with ESMTP id S261691AbUKBPZt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2004 10:25:49 -0500
Content-Disposition: inline
In-Reply-To: <1099120870.27274.37.camel@zezette>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 2004-10-30T09:21:10, christophe varoqui <christophe.varoqui@free.fr>=
 wrote:

> > What is the result of the TUR? I did not see any information about
> > it in other posts in this thread.
> >=20
> the tur checker in multipath-tools report ghosts as failing.

Note: This is about the kernel-internal "I'll try to read the partition
table of every block device I see, no matter what errors I get, and
NOTHING WILL STOP ME BWAHAHAHA", not about the multipath-tools. ;-)

(A behaviour which tends to mess up the logfiles quite badly.)

> > We might not normally every hit this since the scan (INQUIRY failur=
e)
> > would likely prevent the device from showing up at all.=20
> scsi_id and INQUIRY succeed on ghost paths, which allow multipath to
> group them with valid paths to the same LU.

Yeah, multipath-tools et al are behaving quite correctly for these
scenarios.

> > Plus, we only call sd_spinup_disk() during discovery and not on ope=
n,
> > unlike the calls to sd_media_changed().
> Would it be workable to add a scsi_devinfo flag for devices with ghos=
ts.

No. I think the kernel should simply notice that the TUR failed, or
abort reading the partition table on the first error. This would at
least automatically detect these cases w/o requiring explicit
blacklisting.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX AG - A Novell company

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
