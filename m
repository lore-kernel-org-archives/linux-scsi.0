From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: OCZ Z-drive p84 read performance
Date: Mon, 30 Nov 2009 09:11:58 -0700
Message-ID: <20091130161158.GR9482@parisc-linux.org>
References: <b30d1c3b0911300137n2736664fxab0e9f3c55877e73@mail.gmail.com> <0D1E8821739E724A86F4D16902CE275C1C93C7556B@inbmail01.lsi.com> <b30d1c3b0911300607w43f2b2a2mdd8957ffc5d3f74d@mail.gmail.com> <0D1E8821739E724A86F4D16902CE275C1C93C7557A@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:48814 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbZK3QLx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Nov 2009 11:11:53 -0500
Content-Disposition: inline
In-Reply-To: <0D1E8821739E724A86F4D16902CE275C1C93C7557A@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: Ryousei Takano <ryousei@gmail.com>, "Moore, Eric" <Eric.Moore@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>, "Support, Software" <support@lsi.com>, "takano-ryousei@aist.go.jp" <takano-ryousei@aist.go.jp>, "Yang, Bo" <Bo.Yang@lsi.com>

On Mon, Nov 30, 2009 at 08:07:58PM +0530, Desai, Kashyap wrote:
> > for i in 1 4 16 64 256 512 1024 2048 4096 8192 16384 32768 65536; do
> >         bs=$((BS * i))
> >         count=$((COUNT / i))
> > 
> >         echo bs=$bs count=$count
> >         sudo mount /dev/sdb1 /media/test
> >         dd if=/dev/zero of=/media/test/foo bs=$bs count=$count
> >         sudo umount /media/test
> >         sleep 1
> >         sudo mount /dev/sdb1 /media/test
> >         dd if=/media/test/foo of=/dev/null bs=$bs count=$count
> Replace /media/test/foo with /dev/sdb1, you will see raw read
> >         rm /media/test/foo
> >         sudo umount /media/test
> > done
> > 
> This test is not purely RAW read/write test. In you test File system performance is also included. While read operation, (sequential read) File system buffering will give huge advantage to data transfer.

Both filesystem and block access will use the page cache.  You should
use iflag=direct (or oflag=direct as appropriate) in order to bypass
the page cache.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
