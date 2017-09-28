From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: Re: [PATCH V6 0/6] block/scsi: safe SCSI quiescing
Date: Thu, 28 Sep 2017 10:11:17 +0200
Message-ID: <7473098.qZHWJtyrGG@natalenko.name>
References: <20170927054853.6647-1-ming.lei@redhat.com> <20170927082751.GA7464@ming.t460p> <20170927085235.GA14921@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vulcan.natalenko.name ([104.207.131.136]:15382 "EHLO
        vulcan.natalenko.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751524AbdI1ILU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Sep 2017 04:11:20 -0400
In-Reply-To: <20170927085235.GA14921@ming.t460p>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Martin Steigerwald <martin@lichtvoll.de>, Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Johannes Thumshirn <jthumshirn@suse.de>, Cathy Avery <cavery@redhat.com>

Hey.

I can confirm that v6 of your patchset still works well for me. Tested on=20
v4.13 kernel.

Thanks.

On st=C5=99eda 27. z=C3=A1=C5=99=C3=AD 2017 10:52:41 CEST Ming Lei wrote:
> On Wed, Sep 27, 2017 at 04:27:51PM +0800, Ming Lei wrote:
> > On Wed, Sep 27, 2017 at 09:57:37AM +0200, Martin Steigerwald wrote:
> > > Hi Ming.
> > >=20
> > > Ming Lei - 27.09.17, 13:48:
> > > > Hi,
> > > >=20
> > > > The current SCSI quiesce isn't safe and easy to trigger I/O deadloc=
k.
> > > >=20
> > > > Once SCSI device is put into QUIESCE, no new request except for
> > > > RQF_PREEMPT can be dispatched to SCSI successfully, and
> > > > scsi_device_quiesce() just simply waits for completion of I/Os
> > > > dispatched to SCSI stack. It isn't enough at all.
> > > >=20
> > > > Because new request still can be comming, but all the allocated
> > > > requests can't be dispatched successfully, so request pool can be
> > > > consumed up easily.
> > > >=20
> > > > Then request with RQF_PREEMPT can't be allocated and wait forever,
> > > > meantime scsi_device_resume() waits for completion of RQF_PREEMPT,
> > > > then system hangs forever, such as during system suspend or
> > > > sending SCSI domain alidation.
> > > >=20
> > > > Both IO hang inside system suspend[1] or SCSI domain validation
> > > > were reported before.
> > > >=20
> > > > This patch introduces preempt only mode, and solves the issue
> > > > by allowing RQF_PREEMP only during SCSI quiesce.
> > > >=20
> > > > Both SCSI and SCSI_MQ have this IO deadlock issue, this patch fixes
> > > > them all.
> > > >=20
> > > > V6:
> > > > 	- borrow Bart's idea of preempt only, with clean
> > > > =09
> > > > 	  implementation(patch 5/patch 6)
> > > > =09
> > > > 	- needn't any external driver's dependency, such as MD's
> > > > 	change
> > >=20
> > > Do you want me to test with v6 of the patch set? If so, it would be n=
ice
> > > if
> > > you=C2=B4d make a v6 branch in your git repo.
> >=20
> > Hi Martin,
> >=20
> > I appreciate much if you may run V6 and provide your test result,
> > follows the branch:
> >=20
> > https://github.com/ming1/linux/tree/blk_safe_scsi_quiesce_V6
> >=20
> > https://github.com/ming1/linux.git #blk_safe_scsi_quiesce_V6
>=20
> Also follows the branch against V4.13:
>=20
> https://github.com/ming1/linux/tree/v4.13-safe-scsi-quiesce_V6_for_test
>=20
> https://github.com/ming1/linux.git #v4.13-safe-scsi-quiesce_V6_for_test
