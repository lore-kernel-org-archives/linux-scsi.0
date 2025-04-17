Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28F91F585C;
	Thu, 17 Apr 2025 22:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744927526; cv=none; b=KCZ/0i6fxRZMn0VmO8Ti/W/8KtpBI+x/G+M0SrkoBK/pHhpa1iGct1frMkUc1DIP/FOSLEnmnkOBtz3D5iXaJAJ/2vrPa+NDytYakx0u3rhxfeU3IRXC2KObhKh5qXFUKRQfCLploUKtt2sKgaNuhXDA01lDrB9AeOUmteul9BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744927526; c=relaxed/simple;
	bh=c40REWb1a3/s4Fu+jvI3wqsoAE+Q7Vgr4+MPabS7Yjs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=emX9Ec0J1HUa+Jcuo87CkI5TNNPGXCWAow0neFDi2ME1GlIZQchK7vnJ4w1E9YtiXGFqr567/Z/vQJzv3UxRbkxEExOhWfRVn/mYXUuDAjX2U62pA+jFhOxQnVK8d5oOgRzE0uR1pY2S1+V2GsQFdtas8yKUf80N29PbDKNbi3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=HD/yUEiV; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="HD/yUEiV"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZdsQW4fHmzm0yQH;
	Thu, 17 Apr 2025 22:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1744927519; x=1747519520; bh=NDL3DSYzQbDPvC+h3yNAqT5D
	KosWjTUQXIxb1J3u3/U=; b=HD/yUEiVG6NGbo3ZjyNicwscdJCrudzEenkFtH4L
	NpF9ieTP23ia35qhCYcnqMPl3wLzqUEx36/FK2Hes7Nxq4LFRLzC5ePQTJ56lth7
	uW0j1nL1IdJXQc7pQvt03WvL6aTkUK4XM1ZB5U4XoBIbEet0mgMunvKxM9DBM+iW
	jLW53PViB5dQ6VUKiepUTVWnHvMgjbsraNVQg7cnr8aeBxLFFZwtS9xstrI9SmGV
	/UMoAcTgAHw3U1fF0IvUmGigCjhqictpm4v174nbGGsne7hfo9i+yyeVTwlmgNgb
	OmLb4o57UxJxnsMqWnYj7jOEXjuodKvy28SaQnGW7spNXg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id yjzyd_cn1v7u; Thu, 17 Apr 2025 22:05:19 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZdsQ72yWLzm0ysq;
	Thu, 17 Apr 2025 22:05:02 +0000 (UTC)
Message-ID: <4eef6172-3ba2-43a9-b6af-3750c39bb344@acm.org>
Date: Thu, 17 Apr 2025 15:05:01 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: core: Add HID support
To: Huan Tang <tanghuan@vivo.com>, alim.akhtar@samsung.com,
 avri.altman@wdc.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, beanhuo@micron.com, keosung.park@samsung.com,
 quic_ziqichen@quicinc.com, viro@zeniv.linux.org.uk, gwendal@chromium.org,
 peter.wang@mediatek.com, manivannan.sadhasivam@linaro.org,
 quic_cang@quicinc.com, quic_nguyenb@quicinc.com, ebiggers@google.com,
 minwoo.im@samsung.com, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org
Cc: opensource.kernel@vivo.com, luhongfei@vivo.com,
 Wenxing Cheng <wenxing.cheng@vivo.com>
References: <20250417125008.123-1-tanghuan@vivo.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250417125008.123-1-tanghuan@vivo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/17/25 5:50 AM, Huan Tang wrote:
> +What:		/sys/bus/platform/drivers/ufshcd/*/hid_trigger
> +What:		/sys/bus/platform/devices/*.ufs/hid_trigger
> +Date:		April 2025
> +Contact:	Huan Tang <tanghuan@vivo.com>
> +Description:
> +		The host can enable or disable complete HID.
> +
> +		========  ============
> +		enable    Let kworker(ufs_hid_enable_work) execute the complete HID
> +		disable   Cancel kworker(ufs_hid_enable_work) and disable HID
> +		========  ============
> +		The file is write only.
> +
> +What:		/sys/bus/platform/drivers/ufshcd/*/attributes/defrag_operation
> +What:		/sys/bus/platform/devices/*.ufs/attributes/defrag_operation
> +Date:		April 2025
> +Contact:	Huan Tang <tanghuan@vivo.com>
> +Description:
> +		The host can enable or disable HID analysis and HID defrag operations.
> +
> +		===============  ==================================================
> +		all_disable      HID analysis and HID defrag operation are disabled
> +		analysis_enable  HID analysis is enabled
> +		all_enable       HID analysis and HID defrag operation are enabled
> +		===============  ==================================================
> +
> +		The attribute is read/write.

Combining HID analysis and HID defragmentation controls into a single
sysfs attribute seems weird to me. Please replace the above two
attributes with two different attributes: one for controlling HID
analysis and another one for controlling HID defragmentation.

> +
> +What:		/sys/bus/platform/drivers/ufshcd/*/attributes/hid_available_size
> +What:		/sys/bus/platform/devices/*.ufs/attributes/hid_available_size
> +Date:		April 2025
> +Contact:	Huan Tang <tanghuan@vivo.com>
> +Description:
> +		The total fragmented size in the device is reported through this
> +		attribute.
> +
> +		The attribute is read only.

Please change the name of this attribute into "hid_fragmented_size". I
think that this alternative name is much more clear.

> +
> +What:		/sys/bus/platform/drivers/ufshcd/*/attributes/hid_size
> +What:		/sys/bus/platform/devices/*.ufs/attributes/hid_size
> +Date:		April 2025
> +Contact:	Huan Tang <tanghuan@vivo.com>
> +Description:
> +		The host sets the size to be defragmented by an HID defrag operation.
> +
> +		The attribute is read/write.

Please make the name of this attribute more clear, e.g. by renaming it
into "hid_defrag_size". Additionally, please change "defrag" into
"defragmentation".

> +What:		/sys/bus/platform/drivers/ufshcd/*/attributes/hid_progress_ratio
> +What:		/sys/bus/platform/devices/*.ufs/attributes/hid_progress_ratio
> +Date:		April 2025
> +Contact:	Huan Tang <tanghuan@vivo.com>
> +Description:
> +		Defrag progress is reported by this attribute,indicates the ratio of
> +		the completed defrag size over the requested defrag size.
> +
> +		====  ======================================
> +		01h   1%
> +		...
> +		64h   100%
> +		====  ======================================
> +
> +		The attribute is read only.

Please change the format of this attribute from hexadecimal into
decimal (64h -> 100).

> +
> +What:		/sys/bus/platform/drivers/ufshcd/*/attributes/hid_state
> +What:		/sys/bus/platform/devices/*.ufs/attributes/hid_state
> +Date:		April 2025
> +Contact:	Huan Tang <tanghuan@vivo.com>
> +Description:
> +		The HID state is reported by this attribute.
> +
> +		====   ======================================
> +		00h    Idle(analysis required)
> +		01h    Analysis in progress
> +		02h    Defrag required
> +		03h    Defrag in progress
> +		04h    Defrag completed
> +		05h    Defrag is not required
> +		====  ======================================
> +
> +		The attribute is read only.

Please change the format of this attribute from hexadecimal into
decimal. Please add an additional sysfs attribute that provides the
textual meaning of the HID state such that users don't have to look up
the documentation of these codes.

> +config SCSI_UFS_HID
> +	bool "Support UFS Host Initiated Defrag"
> +	help
> +	  The UFS HID feature allows the host to check the status of whether
> +	  defragmentation is needed or not and enable the device's internal
> +	  defrag operation explicitly.
> +
> +	  If unsure, say N.

Here and everywhere else in documentation that is intended for humans,
please change "defrag" into "defragmentation". Please also make the
Kconfig description more clear, e.g. by changing it into the following:

	help
	  In NAND-based storage devices garbage collection is
	  inevitable. Garbage collection may cause latency spikes.
	  The UFS Host-Initiated Defragmentation (HID) functionality
	  gives the host control over when defragmentation (garbage
	  collection) happens and hence can be used to avoid latency
	  spikes.

> +#define HID_SCHED_COUNT_LIMIT	300
> +static int hid_sched_cnt;
> +static void ufs_hid_enable_work_fn(struct work_struct *work)

A blank line is required after the macro definition and also between the
declaration of the static variable and the function definition.

> +{
> +	struct ufs_hba *hba;
> +	int ret = 0;
> +	enum ufs_hid_defrag_operation defrag_op;
> +	u32 hid_ahit = 0;
> +	bool hid_flag = false;

In new code, please order declarations such that the longest declaration
occurs first ("reverse Christmas tree").

> +	hba = container_of(work, struct ufs_hba, ufs_hid_enable_work.work);
> +
> +	if (!hba->dev_info.hid_sup)
> +		return;
> +
> +	down(&hba->host_sem);
> +
> +	if (!ufshcd_is_user_access_allowed(hba)) {
> +		up(&hba->host_sem);
> +		return;
> +	}
> +
> +	ufshcd_rpm_get_sync(hba);
> +	hid_ahit = hba->ahit;
> +	ufshcd_auto_hibern8_update(hba, 0);

Why is auto-hibernation disabled here? Please add a comment.

> +int ufs_hid_disable(struct ufs_hba *hba)
> +{
> +	enum ufs_hid_defrag_operation defrag_op = HID_ANALYSIS_AND_DEFRAG_DISABLE;
> +	u32 hid_ahit;
> +	int ret;
> +
> +	down(&hba->host_sem);
> +
> +	if (!ufshcd_is_user_access_allowed(hba)) {
> +		up(&hba->host_sem);
> +		return -EBUSY;
> +	}
> +
> +	ufshcd_rpm_get_sync(hba);
> +	hid_ahit = hba->ahit;
> +	ufshcd_auto_hibern8_update(hba, 0);
> +
> +	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
> +				QUERY_ATTR_IDN_HID_DEFRAG_OPERATION, 0, 0, &defrag_op);
> +
> +	ufshcd_auto_hibern8_update(hba, hid_ahit);
> +	ufshcd_rpm_put_sync(hba);
> +	up(&hba->host_sem);
> +
> +	return ret;
> +}

Please add a comment that explains why the ufshcd_auto_hibern8_update()
call is present.

> +static ssize_t hid_size_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +	u32 value;
> +	int ret;
> +
> +	ret = hid_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
> +				QUERY_ATTR_IDN_HID_SIZE, &value);
> +	if (ret)
> +		return ret;
> +
> +	return sysfs_emit(buf, "0x%08X\n", value);
> +}

Why the hexadecimal format? All other sysfs size attributes I know of
use the decimal format.

Thanks,

Bart.

