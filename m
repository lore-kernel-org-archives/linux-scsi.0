Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8028330DEDC
	for <linux-scsi@vger.kernel.org>; Wed, 27 Aug 2025 21:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756331526; cv=none; b=I/chCp7ifb2UwwcwJrXWi19J0hWrnRrmOpWb9g8fu99TUUDYXznXSVhLLzX1i8jXmo9Vb/bS552OKRieztUeVgoR9O8fAhvrqYcl08btj0IeSuztX7LHpPYGOiL32YuQ0Iez3EH5NvGEBJZSx4Af7U2l3iCc95HUKh9mtxS+JyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756331526; c=relaxed/simple;
	bh=7MhEe9Qx+MhhPsvUqS34YdpaHn9qVoXMVNVWABwNZfA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=an+L+MCw+/DAEHrdTMErctTWnMy5gUkauBbhTm3QzwgH0a9IKl5xP2FIFujkqhM468akicQDmoo5oFFJK1Wtnbf0mDK7A4FoAPWVkh5VJKJthnMNV2IBuqFgL0WT510flTSL2RCA9248Y+gTWgoWuiUhto7qnXt+v7nteycDU+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Mecfj6Uk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mecfj6Uk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756331523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0MV09FhzMIF8Ui9xrCM0Bui7E6jEybYpp51C5kSRmrI=;
	b=Mecfj6UkQ2SE9pzNMlJlPKOx87TzCRDqPuWkygBFbIS0P7JZQccTXsTlsgqwowcI7K+xuI
	GyTXdFTKc/i8RBJ/3LNWmwHO9PZSn8qSYPcok/zKmGKM5RqZQKgFdix+qHrUODjnMd2BVO
	/RX1iFVkdayaKVLrvwVAj+x0DM2k6s8=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-220-KkFmcprhOI--aTUidTr60g-1; Wed,
 27 Aug 2025 17:52:00 -0400
X-MC-Unique: KkFmcprhOI--aTUidTr60g-1
X-Mimecast-MFC-AGG-ID: KkFmcprhOI--aTUidTr60g_1756331517
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C289A195608E;
	Wed, 27 Aug 2025 21:51:55 +0000 (UTC)
Received: from [10.22.88.109] (unknown [10.22.88.109])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 552111955F24;
	Wed, 27 Aug 2025 21:51:49 +0000 (UTC)
Message-ID: <ccb441d0-7603-4e96-b59a-d69ee6a95e6d@redhat.com>
Date: Wed, 27 Aug 2025 17:51:48 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] nvme-cli: nvmf-autoconnect: udev-rule: add a file for
 new arrays
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Wayne Berthiaume <Wayne.Berthiaume@dell.com>,
 Vasuki Manikarnike <vasuki.manikarnike@hpe.com>,
 Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>,
 Martin George <marting@netapp.com>,
 NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>,
 Zou Ming <zouming.zouming@huawei.com>, Li Xiaokeng <lixiaokeng@huawei.com>,
 Randy Jennings <randyj@purestorage.com>, Jyoti Rani <jrani@purestorage.com>,
 Brian Bunker <brian@purestorage.com>, Uday Shankar
 <ushankar@purestorage.com>, Chaitanya Kulkarni <kch@nvidia.com>,
 Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Marco Patalano <mpatalan@redhat.com>,
 "Ewan D. Milne" <emilne@redhat.com>, Daniel Wagner <dwagner@suse.de>,
 Daniel Wagner <wagi@monom.org>, Hannes Reinecke <hare@suse.de>,
 Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 BLOCK-ML <linux-block@vger.kernel.org>,
 NVME-ML <linux-nvme@lists.infradead.org>,
 SCSI-ML <linux-scsi@vger.kernel.org>, DM_DEVEL-ML <dm-devel@lists.linux.dev>
References: <20250820213254.220715-1-xose.vazquez@gmail.com>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20250820213254.220715-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

I'm sorry but Red Hat will not approve any upstream change like this that modifies the policy for OTHER VENDORS stuff.

You can't simply change the IO policy for all of these arrays.  Many vendors have no autoconnect/udev-rules because they don't want one.  They want to use the default ctrl_loss_tmo and the default iopolicy (numa)... you can't just change this for them.

If you want people to migrate their udev rules out of separate files and into a single autoconnect file like this then you'll have to get them to agree.

When I look upstream I see exactly 3 vendors who have a udev-rule for their iopolicy.

nvme-cli(master) > ls -1 nvmf-autoconnect/udev-rules/71*
nvmf-autoconnect/udev-rules/71-nvmf-hpe.rules.in
nvmf-autoconnect/udev-rules/71-nvmf-netapp.rules.in
nvmf-autoconnect/udev-rules/71-nvmf-vastdata.rules.in

I suggest that you get these three vendors to agree to move their policy into a single 71-nvmf-mulitpath-policy.rules.in file, and then leave everyone else's stuff alone.

In the future, vendors who want to add a multipath-policy rule can then use the new file instead of adding their own.

/John

On 8/20/25 5:32 PM, Xose Vazquez Perez wrote:
> One file per vendor, or device, is a bit excessive for two-four rules.
> 
> 
> If possible, select round-robin (>=5.1), or queue-depth (>=6.11).
> round-robin is a basic selector, and only works well under ideal conditions.
> 
> A nvme benchmark, round-robin vs queue-depth, shows how bad it is:
> https://marc.info/?l=linux-kernel&m=171931850925572
> https://marc.info/?l=linux-kernel&m=171931852025575
> https://github.com/johnmeneghini/iopolicy/?tab=readme-ov-file#sample-data
> https://people.redhat.com/jmeneghi/ALPSS_2023/NVMe_QD_Multipathing.pdf
> 
> 
> [ctrl_loss_tmo default value is 600 (ten minutes)]

You can't remove this because vendors have ctrl_loss_tmo set to -1 on purpose.

> v3:
>   - add Fujitsu/ETERNUS AB/HB
>   - add Hitachi/VSP
> 
> v2:
>   - fix ctrl_loss_tmo commnent
>   - add Infinidat/InfiniBox
> 
> 
> Cc: Wayne Berthiaume <Wayne.Berthiaume@dell.com>
> Cc: Vasuki Manikarnike <vasuki.manikarnike@hpe.com>
> Cc: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>
> Cc: Martin George <marting@netapp.com>
> Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
> Cc: Zou Ming <zouming.zouming@huawei.com>
> Cc: Li Xiaokeng <lixiaokeng@huawei.com>
> Cc: Randy Jennings <randyj@purestorage.com>
> Cc: Jyoti Rani <jrani@purestorage.com>
> Cc: Brian Bunker <brian@purestorage.com>
> Cc: Uday Shankar <ushankar@purestorage.com>
> Cc: Chaitanya Kulkarni <kch@nvidia.com>
> Cc: Sagi Grimberg <sagi@grimberg.me>
> Cc: Keith Busch <kbusch@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Marco Patalano <mpatalan@redhat.com>
> Cc: Ewan D. Milne <emilne@redhat.com>
> Cc: John Meneghini <jmeneghi@redhat.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Daniel Wagner <wagi@monom.org>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: BLOCK-ML <linux-block@vger.kernel.org>
> Cc: NVME-ML <linux-nvme@lists.infradead.org>
> Cc: SCSI-ML <linux-scsi@vger.kernel.org>
> Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
> 
> This will be the last iteration of this patch, there are no more NVMe storage
> array manufacturers.
> 
> 
> Maybe these rules should be merged into this new file. ???
> 71-nvmf-hpe.rules.in
> 71-nvmf-netapp.rules.in
> 71-nvmf-vastdata.rules.in
> 
> ---
>   .../80-nvmf-storage_arrays.rules.in           | 48 +++++++++++++++++++
>   1 file changed, 48 insertions(+)
>   create mode 100644 nvmf-autoconnect/udev-rules/80-nvmf-storage_arrays.rules.in
> 
> diff --git a/nvmf-autoconnect/udev-rules/80-nvmf-storage_arrays.rules.in b/nvmf-autoconnect/udev-rules/80-nvmf-storage_arrays.rules.in
> new file mode 100644
> index 00000000..ac5df797
> --- /dev/null
> +++ b/nvmf-autoconnect/udev-rules/80-nvmf-storage_arrays.rules.in
> @@ -0,0 +1,48 @@
> +##### Storage arrays
> +
> +#### Set iopolicy for NVMe-oF
> +### iopolicy: numa (default), round-robin (>=5.1), or queue-depth (>=6.11)
> +
> +## Dell EMC
> +# PowerMax
> +ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="round-robin", ATTR{model}=="EMC PowerMax"
> +ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="queue-depth", ATTR{model}=="EMC PowerMax"
> +# PowerStore
> +ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="round-robin", ATTR{model}=="dellemc-powerstore"
> +ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="queue-depth", ATTR{model}=="dellemc-powerstore"
> +
> +## Fujitsu
> +# ETERNUS AB/HB
> +ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="round-robin", ATTR{model}=="Fujitsu ETERNUS AB/HB Series"
> +ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="queue-depth", ATTR{model}=="Fujitsu ETERNUS AB/HB Series"
> +
> +## Hitachi Vantara
> +# VSP
> +ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="round-robin", ATTR{model}=="HITACHI SVOS-RF-System"
> +ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="queue-depth", ATTR{model}=="HITACHI SVOS-RF-System"
> +
> +## Huawei
> +# OceanStor
> +ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="round-robin", ATTR{model}=="Huawei-XSG1"
> +ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="queue-depth", ATTR{model}=="Huawei-XSG1"
> +
> +## IBM
> +# FlashSystem (RamSan)
> +ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="round-robin", ATTR{model}=="FlashSystem"
> +ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="queue-depth", ATTR{model}=="FlashSystem"
> +# FlashSystem (Storwize/SVC)
> +ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="round-robin", ATTR{model}=="IBM*214"
> +ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="queue-depth", ATTR{model}=="IBM*214"
> +
> +## Infinidat
> +# InfiniBox
> +ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="round-robin", ATTR{model}=="InfiniBox"
> +ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="queue-depth", ATTR{model}=="InfiniBox"
> +
> +## Pure
> +# FlashArray
> +ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="round-robin", ATTR{model}=="Pure Storage FlashArray"
> +ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{subsystype}=="nvm", ATTR{iopolicy}="queue-depth", ATTR{model}=="Pure Storage FlashArray"
> +
> +
> +##### EOF

