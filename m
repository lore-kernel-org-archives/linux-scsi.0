Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D43030CDAB;
	Tue, 31 Mar 2026 02:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774924411; cv=none; b=WAFFvUhJS4PszW+Jqk/qR2A3UvzqxNm2t83cLp4El+3C0AI4hFvbPMApf9oHosL9w6hEPEjim+O6UJJzkOGbijL6CVZQNLMd+eLSL7EOJfpybVzB2wTce1+eNhYCJKJv7/y/tYRXfs/I0R+0dHj4HZnmQUEcQ6IpPAavGEbf++M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774924411; c=relaxed/simple;
	bh=zh53EDUf1MhP2FLQC/xQGayWW1bLYoZcQLGQmCe7GQY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=U33gO1zhkzHrFQhiaRRgizziqftMkLqPcwXGTt4D2xsSXUNOvoZhBnOWkOxbHcHASsSkmYK792/LyL7vf9UCW5546mRjF2cqAimCk+x1N1axppx05pUJ1AS0D1IHra7xY8olLsabeSBaO3urkJUtZwlAAb+q63Zo53/bMaXKBdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=liwPVmE+; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="liwPVmE+"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=NZt1CnUhicMCsMjLT96aiaYZsCqE6qY/Pe63snk4jrQ=;
	b=liwPVmE+OVozEOUq6hgCuMRaFcvDbxfO+agN+U+inCVJMN5n7ojE98YeTrSo+VF8wGp1qllBt
	g4gx5dUBMhoZxO6CIqqOVXDrsWBnGJSxFLywHqOWMpibttFBRmkzTvB5qSV8+RSvx1a6V63oS5z
	jy5shiA6f1Sce136vbns4A8=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4flBqQ5cQ3z12LDR;
	Tue, 31 Mar 2026 10:28:02 +0800 (CST)
Received: from kwepemj200013.china.huawei.com (unknown [7.202.194.25])
	by mail.maildlp.com (Postfix) with ESMTPS id CD5CD40575;
	Tue, 31 Mar 2026 10:33:26 +0800 (CST)
Received: from [10.174.179.155] (10.174.179.155) by
 kwepemj200013.china.huawei.com (7.202.194.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 31 Mar 2026 10:33:25 +0800
Message-ID: <f2f32b0d-e831-4372-a365-0b850eadfd3d@huawei.com>
Date: Tue, 31 Mar 2026 10:33:25 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: =?UTF-8?B?TW96aWxsYSBUaHVuZGVyYmlyZCDmtYvor5XniYg=?=
Subject: Re: [REGRESSION?] scsi: sas: wildcard user scan may iterate over huge
 max_id
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
	<ranjan.kumar@broadcom.com>
CC: <linux-scsi@vger.kernel.org>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, <rajsekhar.chundru@broadcom.com>,
	<sathya.prakash@broadcom.com>, <sumit.saxena@broadcom.com>,
	<chandrakanth.patil@broadcom.com>, <prayas.patel@broadcom.com>, yangerkun
	<yangerkun@huawei.com>, "zhangyi (F)" <yi.zhang@huawei.com>, Hou Tao
	<houtao1@huawei.com>, "chengzhihao1@huawei.com" <chengzhihao1@huawei.com>,
	<jiangjianjun3@h-partners.com>, <yuancan@huawei.com>
References: <773ba972-433b-44b4-89d2-295bd9f5de38@huawei.com>
 <04995d30c4d11af2e60a1497938031172a5fb332.camel@HansenPartnership.com>
From: Li Lingfeng <lilingfeng3@huawei.com>
In-Reply-To: <04995d30c4d11af2e60a1497938031172a5fb332.camel@HansenPartnership.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemj200013.china.huawei.com (7.202.194.25)


在 2026/3/30 20:18, James Bottomley 写道:
> On Sat, 2026-03-28 at 10:28 +0800, Li Lingfeng wrote:
>> Hi,
>>
>> I think commit 37c4e72b0651 ("scsi: Fix sas_user_scan() to handle
>> wildcard and multi-channel scans") may introduce a regression for
>> wildcard scans on some SAS hosts.
>>
>> Userspace trigger:
>>
>>     echo "- - -" > /sys/class/scsi_host/host0/scan
>>
>> results in:
>>
>>     channel = SCAN_WILD_CARD
>>     id      = SCAN_WILD_CARD
>>     lun     = SCAN_WILD_CARD
>>
>> Before this commit, sas_user_scan() iterated sas_host->rphy_list and
>> called scsi_scan_target() for matching rphys. In effect, scanning was
>> limited to channel 0 and to target ids present in sas_host-
>>> rphy_list.
>> After this commit, sas_user_scan() does:
>>
>>     - scan channel 0 via scan_channel_zero()
>>     - scan channels 1..shost->max_channel via
>> scsi_scan_host_selected()
>>
>> When id == SCAN_WILD_CARD, the latter path goes through
>> scsi_scan_channel(), which iterates ids from 0 to shost->max_id.
>>
>> This looks problematic for drivers that use a very large max_id. For
>> example, smartpqi sets:
>>
>>     shost->max_id = ~0;
>>
>> In that case, a wildcard scan may end up iterating from id 0 to ~0 in
>> scsi_scan_channel(). In my testing/analysis, this makes the scan take
>> a very long time, and the id-space walk itself does not seem
>> meaningful for this SAS transport scan path.
>>
>> So while the commit fixes incomplete wildcard channel handling, it
>> also appears to expand the id scan range from:
>>
>>     sas_host->rphy_list target ids
>>
>> to:
>>
>>     0..shost->max_id
>>
>> for the additional channels.
>>
>> It seems to me that wildcard SAS scans should probably remain bounded
>> by transport-discovered SAS targets, instead of falling back to a
>> host-wide id enumeration for the extra channels. One possible
>> direction may be to avoid calling scsi_scan_host_selected() with id
>> == SCAN_WILD_CARD from sas_user_scan(), or otherwise constrain the id
>> range in a transport-aware way.
>>
>> Am I understanding this correctly? If so, what would be the preferred
>> way to address this? I would appreciate feedback on whether this is
>> considered a real regression, and on the best fix direction.
> In the case of smartpqi, it isn't designed to be user scanned, I think.
> So, as you say, it would take a long time to scan one channel.  Since
> it sets max_channels to 3, it would only take 4 times longer which
> hardly constitutes a regression.
>
> Doing serial scans is very scsi-2 so most discoverable device fabrics
> don't bother and get the default settings for the scan max_channels
> (which is zero).  The only devices that seem to care about this at all
> are fat firmware devices that bundle RAID or other capabilities by re-
> purposing channels and they seem to be the ones that want this
> behaviour:
>
> https://lore.kernel.org/linux-scsi/CAFdVvOwjy+2ORJ6uJkspiLTPF05481U7gcS4QohFOFGPqAs8ig@mail.gmail.com/
>
> Regards,
>
> James
Hi James,

Thank you very much for the reply and for the additional background.

I would like to clarify one point about the performance regression I was
trying to describe.

I was not referring to the change from scanning one channel to scanning
multiple channels. My concern was about the change in the target ID scan
range within a single channel.

Before commit 37c4e72b0651 ("scsi: Fix sas_user_scan() to handle wildcard
and multi-channel scans"), the SAS path was effectively bounded by
rphy->scsi_target_id values discovered by the transport. After that change,
for the additional channels, the scan may go through scsi_scan_channel()
and iterate IDs in the range 0..shost->max_id when id == SCAN_WILD_CARD.

So the performance concern I had in mind was not really:

   "one channel" -> "multiple channels"

but rather:

   "scan transport-discovered IDs" -> "scan 0..max_id within a channel"

That said, after reading your reply, my current understanding is that the
motivation for 37c4e72b0651 is mainly to support controllers such as
mpt3sas and mpi3mr, where non-zero channels are meaningful and expected.

 From that perspective, it seems to me that for scenarios that do not
involve mpt3sas/mpi3mr-like usage, one option would be to simply not take
37c4e72b0651, while if we do take it, we should accept that it may bring
this kind of scan-time performance regression on some hosts.

Does that sound like a reasonable way to look at it?

Thanks again for the clarification.

Regards,
Lingfeng.
