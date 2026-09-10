Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3603812C7;
	Thu, 10 Sep 2026 02:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789007469; cv=none; b=MrhMQPencykFZrmqUjrs6BoPtJ05kvQZ1AWeKGoCQTkckC9xfOXcLcpnsOgjbh/wMc4Fi9wu+lfDs7Npyk44q8Bp7PHMUxX2+uEkGZMJweoqDVLnKlVe1tU2YuzTbUN5TSNt0mOSZevwo9zljJsDK4ukLNKk9GcSR6EO8Ivioj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789007469; c=relaxed/simple;
	bh=pXtof9x+XeZRcqnWRPf7ok3hRxcrE7dbIvn8iJIv8Q0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=bh/0170n0AqmcPR1I3kPs/+7z+7ilXzH97pm/Q1PQ4dmOon1ALiSfU2zLP/eitPDETgYj7iaodXnq+XmcnuAPjspydz/QA+ewe4W+QZACjYy/9iPRnpwTG5J7uzCKO94HEel75OUdxUcuPax1CdTz/E/jYJ2Sii39PX9yFg91Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CpeuCQoh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CpeuCQoh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4A21F00893;
	Thu, 10 Sep 2026 02:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789007467;
	bh=fnvEJ+YTWuOfxdkYCNV17QMjxIJWd4IjBCnevIkTrww=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=CpeuCQohhsoMUdrZSw5mMnsARDv388MTTog+9VjkZB7TjyvXLBnm9z9fOKzgA/C87
	 MkEZiaZk+LwvkJYXMtMSvl0FsfqTwg03sDtpJneL04BecyhsxyvgIIVnWYDmLODdEY
	 TKp5ZKBUwUmllqqMpgMX9Dodrzx4o4PTHctO/LzicEix52k/edS9b02GeCvV+UqaS7
	 qqE+g1eoj+FZSOmxwN5bWG0+EWkDoASPhIet1UkacKCJdIkIMUt1MvHxnkztL29DCC
	 FavQeK2EfuS69nCm87qF8dJel1hHpmECDnhCWes4d0+o+3hKroOHIUZ8nZZCg8HZqY
	 968uspUMQNXFw==
To: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
Cc: mani@kernel.org,  James.Bottomley@HansenPartnership.com,
  konrad.dybcio@linaro.org,  martin.petersen@oracle.com,
  linux-scsi@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH V2] scsi: ufs: ufs-qcom: Enable only lane clocks in lane
 clock APIs
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <20260909053944.2827968-1-nitin.rawat@oss.qualcomm.com> (Nitin
	Rawat's message of "Wed, 9 Sep 2026 11:09:44 +0530")
Message-ID: <yq1qzj1alcy.fsf@mail.kernel.org>
References: <20260909053944.2827968-1-nitin.rawat@oss.qualcomm.com>
Date: Wed, 09 Sep 2026 22:31:06 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Nitin,

> ufs_qcom_enable_lane_clks() and ufs_qcom_disable_lane_clks() currently
> use clk_bulk_prepare_enable()/clk_bulk_disable_unprepare() on the
> entire host->clks array obtained from devm_clk_bulk_get_all(). This
> array contains all device clocks, not just lane symbol clocks.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
