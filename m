From: Hannes Reinecke <hare@suse.de>
Subject: Re: Can we use SCSI error trace events to monitor SCSI hardware problems
 ?
Date: Thu, 02 Jan 2014 15:51:47 +0100
Message-ID: <52C57D03.1050400@suse.de>
References: <1387769303.2695.20.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42459 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbaABMtR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Jan 2014 07:49:17 -0500
In-Reply-To: <1387769303.2695.20.camel@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Junliang Li <lijunliang.dna@gmail.com>
Cc: linux-scsi@vger.kernel.org

On 12/23/2013 04:28 AM, Junliang Li wrote:
> Hello, Hannes
>
> I found you owned a project on github named "md_monitor". It supports=
 MD
> array by using mdadm tool. But how about generic SCSI devices ? There=
 is
> a "scsi_dispatch_cmd_error" tracepoint in SCSI subsystem, from which =
we
> can get something useful output via sysfs.  We can do more work in
> userspace. Now I setup a tracepoint in "scsi_print_result" and trace
> scsi cmd result. By reading host status and sense data, I can find ou=
t
> anything wrong while executing SCSI commands. Does it make sense or i=
t
> could be better ?
>
Hmm. Not sure if that gives you what you want.

md_monitor was primarily designed to handle transient I/O errors
when running under md, and re-adding failed devices if the I/O error=20
condition was found to be resolved.
=46or DASD the entire functionality was implemented into md_monitor,
but when running on top of a SCSI device it should better be handled
via multipathing, as then most of the functionality is already
implemented there.

However, one of the goals of md_monitor was to guarantee a specific
response time, which isn't easily possible with SCSI devices.
With the updated SCSI EH it might be easier, but the code would
need to be updated and tested to work on SCSI devices, too.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
