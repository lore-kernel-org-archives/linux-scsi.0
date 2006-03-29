From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/2] scsi: Add scsi_device max_cmd_len
Date: Tue, 28 Mar 2006 18:12:24 -0600
Message-ID: <1143591144.3353.55.camel@mulgrave.il.steeleye.com>
References: <200603282217.k2SMHJTH032251@d03av04.boulder.ibm.com>
	 <1143584967.3353.47.camel@mulgrave.il.steeleye.com>
	 <4429BB02.80304@us.ibm.com>
	 <1143586146.3353.51.camel@mulgrave.il.steeleye.com>
	 <4429CEB4.4050608@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:21909 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964865AbWC2AMe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Mar 2006 19:12:34 -0500
In-Reply-To: <4429CEB4.4050608@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 2006-03-28 at 18:03 -0600, Brian King wrote:
> I'm still struggling a little with where you want to head here. Are you
> proposing a scsi_transport_sata in addition to the existing scsi transports,
> or are you proposing adding to the existing scsi_transport_sas code?
> I assume it is the latter, since a single SAS HBA will be supporting
> both SAS and SATA devices at the same time and currently scsi core only
> handles a single transport per scsi_host.

Well, no, not scsi transport; I think just a general transport ... see
the raid_class for an example of one of these (albeit not very related
to what you want to do, I'm afraid).

technically, you can have multiple transports per device, even with SCSI
ones.  It's just convenient to simplify the single attachement case
since that's the predominant one.

The key is in the match function.  Given a generic device, you have to
know how to verify its a device of the type you want.

James


