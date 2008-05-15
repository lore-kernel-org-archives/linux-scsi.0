From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/7] scsi_dh: add generic SPC-3 alua handler
Date: Thu, 15 May 2008 10:13:18 +0200
Message-ID: <482BF09E.2070905@suse.de>
References: <20080514144319.543D910B5DF@craiglockhart-ipmi.suse.de>
	<1210819780.21974.264.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1210819780.21974.264.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@us.ibm.com
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Chandra Seetharaman wrote:
> I do not know the functionality of this module. So, my comments are onl=
y
> related to code.
>=20
> blk_request_rq() frees up the request before it returns (in
> blk_end_sync_rq()). So, there is no need for blk_put_request().
>=20
Indeed. But this opens up another question:

By the time blk_execute_rq() returns, the request is already
put back onto the queue.
That means that I shouldn't access rq->errors any more, as
the request might have been reused already.
But blk_execute_rq() returns -EIO for any error, making it
impossible to signal a proper error here.
So how do I get the contents of rq->errors safely?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
