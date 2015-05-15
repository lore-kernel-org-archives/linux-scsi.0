From: "Narsimhulu Musini (nmusini)" <nmusini@cisco.com>
Subject: Re: [PATCH v5 0/9] snic:initial submission of snic driver for Cisco
 SCSI HBA
Date: Fri, 15 May 2015 16:08:29 +0000
Message-ID: <D17C16FC.25A05%nmusini@cisco.com>
References: <1429694642-22309-1-git-send-email-nmusini@cisco.com>
 <1431704986.2295.2.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcdn-iport-6.cisco.com ([173.37.86.77]:6765 "EHLO
	rcdn-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934713AbbEOQIa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2015 12:08:30 -0400
In-Reply-To: <1431704986.2295.2.camel@HansenPartnership.com>
Content-Language: en-US
Content-ID: <65A549680D184E4BB8517E303A9719D1@emea.cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.de" <hare@suse.de>

Hi James,

>>This doesn't build on 32 bits.  Is it supposed to be 64 bit only?
Yes please, x86_64 arch only.

Thanks
Narsimhulu Musini
On 15/05/15 9:19 pm, "James Bottomley"
<James.Bottomley@HansenPartnership.com> wrote:

>On Wed, 2015-04-22 at 02:23 -0700, Narsimhulu Musini wrote:
>> The following patch series adds snic driver for Cisco SCSI HBA
>>=20
>> Cisco has developed a new PCI HBA interface called sNIC, which stand=
s
>>for=20
>> SCSI NIC. This is a new storage feature supported on specialized net=
work
>> adapter. The new PCI function provides a uniform host interface and
>>abstracts
>> backend storage.
>>=20
>> * v5
>> - Incorporated Dr. Hannes Reinecke's review comments.
>>=20
>> * v4
>> - Incorporated Christoph Hellwig's comments.
>>=20
>> * v3
>> - Incorporated Dr. Hannes Reinecke's review comments.
>>=20
>> * v2
>> - Incorporated Dr. Hannes Reinecke's review comments.
>>=20
>> 	Thanks
>> 	Narsimhulu Musini & Sesidhar Baddela
>>=20
>> Narsimhulu Musini (9):
>>   snic: snic module infrastructure
>>   snic:Add interrupt, resource firmware interfaces
>>   snic:Add meta request,  handling of meta requests.
>>   snic:Add snic target discovery
>>   snic:add SCSI handling, AEN, and fwreset handling
>>   snic:Add low level queuing interfaces
>>   snic:Add sysfs entries to list stats and trace data
>>   snic:Add event tracing to capture IO events.
>>   snic:Add Makefile, patch Kconfig, MAINTAINERS
>>=20
>>  MAINTAINERS                       |    7 +
>>  drivers/scsi/Kconfig              |   17 +
>>  drivers/scsi/Makefile             |    1 +
>>  drivers/scsi/snic/Makefile        |   21 +
>>  drivers/scsi/snic/cq_desc.h       |   76 ++
>>  drivers/scsi/snic/cq_enet_desc.h  |   38 +
>>  drivers/scsi/snic/snic.h          |  415 ++++++
>>  drivers/scsi/snic/snic_attrs.c    |   79 ++
>>  drivers/scsi/snic/snic_ctl.c      |  276 ++++
>>  drivers/scsi/snic/snic_debugfs.c  |  562 ++++++++
>>  drivers/scsi/snic/snic_disc.c     |  602 +++++++++
>>  drivers/scsi/snic/snic_disc.h     |  124 ++
>>  drivers/scsi/snic/snic_fwint.h    |  525 ++++++++
>>  drivers/scsi/snic/snic_io.c       |  519 ++++++++
>>  drivers/scsi/snic/snic_io.h       |  118 ++
>>  drivers/scsi/snic/snic_isr.c      |  209 +++
>>  drivers/scsi/snic/snic_main.c     | 1039 +++++++++++++++
>>  drivers/scsi/snic/snic_res.c      |  297 +++++
>>  drivers/scsi/snic/snic_res.h      |   96 ++
>>  drivers/scsi/snic/snic_scsi.c     | 2640
>>+++++++++++++++++++++++++++++++++++++
>>  drivers/scsi/snic/snic_stats.h    |  123 ++
>>  drivers/scsi/snic/snic_trc.c      |  182 +++
>>  drivers/scsi/snic/snic_trc.h      |  121 ++
>>  drivers/scsi/snic/vnic_cq.c       |   86 ++
>>  drivers/scsi/snic/vnic_cq.h       |  110 ++
>>  drivers/scsi/snic/vnic_cq_fw.h    |   62 +
>>  drivers/scsi/snic/vnic_dev.c      |  748 +++++++++++
>>  drivers/scsi/snic/vnic_dev.h      |  110 ++
>>  drivers/scsi/snic/vnic_devcmd.h   |  270 ++++
>>  drivers/scsi/snic/vnic_intr.c     |   59 +
>>  drivers/scsi/snic/vnic_intr.h     |  105 ++
>>  drivers/scsi/snic/vnic_resource.h |   68 +
>>  drivers/scsi/snic/vnic_snic.h     |   54 +
>>  drivers/scsi/snic/vnic_stats.h    |   68 +
>>  drivers/scsi/snic/vnic_wq.c       |  237 ++++
>>  drivers/scsi/snic/vnic_wq.h       |  170 +++
>>  drivers/scsi/snic/wq_enet_desc.h  |   91 ++
>>  37 files changed, 10325 insertions(+)
>>  create mode 100644 drivers/scsi/snic/Makefile
>>  create mode 100644 drivers/scsi/snic/cq_desc.h
>>  create mode 100644 drivers/scsi/snic/cq_enet_desc.h
>>  create mode 100644 drivers/scsi/snic/snic.h
>>  create mode 100644 drivers/scsi/snic/snic_attrs.c
>>  create mode 100644 drivers/scsi/snic/snic_ctl.c
>>  create mode 100644 drivers/scsi/snic/snic_debugfs.c
>>  create mode 100644 drivers/scsi/snic/snic_disc.c
>>  create mode 100644 drivers/scsi/snic/snic_disc.h
>>  create mode 100644 drivers/scsi/snic/snic_fwint.h
>>  create mode 100644 drivers/scsi/snic/snic_io.c
>>  create mode 100644 drivers/scsi/snic/snic_io.h
>>  create mode 100644 drivers/scsi/snic/snic_isr.c
>>  create mode 100644 drivers/scsi/snic/snic_main.c
>>  create mode 100644 drivers/scsi/snic/snic_res.c
>>  create mode 100644 drivers/scsi/snic/snic_res.h
>>  create mode 100644 drivers/scsi/snic/snic_scsi.c
>>  create mode 100644 drivers/scsi/snic/snic_stats.h
>>  create mode 100644 drivers/scsi/snic/snic_trc.c
>>  create mode 100644 drivers/scsi/snic/snic_trc.h
>>  create mode 100644 drivers/scsi/snic/vnic_cq.c
>>  create mode 100644 drivers/scsi/snic/vnic_cq.h
>>  create mode 100644 drivers/scsi/snic/vnic_cq_fw.h
>>  create mode 100644 drivers/scsi/snic/vnic_dev.c
>>  create mode 100644 drivers/scsi/snic/vnic_dev.h
>>  create mode 100644 drivers/scsi/snic/vnic_devcmd.h
>>  create mode 100644 drivers/scsi/snic/vnic_intr.c
>>  create mode 100644 drivers/scsi/snic/vnic_intr.h
>>  create mode 100644 drivers/scsi/snic/vnic_resource.h
>>  create mode 100644 drivers/scsi/snic/vnic_snic.h
>>  create mode 100644 drivers/scsi/snic/vnic_stats.h
>>  create mode 100644 drivers/scsi/snic/vnic_wq.c
>>  create mode 100644 drivers/scsi/snic/vnic_wq.h
>>  create mode 100644 drivers/scsi/snic/wq_enet_desc.h
>
>This doesn't build on 32 bits.  Is it supposed to be 64 bit only?
>
>  CC [M]  drivers/scsi/snic/snic_attrs.o
>  CC [M]  drivers/scsi/snic/snic_main.o
>  CC [M]  drivers/scsi/snic/snic_isr.o
>  CC [M]  drivers/scsi/snic/snic_res.o
>  CC [M]  drivers/scsi/snic/snic_ctl.o
>  CC [M]  drivers/scsi/snic/snic_io.o
>  CC [M]  drivers/scsi/snic/snic_disc.o
>  CC [M]  drivers/scsi/snic/snic_scsi.o
>drivers/scsi/snic/snic_ctl.c: In function =8Csnic_queue_exch_ver_req=B9=
:
>drivers/scsi/snic/snic_ctl.c:130:25: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>    snic->config.hid, 0, (u64)rqi);
>                         ^
>drivers/scsi/snic/snic_ctl.c: In function
>=8Csnic_io_exch_ver_cmpl_handler=B9:
>drivers/scsi/snic/snic_ctl.c:167:8: warning: cast to pointer from
>integer of different size [-Wint-to-pointer-cast]
>  rqi =3D (struct snic_req_info *) ctx;
>        ^
>  CC [M]  drivers/scsi/snic/vnic_cq.o
>In file included from drivers/scsi/snic/snic.h:33:0,
>                 from drivers/scsi/snic/snic_io.c:29:
>drivers/scsi/snic/snic_io.c: In function =8Csnic_wq_cmpl_frame_send=B9=
:
>drivers/scsi/snic/snic_io.c:49:5: warning: cast from pointer to intege=
r
>of different size [-Wpointer-to-int-cast]
>    ((u64)(buf->os_buf) - sizeof(struct snic_req_info)), 0, 0, 0);
>     ^
>drivers/scsi/snic/snic_trc.h:90:14: note: in definition of macro
>=8CSNIC_TRC=B9
>        (u64)(d2),    \
>              ^
>In file included from drivers/scsi/snic/snic_io.c:28:0:
>drivers/scsi/snic/snic_io.c: In function =8Csnic_free_wq_buf=B9:
>drivers/scsi/snic/snic_io.h:104:3: warning: cast to pointer from integ=
er
>of different size [-Wint-to-pointer-cast]
>  ((struct snic_req_info *) (((struct snic_host_req
>*)req)->hdr.init_ctx))
>   ^
>drivers/scsi/snic/snic_io.c:106:8: note: in expansion of macro
>=8Creq_to_rqi=B9
>  rqi =3D req_to_rqi(req);
>        ^
>drivers/scsi/snic/snic_io.c:119:9: warning: cast to pointer from integ=
er
>of different size [-Wint-to-pointer-cast]
>   kfree((void *)rqi->sge_va);
>         ^
>drivers/scsi/snic/snic_io.c: In function =8Csnic_req_init=B9:
>drivers/scsi/snic/snic_io.c:245:27: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>  rqi->req->hdr.init_ctx =3D (u64) rqi;
>                           ^
>drivers/scsi/snic/snic_io.c: In function =8Csnic_abort_req_init=B9:
>drivers/scsi/snic/snic_io.c:278:22: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>  req->hdr.init_ctx =3D (u64) rqi;
>                      ^
>drivers/scsi/snic/snic_io.c: In function =8Csnic_dr_req_init=B9:
>drivers/scsi/snic/snic_io.c:305:22: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>  req->hdr.init_ctx =3D (u64) rqi;
>                      ^
>drivers/scsi/snic/snic_io.c: In function =8Csnic_free_all_untagged_req=
s=B9:
>drivers/scsi/snic/snic_io.c:360:10: warning: cast to pointer from
>integer of different size [-Wint-to-pointer-cast]
>    kfree((void *)rqi->sge_va);
>          ^
>drivers/scsi/snic/snic_io.c: In function =8Csnic_dump_desc=B9:
>drivers/scsi/snic/snic_io.c:416:9: warning: cast to pointer from integ=
er
>of different size [-Wint-to-pointer-cast]
>   rqi =3D (struct snic_req_info *) fwreq->hdr.init_ctx;
>         ^
>drivers/scsi/snic/snic_io.c:418:9: warning: cast to pointer from integ=
er
>of different size [-Wint-to-pointer-cast]
>   rqi =3D (struct snic_req_info *) req->hdr.init_ctx;
>         ^
>  CC [M]  drivers/scsi/snic/vnic_intr.o
>In file included from include/uapi/linux/stddef.h:1:0,
>                 from include/linux/stddef.h:4,
>                 from ./include/uapi/linux/posix_types.h:4,
>                 from include/uapi/linux/types.h:13,
>                 from include/linux/types.h:5,
>                 from include/linux/mod_devicetable.h:11,
>                 from include/linux/pci.h:20,
>                 from drivers/scsi/snic/snic_io.c:19:
>drivers/scsi/snic/snic_io.c: In function =8Csnic_req_init=B9:
>include/linux/compiler.h:408:20: error: call to
>=8C__compiletime_assert_226=B9 declared with attribute error: BUILD_BU=
G_ON
>failed: (sizeof(struct snic_req_info) % SNIC_SG_DESC_ALIGN) !=3D 0
>    prefix ## suffix();    \
>                    ^
>include/linux/compiler.h:413:2: note: in expansion of macro
>=8C__compiletime_assert=B9
>  __compiletime_assert(condition, msg, prefix, suffix)
>  ^
>include/linux/compiler.h:425:2: note: in expansion of macro
>=8C_compiletime_assert=B9
>  _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
>  ^
>include/linux/bug.h:50:37: note: in expansion of macro
>=8Ccompiletime_assert=B9
> #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
>                                     ^
>include/linux/bug.h:74:2: note: in expansion of macro =8CBUILD_BUG_ON_=
MSG=B9
>  BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
>  ^
>drivers/scsi/snic/snic_io.c:226:2: note: in expansion of macro
>=8CBUILD_BUG_ON=B9
>  BUILD_BUG_ON((sizeof(struct snic_req_info) % SNIC_SG_DESC_ALIGN) !=3D
>0);
>  ^
>  CC [M]  drivers/scsi/snic/vnic_dev.o
>scripts/Makefile.build:258: recipe for target
>'drivers/scsi/snic/snic_io.o' failed
>make[3]: *** [drivers/scsi/snic/snic_io.o] Error 1
>make[3]: *** Waiting for unfinished jobs....
>drivers/scsi/snic/snic_scsi.c: In function =8Csnic_queue_icmnd_req=B9:
>drivers/scsi/snic/snic_scsi.c:212:4: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>    (u64)rqi,
>    ^
>drivers/scsi/snic/snic_scsi.c:220:4: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>    (u64)req_to_sgl(rqi->req),
>    ^
>In file included from drivers/scsi/snic/snic.h:33:0,
>                 from drivers/scsi/snic/snic_scsi.c:34:
>drivers/scsi/snic/snic_scsi.c: In function =8Csnic_issue_scsi_req=B9:
>drivers/scsi/snic/snic_scsi.c:253:44: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>   SNIC_TRC((u16)snic->shost->host_no, tag, (u64)sc, 0,
>                                            ^
>drivers/scsi/snic/snic_trc.h:89:14: note: in definition of macro
>=8CSNIC_TRC=B9
>        (u64)(d1),    \
>              ^
>drivers/scsi/snic/snic_scsi.c:297:39: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>   SNIC_TRC(snic->shost->host_no, tag, (u64)sc, 0, 0, 0,
>                                       ^
>drivers/scsi/snic/snic_trc.h:89:14: note: in definition of macro
>=8CSNIC_TRC=B9
>        (u64)(d1),    \
>              ^
>drivers/scsi/snic/snic_scsi.c:314:39: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>   SNIC_TRC(snic->shost->host_no, tag, (u64)sc, (u64)rqi, sg_cnt,
>                                       ^
>drivers/scsi/snic/snic_trc.h:89:14: note: in definition of macro
>=8CSNIC_TRC=B9
>        (u64)(d1),    \
>              ^
>drivers/scsi/snic/snic_scsi.c:314:48: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>   SNIC_TRC(snic->shost->host_no, tag, (u64)sc, (u64)rqi, sg_cnt,
>                                                ^
>drivers/scsi/snic/snic_trc.h:90:14: note: in definition of macro
>=8CSNIC_TRC=B9
>        (u64)(d2),    \
>              ^
>drivers/scsi/snic/snic_scsi.c: In function =8Csnic_icmnd_cmpl_handler=B9=
:
>drivers/scsi/snic/snic_trc.h:91:8: warning: cast from pointer to integ=
er
>of different size [-Wpointer-to-int-cast]
>        (u64)(d3),    \
>        ^
>drivers/scsi/snic/snic_scsi.c:588:3: note: in expansion of macro
>=8CSNIC_TRC=B9
>   SNIC_TRC(snic->shost->host_no, cmnd_id, 0,
>   ^
>In file included from drivers/scsi/snic/snic_scsi.c:34:0:
>drivers/scsi/snic/snic_scsi.c:610:21: warning: cast to pointer from
>integer of different size [-Wint-to-pointer-cast]
>  SNIC_BUG_ON(rqi !=3D (struct snic_req_info *)ctx);
>                     ^
>drivers/scsi/snic/snic.h:184:7: note: in definition of macro
>=8CSNIC_BUG_ON=B9
>   if (EXPR) { \
>       ^
>In file included from ./arch/x86/include/asm/bug.h:35:0,
>                 from include/linux/bug.h:4,
>                 from include/linux/thread_info.h:11,
>                 from ./arch/x86/include/asm/preempt.h:6,
>                 from include/linux/preempt.h:18,
>                 from include/linux/spinlock.h:50,
>                 from include/linux/wait.h:8,
>                 from include/linux/mempool.h:7,
>                 from drivers/scsi/snic/snic_scsi.c:18:
>drivers/scsi/snic/snic_scsi.c:610:21: warning: cast to pointer from
>integer of different size [-Wint-to-pointer-cast]
>  SNIC_BUG_ON(rqi !=3D (struct snic_req_info *)ctx);
>                     ^
>include/asm-generic/bug.h:111:27: note: in definition of macro
>=8CWARN_ON_ONCE=B9
>  int __ret_warn_once =3D !!(condition);   \
>                           ^
>drivers/scsi/snic/snic_scsi.c:610:2: note: in expansion of macro
>=8CSNIC_BUG_ON=B9
>  SNIC_BUG_ON(rqi !=3D (struct snic_req_info *)ctx);
>  ^
>drivers/scsi/snic/snic_scsi.c:624:8: warning: cast to pointer from
>integer of different size [-Wint-to-pointer-cast]
>  rqi =3D (struct snic_req_info *) ctx;
>        ^
>In file included from drivers/scsi/snic/snic.h:33:0,
>                 from drivers/scsi/snic/snic_scsi.c:34:
>drivers/scsi/snic/snic_trc.h:89:8: warning: cast from pointer to integ=
er
>of different size [-Wpointer-to-int-cast]
>        (u64)(d1),    \
>        ^
>drivers/scsi/snic/snic_scsi.c:650:3: note: in expansion of macro
>=8CSNIC_TRC=B9
>   SNIC_TRC(snic->shost->host_no, cmnd_id, sc,
>   ^
>drivers/scsi/snic/snic_trc.h:91:8: warning: cast from pointer to integ=
er
>of different size [-Wpointer-to-int-cast]
>        (u64)(d3),    \
>        ^
>drivers/scsi/snic/snic_scsi.c:650:3: note: in expansion of macro
>=8CSNIC_TRC=B9
>   SNIC_TRC(snic->shost->host_no, cmnd_id, sc,
>   ^
>drivers/scsi/snic/snic_scsi.c:678:42: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>  SNIC_TRC(snic->shost->host_no, cmnd_id, (u64)sc,
>                                          ^
>drivers/scsi/snic/snic_trc.h:89:14: note: in definition of macro
>=8CSNIC_TRC=B9
>        (u64)(d1),    \
>              ^
>drivers/scsi/snic/snic_scsi.c:679:44: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>    jiffies_to_msecs(jiffies - start_time), (u64)fwreq,
>                                            ^
>drivers/scsi/snic/snic_trc.h:91:14: note: in definition of macro
>=8CSNIC_TRC=B9
>        (u64)(d3),    \
>              ^
>drivers/scsi/snic/snic_scsi.c: In function =8Csnic_proc_dr_cmpl_locked=
=B9:
>drivers/scsi/snic/snic_trc.h:89:8: warning: cast from pointer to integ=
er
>of different size [-Wpointer-to-int-cast]
>        (u64)(d1),    \
>        ^
>drivers/scsi/snic/snic_scsi.c:707:3: note: in expansion of macro
>=8CSNIC_TRC=B9
>   SNIC_TRC(snic->shost->host_no, cmnd_id, sc,
>   ^
>drivers/scsi/snic/snic_trc.h:91:8: warning: cast from pointer to integ=
er
>of different size [-Wpointer-to-int-cast]
>        (u64)(d3),    \
>        ^
>drivers/scsi/snic/snic_scsi.c:707:3: note: in expansion of macro
>=8CSNIC_TRC=B9
>   SNIC_TRC(snic->shost->host_no, cmnd_id, sc,
>   ^
>drivers/scsi/snic/snic_trc.h:89:8: warning: cast from pointer to integ=
er
>of different size [-Wpointer-to-int-cast]
>        (u64)(d1),    \
>        ^
>drivers/scsi/snic/snic_scsi.c:722:3: note: in expansion of macro
>=8CSNIC_TRC=B9
>   SNIC_TRC(snic->shost->host_no, cmnd_id, sc,
>   ^
>drivers/scsi/snic/snic_trc.h:91:8: warning: cast from pointer to integ=
er
>of different size [-Wpointer-to-int-cast]
>        (u64)(d3),    \
>        ^
>drivers/scsi/snic/snic_scsi.c:722:3: note: in expansion of macro
>=8CSNIC_TRC=B9
>   SNIC_TRC(snic->shost->host_no, cmnd_id, sc,
>   ^
>drivers/scsi/snic/snic_scsi.c: In function =8Csnic_process_itmf_cmpl=B9=
:
>drivers/scsi/snic/snic_trc.h:89:8: warning: cast from pointer to integ=
er
>of different size [-Wpointer-to-int-cast]
>        (u64)(d1),    \
>        ^
>drivers/scsi/snic/snic_scsi.c:858:4: note: in expansion of macro
>=8CSNIC_TRC=B9
>    SNIC_TRC(snic->shost->host_no, cmnd_id, sc,
>    ^
>drivers/scsi/snic/snic_trc.h:91:8: warning: cast from pointer to integ=
er
>of different size [-Wpointer-to-int-cast]
>        (u64)(d3),    \
>        ^
>drivers/scsi/snic/snic_scsi.c:858:4: note: in expansion of macro
>=8CSNIC_TRC=B9
>    SNIC_TRC(snic->shost->host_no, cmnd_id, sc,
>    ^
>drivers/scsi/snic/snic_scsi.c: In function =8Csnic_itmf_cmpl_handler=B9=
:
>drivers/scsi/snic/snic_scsi.c:943:9: warning: cast to pointer from
>integer of different size [-Wint-to-pointer-cast]
>   rqi =3D (struct snic_req_info *) ctx;
>         ^
>drivers/scsi/snic/snic_scsi.c: In function
>=8Csnic_hba_reset_cmpl_handler=B9:
>drivers/scsi/snic/snic_scsi.c:1025:9: warning: cast to pointer from
>integer of different size [-Wint-to-pointer-cast]
>   rqi =3D (struct snic_req_info *) ctx;
>         ^
>In file included from drivers/scsi/snic/snic_scsi.c:33:0:
>drivers/scsi/snic/snic_scsi.c: In function =8Csnic_queue_itmf_req=B9:
>drivers/scsi/snic/snic_io.h:104:3: warning: cast to pointer from integ=
er
>of different size [-Wint-to-pointer-cast]
>  ((struct snic_req_info *) (((struct snic_host_req
>*)req)->hdr.init_ctx))
>   ^
>drivers/scsi/snic/snic_scsi.c:1302:30: note: in expansion of macro
>=8Creq_to_rqi=B9
>  struct snic_req_info *rqi =3D req_to_rqi(tmreq);
>                              ^
>drivers/scsi/snic/snic_scsi.c:1317:10: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>          (u64) rqi,
>          ^
>In file included from drivers/scsi/snic/snic.h:33:0,
>                 from drivers/scsi/snic/snic_scsi.c:34:
>drivers/scsi/snic/snic_scsi.c: In function =8Csnic_abort_cmd=B9:
>drivers/scsi/snic/snic_trc.h:89:8: warning: cast from pointer to integ=
er
>of different size [-Wpointer-to-int-cast]
>        (u64)(d1),    \
>        ^
>drivers/scsi/snic/snic_scsi.c:1642:2: note: in expansion of macro
>=8CSNIC_TRC=B9
>  SNIC_TRC(snic->shost->host_no, tag, sc,
>  ^
>drivers/scsi/snic/snic_scsi.c: In function
>=8Csnic_unlink_and_release_req=B9:
>drivers/scsi/snic/snic_trc.h:89:8: warning: cast from pointer to integ=
er
>of different size [-Wpointer-to-int-cast]
>        (u64)(d1),    \
>        ^
>drivers/scsi/snic/snic_scsi.c:2114:2: note: in expansion of macro
>=8CSNIC_TRC=B9
>  SNIC_TRC(snic->shost->host_no, snic_cmd_tag(sc), sc,
>  ^
>drivers/scsi/snic/snic_trc.h:91:8: warning: cast from pointer to integ=
er
>of different size [-Wpointer-to-int-cast]
>        (u64)(d3),    \
>        ^
>drivers/scsi/snic/snic_scsi.c:2114:2: note: in expansion of macro
>=8CSNIC_TRC=B9
>  SNIC_TRC(snic->shost->host_no, snic_cmd_tag(sc), sc,
>  ^
>drivers/scsi/snic/snic_scsi.c: In function =8Csnic_device_reset=B9:
>drivers/scsi/snic/snic_trc.h:89:8: warning: cast from pointer to integ=
er
>of different size [-Wpointer-to-int-cast]
>        (u64)(d1),    \
>        ^
>drivers/scsi/snic/snic_scsi.c:2187:2: note: in expansion of macro
>=8CSNIC_TRC=B9
>  SNIC_TRC(snic->shost->host_no, tag, sc,
>  ^
>drivers/scsi/snic/snic_scsi.c: In function =8Csnic_issue_hba_reset=B9:
>drivers/scsi/snic/snic_scsi.c:2245:25: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>    snic->config.hid, 0, (u64)rqi);
>                         ^
>In file included from drivers/scsi/snic/snic.h:33:0,
>                 from drivers/scsi/snic/snic_scsi.c:34:
>drivers/scsi/snic/snic_scsi.c: In function =8Csnic_host_reset=B9:
>drivers/scsi/snic/snic_trc.h:89:8: warning: cast from pointer to integ=
er
>of different size [-Wpointer-to-int-cast]
>        (u64)(d1),    \
>        ^
>drivers/scsi/snic/snic_scsi.c:2376:2: note: in expansion of macro
>=8CSNIC_TRC=B9
>  SNIC_TRC(shost->host_no, snic_cmd_tag(sc), sc,
>  ^
>drivers/scsi/snic/snic_scsi.c: In function =8Csnic_scsi_cleanup=B9:
>drivers/scsi/snic/snic_trc.h:89:8: warning: cast from pointer to integ=
er
>of different size [-Wpointer-to-int-cast]
>        (u64)(d1),    \
>        ^
>drivers/scsi/snic/snic_scsi.c:2477:4: note: in expansion of macro
>=8CSNIC_TRC=B9
>    SNIC_TRC(snic->shost->host_no, tag, sc,
>    ^
>drivers/scsi/snic/snic_disc.c: In function =8Csnic_report_tgt_init=B9:
>drivers/scsi/snic/snic_disc.c:73:28: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>  req->u.rpt_tgts.sg_addr =3D (u64) sgd;
>                            ^
>drivers/scsi/snic/snic_disc.c: In function =8Csnic_queue_report_tgt_re=
q=B9:
>drivers/scsi/snic/snic_disc.c:128:16: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>  rqi->sge_va =3D (u64) buf;
>                ^
>drivers/scsi/snic/snic_disc.c:135:9: warning: cast from pointer to
>integer of different size [-Wpointer-to-int-cast]
>         (u64)rqi);
>         ^
>drivers/scsi/snic/snic_disc.c: In function
>=8Csnic_report_tgt_cmpl_handler=B9:
>drivers/scsi/snic/snic_disc.c:405:8: warning: cast to pointer from
>integer of different size [-Wint-to-pointer-cast]
>  rqi =3D (struct snic_req_info *)ctx;
>        ^
>drivers/scsi/snic/snic_disc.c:406:10: warning: cast to pointer from
>integer of different size [-Wint-to-pointer-cast]
>  tgtid =3D (struct snic_tgt_id *) (rqi->sge_va);
>          ^
>scripts/Makefile.build:403: recipe for target 'drivers/scsi/snic' fail=
ed
>
>James
>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
