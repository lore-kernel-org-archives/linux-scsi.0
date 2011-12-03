From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [SCSI] NULL pointer dereference in sym53c8xx (bisected)
Date: Sat, 03 Dec 2011 22:07:53 +0100
Message-ID: <4EDA8FA9.8020004@linux.vnet.ibm.com>
References: <4ED8EE1C.4090404@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4ED8EE1C.4090404@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Stratos Psomadakis <psomas@gentoo.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, gregkh@suse.de, linux-scsi@vger.kernel.org, JBottomley@parallels.com, matthew@wil.cx, Martin.vGagern@gmx.net, kernel@gentoo.org
List-Id: linux-scsi@vger.kernel.org

On 12/02/2011 04:26 PM, Stratos Psomadakis wrote:
> After upstream commit 4e6c82b3614a18740ef63109d58743a359266daf ([SCSI=
]
> fix WARNING: at drivers/scsi/scsi_lib.c:1704), which is also included=
 in
> 3.0-stable and 3.1-stable kernels, the kernel fails to boot (NULL
> pointer dereference in sym53c8xx_slave_destroy).
>
> Bug report at the Gentoo Bugzilla (reported and bisected by Martin vo=
n
> Gagern). [1]  (stack trace [2])
>
> I think that the problem is that (after commit 4e6c82b)
> __scsi_remove_device() is called if slave_alloc() in scsi_alloc_sdev(=
)
> fails. But __scsi_remove_device() calls slave_destroy(), which (I thi=
nk)
> doesn't make much sense (ie to call slave_destroy() when slave_alloc(=
)
> fails).
>
> For sym53c8xx, this results in a NULL pointer dereference (struct
> sym_lcb pointer) in slave_destroy().
>
> [1] https://bugs.gentoo.org/show_bug.cgi?id=3D392567
> [2] https://392567.bugs.gentoo.org/attachment.cgi?id=3D294381

To me this looks like the same thing we encountered in the zfcp LLD:
http://www.spinics.net/lists/linux-scsi/msg55575.html
James explained the pairing of slave_alloc and slave_destroy even if=20
slave_alloc returned early in which case slave_destroy needs to cope=20
with that:
http://www.spinics.net/lists/linux-scsi/msg55449.html

HTH
Steffen

Linux on System z Development

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Martin Jetter
Gesch=C3=A4ftsf=C3=BChrung: Dirk Wittkopp
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
