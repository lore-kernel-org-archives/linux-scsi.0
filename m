Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99906C433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 19:36:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73FEB20672
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 19:36:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="l6IKyZj0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730915AbgF2TgV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 15:36:21 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:64018 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729305AbgF2TgP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 15:36:15 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200629100821epoutp02828f6c040b45218819f6b19df8344622~c_96k_KXn2849428494epoutp02S
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2020 10:08:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200629100821epoutp02828f6c040b45218819f6b19df8344622~c_96k_KXn2849428494epoutp02S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593425301;
        bh=Bz1jgn5lFYz3ryUkUY+SYpUT1f1J5ojz590MFiI3hWk=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=l6IKyZj0+6z+CnzRnMhtF2BQ9she0SC1/WZmFIjTgTj7PfXemniuAOgBZv4jx33oV
         T6ne8/9bDT3zY7SYUJ0BvvnansFGoIXtq2krAW8hK5mghiv+CcPhfUF1lR4WVYsBHq
         A9DtGwDRGmSCljOxWrdgcc+EYpgQEKeKKeeb6euY=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20200629100821epcas2p178ed16b5030e9f05d40286cca58ffa30~c_96QZjud2803628036epcas2p1c
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2020 10:08:21 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.191]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 49wNVD1PWKzMqYkn for
        <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2020 10:08:20 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        4B.7D.18874.29DB9FE5; Mon, 29 Jun 2020 19:08:18 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20200629100818epcas2p30836dcec6f42a01d6d60342f2856bb27~c_93c3IM51068610686epcas2p3L
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2020 10:08:18 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200629100818epsmtrp28d871e84964e77675be7093a632c2c9e~c_93cVFov2565425654epsmtrp2f
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2020 10:08:18 +0000 (GMT)
X-AuditID: b6c32a46-503ff700000049ba-17-5ef9bd926cc9
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        BA.63.08303.29DB9FE5; Mon, 29 Jun 2020 19:08:18 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200629100818epsmtip2ff1ab8099d538087f1dd437306cd350b~c_93Vq65x0047100471epsmtip2Z
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2020 10:08:18 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     <linux-scsi@vger.kernel.org>
In-Reply-To: <6eaeed01-9c1b-1bf2-8375-568d24f079e3@acm.org>
Subject: RE: [RFC PATCH v1 2/2] exynos-ufs: support command history
Date:   Mon, 29 Jun 2020 19:08:18 +0900
Message-ID: <007101d64dfd$361ca580$a255f080$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJ/aiFPr5h6sgfcz1l8UT25RU07RwGHv1nhAhmw7q0ByhIEUKdxyX/w
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGKsWRmVeSWpSXmKPExsWy7bCmhe6kvT/jDBbdtbHovr6DzYHR4/Mm
        uQDGqBybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
        SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpdSClJwCQ8MCveLE3OLSvHS95PxcK0MDAyNT
        oMqEnIwJLS/ZC/5aVKxdP4G9gXGZXhcjJ4eEgInEq72/mLoYuTiEBHYwSpy618kK4Uxmkviy
        YS9UZgqTRM/zKUwwLR2v50IldjFKvL70hA3C6WSSaNx8nRmkik1AW2Law92sILaIgILE37ZD
        YHFOAWuJyxNOMoLYwgLOEnsnd7OB2CwCqhJfD29jB7F5BSwlNuy4wgJhC0qcnPkEzGYGmrls
        4WtmiCsUJH4+XQY1303i48lrTBA1IhKzO9uYQQ6SENjFLjG74yobRIOLxM7OpVC2sMSr41vY
        IWwpic/v9kLF6yX2TW1ghWjuYZR4uu8fI0TCWGLWs3YgmwNog6bE+l36IKaEgLLEkVtQt/FJ
        dBz+yw4R5pXoaBOCaFSW+DVpMtQQSYmZN+9AlXhIfN7HOoFRcRaSJ2cheXIWkmdmIaxdwMiy
        ilEstaA4Nz212KjACDmyNzGCE5yW2w7GKW8/6B1iZOJgPMQowcGsJML72fpbnBBvSmJlVWpR
        fnxRaU5q8SFGU2CwT2SWEk3OB6bYvJJ4Q1MjMzMDS1MLUzMjCyVx3nrFC3FCAumJJanZqakF
        qUUwfUwcnFINTI7BP+ZMyq1g6NdKX7/QdensZruLkx75ij98kPW1tZH/Sdttzrv/K/b8/7XZ
        tmlqz4RtT9g9f66d1BzRUPK88qXwvmfXYxq7XkaJsrRVuLXlS0umGNla+btWt3olvYthbmH/
        e/P1+nXa4nF18u/PBu81Tv216/gpptf78xzmhhn8uSDVYJl2VCTM7cbktxnq7LckvMsjzkpN
        Ueydu6hXsSAwkKm6lisr4FVC5AeWxJJKx5icytjr2yq2infVBh7f98BWxEIu5/6cXT5VwgsM
        uf8fubMo0mpK3XzThHLT3WdYGFPc9B6z66UZipgu2bBpE+s6U28Rp2V3VNdd9npY1LLzb+BL
        lhneKxq//eJUYinOSDTUYi4qTgQAUD8ybPkDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsWy7bCSvO6kvT/jDBYuk7bovr6DzYHR4/Mm
        uQDGKC6blNSczLLUIn27BK6MzfuvMRdMMK6YueAiewPjZPUuRk4OCQETiY7Xc5m6GLk4hAR2
        MEpMX3CUHSIhKXFi53NGCFtY4n7LEVaIonYmiamTbrOCJNgEtCWmPdwNZosIKEj8bTvEDFHU
        wCSxe9VdFpAEp4C1xOUJJ8EmCQs4S+yd3M0GYrMIqEp8PbwNbBuvgKXEhh1XWCBsQYmTM5+A
        2cxAC3oftjLC2MsWvmaGuEhB4ufTZVCL3SQ+nrzGBFEjIjG7s415AqPQLCSjZiEZNQvJqFlI
        WhYwsqxilEwtKM5Nzy02LDDKSy3XK07MLS7NS9dLzs/dxAgOai2tHYx7Vn3QO8TIxMF4iFGC
        g1lJhPez9bc4Id6UxMqq1KL8+KLSnNTiQ4zSHCxK4rxfZy2MExJITyxJzU5NLUgtgskycXBK
        NTAdb+C5OFOyut+ttqK6P4Mh0Ti3tpyhJl/ZaddxnoSjcpoV6tVGdrLbcj3fPzlye3HA5Ncq
        b3jmtGtINJ3PZH+0oeuaWdOKnn/ZcR4epdp7XbgS3j/a4c4j1vBf86CY7I7U3k33S/yq30Yd
        PKFlxXt/5UX7UAP3r/+z8xecW9z95sqz95Luxky1129fXMxbdfaJ7bSULkapnF2XbEVNW9K5
        BTN3pc5edCx6w7d7eseNzb8r/dk3X/O8vUrrzWsH+w7wLVjUeJ4vpOi3kEXp7+wdL1nMJM37
        7b9lhJ5p6VxmeXPB5vOLeQSnat56J33gjID/93dX0mY828SjM0ujZ7u3f/ien9Vr65JsMwTf
        8iuxFGckGmoxFxUnAgCDEwx/2QIAAA==
X-CMS-MailID: 20200629100818epcas2p30836dcec6f42a01d6d60342f2856bb27
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200620070047epcas2p37229d52d479df9f64ee4fc14f469acf9
References: <1592635992-35619-1-git-send-email-kwmad.kim@samsung.com>
        <CGME20200620070047epcas2p37229d52d479df9f64ee4fc14f469acf9@epcas2p3.samsung.com>
        <1592635992-35619-2-git-send-email-kwmad.kim@samsung.com>
        <6eaeed01-9c1b-1bf2-8375-568d24f079e3@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > +=23define EN_PRINT_UFS_LOG 1
>=20
> Since this macro controls debug code, please make this configurable at
> runtime, e.g. as a kernel module parameter or by using the dynamic debug
> mechanism.

Got it.

>=20
> > +/* Structure for ufs cmd logging */
> > +=23define MAX_CMD_LOGS    32
>=20
> Please clarify in the comment above this constant how this constant has
> been chosen. Is this constant e.g. related to the queue depth? Is this
> constant per UFS device or is it a maximum for all UFS devices?
>=20
> > +struct cmd_data =7B
> > +	unsigned int tag;
> > +	unsigned int sct;
> > +	unsigned long lba;
> > +	u64 start_time;
> > +	u64 end_time;
> > +	u64 outstanding_reqs;
> > +	int retries;
> > +	unsigned char op;
> > +=7D;
>=20
> Please use data types that explicitly specify the width for members like
> e.g. the lba (u64 instead of unsigned long). Please also use u8 instead o=
f
> unsigned char for 'op' since 'op' is not used to store any kind of ASCII
> character.

Got it.

>=20
> > +struct ufs_cmd_info =7B
> > +	u32 total;
> > +	u32 last;
> > +	struct cmd_data data=5BMAX_CMD_LOGS=5D;
> > +	struct cmd_data *pdata=5B32=5D;	/* Currently, 32 slots */
> > +=7D;
>=20
> What are 'slots'? Why 32?

I meant tag number and assumed that CAP.NUTRS be 32.
With 32, you can see all the command context with full outstanding situatio=
ns.
Of course, there is a possibility that the value increases in the next UFS =
versions.
So, to run automatically, yes, I should have made this get CAP.NUTRS.
However, to do that, I have to add another call after enabling host.

>=20
> > +=23define DBG_NUM_OF_HOSTS	1
> > +struct ufs_s_dbg_mgr =7B
> > +	struct ufs_exynos_handle *handle;
> > +	int active;
> > +	u64 first_time;
> > +	u64 time;
> > +
> > +	/* cmd log */
> > +	struct ufs_cmd_info cmd_info;
> > +	struct cmd_data cmd_log;		/* temp buffer to put */
> > +	spinlock_t cmd_lock;
> > +=7D;
>=20
> Please add a comment above this structure that explains the role of this
> data structure.

Got it.

>=20
> > +static struct ufs_s_dbg_mgr ufs_s_dbg=5BDBG_NUM_OF_HOSTS=5D;
>=20
> A static array? That's suspicious. Should that array perhaps be a member
> of another UFS data structure, e.g. the UFS host or device data structure=
?
>=20
> > +static int ufs_s_dbg_mgr_idx;

I considered it again and will remove.

>=20
> What does this variable represent?
>=20
> > +	for (i =3D 0 ; i < max ; i++, data++) =7B
> > +		dev_err(dev, =22: 0x%02x, %02d, 0x%08lx,
> 0x%04x, %d, %llu, %llu, 0x%llx %s=22,
> > +				data->op,
> > +				data->tag,
> > +				data->lba,
> > +				data->sct,
> > +				data->retries,
> > +				data->start_time,
> > +				data->end_time,
> > +				data->outstanding_reqs,
> > +				((last =3D=3D i) ? =22<--=22 : =22 =22));
>=20
> Please follow the same coding style as elsewhere in the Linux kernel and
> specify multiple arguments per line (up to the current column limit).
> Please also align the arguments either with the opening parentheses or
> indent these by one tab as requested in the Linux kernel coding style
> document.
>=20

Got it.

> > +/*
> > + * EXTERNAL FUNCTIONS
> > + *
> > + * There are two classes that are to initialize data structures for
> > +debug
> > + * and to define actual behavior.
> > + */
> > +void exynos_ufs_dump_info(struct ufs_exynos_handle *handle, struct
> > +device *dev) =7B
> > +	struct ufs_s_dbg_mgr *mgr =3D (struct ufs_s_dbg_mgr *)handle->private=
;
> > +
> > +	if (mgr->active =3D=3D 0)
> > +		goto out;
> > +
> > +	mgr->time =3D cpu_clock(raw_smp_processor_id());
> > +
> > +=23if EN_PRINT_UFS_LOG
> > +	ufs_s_print_cmd_log(mgr, dev);
> > +=23endif
> > +
> > +	if (mgr->first_time =3D=3D 0ULL)
> > +		mgr->first_time =3D mgr->time;
> > +out:
> > +	return;
> > +=7D
>=20
> Using cpu_clock() without storing the CPU on which it has been sampled
> seems wrong to me. Is higher accuracy than a single jiffy required? If no=
t,
> how about using 'jiffies' instead? From clock.h:

I think jiffies isn't proper for the original purpose.

>=20
> /*
>  * As outlined in clock.c, provides a fast, high resolution, nanosecond
>  * time source that is monotonic per cpu argument and has bounded drift
>  * between cpus.
>  *
>  * =23=23=23=23=23=23=23=23=23=23=23=23=23=23=23=23=23=23=23=23=23=23=23=
=23=23 BIG FAT WARNING =23=23=23=23=23=23=23=23=23=23=23=23=23=23=23=23=23=
=23=23=23=23=23=23=23=23=23
>  * =23 when comparing cpu_clock(i) to cpu_clock(j) for i =21=3D j, time c=
an =23
>  * =23 go backwards =21=21                                               =
   =23
>  * =23=23=23=23=23=23=23=23=23=23=23=23=23=23=23=23=23=23=23=23=23=23=23=
=23=23=23=23=23=23=23=23=23=23=23=23=23=23=23=23=23=23=23=23=23=23=23=23=23=
=23=23=23=23=23=23=23=23=23=23=23=23=23=23=23=23=23=23=23=23
>  */
>=20
> > +void exynos_ufs_cmd_log_start(struct ufs_exynos_handle *handle,
> > +			      struct ufs_hba *hba, struct scsi_cmnd *cmd) =7B
> > +	struct ufs_s_dbg_mgr *mgr =3D (struct ufs_s_dbg_mgr *)handle->private=
;
> > +	int cpu =3D raw_smp_processor_id();
> > +	struct cmd_data *cmd_log =3D &mgr->cmd_log;	/* temp buffer to put
> */
> > +	unsigned long lba =3D (cmd->cmnd=5B2=5D << 24) =7C
> > +					(cmd->cmnd=5B3=5D << 16) =7C
> > +					(cmd->cmnd=5B4=5D << 8) =7C
> > +					(cmd->cmnd=5B5=5D << 0);
> > +	unsigned int sct =3D (cmd->cmnd=5B7=5D << 8) =7C
> > +					(cmd->cmnd=5B8=5D << 0);
>=20
> Aargh=21 SCSI command parsing ... Has it been considered to use
> blk_rq_pos(cmd->req) and blk_rq_bytes(cmd->req) instead?

Sure and I have recognized those things for years.
UFS depends on SCSI and regarding to actual usages.
Thus, I don't feel that sort of parsing unless there is another macro to pa=
rse SCSI commands.
As I know, nothing exits.
And blk_rq_pos doesn't represent actual lba. That represents in-partition a=
ddressing.
With this, I have to refer to the start address of partitions and I don=E2=
=80=99t=20think=20that=20isn't=20suitable=20in=20UFS=20driver.=0D=0A=0D=0A>=
=20=0D=0A>=20>=20+int=20exynos_ufs_init_dbg(struct=20ufs_exynos_handle=20*h=
andle)=20=7B=0D=0A>=20>=20+=09struct=20ufs_s_dbg_mgr=20*mgr;=0D=0A>=20>=20+=
=0D=0A>=20>=20+=09if=20(ufs_s_dbg_mgr_idx=20>=3D=20DBG_NUM_OF_HOSTS)=0D=0A>=
=20>=20+=09=09return=20-1;=0D=0A>=20>=20+=0D=0A>=20>=20+=09mgr=20=3D=20&ufs=
_s_dbg=5Bufs_s_dbg_mgr_idx++=5D;=0D=0A>=20>=20+=09handle->private=20=3D=20(=
void=20*)mgr;=0D=0A>=20>=20+=09mgr->handle=20=3D=20handle;=0D=0A>=20>=20+=
=09mgr->active=20=3D=201;=0D=0A>=20=0D=0A>=20Can=20the=20'(void=20*)'=20cas=
t=20above=20be=20left=20out?=0D=0A=0D=0AI=20didn't=20want=20to=20share=20th=
e=20details=20of=20this=20structure=20with=20ufs-exynos.c.=0D=0AI=20don=E2=
=80=99t=20feel=20that=20it's=20better.=0D=0A=0D=0A>=20=0D=0A>=20>=20+=23def=
ine=20UFS_VS_MMIO_VER=201=0D=0A>=20=0D=0A>=20What=20does=20this=20constant=
=20represent?=20Please=20add=20a=20comment.=0D=0A=0D=0AI=20considered=20it=
=20again=20and=20will=20remove.=0D=0A=0D=0A>=20=0D=0A>=20Thanks,=0D=0A>=20=
=0D=0A>=20Bart.=0D=0A=0D=0AThank=20you=20for=20your=20comments=20even=20if=
=20this=20is=20a=20RFS=20patch.=0D=0A=0D=0A=0D=0AThanks.=0D=0AKiwoong=20Kim=
=0D=0A=0D=0A
