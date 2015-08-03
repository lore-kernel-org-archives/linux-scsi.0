From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/6] libata: Do not retry commands with valid autosense
Date: Mon, 03 Aug 2015 09:31:57 +0200
Message-ID: <55BF18ED.3000002@suse.de>
References: <1438347728-106434-1-git-send-email-hare@suse.de> <1438347728-106434-2-git-send-email-hare@suse.de> <20150802154415.GA31100@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20150802154415.GA31100@mtj.duckdns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <james.bottomley@hansenpartnership.com>
List-Id: linux-scsi@vger.kernel.org

On 08/02/2015 05:44 PM, Tejun Heo wrote:
> Hello,
>=20
> On Fri, Jul 31, 2015 at 03:02:03PM +0200, Hannes Reinecke wrote:
>> If a failed command has a valid autosense there is no need to
>> retry it on the ATA level; at best we're incurring the same
>> error again. So rather not retry it here, but leave it to
>> the SCSI layer to decide if a retry is in order.
>=20
> Hmmm... I don't know.  So, we change how we handle errors completely
> depending on how the device reports it?  Doesn't seem like a
> particularly good idea to me.
>=20
The whole point of the autosense feature is that you do _not_
have to fall back to the original trial-and-error libata EH,
but know exactly what the problem is. Plus any retry will be giving
us (in most cases) exactly the same sense code.
_And_ the SCSI layer is actually able to understand the sense code,
allowing him to make a better judgment on what to do with that error.

So any retry in the libata layer will only slow things down,
leading to the same results eventually.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
