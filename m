Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C251C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 19:29:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F7C92067D
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 19:29:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="DhR4YqwV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729774AbgF2T3K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 15:29:10 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:17495 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728802AbgF2T2j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 15:28:39 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200629084907epoutp032b652c44fca85e32344a444a6e42daa1~c94uffBlu2057120571epoutp03R
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2020 08:49:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200629084907epoutp032b652c44fca85e32344a444a6e42daa1~c94uffBlu2057120571epoutp03R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593420547;
        bh=xGVBQ/nFX/cdlH/spXsnzoexKPYHISawQkGvAlN7KTw=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=DhR4YqwVVn84UA+0+SErMMrHw+DaIiprRJvLjHQJUNEC8M5LJroLdvQ7wD5Jo44YM
         pEdwdP995aJguxantXfUyV5cUNCGqdrtbxqjgMMrQP9rNcxDQwF0RAd/4pjLpKbnQT
         K23pu1clSxdTQOg8197k4nsYn0wVo+baA90aAyeM=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20200629084906epcas2p49e8ddf4d3e5722fe676f9e9127cc1241~c94uAeIBi2112521125epcas2p4I;
        Mon, 29 Jun 2020 08:49:06 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.183]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 49wLkn2Ss0zMqYks; Mon, 29 Jun
        2020 08:49:05 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        6F.7D.18874.FFAA9FE5; Mon, 29 Jun 2020 17:49:03 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20200629084903epcas2p23fb407e0ce458118376143153b0a076a~c94qre2eq0538305383epcas2p2u;
        Mon, 29 Jun 2020 08:49:03 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200629084903epsmtrp2d7e2e1c09797fee43cd0528543962770~c94qqlFR91496214962epsmtrp2s;
        Mon, 29 Jun 2020 08:49:03 +0000 (GMT)
X-AuditID: b6c32a46-519ff700000049ba-11-5ef9aaffb167
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        8C.89.08303.EFAA9FE5; Mon, 29 Jun 2020 17:49:02 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20200629084902epsmtip1ca258fc926dd4b1295944f1d1c3575de~c94qbtWv72030420304epsmtip1A;
        Mon, 29 Jun 2020 08:49:02 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Bart Van Assche'" <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <avri.altman@wdc.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <beanhuo@micron.com>,
        <asutoshd@codeaurora.org>, <cang@codeaurora.org>
In-Reply-To: <6eaeed01-9c1b-1bf2-8375-568d24f079e3@acm.org>
Subject: RE: [RFC PATCH v1 2/2] exynos-ufs: support command history
Date:   Mon, 29 Jun 2020 17:49:02 +0900
Message-ID: <006001d64df2$23a2e230$6ae8a690$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJ/aiFPr5h6sgfcz1l8UT25RU07RwGHv1nhAhmw7q0ByhIEUKdxroDQ
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAJsWRmVeSWpSXmKPExsWy7bCmue7/VT/jDM5eU7d4MG8bm8XethPs
        Fi9/XmWzOPiwk8Vi2oefzBaf1i9jtVh0YxuTRff1HWwWy4//Y3Lg9Lh8xdvjcl8vk8eERQcY
        Pb6v72Dz+Pj0FotH35ZVjB6fN8l5tB/oZgrgiMqxyUhNTEktUkjNS85PycxLt1XyDo53jjc1
        MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAE6T0mhLDGnFCgUkFhcrKRvZ1OUX1qSqpCRX1xiq5Ra
        kJJTYGhYoFecmFtcmpeul5yfa2VoYGBkClSZkJMx6dk19oJtlhUHji9ib2C8ptfFyMkhIWAi
        8fbKapYuRi4OIYEdjBIbrz5iA0kICXxilFj1TwYi8ZlR4ufOQ4wwHXfPv2GFSOxilHj1/hcz
        hPOCUeLY9L1g7WwC2hLTHu4GqxIR+Mco8fDYH7AEp4C1xOUJJ8FGCQs4S+yd3A0WZxFQldg/
        +zoziM0rYClxZf51NghbUOLkzCcsIDYz0NBlC18zQ5yhIPHz6TJWEFtEwE2idV8nK0SNiMTs
        zjawiyQEVnJITNy+lhWiwUXi5Zd2dghbWOLV8S1QtpTE53cQV0sI1Evsm9rACtHcwyjxdN8/
        qKeNJWY9aweyOYA2aEqs36UPYkoIKEscuQV1G59Ex+G/7BBhXomONiGIRmWJX5MmQw2RlJh5
        8w5UiYfE532sExgVZyF5chaSJ2cheWYWwtoFjCyrGMVSC4pz01OLjQqMkCN7EyM46Wq57WCc
        8vaD3iFGJg7GQ4wSHMxKIryfrb/FCfGmJFZWpRblxxeV5qQWH2I0BQb7RGYp0eR8YNrPK4k3
        NDUyMzOwNLUwNTOyUBLnrVe8ECckkJ5YkpqdmlqQWgTTx8TBKdXAtIOXm8u72Yg3drpNtFNx
        8Pk6kckHgjXWXJUvFbaf6rap8lyJwz4tJePjiRWq5dypl0tP59+L+X/Xq2rVgz1B01165jpc
        6eD+t+e80v1F853aVqq5aZ/5+fHrg/RlWccX535jb5f0kLPn+aZgZPWljHfz4X2rvx5rbbtQ
        ZPDrkNFXWRfBw2uWps3W+pGcvDSz43DC10LrhMpNEb8tJ5dpyFxn/Dzr1q/8P4ufGvb377m5
        5eIFlb93mffH5LlWe2bWfuj+aPwmfIH3lYWCJxI0Xp/75cWTf2Ol/YzZj41+yPe92csqWX01
        dJJz7NdFWv3FJ5VFZV9q8J5LarLI2OjWFnHdzTCOKV2p+8/yZJ/NSizFGYmGWsxFxYkAPUMO
        9UMEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsWy7bCSnO6/VT/jDKZPtbF4MG8bm8XethPs
        Fi9/XmWzOPiwk8Vi2oefzBaf1i9jtVh0YxuTRff1HWwWy4//Y3Lg9Lh8xdvjcl8vk8eERQcY
        Pb6v72Dz+Pj0FotH35ZVjB6fN8l5tB/oZgrgiOKySUnNySxLLdK3S+DKePTrNXPBQeOKhxsW
        MDUwblfvYuTkkBAwkbh7/g0riC0ksINR4ugsCYi4pMSJnc8ZIWxhifstR4BquIBqnjFKXGqd
        AJZgE9CWmPZwN1hCRKCDSeJVx0Y2iKoGJondq+6ygFRxClhLXJ5wEqxDWMBZYu/kbjYQm0VA
        VWL/7OvMIDavgKXElfnX2SBsQYmTM5+A9TIDbeh92MoIYy9b+JoZ4iQFiZ9Pl4GdLSLgJtG6
        r5MVokZEYnZnG/MERqFZSEbNQjJqFpJRs5C0LGBkWcUomVpQnJueW2xYYJSXWq5XnJhbXJqX
        rpecn7uJERxpWlo7GPes+qB3iJGJg/EQowQHs5II72frb3FCvCmJlVWpRfnxRaU5qcWHGKU5
        WJTEeb/OWhgnJJCeWJKanZpakFoEk2Xi4JRqYJpSutL2d9Ucjoe2LRfOOX+xWCm0+Nu7GQde
        xgSrzcp/N8f40rLz9vOm1qlFfz0rkr0nfGV12zftkJhzr77y2J9796/4Ql2qQp9cQDXbg0Ad
        xecG11XV3vye52aYWDezf6/Hd4vY9Hb+yWzv81Kd7lyP+7Zs4eR/y7e63ty07+3u4ym89uY5
        ss/Dvf+fWt7qNM0rZ1rtnU+b/lqqBh8q3iIbMz/HjTO98vBet3mej0pS535qbBC/E7JVI6GE
        d/MDTes4Gd7CfIZwmcuPzdU1N/tpHpiatYw5fuoGtmUs8z4sCe56OrFyWedPbg5f0zj17TPD
        mU9X7tuTGpw4fdH1yoe3+8Taub+ZpKzuWKKm6qXEUpyRaKjFXFScCACbMtrYIwMAAA==
X-CMS-MailID: 20200629084903epcas2p23fb407e0ce458118376143153b0a076a
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
>=20
> > +/* Structure for ufs cmd logging */
> > +=23define MAX_CMD_LOGS    32

Got it.

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
> e.g. the lba (u64 instead of unsigned long). Please also use u8 instead
> of unsigned char for '
op' since 'op' is not used to store any kind of
> ASCII character.=20

Got it.

>=20
> > +struct ufs_cmd_info =7B
> > +	u32 total;
> > +	u32 last;
> > +	struct cmd_data data=5BMAX_CMD_LOGS=5D;
> > +	struct cmd_data *pdata=5B32=5D;	/* Currently, 32 slots */
> > +=7D;
>=20
> What are 'slots'? Why 32?=20

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
> data structure.=20

Got it.

>=20
> > +static struct ufs_s_dbg_mgr ufs_s_dbg=5BDBG_NUM_OF_HOSTS=5D;
>=20
> A static array? That's suspicious. Should that array perhaps be a member
> of another UFS data structure, e.g. the UFS host or device data structure=
?=20

Got it.

>=20
> > +static int ufs_s_dbg_mgr_idx;
>=20
> What does this variable represent?=20

I considered it again and will remove.

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
> document.=20

Got it.

>=20
> > +/*
> > + * EXTERNAL FUNCTIONS
> > + *
> > + * There are two classes that are to initialize data structures for
> debug
> > + * and to define actual behavior.
> > + */
> > +void exynos_ufs_dump_info(struct ufs_exynos_handle *handle, struct
> device *dev)
> > +=7B
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
> seems wrong to me. Is higher accuracy than a single jiffy required? If
> not, how about using 'jiffies' instead? From clock.h:
>=20

I think jiffies isn't proper for the original purpose.

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
> > +			      struct ufs_hba *hba, struct scsi_cmnd *cmd)
> > +=7B
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
=80=99t=20think=0D=0Athat=20isn't=20suitable=20in=20UFS=20driver.=0D=0A=0D=
=0A>=20=0D=0A>=20>=20+int=20exynos_ufs_init_dbg(struct=20ufs_exynos_handle=
=20*handle)=0D=0A>=20>=20+=7B=0D=0A>=20>=20+=09struct=20ufs_s_dbg_mgr=20*mg=
r;=0D=0A>=20>=20+=0D=0A>=20>=20+=09if=20(ufs_s_dbg_mgr_idx=20>=3D=20DBG_NUM=
_OF_HOSTS)=0D=0A>=20>=20+=09=09return=20-1;=0D=0A>=20>=20+=0D=0A>=20>=20+=
=09mgr=20=3D=20&ufs_s_dbg=5Bufs_s_dbg_mgr_idx++=5D;=0D=0A>=20>=20+=09handle=
->private=20=3D=20(void=20*)mgr;=0D=0A>=20>=20+=09mgr->handle=20=3D=20handl=
e;=0D=0A>=20>=20+=09mgr->active=20=3D=201;=0D=0A>=20=0D=0A>=20Can=20the=20'=
(void=20*)'=20cast=20above=20be=20left=20out?=20=0D=0A=0D=0AI=20didn't=20wa=
nt=20to=20share=20the=20details=20of=20this=20structure=20with=20ufs-exynos=
.c.=0D=0AI=20don=E2=80=99t=20feel=20that=20it's=20better.=0D=0A=0D=0A>=20=
=0D=0A>=20>=20+=23define=20UFS_VS_MMIO_VER=201=0D=0A>=20=0D=0A>=20What=20do=
es=20this=20constant=20represent?=20Please=20add=20a=20comment.=20=0D=0A=0D=
=0AI=20considered=20it=20again=20and=20will=20remove.=0D=0A=0D=0A>=20=0D=0A=
>=20Thanks,=0D=0A>=20=0D=0A>=20Bart.=20=0D=0A=0D=0AThank=20you=20for=20your=
=20comments=20even=20if=20this=20is=20a=20RFS=20patch.=0D=0A=0D=0A=0D=0ATha=
nks.=0D=0AKiwoong=20Kim=0D=0A=0D=0A
