From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/2] Use sdev_scsi2lun for SCSI parallel drivers
Date: Mon, 07 Jul 2014 09:54:51 +0200
Message-ID: <53BA524B.7060400@suse.de>
References: <1404474875-109997-1-git-send-email-hare@suse.de> <1404474875-109997-2-git-send-email-hare@suse.de> <20140704134437.GA12345@infradead.org> <53B6B646.5080301@suse.de> <20140705094147.GA18130@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54454 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbaGGHyx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Jul 2014 03:54:53 -0400
In-Reply-To: <20140705094147.GA18130@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On 07/05/2014 11:41 AM, Christoph Hellwig wrote:
> On Fri, Jul 04, 2014 at 04:12:22PM +0200, Hannes Reinecke wrote:
>>> So what would be set in the upper 48 bits for those drivers?  We re=
ceive
>>> the LUN over the wire to start with.
>>>
>> None. All these devices are physically incapable of receiving or sen=
ding
>> LUNs more that a byte wide.
>
> So what problems does this patch fix then?
>
The intention is twofold:

1) Isolate from any fallout due to the 64bit LUN changes. By=20
introducing accessors we are guaranteed that the drivers will only=20
ever see LUN numbers they are expecting.
2) Using accessors allows us to eventually change the ->lun field to=20
'struct scsi_lun', and call 'scsilun_to_int' only for display=20
purposes. This will address the objection by Bart for
ib_srp, but applies to other drivers as well.

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
