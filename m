From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCH 6/6] Invalidate VPD page data
Date: Mon, 17 Mar 2014 17:11:29 -0500
Message-ID: <53277311.9000105@tributary.com>
References: <1394873512-102073-1-git-send-email-hare@suse.de> <1394873512-102073-7-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.58]:31598 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbaCQWLc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Mar 2014 18:11:32 -0400
In-Reply-To: <1394873512-102073-7-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 3/15/2014 3:51 AM, Hannes Reinecke wrote:
> Add a flag 'vpd_invalid' to the SCSI device to indicate that the VPD data
> needs to be refreshed. This is required if either a manual rescan is
> triggered or if the sense code INQUIRY DATA HAS CHANGED has been received.


> --- a/drivers/scsi/scsi_error.c +++ b/drivers/scsi/scsi_error.c @@ -393,6
> +393,7 @@ static void scsi_report_sense(struct scsi_device *sdev,
> 
> if (sshdr->sense_key == UNIT_ATTENTION) { if (sshdr->asc == 0x3f &&
> sshdr->ascq == 0x03) { +			sdev->vpd_invalid = 1;


	I didn't study the whole code path but does the VPD data get updated on a
6/2900? I suspect it should be.
	I can imagine a number of cases where the luns changed check condition gets
preempted/lost by a device reset. I guess much of that should be masked by the
port login/logout, but its probably better to be safe...





-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTJ3MRAAoJEL5i86xrzcy7vsAIAKyiMPZ0FBlLRxlQsGQxHaet
8FTCoj0GtgE1hmw+BfLvKzdR5VqMNt/yTSsJd/8OZrykDQ298TQlfgoSle7/dpYp
FDaMq2uXINGpe+EC/OvVGH8GJbOgdjLectwu2EqKhkMblpyBPM83XXWNOD1lbLYf
/TN/WPug9s5NOwdwSxeNhZRZKVw/9T33fxVKlXQg/sExfjIeFqHSTxIRH9bvktvw
/ewe85P8WNtTXwZUGj1O3PaPzg0B98+LgHmAJNYREBf7t/mDZpkR492Ty9fRKkxi
SauSIvdaNWuc28a88xaJGD+WRDPqSbLjecpNnWiYNfbNrNKx/WoJUpfVJS+Ltmk=
=mfSZ
-----END PGP SIGNATURE-----
