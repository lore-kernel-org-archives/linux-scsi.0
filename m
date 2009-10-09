From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: RE: [PATCH 0/4] scsi_dh: Make scsi_dh_activate
	asynchronous
Date: Fri, 9 Oct 2009 08:06:01 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF474F4317C@cosmail01.lsi.com>
References: <20090930020811.11455.59565.sendpatchset@chandra-ubuntu>
	<4AC9EE1B.7030702@suse.de> <1254785154.15826.18.camel@chandra-ubuntu>
	<4ACAFAF5.5000805@suse.de>
	<E463DF2B2E584B4A82673F53D62C2EF474ED90C7@cosmail01.lsi.com>
	<E463DF2B2E584B4A82673F53D62C2EF474ED95C8@cosmail01.lsi.com>
	<4ACF05FF.2030401@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4ACF05FF.2030401@suse.de>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "Stankey,
	Robert" <Robert.Stankey@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "sekharan@linux.vnet.ibm.com" <sekharan@linux.vnet.ibm.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>, device-mapper development <dm-devel@redhat.com>, "Chauhan,
	Vijay" <Vijay.Chauhan@lsi.com>, "Benoit_Arthur@emc.com" <Benoit_Arthur@emc.com>, "Qi,
	Yanling" <Yanling.Qi@lsi.com>, "Eddie.Williams@steeleye.com" <Eddie.Williams@steeleye.com>
List-Id: linux-scsi@vger.kernel.org

Hannes, Thanks again for the response..  Please see the comments below..
=20
> Moger, Babu wrote:
> > 1. Run I/O on both these Luns
> > 2. Pull the cable connected to controller A.
> > 3. Failover will happen and Lun 0 will move to controller B. Now both
> the Luns are on controller B.
> > 4. Connect the cable back on controller A.
> > 5. multipath tool will detect the physical Luns on controller A and
> run the priority test.
> > 6. It will find that Lun 0 is not on preferred path and will initiate
> a failback.
> >    Because it is a controller level failover it will move the Lun 1
> also to controller A.
> >    Now both the Luns are on controller A.
> > 7. Multipath tool will come again and find Lun 1 not on preferred
> path and initiate failback.
> >    This will both the Luns to controller B.
> >    This will continue forever.
> >
> Hmm. Yes, correct.
> After all, the patch I sent was meant to be a proof of concept, not a
> fully fledged
> solution. (In fact, I'm quite surprised it worked so well :-)
>=20
> What about modifying the LUN select code to switch all _visible_ LUNs
> (ie all LUNs which
> are _not_ on the preferred path) in one go?
> That way we wouldn't run into this issue.

In this case handler should be able to do two tasks.
1. move all the Luns when one of the path failed(failover)
2. move only the luns which are not there on preferred path(failback).

With the current code rdac_activate(struct scsi_device *sdev) we cannot m=
ake that decision.  There is no information passed from dm layer to know =
if this command is for task 1(failover) or task 2(failback).=20
