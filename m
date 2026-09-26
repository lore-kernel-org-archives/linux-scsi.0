Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF545315D53;
	Sat, 26 Sep 2026 02:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790390295; cv=none; b=cYC8jicxlEMpivJEGfDwWmO6t1vFhjEF/IAgz8uhr8VQiBYvv810aTv5EHWK6fGd+deOGErxxnUE3yx0VRECpNERQWqxGaSwpb7y+SbYLnavKOidTO5e+lo9/CbMTN0OGLqaBIar8QUimJb+L5I8x58/6WS1N8ERSc6zWiZ/FpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790390295; c=relaxed/simple;
	bh=3kb80s3lg/5IlmooEWsOA8wvRHkzTI8u3lF5VCCh02g=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=Lql1X29uz09PM6yPT6FbRk0j3da6pgud0z9QyJTB1PMlbQD7lEplkrPw9JMzeisVBVWZKGcm0bNgnhna4cBJ7dHPNbwaqvOdz2u8uLacjtTUqTw96X//9AogDi8k4R/giYDcs6YlNgWv3HBiDdeO6f23F2MpvtoXfvoOcIJby7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kmEScZiQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kmEScZiQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411291F000FF;
	Sat, 26 Sep 2026 02:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790390294;
	bh=tRefiV1w6pAG18rm1EoIHBCOfs55oCyFjLuuiqF32k8=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=kmEScZiQ/aTdEzhqD8h8LDhbCJ8Gvs2haPa/4aFPTatZU/NmVOHba8SCSlGX79Eri
	 E71iU7UjjdPpIYSWLAnc/HWu3yqHMPYbun7AX0dPfYmM/KMq8Oje/FbmBAYnMcVK9T
	 CbsS0jNuEuNCOMMD7h6UnzamtHwXEFD/zU6azltOjLne0QQ0vFY81Dg0turuRJVFnD
	 9uV5Nvi2yoN/MHSmE4NNvtuPjZQg2jIauJHahhyQKFF4zK9y7zFUuISD0hsQMpfrr2
	 y/xQ9gDe6kYrHXRJZmXyBV44zpuAhzKrLJUH9jp4LBede2bIQvLjTVVqKqFnmnAVMZ
	 EKWNoY6sjTX2Q==
To: Shawn Guo <shengchao.guo@oss.qualcomm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,  Manivannan
 Sadhasivam <mani@kernel.org>,  "James E . J . Bottomley"
 <James.Bottomley@hansenpartnership.com>,  linux-arm-msm@vger.kernel.org,
  linux-scsi@vger.kernel.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ufs: host: qcom: Enable MCQ support for sa8255p
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <aqyZKy1gMnHud4Vy@QCOM-aGQu4IUr3Y>
Message-ID: <yq18q4opwj9.fsf@mail.kernel.org>
References: <20260728051104.675088-1-shengchao.guo@oss.qualcomm.com>
	<aqyZKy1gMnHud4Vy@QCOM-aGQu4IUr3Y>
Date: Fri, 25 Sep 2026 22:38:13 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Shawn,

>> The sa8255p vops (fw-managed variant) was missing the MCQ hooks, causing
>> the driver to silently fall back to SDB mode even when MCQ resource is
>> available. Wire up the same MCQ ops used by the standard qcom vops,
>> so that MCQ mode works on sa8255p.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
