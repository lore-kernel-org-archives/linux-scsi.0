From: "Malavali, Giridhar" <Giridhar.Malavali@cavium.com>
Subject: Re: [PATCH] qla2xxx: Protect access to qpair members with
 qpair->qp_lock
Date: Fri, 23 Jun 2017 22:04:26 +0000
Message-ID: <D572DE61.976AF%giridhar.malavali@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Content-ID: <06E33A1C53A2F54B939D7C14C54087C0@namprd07.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@cavium.com>, "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>, Johannes Thumshirn <jthumshirn@suse.de>Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@cavium.com>"Madhani, Himanshu" <Himanshu.Madhani@cavium.com>Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

Yes, it=B9s needed. We will post a patch.

On 6/23/17, 9:34 AM, "Julia Lawall" <julia.lawall@lip6.fr> wrote:

>Please check on whether an unlock is neeed before line 1965.
>
>julia
>
>---------- Forwarded message ----------
>Date: Fri, 23 Jun 2017 15:23:00 +0800
>From: kbuild test robot <fengguang.wu@intel.com>
>To: kbuild@01.org
>Cc: Julia Lawall <julia.lawall@lip6.fr>
>Subject: Re: [PATCH] qla2xxx: Protect access to qpair members with
>    qpair->qp_lock
>
>CC: kbuild-all@01.org
>In-Reply-To: <20170622134325.26931-1-jthumshirn@suse.de>
>
>Hi Johannes,
>
>[auto build test WARNING on scsi/for-next]
>[also build test WARNING on v4.12-rc6 next-20170622]
>[if your patch is applied to the wrong git tree, please drop us a note to
>help improve the system]
>
>url:   =20
>https://github.com/0day-ci/linux/commits/Johannes-Thumshirn/qla2xxx-Protec
>t-access-to-qpair-members-with-qpair-qp_lock/20170623-123844
>base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git
>for-next
>:::::: branch date: 3 hours ago
>:::::: commit date: 3 hours ago
>
>>> drivers/scsi/qla2xxx/qla_iocb.c:1965:3-9: preceding lock on line 1952
>
>git remote add linux-review https://github.com/0day-ci/linux
>git remote update linux-review
>git checkout 4a35d720268dbe9ac016957a3c4fc644398d68ba
>vim +1965 drivers/scsi/qla2xxx/qla_iocb.c
>
>d74595278 Michael Hernandez  2016-12-12  1946  	/* Only process
>protection or >16 cdb in this routine */
>d74595278 Michael Hernandez  2016-12-12  1947  	if (scsi_get_prot_op(cmd)
>=3D=3D SCSI_PROT_NORMAL) {
>d74595278 Michael Hernandez  2016-12-12  1948  		if (cmd->cmd_len <=3D 16)
>d74595278 Michael Hernandez  2016-12-12  1949  			return
>qla2xxx_start_scsi_mq(sp);
>d74595278 Michael Hernandez  2016-12-12  1950  	}
>d74595278 Michael Hernandez  2016-12-12  1951
>4a35d7202 Johannes Thumshirn 2017-06-22 @1952
>	spin_lock_irqsave(&qpair->qp_lock, flags);
>4a35d7202 Johannes Thumshirn 2017-06-22  1953
>d74595278 Michael Hernandez  2016-12-12  1954  	/* Setup qpair pointers */
>d74595278 Michael Hernandez  2016-12-12  1955  	rsp =3D qpair->rsp;
>d74595278 Michael Hernandez  2016-12-12  1956  	req =3D qpair->req;
>d74595278 Michael Hernandez  2016-12-12  1957
>d74595278 Michael Hernandez  2016-12-12  1958  	/* So we know we haven't
>pci_map'ed anything yet */
>d74595278 Michael Hernandez  2016-12-12  1959  	tot_dsds =3D 0;
>d74595278 Michael Hernandez  2016-12-12  1960
>d74595278 Michael Hernandez  2016-12-12  1961  	/* Send marker if
>required */
>d74595278 Michael Hernandez  2016-12-12  1962  	if (vha->marker_needed !=
=3D
>0) {
>d74595278 Michael Hernandez  2016-12-12  1963  		if (qla2x00_marker(vha,
>req, rsp, 0, 0, MK_SYNC_ALL) !=3D
>d74595278 Michael Hernandez  2016-12-12  1964  		    QLA_SUCCESS)
>d74595278 Michael Hernandez  2016-12-12 @1965  			return
>QLA_FUNCTION_FAILED;
>d74595278 Michael Hernandez  2016-12-12  1966  		vha->marker_needed =3D 0;
>d74595278 Michael Hernandez  2016-12-12  1967  	}
>d74595278 Michael Hernandez  2016-12-12  1968
>
>:::::: The code at line 1965 was first introduced by commit
>:::::: d74595278f4ab192af66d9e60a9087464638beee scsi: qla2xxx: Add
>multiple queue pair functionality.
>
>:::::: TO: Michael Hernandez <michael.hernandez@cavium.com>
>:::::: CC: Martin K. Petersen <martin.petersen@oracle.com>
>
>---
>0-DAY kernel test infrastructure                Open Source Technology
>Center
>https://lists.01.org/pipermail/kbuild-all                   Intel
>Corporation
