From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 18/23] scsi_dh_alua: Send TEST UNIT READY to poll for
 transitioning
Date: Fri, 12 Feb 2016 08:12:59 +0100
Message-ID: <56BD85FB.7060907@suse.de>
References: <1454942086-128704-1-git-send-email-hare@suse.de>
 <1454942086-128704-19-git-send-email-hare@suse.de>
 <1455222318.22112.330.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48988 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbcBLHNC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Feb 2016 02:13:02 -0500
In-Reply-To: <1455222318.22112.330.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On 02/11/2016 09:25 PM, Ewan Milne wrote:
> On Mon, 2016-02-08 at 15:34 +0100, Hannes Reinecke wrote:
>> Sending a 'REPORT TARGET PORT GROUP' command is a costly operation,
>> as the array has to gather information about all ports.
>> So instead of using RTPG to poll for a status update when a port
>> is in transitioning we should be sending a TEST UNIT READY, and
>> wait for the sense code to report success.
>=20
> Note that we may need to add a timeout on this somehow, I have
> recently seen a bug report where an array stayed in the ALUA
> transitioning state for an extremely long period of time.
>=20
> That problem would occur with either the current or this new
> ALUA code, the question is whether we want to handle it better.
>=20
There already is provisioning in the code to set the port to STANDBY
if the transitioning time is exceeded.
Not that this code path is well tested, but it's there :-)

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
