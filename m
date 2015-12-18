From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH RFC 0/2] avoid crashing when reading /proc/scsi/scsi and
 simultaneously removing devices
Date: Fri, 18 Dec 2015 10:22:01 +0100
Message-ID: <5673D039.6060805@suse.de>
References: <1449583704-32400-1-git-send-email-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42140 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966116AbbLRJWE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Dec 2015 04:22:04 -0500
In-Reply-To: <1449583704-32400-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org

On 12/08/2015 03:08 PM, Ewan D. Milne wrote:
> From: "Ewan D. Milne" <emilne@redhat.com>
>
> The klist traversal used by the reading of /proc/scsi/scsi is not int=
erlocked
> against device removal.  It takes a reference on the containing objec=
t, but
> this does not prevent the device from being removed from the list.  T=
hus, we
> get errors and eventually panic, as shown in the traces below.  Fix t=
his by
> keeping a klist iterator in the seq_file private data.
>
> The problem can be easily reproduced by repeatedly increasing scsi_de=
bug's
> max_luns to 30 and then deleting the devices via sysfs, while simulat=
enously
> accessing /proc/scsi/scsi.
>
>  From a patch originally developed by David Jeffery <djeffery@redhat.=
com>
>
That's now, what, the third attempt on fixing this?

All previous attempts have been rejected on the grounds that=20
/proc/scsi/scsi is deprecated and we should allow any updates to it.

Maybe this time we get lucky ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
