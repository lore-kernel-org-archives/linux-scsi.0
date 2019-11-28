Return-Path: <SRS0=EtEA=ZU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0473C43141
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Nov 2019 02:58:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADD0B215F2
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Nov 2019 02:58:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LZdwV7G5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727480AbfK1C6m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Nov 2019 21:58:42 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:46715 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727774AbfK1C6m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Nov 2019 21:58:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574909920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Coc3ROfTcpkDKNK46WxP6fvoSRPOxvHS7y/xlpJozS0=;
        b=LZdwV7G5YpjoTgeaP9cHtYxY+PYIArjZ6g2k9mWlN1Kncxc63cpA5/YEuKzz6dkZfu0d2n
        oQ1sxZeOCKQFEtC+ivPQF4BZq8uk+px7sZX9Cw86g1FMtwbUhjIyuAR3c7Jr2y+9k2OAZH
        TzTQ5oT2UrEfKxYq4v840zH4G6yofhg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-53-pP1oIlfbO-utmp5D8fduPA-1; Wed, 27 Nov 2019 21:58:37 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 423B9593A0;
        Thu, 28 Nov 2019 02:58:35 +0000 (UTC)
Received: from ming.t460p (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 943F160BE2;
        Thu, 28 Nov 2019 02:58:27 +0000 (UTC)
Date:   Thu, 28 Nov 2019 10:58:22 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Rob Townley <rob.townley@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Stephen Rust <srust@blockbridge.com>,
        linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        target-devel@vger.kernel.org
Subject: Re: Data corruption in kernel 5.1+ with iSER attached ramdisk
Message-ID: <20191128025822.GC3277@ming.t460p>
References: <CAAFE1bd9wuuobpe4VK7Ty175j7mWT+kRmHCNhVD+6R8MWEAqmw@mail.gmail.com>
 <20191128015748.GA3277@ming.t460p>
 <CA+VdTb_-CGaPjKUQteKVFSGqDz-5o-tuRRkJYqt8B9iOQypiwQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CA+VdTb_-CGaPjKUQteKVFSGqDz-5o-tuRRkJYqt8B9iOQypiwQ@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: pP1oIlfbO-utmp5D8fduPA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 27, 2019 at 08:18:30PM -0600, Rob Townley wrote:
> On Wed, Nov 27, 2019 at 7:58 PM Ming Lei <ming.lei@redhat.com> wrote:
>=20
> > Hello,
> >
> > On Wed, Nov 27, 2019 at 02:38:42PM -0500, Stephen Rust wrote:
> > > Hi,
> > >
> > > We recently began testing 5.4 in preparation for migration from 4.14.=
 One
> > > of our tests found reproducible data corruption in 5.x kernels. The t=
est
> > > consists of a few basic single-issue writes to an iSER attached ramdi=
sk.
> > > The writes are subsequently verified with single-issue reads. We trac=
ked
> > > the corruption down using git bisect. The issue appears to have start=
ed
> > in
> > > 5.1 with the following commit:
> > >
> > > 3d75ca0adef4280650c6690a0c4702a74a6f3c95 block: introduce multi-page =
bvec
> > > helpers
> > >
> > > We wanted to bring this to your attention. A reproducer and the git
> > bisect
> > > data follows below.
> > >
> > > Our setup consists of two systems: A ramdisk exported in a LIO target
> > from
> > > host A, iSCSI attached with iSER / RDMA from host B. Specific writes =
to
> > the
> >
> > Could you explain a bit what is iSCSI attached with iSER / RDMA? Is the
> > actual transport TCP over RDMA? What is related target driver involved?
> >
> > > very end of the attached disk on B result in incorrect data being wri=
tten
> > > to the remote disk. The writes appear to complete successfully on the
> > > client. We=E2=80=99ve also verified that the correct data is being se=
nt over the
> > > network by tracing the RDMA flow. For reference, the tests were condu=
cted
> > > on x86_64 Intel Skylake systems with Mellanox ConnectX5 NICs.
> >
> > If I understand correctly, LIO ramdisk doesn't generate any IO to block
> > stack, see rd_execute_rw(), and the ramdisk should be one big/long
> > pre-allocated sgl, see rd_build_device_space().
> >
> > Seems very strange, given no bvec/bio is involved in this code
> > path from iscsi_target_rx_thread to rd_execute_rw. So far I have no ide=
a
> > how commit 3d75ca0adef428065 causes this issue, because that patch
> > only changes bvec/bio related code.
> >
> > >
> > > The issue appears to lie on the target host side. The initiator kerne=
l
> > > version does not appear to play a role. The target host exhibits the
> > issue
> > > when running kernel version 5.1+.
> > >
> > > To reproduce, given attached sda on client host B, write data at the =
end
> > of
> > > the device:
> > >
> > >
> > > SIZE=3D$(blockdev --getsize64 /dev/sda)
> > >
> > > SEEK=3D$((( $SIZE - 512 )))
> > >
> > > # initialize device and seed data
> > >
> > > dd if=3D/dev/zero of=3D/dev/sda bs=3D512 count=3D1 seek=3D$SEEK oflag=
=3Dseek_bytes
> > > oflag=3Ddirect
> > >
> > > dd if=3D/dev/urandom of=3D/tmp/random bs=3D512 count=3D1 oflag=3Ddire=
ct
> > >
> > >
> > > # write the random data (note: not direct)
> > >
> > > dd if=3D/tmp/random of=3D/dev/sda bs=3D512 count=3D1 seek=3D$SEEK ofl=
ag=3Dseek_bytes
> > >
> > >
> > > # verify the data was written
> > >
> > > dd if=3D/dev/sda of=3D/tmp/verify bs=3D512 count=3D1 skip=3D$SEEK ifl=
ag=3Dskip_bytes
> > > iflag=3Ddirect
> > >
> > > hexdump -xv /tmp/random > /tmp/random.hex
> > >
> > > hexdump -xv /tmp/verify > /tmp/verify.hex
> > >
> > > diff -u /tmp/random.hex /tmp/verify.hex
> >
> > I just setup one LIO for exporting ramdisk(2G) via iscsi, and run the
> > above test via iscsi HBA, still can't reproduce the issue.
> >
> > > # first bad commit: [3d75ca0adef4280650c6690a0c4702a74a6f3c95] block:
> > > introduce multi-page bvec helpers
> > >
> > >
> > > Please advise. We have cycles and systems to help track down the issu=
e.
> > Let
> > > me know how best to assist.
> >
> > Could you install bcc and start to collect the following trace on targe=
t
> > side
> > before you run the above test in host side?
> >
> > /usr/share/bcc/tools/stackcount -K rd_execute_rw
> >
> >
> > Thanks,
> > Ming
> >
>=20
>=20
> Interesting case to follow as there are many types of RamDisks.  The comm=
on
> tmpfs kind will use its RAM allocation and all free harddrive space.
>=20
> The ramdisk in CentOS 7 backed by LIO will overflow its size in RAM and
> fill up all remaining free space on spinning platters.  So if the RamDisk
> is 4GB out of 192GB RAM in the lightly used machine. Free filesystem spac=
e
> is 16GB.  Writes to the 4GB RamDisk will only error out at 21GB when ther=
e
> is no space left on filesystem.
>=20
> dd if=3D/dev/zero of=3D/dev/iscsiRamDisk
> Will keep writing way past 4GB and not stop till hardrive is full which i=
s
> totally different than normal disks.
>=20
> Wonder what exact kind of RamDisk is in that kernel?

In my test, it is the LIO built-in ramdisk:

/backstores/ramdisk> create rd0 2G
Created ramdisk rd0 with size 2G.
/backstores/ramdisk> ls
o- ramdisk ................................................................=
......... [Storage Objects: 1]
  o- rd0 ..................................................................=
....... [(2.0GiB) deactivated]
    o- alua ...............................................................=
............. [ALUA Groups: 1]
      o- default_tg_pt_gp ................................................ =
[ALUA state: Active/optimized]

Stephen, could you share us how you setup the ramdisk in your test?

Thanks,=20
Ming

