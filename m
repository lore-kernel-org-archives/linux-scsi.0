From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv2 05/14] libata: NCQ Encapsulation for READ LOG DMA EXT
Date: Thu, 14 Apr 2016 07:44:19 +0200
Message-ID: <570F2E33.3080709@suse.de>
References: <1460443678-57934-1-git-send-email-hare@suse.de>
 <1460443678-57934-6-git-send-email-hare@suse.de>
 <20160413180735.GD3676@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20160413180735.GD3676@htj.duckdns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

On 04/13/2016 08:07 PM, Tejun Heo wrote:
> On Tue, Apr 12, 2016 at 08:47:49AM +0200, Hannes Reinecke wrote:
>> Recent devices can use NCQ encapsulation for READ LOG DMA EXT,
>> so we should be using it if available.
>=20
> Does this have any actual benefits than being new and shiny?  It's
> being called from EH path where we know that no other commands are in
> flight.
>=20
Hehe. No, it isn't, if you look closely.
(Or make that: it _shouldn't_, and I've messed it up)
(That's what the 'fpdma' parameter is for)

The benefit is not so much for normal operations, but it'll give us
a performance improvements on SMR drives where we need to issue
READ LOG DMA EXT rather frequently. There we really want to have
them as NCQ commands.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
