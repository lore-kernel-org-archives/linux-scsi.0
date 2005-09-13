From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH 3/8] aacraid: handle AIF hotplug events
Date: Tue, 13 Sep 2005 07:53:53 -0400
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F0191A08C@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:7816 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932618AbVIMLxz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Sep 2005 07:53:55 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Mark Haverkamp <markh@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

Christoph Hellwig sez:
>On Mon, Sep 12, 2005 at 07:10:05AM -0400, Salyzyn, Mark wrote:
>> Christoph Hellwig [mailto:hch@infradead.org] writes:
>> >> +				device->removable = 1;
>> > devce->removeable means the device has a removable medium, not that
>> > it can go away.
>> It also means that the capacity can change. The SCSI subsystem will 
>> cache the partition table and capacity for the device if this is not
>please submit a patch to split ->removable into one flag for removal
dervices and one for those that allow underlying volume changes.
>Usage of ->removable as-is is defintelitly wrong.

As this is too close to rc, and all these patches have had more than a
year of stability testing, we will remove this concern from this patch
(as already done in the Updated patch yesterday) in order to propagate
the AIF hot plug events now. Splitting and/or removable flag is perhaps
for another day as I expect such flag setting belongs in
aac_slave_configure instead. I would hope that you would approve of the
current updated patch.

And now on to the discussion.

The removable flag is used for RAID to also track prevent/allow media
removal (one recommended means to track busy status to block array
changes while array is in use) and to manage the write protect status
(transition to array failure during second chance recovery phase). What
is left as unnecessary is perhaps the check condition handling, but even
that has its desirable side-effects with regards to media change
notification after a Morph has completed (although the architectural
choice was to issue a scsi_rescan_device instead as part of this patch).
I have almost convinced myself to place if (sdp->removable ||
sdp->morphable_raid) in all the code locations in scsi_ioctl.c,
scsi_lib.c, scsi_scan.c and sd.c!

Allowing on-line array changes, failures & recovery is looking
remarkably similar to a removable device except for the pesky 'Device
not ready. Make sure there is a disc in the drive' message ;-> And now I
may be slitting my own throat. Until recently the aacraid driver set the
removable flag via the spoofed inquiry, this moved the flag to be
explicitly set so that the array could be declared clearly as an sd but
still behave like an sr. I did not expect a debate over the removable
flag as it has been done this way, in not just this array driver, for
some time.

-- Mark
