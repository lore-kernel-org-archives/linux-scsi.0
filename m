From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi_transport_spi: Export host width and HBA id
Date: Wed, 01 Jun 2011 17:00:24 +0200
Message-ID: <4DE65408.2020502@suse.de>
References: <201106011318.p51DImMr003035@pentland.suse.de> <1306940171.11897.52.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:58843 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758252Ab1FAPA0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Jun 2011 11:00:26 -0400
In-Reply-To: <1306940171.11897.52.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: James Bottomley <James.Bottomley@parallels.com>, linux-scsi@vger.kernel.org

On 06/01/2011 04:56 PM, James Bottomley wrote:
> On Wed, 2011-06-01 at 15:18 +0200, Hannes Reinecke wrote:
>> Currently it's impossible to find out if the host supports
>> wide SCSI unless you're committed to trawl through syslog.
>> And it's near impossible to find the actual HBA id, which
>> is settable for some SCSI HBAs (like aic7xxx).
>> So export them via sysfs.
>
> Um, that's what the the
>
> /sys/class/spi_transport/target<x:y:x>/max_width
>
> parameter gives you, isn't it?
>
> max_width tells you if the HBA/device combination supports wide; widt=
h
> tells you if the device is using it.
>
Not quite. You'll only have that parameter if there is a target=20
attached to the HBA.
If there is none you still wouldn't know how far you should be=20
scanning as there won't be any indicator in sysfs.

In this case that's an ESX server emulating an sym53c8xx HBA.
And disks attached to it on the fly.
If you start up with no disks attached and attach a new disc
to eg target ID 12 you're stuck.

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
