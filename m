From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 09/17] scsi_dh_alua: switch to scsi_execute()
Date: Wed, 06 May 2015 11:58:16 +0200
Message-ID: <5549E5B8.8040902@suse.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de> <1430743343-47174-10-git-send-email-hare@suse.de> <20150506092637.GA26004@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44581 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbbEFJ6S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 May 2015 05:58:18 -0400
In-Reply-To: <20150506092637.GA26004@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On 05/06/2015 11:26 AM, Christoph Hellwig wrote:
> On Mon, May 04, 2015 at 02:42:15PM +0200, Hannes Reinecke wrote:
>> All commands are issued synchronously, so no need to open-code
>> scsi_execute anymore.
>=20
> Currently the alua codes doesn't set REQ_PREEMPT, and uses a GFP_NOIO
> allocation.  Please document why changing these is safe/and or desira=
ble.
>=20
> Also it would be good to a change like this to the other device handl=
ers,
> as the code is copy and pasted everywhere, and only hp_sw has an asyn=
chronous
> case that can be handled separately.
>=20
Well, yes, of course.
However, for ALUA this will only work once the previous alua patches
are in. So I'd prefer to have another patchset on top of this,
converting the other device handlers.

As for the REQ_PREEMPT / GFP_NOIO I'll have a look and document
or fix is as appropriate.

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
