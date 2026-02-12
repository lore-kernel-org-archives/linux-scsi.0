Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E751E314D2B
	for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 10:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770893668; cv=none; b=IF6cmMNuaeh2sCCBb65NaAtHNrQKudZzmYejGiKhUFDGAaWxcGI2gIrLamfpyuwbKRI2pZXtrQU8dhXLEvS4EAqXLryJfcP/fcWkeiXRmULCN9+4vWMjkn96bKRegCfCe8OkTuiWtokR8RK0f9o1siUvvABIy1PoNP+Qjup+0DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770893668; c=relaxed/simple;
	bh=0ixpePWMRsXhF8eRZ3uIv07tiBeZt7WqBjNN7+fJpTo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 References; b=smDglvj26+RYwlJ4IlENOjnKip/9Wjt15H4SA9A+yOltN66v8WhzxRz3MVRmRJz/IzNsCFqb3UPrnvFJXDbB2owvHUUTweQbRC+B03LsgrpTOsoPLhjK4pKsqZjn115Fb2tlbFOx6iuHzYt82u6To1zkZH8HHrVWs0VZ8ZI64xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=g6v39hvv; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="g6v39hvv"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260212105424epoutp018269002eeff212695807850ada6584a4~TemfHBV1E2167221672epoutp01P
	for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 10:54:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260212105424epoutp018269002eeff212695807850ada6584a4~TemfHBV1E2167221672epoutp01P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1770893664;
	bh=lqWF8pN10NTRhmpYYQOYzsKH6BVjm63zoRQ632tFCrQ=;
	h=From:To:Cc:Subject:Date:References:From;
	b=g6v39hvvZZXVLiI/10cV4KMpYtCg4ni4kTksD2QZSP3sVrpAvkcH39g6gZpHBhUwz
	 KQhwQEZ5o2h1hfF8wOgkrOqYy19y7PBu4OjsxXip0cD4ZJyHBrb3TF6xtSBCM6s87C
	 wrGflC+LlrjD/uA+6VSAXU32w+NR+5Pn7r/M1Wws=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPS id
	20260212105423epcas2p19e7a28b4797bbf3440c5940921b62ae0~Temehgrf42282222822epcas2p1x;
	Thu, 12 Feb 2026 10:54:23 +0000 (GMT)
Received: from epcas2p2.samsung.com (unknown [182.195.38.211]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4fBXHM4lk4z6B9mF; Thu, 12 Feb
	2026 10:54:23 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
	20260212105422epcas2p44c875c9f8d57d1b4f6d231b9aef833c9~Temde-NDZ3129231292epcas2p4j;
	Thu, 12 Feb 2026 10:54:22 +0000 (GMT)
Received: from KORCO118546 (unknown [12.80.207.184]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20260212105422epsmtip25c0da83bc2b5d085017ddb304c2e5174~TemdYKFu62303423034epsmtip2I;
	Thu, 12 Feb 2026 10:54:22 +0000 (GMT)
From: "hoyoung seo" <hy50.seo@samsung.com>
To: <bvanassche@acm.org>
Cc: <Arthur.Simchaev@wdc.com>, <JBottomley@Parallels.com>,
	<adrian.hunter@intel.com>, <athierry@redhat.com>, <avri.altman@wdc.com>,
	<beanhuo@micron.com>, <cpgs@samsung.com>, <hy50.seo@samsung.com>,
	<jaegeuk@kernel.org>, <jejb@linux.ibm.com>, <kwangwon.min@samsung.com>,
	<kwmad.kim@samsung.com>, <linux-scsi@vger.kernel.org>,
	<martin.petersen@oracle.com>, <santoshsy@gmail.com>, <h10.kim@samsung.com>,
	<cmllamas@google.com>
Subject: Re: [PATCH v3 2/4] scsi: ufs: Fix handling of lrbp->cmd
Date: Thu, 12 Feb 2026 19:54:22 +0900
Message-ID: <000101dc9c0d$f231f360$d695da20$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AdycDXjyRsYos9zaTPGrqpNqnLbseA==
Content-Language: ko
X-CMS-MailID: 20260212105422epcas2p44c875c9f8d57d1b4f6d231b9aef833c9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260212105422epcas2p44c875c9f8d57d1b4f6d231b9aef833c9
References: <CGME20260212105422epcas2p44c875c9f8d57d1b4f6d231b9aef833c9@epcas2p4.samsung.com>

>On 6/26/23 18:26, hoyoung seo wrote:
>> =40=40 -5408,7 +5406,6 =40=40 static void ufshcd_release_scsi_cmd(struct=
 ufs_hba *hba,
>>   	struct scsi_cmnd *cmd =3D lrbp->cmd;
>>  =20
>>   	scsi_dma_unmap(cmd);
>> -	lrbp->cmd =3D NULL;	/* Mark the command as completed. */
>>   	ufshcd_release(hba);
>>   	ufshcd_clk_scaling_update_busy(hba);
>>   =7D
>>=20
>> Hi,
>> Is there any reason to delete =22lrbp->cmd =3D NULL=22?
>> As far as I know, clear to NULL to indicate that cmd is completed.
>>=20
>> When the UFS MCQ mode is activated, check that lrbp->cmd is NULL to chec=
k the completion of the command.
>> https://lore.kernel.org/linux-scsi/f0d923ee1f009f171a55c258d044e814ec091=
7ab.1685396241.git.quic_nguyenb=40quicinc.com/
>>=20
>> If there is no special reason, why don't you add =22lrb->cmd =3D NULL=22=
 again?
>
>The lrbp->cmd =3D NULL assignment has been removed because if it would be =
kept
>the SCSI error handler would crash if it reuses a SCSI command. See also t=
he
>scsi_eh_prep_cmnd() and scsi_eh_restore_cmnd() callers. The MCQ code shoul=
d
>still work because it uses blk_mq_request_started() to check whether or no=
t
>a request is still active.
>
>Bart.


Hi, Bart

The problem I asked before was caused by an KASAN error.
I try to work based on kernel-6.18.
When I stability checked, occurred a KASAN error related to UFS was detecte=
d.
In below log, UFS driver accessed bad address during operate pending reques=
t.
It seems that a problem occurred when accessing the already de-allocated cm=
d memory.
The cmd memory will de-allocated after IO cmd complete, but lrbp->cmd conti=
nues=20
to have the address of the released memory.
So occurred below KASAN error.
In fact, the tag at the time of allocation to send cmd is 09, but the tag=
=20
in memory is 90 now.
This means that the memory is released once and then re-allocated by anothe=
r process.

The situation you mentioned seems to be that the scsi layer uses cmd=20
in the error recovery situation, so it should not be made null.
However, in normal situations, scsi_eh_prep_cmnd() and scsi_eh_restore_cmnd=
()=20
of the scsi layer do not seem to reuse cmd.
And now the cmd is processed normally and there is a KASAN error while=20
checking if there is a pending cmd during UFS re linkup.

I wanted to modify the mainline, but lrbp->cmd was deleted in kernel-6.20.
I have to use kernel-6.18, what should I do in this case?
Please give us your opinion.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

BUG: KASAN: invalid-access in ufshcd_mcq_compl_pending_transfer+0x10c/0x21c
Read of size 4 at addr 09ffff881b0a2708 by task kworker/u40:22/3402
Pointer tag: =5B09=5D, memory tag: =5B90=5D

CPU: 5 UID: 0 PID: 3402 Comm: kworker/u40:22 Tainted: G           OE       =
6.18.1
Workqueue: async async_run_entry_fn
Call trace:
 show_stack+0x18/0x28 (C)
 __dump_stack+0x28/0x3c
 dump_stack_lvl+0x7c/0xa8
 print_address_description+0x7c/0x20c
 print_report+0x70/0x8c
 kasan_report+0xb4/0x114
 __hwasan_load4_noabort+0x88/0x98
 ufshcd_mcq_compl_pending_transfer+0x10c/0x21c
 ufshcd_host_reset_and_restore+0x26c/0x2c4
 ufshcd_reset_and_restore+0xcc/0x554
 __ufshcd_wl_resume+0x100/0x510
 ufshcd_wl_resume+0x70/0x284
 scsi_bus_resume+0x70/0xb4
 dpm_run_callback+0xa0/0x358
 device_resume+0x2b8/0x3b4
 async_resume+0x24/0x3c
 async_run_entry_fn+0x68/0x210
 process_one_work+0x3fc/0x954
 worker_thread+0x3e4/0x5b0
 kthread+0x388/0x3f0
 ret_from_fork+0x10/0x20

The buggy address belongs to the object at ffffff881b0a2600
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 264 bytes inside of
 416-byte region =5Bffffff881b0a2600, ffffff881b0a27a0)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x89b0a0
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
memcg:e4ffff881b0a4a01
flags: 0x4000000000000040(head=7Czone=3D1=7Ckasantag=3D0x0)
page_type: f5(slab)
raw: 4000000000000040 06ffff8800008ac0 fffffffee15a3810 fffffffee83bd810
raw: 0000000000000000 0000000000150015 00000000f5000000 e4ffff881b0a4a01
head: 4000000000000040 06ffff8800008ac0 fffffffee15a3810 fffffffee83bd810
head: 0000000000000000 0000000000150015 00000000f5000000 e4ffff881b0a4a01
head: 4000000000000003 fffffffee06c2801 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffffff881b0a2500: fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
 ffffff881b0a2600: 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90
>ffffff881b0a2700: 90 90 90 90 90 90 90 90 90 90 fe fe fe fe fe fe

                   =5E
 ffffff881b0a2800: fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
 ffffff881b0a2900: fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Kernel panic - not syncing: KASAN: panic_on_warn set ...

Thanks
SEO

