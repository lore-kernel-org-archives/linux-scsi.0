Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01ED2E7F05;
	Thu,  3 Jul 2025 14:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751552226; cv=none; b=sZOUsk6v/q8mzfWBl6vpqRMpxZ73B/XtpnjAGSe2kswto2dpzzgdAS/NXm/vv1UzVKyPCBZ5FMf7D6nUI7WAe6qyWhkacGDhWOqKhHc7sFoWwslUJQMirUR7BPpAFdQ117Eu50xs0/Lt/ztJ2gP2t6iusIIcTfGK2h4TeCXSsU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751552226; c=relaxed/simple;
	bh=lCKLpqueK88GUgqdWwqfrXQ/O1O8CPEQNkMDi9HGhJ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=cP7PONr+ICWYoEc0XHbBMfmq7EUsmg1mJyWIiWDLMEAspeXmVk6b6miN1USONT0wNhNBuILruAZMGdB1d6OAWVjjA1f6PkwdzswcIT+oCHOC2qlm/3chX2tkolSBqI9d56oxQMAw5yLh1kCmdRZOvBE1wAqqcLHXozyK8fR9XdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4bXzHt2SNqz1GCFw;
	Thu,  3 Jul 2025 22:12:58 +0800 (CST)
Received: from kwepemg500017.china.huawei.com (unknown [7.202.181.81])
	by mail.maildlp.com (Postfix) with ESMTPS id C708318006C;
	Thu,  3 Jul 2025 22:16:59 +0800 (CST)
Received: from [10.174.179.155] (10.174.179.155) by
 kwepemg500017.china.huawei.com (7.202.181.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 3 Jul 2025 22:16:58 +0800
Message-ID: <563d1da8-abd8-48e6-9aab-5a4f13859995@huawei.com>
Date: Thu, 3 Jul 2025 22:16:58 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: =?UTF-8?B?TW96aWxsYSBUaHVuZGVyYmlyZCDmtYvor5XniYg=?=
Subject: Re: CVE-2022-50031: scsi: iscsi: Fix HW conn removal use after free
To: Greg Kroah-Hartman <gregkh@kernel.org>
CC: <cve@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-cve-announce@vger.kernel.org>, <lduncan@suse.com>,
	<cleech@redhat.com>, Mike Christie <michael.christie@oracle.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<open-iscsi@googlegroups.com>, <linux-scsi@vger.kernel.org>, yangerkun
	<yangerkun@huawei.com>, "zhangyi (F)" <yi.zhang@huawei.com>, Hou Tao
	<houtao1@huawei.com>, "yukuai (C)" <yukuai3@huawei.com>,
	"chengzhihao1@huawei.com" <chengzhihao1@huawei.com>
References: <2025061839-CVE-2022-50031-f2bc@gregkh>
From: Li Lingfeng <lilingfeng3@huawei.com>
In-Reply-To: <2025061839-CVE-2022-50031-f2bc@gregkh>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemg500017.china.huawei.com (7.202.181.81)

Hi, Greg

在 2025/6/18 19:01, Greg Kroah-Hartman 写道:
> From: Greg Kroah-Hartman <gregkh@kernel.org>
>
> Description
> ===========
>
> In the Linux kernel, the following vulnerability has been resolved:
>
> scsi: iscsi: Fix HW conn removal use after free
>
> If qla4xxx doesn't remove the connection before the session, the iSCSI
> class tries to remove the connection for it. We were doing a
> iscsi_put_conn() in the iter function which is not needed and will result
> in a use after free because iscsi_remove_conn() will free the connection.
>
> The Linux kernel CVE team has assigned CVE-2022-50031 to this issue.
>
>
> Affected and fixed versions
> ===========================
>
> 	Fixed in 5.19.4 with commit 0483ffc02ebb953124c592485a5c48ac4ffae5fe
> 	Fixed in 6.0 with commit c577ab7ba5f3bf9062db8a58b6e89d4fe370447e
>
> Please see https://www.kernel.org for a full list of currently supported
> kernel versions by the kernel community.
>
> Unaffected versions might change over time as fixes are backported to
> older supported kernel versions.  The official CVE entry at
> 	https://cve.org/CVERecord/?id=CVE-2022-50031
> will be updated if fixes are backported, please check that for the most
> up to date information about this issue.
>
>
> Affected files
> ==============
>
> The file(s) affected by this issue are:
> 	drivers/scsi/scsi_transport_iscsi.c
>
>
> Mitigation
> ==========
>
> The Linux kernel CVE team recommends that you update to the latest
> stable kernel version for this, and many other bugfixes.  Individual
> changes are never tested alone, but rather are part of a larger kernel
> release.  Cherry-picking individual commits is not recommended or
> supported by the Linux kernel community at all.  If however, updating to
> the latest release is impossible, the individual changes to resolve this
> issue can be found at these commits:
> 	https://git.kernel.org/stable/c/0483ffc02ebb953124c592485a5c48ac4ffae5fe
> 	https://git.kernel.org/stable/c/c577ab7ba5f3bf9062db8a58b6e89d4fe370447e
>
Based on the details described in the linked discussion, I have concerns
that this patch may not fully resolve the Use-After-Free vulnerability.
Instead, it appears the changes could potentially introduce memory leak
issues.
Given these concerns, I'd recommend ​rejecting this CVE until we can
thoroughly investigate and validate the complete solution.

Link: 
https://lore.kernel.org/all/0b0a0bcf-b805-5041-9923-37ad391169c0@huaweicloud.com/

Thanks,
Lingfeng
