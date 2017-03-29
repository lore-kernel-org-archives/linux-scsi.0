From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 03/23] sd: implement REQ_OP_WRITE_ZEROES
Date: Wed, 29 Mar 2017 16:28:01 +0000
Message-ID: <1490804856.3551.3.camel@sandisk.com>
References: <20170323143341.31549-1-hch@lst.de>
         <20170323143341.31549-4-hch@lst.de> <1490726988.2573.16.camel@sandisk.com>
         <e19ca1bf-0908-1eb0-cb04-cd306692f216@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:61511 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752264AbdC2Q2N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Mar 2017 12:28:13 -0400
In-Reply-To: <e19ca1bf-0908-1eb0-cb04-cd306692f216@redhat.com>
Content-Language: en-US
Content-ID: <7F521760D57C1746ACD169C42D3C2D16@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "agk@redhat.com" <agk@redhat.com>, "lars.ellenberg@linbit.com" <lars.ellenberg@linbit.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "philipp.reisner@linbit.com" <philipp.reisner@linbit.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "shli@kernel.org" <shli@kernel.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>

On Wed, 2017-03-29 at 16:51 +0200, Paolo Bonzini wrote:
> On 28/03/2017 20:50, Bart Van Assche wrote:
> > This means that just like the start and end of a discard must be aligne=
d on a
> > discard_granularity boundary, WRITE SAME commands with the UNMAP bit se=
t must
> > also respect that granularity. I think this means that either
> > __blkdev_issue_zeroout() has to be modified such that it rejects unalig=
ned
> > REQ_OP_WRITE_ZEROES operations or that blk_bio_write_same_split() has t=
o be
> > modified such that it generates REQ_OP_WRITEs for the unaligned start a=
nd tail.
>=20
> I don't think this is the case.

Hello Paolo,

Can you cite the section(s) from the SCSI specs that support your view? I
reread the "5.49 WRITE SAME (10) command" and "4.7.3.4.4 WRITE SAME command
and unmap operations" sections but I have not found any explicit statement
that specifies the behavior for unaligned WRITE SAME commands with the UNMA=
P
bit set. It seems to me like=A0the OPTIMAL UNMAP GRANULARITY parameter was
overlooked when both sections were written. Should we ask the T10 committee
for a clarification?

Another question is, if the specification of WRITE SAME + UNMAP would be
made unambiguous in the SBC document, whether or not we should take the ris=
k
to trigger behavior that is not what we expect by sending unaligned WRITE
SAME + UNMAP commands to SCSI devices?

Thanks,

Bart.=
