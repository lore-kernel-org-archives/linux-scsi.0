From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/4] libata-scsi: Update SATL for ZAC drives
Date: Wed, 30 Jul 2014 08:18:43 +0200
Message-ID: <53D88E43.40301@suse.de>
References: <1406645117-53088-1-git-send-email-hare@suse.de> <1406645117-53088-4-git-send-email-hare@suse.de> <20140729171258.GB32713@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58413 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbaG3GSp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jul 2014 02:18:45 -0400
In-Reply-To: <20140729171258.GB32713@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Tejun Heo <tj@kernel.org>

On 07/29/2014 07:12 PM, Christoph Hellwig wrote:
> On Tue, Jul 29, 2014 at 04:45:16PM +0200, Hannes Reinecke wrote:
>> ZAC (zoned-access command) drives translate into ZBC (Zoned block
>> command) device type for SCSI. So implement the correct mappings
>> into libata-scsi and update the SCSI command set versions.
>
> This seems to both set the periphal type to ZBC and set the
> HAW_ZBC bit, which is invalid for the version of ZBC spec I've seen.
>
D'oh. You are correct, one should read the doc properly.

> Doesn't ZAC also destinguish between host aware and host managed devi=
ce
> like ZBC does?
>
Not as such. The spec I have only differentiates between CMR=20
(conventional media recording) and SMR (shingled media recording)=20
zones. And every SMR zone is a sequential write required zone.
So the host aware device type with sequential write preferred zones=20
is not supported.

I'll be sending an updated patch with the correct bits set.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
