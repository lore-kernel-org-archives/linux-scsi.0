From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 1/2] IB/srp: Fix SCSI scanning
Date: Tue, 21 Jun 2011 17:15:19 +0200
Message-ID: <BANLkTi=GpKrMFBhgjjm6EsBoULkL1P-V0Q@mail.gmail.com>
References: <201106191348.24122.bvanassche@acm.org> <1308504469.14467.5.camel@obelisk.thedillows.org>
 <BANLkTi=5nBDB-SGd0U0UZDgR4gKBDqaj0w@mail.gmail.com> <20110620113736.GA406@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45442 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab1FUPPl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jun 2011 11:15:41 -0400
Received: by vxb39 with SMTP id 39so1791126vxb.19
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jun 2011 08:15:40 -0700 (PDT)
In-Reply-To: <20110620113736.GA406@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: David Dillow <dillowda@ornl.gov>, linux-scsi@vger.kernel.org, Roland Dreier <roland@purestorage.com>, Brian King <brking@linux.vnet.ibm.com>

On Mon, Jun 20, 2011 at 1:37 PM, Christoph Hellwig <hch@infradead.org> =
wrote:
> We really shouldn't require workaround for this in every SCSI driver.
>
> scsi_scan_host_selected already makes sure never to scan above
> shost->max_channel. =A0Could it be that you don't have that one set
> properly in the srp driver? =A0It not we'll need to debug why it happ=
ens
> instead of adding hacks like this.

What does scsi_device_lookup_by_target() actually do ? As far as I can
see the SCSI command REPORT LUNs reports all LUNs that match the
pattern H:*:*:* but scsi_device_lookup_by_target() only looks for
already existing LUNs in the subrange H:C:I:*. Hence the duplicates
that are created during scanning. If my analysis is correct, the bug
is in the SCSI scanning code and not in the ib_srp nor in the ibmvscsi
driver.

The least one can say is that the term "lun" has at least two entirely
different meanings inside the SCSI core without clear comments about
which meaning it has in which context.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
