Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B43322612;
	Thu, 19 Sep 2024 18:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726771800; cv=none; b=dt513mVABw9la3xKs52PBkU8tJDv8bxXkvqe2QiAyPmas36QcvhJF2uJgaSLADSf5ShX8gr9pDRCRGAa9WWE0IWF/g2feRtjdqevwSeS+sTnHe7H1o90N0VZCgr2RXIA4ycqh/JEpV+7VY+Yawgd7VNi3+KC99O6o34UBWPmee0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726771800; c=relaxed/simple;
	bh=/TylInyXpNzv6ZDnzDfgqa5QAFwKPnJ+r/MBb/q+ll4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pAyiffJ4uU5Nz+71sQA5UFT2PHMXCD4ysEh8n6PRVfIsfBwHgiHOCPoSm3d7SC+YRazNRFJBaXVQGYhcD5M2qStMXDKQ88OeZByjCcQPf4U8I3zwCuAYFYIO9jpjtMRBuEY/fDi2DZWoL1CSChcjY3H+deZCTj8Z5sOQW74+G1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=hmfFxqyK; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="hmfFxqyK"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4X8l1r4CGBzlgMVg;
	Thu, 19 Sep 2024 18:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1726771778; x=1729363779; bh=W4NpPLc14tJ/Fx1/86QfUQVW
	/u1BXw8j2afYzA93uxk=; b=hmfFxqyKHDBG8IlPa8uJvSA1zi5bkTIB6X/FnLIw
	jblAt5xmpnmiJE8IvgigjJ5bXJlUH0/SFqDmyxT9Nr5oMbQg46tOP/5iy9LQBPef
	kzdP0aqnadp9R+hECPuOL5nNaxM2RmAX5gD7vMXgEeKqFTbL+tfMs3quXpnVFmmM
	0ueWAuOod6QbVMpZGyg3iiUjUxECqn2PwD2u2gbqzA/JFq4sQtC1UiCr+eoqn7Pz
	ix8bDu9+FCWx1L918OxujiKJBtHkuW21wj7gKAcqu7BNbvaHxNfbX28tSUud/T8c
	dpOXzMAaIi1H7VEgj82gAi4hi9t7EFOgxeomTDbxD0DnWQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id U8-ZFBmmmX41; Thu, 19 Sep 2024 18:49:38 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4X8l1X2YGnzlgMVY;
	Thu, 19 Sep 2024 18:49:36 +0000 (UTC)
Message-ID: <beeec868-b4ac-4025-859b-35a828cd2f8e@acm.org>
Date: Thu, 19 Sep 2024 11:49:35 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] ufs: core: requeue aborted request
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-mediatek@lists.infradead.org"
 <linux-mediatek@lists.infradead.org>,
 =?UTF-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
 =?UTF-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
 =?UTF-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
 =?UTF-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
 wsd_upstream <wsd_upstream@mediatek.com>,
 =?UTF-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 =?UTF-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
 =?UTF-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>,
 =?UTF-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
 =?UTF-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
 <Chaotian.Jing@mediatek.com>, =?UTF-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
 <Powen.Kao@mediatek.com>, =?UTF-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
 <Naomi.Chu@mediatek.com>, =?UTF-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
 <Qilin.Tan@mediatek.com>
References: <20240910073035.25974-1-peter.wang@mediatek.com>
 <20240910073035.25974-3-peter.wang@mediatek.com>
 <e42abf07-ba6b-4301-8717-8d5b01d56640@acm.org>
 <04e392c00986ac798e881dcd347ff5045cf61708.camel@mediatek.com>
 <858c4b6b-fcbc-4d51-8641-051aeda387c5@acm.org>
 <524e9da9196cc0acf497ff87eba3a8043b780332.camel@mediatek.com>
 <6203d7c9-b33c-4bf1-aca3-5fc8ba5636b9@acm.org>
 <6fc025d7ffb9d702a117381fb5da318b40a24246.camel@mediatek.com>
 <46d8be04-10db-4de1-8a59-6cd402bcecb1@acm.org>
 <61a1678cad16dcb15f1e215ff1c47476666f0ee8.camel@mediatek.com>
 <78c7fc74-81c2-40e4-b050-1d65dec96d0a@acm.org>
 <f350a1dee5a03347b5e88b9d7249223ce7b72c08.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <f350a1dee5a03347b5e88b9d7249223ce7b72c08.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/19/24 5:16 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> The four case flows for abort are as follows:
> ----------------------------------------------------------------
>=20
> Case1: DBR ufshcd_abort

Please follow the terminology from the UFSHCI 4.0 standard and use the
word "legacy" instead of "DBR".

> In this case, you can see that ufshcd_release_scsi_cmd will
> definitely be called.
>=20
> ufshcd_abort()
>    ufshcd_try_to_abort_task()		// It should trigger an
> interrupt, but the tensor might not
>    get outstanding_lock
>    clear outstanding_reqs tag
>    ufshcd_release_scsi_cmd()
>    release outstanding_lock
>=20
> ufshcd_intr()
>    ufshcd_sl_intr()
>      ufshcd_transfer_req_compl()
>        ufshcd_poll()
>          get outstanding_lock
>          clear outstanding_reqs tag
>          release outstanding_lock		=09
>          __ufshcd_transfer_req_compl()
>            ufshcd_compl_one_cqe()
>            cmd->result =3D DID_REQUEUE	// mediatek may need quirk
> change DID_ABORT to DID_REQUEUE
>            ufshcd_release_scsi_cmd()
>            scsi_done();
>=20
> In most cases, ufshcd_intr will not reach scsi_done because the
> outstanding_reqs tag is cleared by the original thread.
> Therefore, whether there is an interrupt or not doesn't affect
> the result because the ISR will do nothing in most cases.
>=20
> In a very low chance, the ISR will reach scsi_done and notify
> SCSI to requeue, and the original thread will not
> call ufshcd_release_scsi_cmd.
> MediaTek may need to change DID_ABORT to DID_REQUEUE in this
> situation, or perhaps not handle this ISR at all.

Please modify ufshcd_compl_one_cqe() such that it ignores commands
with status OCS_ABORTED. This will make the UFSHCI driver behave in
the same way for all UFSHCI controllers, whether or not clearing a
command triggers a completion interrupt.

> ----------------------------------------------------------------
>=20
> Case2: MCQ ufshcd_abort
>=20
> In the case of MCQ ufshcd_abort, you can also see that
> ufshcd_release_scsi_cmd will definitely be called too.
> However, there seems to be a problem here, as
> ufshcd_release_scsi_cmd might be called twice.
> This is because cmd is not null in ufshcd_release_scsi_cmd,
> which the previous version would set cmd to null.
> Skipping OCS: ABORTED in ufshcd_compl_one_cqe indeed
> can avoid this problem. This part needs further
> consideration on how to handle it.
>=20
> ufshcd_abort()
>    ufshcd_mcq_abort()
>      ufshcd_try_to_abort_task()	// will trigger ISR
>      ufshcd_release_scsi_cmd()
>=20
> ufs_mtk_mcq_intr()
>    ufshcd_mcq_poll_cqe_lock()
>      ufshcd_mcq_process_cqe()
>        ufshcd_compl_one_cqe()
>          cmd->result =3D DID_ABORT
>          ufshcd_release_scsi_cmd() // will release twice
>          scsi_done()

Do you agree that this case can be addressed with the
ufshcd_compl_one_cqe() change proposed above?

> ----------------------------------------------------------------
>=20
> Case3: DBR ufshcd_err_handler
>=20
> In the case of the DBR mode error handler, it's the same;
> ufshcd_release_scsi_cmd will also be executed, and scsi_done
> will definitely be used to notify SCSI to requeue.
>=20
> ufshcd_err_handler()
>    ufshcd_abort_all()
>      ufshcd_abort_one()
>        ufshcd_try_to_abort_task()	// It should trigger an
> interrupt, but the tensor might not
>      ufshcd_complete_requests()
>        ufshcd_transfer_req_compl()
>          ufshcd_poll()
>            get outstanding_lock
>            clear outstanding_reqs tag
>            release outstanding_lock=09
>            __ufshcd_transfer_req_compl()
>              ufshcd_compl_one_cqe()
>                cmd->result =3D DID_REQUEUE // mediatek may need quirk
> change DID_ABORT to DID_REQUEUE
>                ufshcd_release_scsi_cmd()
>                scsi_done()
>=20
> ufshcd_intr()
>    ufshcd_sl_intr()
>      ufshcd_transfer_req_compl()
>        ufshcd_poll()
>          get outstanding_lock
>          clear outstanding_reqs tag
>          release outstanding_lock		=09
>          __ufshcd_transfer_req_compl()
>            ufshcd_compl_one_cqe()
>            cmd->result =3D DID_REQUEUE // mediatek may need quirk chang=
e
> DID_ABORT to DID_REQUEUE
>            ufshcd_release_scsi_cmd()
>            scsi_done();
>=20
> At this time, the same actions are taken regardless of whether
> there is an ISR, and with the protection of outstanding_lock,
> only one thread will execute ufshcd_release_scsi_cmd and scsi_done.
> ----------------------------------------------------------------
>=20
> Case4: MCQ ufshcd_err_handler
>=20
> It's the same with MCQ mode; there is protection from the cqe lock,
> so only one thread will execute. What my patch 2 aims to do is to
> change DID_ABORT to DID_REQUEUE in this situation.
>=20
> ufshcd_err_handler()
>    ufshcd_abort_all()
>      ufshcd_abort_one()
>        ufshcd_try_to_abort_task()	// will trigger irq thread
>      ufshcd_complete_requests()
>        ufshcd_mcq_compl_pending_transfer()
>          ufshcd_mcq_poll_cqe_lock()
>            ufshcd_mcq_process_cqe()
>              ufshcd_compl_one_cqe()
>                cmd->result =3D DID_ABORT // should change to DID_REQUEU=
E
>                ufshcd_release_scsi_cmd()
>                scsi_done()
>=20
> ufs_mtk_mcq_intr()
>    ufshcd_mcq_poll_cqe_lock()
>      ufshcd_mcq_process_cqe()
>        ufshcd_compl_one_cqe()
>          cmd->result =3D DID_ABORT  // should change to DID_REQUEUE
>          ufshcd_release_scsi_cmd()
>          scsi_done()

For legacy and MCQ mode, I prefer the following behavior for
ufshcd_abort_all():
* ufshcd_compl_one_cqe() ignores commands with status OCS_ABORTED.
* ufshcd_release_scsi_cmd() is called either by ufshcd_abort_one() or
   by ufshcd_abort_all().

Do you agree with making the changes proposed above?

Thank you,

Bart.
