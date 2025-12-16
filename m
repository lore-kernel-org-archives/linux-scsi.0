Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51603254AD;
	Tue, 16 Dec 2025 06:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.19.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765867457; cv=none; b=NetcZTF75Esy09mKKNIkhQfQ0qfF+90En0l8ADInfeTmTQoaeQXVvQkuJI+lWzoPmdvQo3CpAhmohAI+gPZMLqSAE9ULhpfNZHW4e8lX5C74mhygVnyhTB1z2zfuqlWh6zuFA/rBOUNmrW9dri7Ac+AY2bE9fDvMzeek3hL3dgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765867457; c=relaxed/simple;
	bh=ril54GOhWBDEb0U64qDski1oPodK8jzqI766xMGddu0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FsTcP5ZugpRBorfqQxGCu/fv6PnfMbdcdz8H4K159/WjKifj/uqWrYSp4KXrtovJGcZS+FCQQkAmV8W7Xg/wtyHT3x55+ZSQp48uTDYcNsWiGMwYUjk6aM3Cafu8lQ8EL44C7qwT6ZMvpiw1/A7t2QsUJmktWzqX82Slo0CV3rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=darknavy.com; spf=pass smtp.mailfrom=darknavy.com; dkim=pass (1024-bit key) header.d=darknavy.com header.i=@darknavy.com header.b=r39x+Sj9; arc=none smtp.client-ip=54.207.19.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=darknavy.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=darknavy.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=darknavy.com header.i=@darknavy.com header.b="r39x+Sj9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=darknavy.com;
	s=litx2311; t=1765867404;
	bh=eBb/mwvHnHZnIX8S3eE2z2bF9eyAeqDxV/6nbdOcIYs=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=r39x+Sj9eFp8+FID6eiOZFuefmzF/4HhOk/tOc+7SlIgKtRdScrAwZscbZyN977x4
	 +jd+RfmiH3o7oTG1cl80ItH1id7xyT4OJqgldzIeTHqELP0XWIpJ/VmQCbjcV8YHsW
	 25a7ngVqBFCWhK93NatUpvgjjndA1Kmj3ZVRtCqY=
X-QQ-mid: zesmtpgz8t1765867395t949d7b83
X-QQ-Originating-IP: qGU6cjUqXpUBD+ojSRfziOHcDAqVRhOnkDgzWFQmEAU=
Received: from localhost.localdomain ( [223.166.168.213])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 16 Dec 2025 14:43:13 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 13400267779485537126
EX-QQ-RecipientCnt: 7
From: Shipei Qu <qu@darknavy.com>
To: jejb@linux.ibm.com
Cc: martin.petersen@oracle.com,
	aradford@gmail.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	vr@darknavy.com,
	qu@darknavy.com
Subject: Re: [PATCH v2] scsi: 3w-sas: validate request_id reported by controller
Date: Tue, 16 Dec 2025 14:43:13 +0800
Message-Id: <20251216064313.69144-1-qu@darknavy.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <27297f052a89a5e171bad743dd59f39a339ce126.camel@HansenPartnership.com>
References: <27297f052a89a5e171bad743dd59f39a339ce126.camel@HansenPartnership.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:darknavy.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: OS4uHVcO72ZrKzi/Yg/VVrDPfna6fntVAJHMkmE1rir4yE4YaTrSDYZF
	W3aNycDo54+p3Z1MYpSJVehp1wMIqo7TcCYV54KtWpu+rW//jAr5RikgQup50AnvUJqktQb
	zV66tQ/G0V5efAm1I90glB+BioO/SyQ5JviVElrmb86O2F+jC02p9sEDwHTzEhbJ9SEaVnT
	jP/H5VgJRHv099xc7K/UALdXbfUi1wznSlaenuTrZKgm94JfX+ilr/KnAQgu0Xtp0+7n6VW
	M5pnxqsM0/kR3I5hvkpBnNAkv2YwKlTnJaR9SNSj7JzTjWjCRhzFtsafX3hUx79ILvu/8tY
	trnsTpvwvmFKv30J/hUV5gvTOvNLrEPOGHKnyKEX7GoR/BW1BOjIjOZVFcdzHDBNIy0SSbX
	bS8kAZ/RFFMrJao06pKLLiQesIs6NKAF33d5QOsT+nkewKQDM6O59sDjNviC4Ayu69oQDCX
	BCYbNJMGaOCm26vcOPF7Xa4oCDHUpmQ3G+kQCIJ7F/ZAUihOinrVeeBej7S8JGcU4qHsCIk
	6HxMsvSpG61gC+H9t3t5h5d7vXBrhYV/cD6H6wM6NByyi+oBZQdlAFrIygoH7/ZWKWH20US
	T7/EQT1bP/P7ZXn6+uSnGQYLTVo06DORCln8uHXER3NUuM+mIuQiNHTo+CmQXgPoL8eSsn+
	orh/uV9ZpoMbe75mdDZhzgiD/Gp83Ges8M/SQirNCUBVDa7lVMm01hFCiZ09hVLfUwBAi2/
	pP1lzITJ3FDEgozDB+kqUnb1i5EXt+HDcOT9eo59iw5KQwvEQdjFdwcciOofS7JtSQapzct
	OhQlDrIhHpbksgndVeaYT1sOFXzZBcoG/Bzyd2hxqCs3PsL3P4nWZB0IeLQ4WnHTWTJjnG/
	iWuYbxrSB4/tqA87+Z1k9nIoB4y5OUJKFHpZerJsr78PG9t++3hJUMlR8vFE6wMS3zikUT8
	vjfU+xbk1PLmNkA192JqecxCauLl16ckX9A84UVU+QjU5qCmOZN0R3tbDgi7ZeTvLkKf2Nx
	VUL6XW9Q==
X-QQ-XMRINFO: Nq+8W0+stu50PRdwbJxPCL0=
X-QQ-RECHKSPAM: 0

Hi James,

> Realistically the same rationale goes for us as well.  Absent the
> observation in the field of a problem device, we usually trust the
> hardware, so unless you can find an actual device that exhibits the
> problem this isn't really a fix for anything.
>
> If the security@ list is happy that the existing trust model for
> Thunderbolt/PCIe would prevent the attachment of malicious devices,
> then I think we're also happy to take their word for it.  Even if
> thunderbolt were a security problem, the fix would likely be in the
> trust model not in all possible drivers.

Thanks for the feedback. We understand and respect the current trust
model (drivers assume trusted hardware), so no objections if you prefer
not to take the patch under that model.

For context: some confidential-computing / virtualized deployments
include a hostile or compromised VMM or passthrough device in the threat
model, so bounds checks can reduce crash surface when the device isn't
fully trusted. But if that's outside upstream scope here, we're fine
either way. Thanks for the clarification.

Thanks,
Shipei
