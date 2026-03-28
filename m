Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE15D35836F;
	Sat, 28 Mar 2026 02:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774664948; cv=none; b=gNcQhLSDGPHxnzF46HWKhioxvvDEt4tCmtcTh4i6TBNE4W6YHyyLZ3IzDiOpetNCgKgud1NLvcRyHgwz+H0AuDHLx/3uMoMIrJtR9L92MGAuXXTjr+OwdRjJddM92c2tZJeuE1gIKUViE7+ZJEBdFipRQp9cQwAk5Qz2uipMN5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774664948; c=relaxed/simple;
	bh=kjpl+/QuuRP2o444wYKocPcPIUwJx11qQPUGaBagka4=;
	h=Message-ID:Date:MIME-Version:To:CC:From:Subject:Content-Type; b=taxKs5xqeRcCuaXb/K5rPvQWHsVRTyTFqmqP5TYWCYRE0hFezGPabTF1+KixZvov5Qdeb4ZwJpwYLJIOO1f7yVClSJhSEVJ4E69r8GCADxj+wrmAwepcvTKYKO3rEBEhJvhvX6ndbYs+m/MEZyP8OeAcPgaKVSgxm601Q6pp9tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=UF6HNvxL; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="UF6HNvxL"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=kjpl+/QuuRP2o444wYKocPcPIUwJx11qQPUGaBagka4=;
	b=UF6HNvxLgCxzoByUoUORBOqCnxtIKXOR5PAAckGb/n4KAF/0i5oZhGnBXMFjuA8OfLL0uMF0T
	1nqEuOmn3vYCPNxF2y7joFFw31jdT02Js9MXvn3ehwQZ3PqU9Aq3xIkEDQlHlrMTZYxouMB0Ix8
	5r1L9ekrLpjOzsqD0Hu8Wd8=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4fjLsJ4WqpzpTMC;
	Sat, 28 Mar 2026 10:23:16 +0800 (CST)
Received: from kwepemj200013.china.huawei.com (unknown [7.202.194.25])
	by mail.maildlp.com (Postfix) with ESMTPS id 2E11A40569;
	Sat, 28 Mar 2026 10:28:57 +0800 (CST)
Received: from [10.174.179.155] (10.174.179.155) by
 kwepemj200013.china.huawei.com (7.202.194.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 28 Mar 2026 10:28:56 +0800
Message-ID: <773ba972-433b-44b4-89d2-295bd9f5de38@huawei.com>
Date: Sat, 28 Mar 2026 10:28:55 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: =?UTF-8?B?TW96aWxsYSBUaHVuZGVyYmlyZCDmtYvor5XniYg=?=
To: <ranjan.kumar@broadcom.com>
CC: <linux-scsi@vger.kernel.org>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, <rajsekhar.chundru@broadcom.com>,
	<sathya.prakash@broadcom.com>, <sumit.saxena@broadcom.com>,
	<chandrakanth.patil@broadcom.com>, <prayas.patel@broadcom.com>, yangerkun
	<yangerkun@huawei.com>, "zhangyi (F)" <yi.zhang@huawei.com>, Hou Tao
	<houtao1@huawei.com>, "chengzhihao1@huawei.com" <chengzhihao1@huawei.com>,
	<jiangjianjun3@h-partners.com>, <yuancan@huawei.com>
From: Li Lingfeng <lilingfeng3@huawei.com>
Subject: [REGRESSION?] scsi: sas: wildcard user scan may iterate over huge
 max_id
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemj200013.china.huawei.com (7.202.194.25)

Hi,

I think commit 37c4e72b0651 ("scsi: Fix sas_user_scan() to handle wildcard
and multi-channel scans") may introduce a regression for wildcard scans on
some SAS hosts.

Userspace trigger:

   echo "- - -" > /sys/class/scsi_host/host0/scan

results in:

   channel = SCAN_WILD_CARD
   id      = SCAN_WILD_CARD
   lun     = SCAN_WILD_CARD

Before this commit, sas_user_scan() iterated sas_host->rphy_list and called
scsi_scan_target() for matching rphys. In effect, scanning was limited to
channel 0 and to target ids present in sas_host->rphy_list.

After this commit, sas_user_scan() does:

   - scan channel 0 via scan_channel_zero()
   - scan channels 1..shost->max_channel via scsi_scan_host_selected()

When id == SCAN_WILD_CARD, the latter path goes through
scsi_scan_channel(), which iterates ids from 0 to shost->max_id.

This looks problematic for drivers that use a very large max_id. For
example, smartpqi sets:

   shost->max_id = ~0;

In that case, a wildcard scan may end up iterating from id 0 to ~0 in
scsi_scan_channel(). In my testing/analysis, this makes the scan take a
very long time, and the id-space walk itself does not seem meaningful for
this SAS transport scan path.

So while the commit fixes incomplete wildcard channel handling, it also
appears to expand the id scan range from:

   sas_host->rphy_list target ids

to:

   0..shost->max_id

for the additional channels.

It seems to me that wildcard SAS scans should probably remain bounded by
transport-discovered SAS targets, instead of falling back to a host-wide
id enumeration for the extra channels. One possible direction may be to
avoid calling scsi_scan_host_selected() with id == SCAN_WILD_CARD from
sas_user_scan(), or otherwise constrain the id range in a transport-aware
way.

Am I understanding this correctly? If so, what would be the preferred way
to address this? I would appreciate feedback on whether this is considered
a real regression, and on the best fix direction.

Thanks,
Lingfeng.

