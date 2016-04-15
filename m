From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv2 05/14] libata: NCQ Encapsulation for READ LOG DMA EXT
Date: Fri, 15 Apr 2016 14:32:25 +0200
Message-ID: <5710DF59.5060103@suse.de>
References: <1460443678-57934-1-git-send-email-hare@suse.de>
 <1460443678-57934-6-git-send-email-hare@suse.de>
 <20160413180735.GD3676@htj.duckdns.org> <570F2E33.3080709@suse.de>
 <20160414154338.GB12583@htj.duckdns.org> <570FBE74.2040202@suse.com>
 <20160414160750.GF12583@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37068 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326AbcDOMce (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Apr 2016 08:32:34 -0400
In-Reply-To: <20160414160750.GF12583@htj.duckdns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.com>
Cc: linux-ide@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org

On 04/14/2016 06:07 PM, Tejun Heo wrote:
> On Thu, Apr 14, 2016 at 05:59:48PM +0200, Hannes Reinecke wrote:
>> For this patch, yes, you are right.
>> However, the ZAC enablement patches later on submit READ LOG EXT com=
mands
>> (for REPORT ZONES), and _they_ benefit from NCQ encapsulation.
>=20
> Umm... so, you can't use ata_exec_internal() outside of EH context.
>=20
Right, I've checked the overall situation.
Yes, there is an NCQ encapsulation for READ LOG EXT, but indeed we
cannot sensibly use it from an EH context.
And the only other position where we would need it is during device
initialisation, which is hardly performance critical.

So I'll be dropping this patch from the next round of submissions
and will just keep the command definitions.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
