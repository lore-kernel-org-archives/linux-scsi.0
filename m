From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 00/22] scsi logging update
Date: Fri, 29 Aug 2014 11:48:13 +0200
Message-ID: <54004C5D.80707@suse.de>
References: <1409247216-76074-1-git-send-email-hare@suse.de> <53FF81F8.2000807@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41028 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbaH2JsP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Aug 2014 05:48:15 -0400
In-Reply-To: <53FF81F8.2000807@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, James Bottomley <jbottomley@parallels.com>
Cc: Ewan Milne <emilne@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>

On 08/28/2014 09:24 PM, Douglas Gilbert wrote:
> On 14-08-28 01:33 PM, Hannes Reinecke wrote:
>> Hi all,
>>
>> here's my next round of scsi logging updates.
>> Main feature is the update to have all logging
>> statements in one line so that they won't be broken
>> up even under high load.
>> This will dramatically improve debugging.
>>
>> Additionally all printk() statements are moved
>> to dev_printk() variants to ensure proper device
>> tagging and keep the systemd journal happy.
>
> s/all/most/ ??
>
My, you are picky.

> Surely there are situations where a "dev" cannot be
> associated with a printk(). For example in transport
> discovery before any devices are found (or after,
> if none are found). LLDs often helpfully log their HBA's
> firmware details prior to discovery (and may fail
> before discovery).
>
Indeed there are some printks left, eg during
SCSI initialization where we don't have any device.
And I didn't modify the LLDDs, which have their
own logging.
(But most don't use dev_printk(), neither).

> And it is possible to write via sysfs to a driver
> that has no devices attached. How does one log that?
>
Well, I haven't come across any logging messages here,
so the question has never arisen.

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
