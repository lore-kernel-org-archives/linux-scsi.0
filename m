Received: from outbound.st.icloud.com (st-2006j-snip4-3.eps.apple.com [57.103.76.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC5638B124
	for <linux-scsi@vger.kernel.org>; Wed, 19 Aug 2026 03:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.76.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787109825; cv=none; b=pXSR44pHsJGCKLgk6Y2xM9iLU2AZxafdZXf9cT2XUAFcOTakrgJWJO9+qfjxpyA8S8JdjxWEntvaru9XxvcJ//8Hyoh3IrJoeTk5iXt7jAb0gjkC+oU8d1N+aW/Gq2crJt1QspZo2vb13gjHf/INoIwvCH+RVxxGe+k7o3RoZro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787109825; c=relaxed/simple;
	bh=ylJxSml66eSdEcWFnt44RyzT2km06LqKisxCfiubXos=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YuyhaBpNiLx7/3UMfrZ2zvy0LZDvqvw/M3xQK/86mlchlF/TEQk4PHfPc5vOIpAYDC7t5wEeQGKPisG2waNPnBLK/q1KGL7ty6gcoGcXqUJr8g5g1DHFOpYbwD7HFWMWWZT3Rlhxe19xPsMXtH7mEQgUYFwJK33dvK5T1gmUAiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=OcCQCpXj; arc=none smtp.client-ip=57.103.76.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="OcCQCpXj"
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-4 (Postfix) with ESMTPS id 40BFF1800117;
	Wed, 19 Aug 2026 03:23:42 +0000 (UTC)
X-ICL-RepId: 01a0180b-cef1-748c-a13d-959704ab168f
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhKC0MFWgNeC00HQwZdBlBcHA4IRANTEVdKA14GK1sTVRdGCRkIXR0ZHldQXgheH0wcHQ5YBhICWkUETV8OXh8EF0YZVQRHHl1WQBkZAlEcVg1XQ1QEX1BJDEFQbFoARxdIHV0ZWW9QXRwOBFQHXQVdVlACWktfGV1FD18HWQRAAUkKXQRZAUIIVgdUBFwGRhRJHghEA1MRV0oDXgYrWxNVF0YJGQhdHQdYRxRHDg8ZWhRcGFM=
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1787109823; x=1789701823; bh=A1QpEVx2b6+aa4ylMexU8jRm255JWvlShN3Aa+0+5l4=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=OcCQCpXj1JW5D5mepvO2codG6tYZD1I88OS1PdxNDFrmcdpvh7V1Eo1Tfea7r3/eCGt0SMJdjKMdgygY5JNRFBNl2gPwm2lAdDoSMkzMyaPih51thzzHTDoj0HWG31HAgy9L/GmJt8J4+1UjzVGAOrd4HQuKwbKnwe8Qpa0gLijLYdXK+rP9gPD9llNubMSHFqv4YSAmsj8/soY/+hGTfJnZaDIAvpx8A50KiIVhjTRqz9and52HJHGOR5s93r5uuv5VHRuoP+rFmdAmZ2h3cFdq7Y6LPSK99qUj0ZEYc3BZiDTEIUhz+JOwo4thzx/9/fQmj0pNCI9fACkVn+VGXw==
Received: from machine.resnet.purdue.edu (unknown [17.156.216.30])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-4 (Postfix) with ESMTPSA id 53AB918000AC;
	Wed, 19 Aug 2026 03:23:41 +0000 (UTC)
From: Eshaan Deshmukh <eshaan2031@icloud.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eshaan Deshmukh <eshaan2031@icloud.com>
Subject: [PATCH v4 0/3] Fix control flow in sas_ex_add_parent_port()
Date: Tue, 18 Aug 2026 23:23:18 -0400
Message-ID: <20260819032321.493746-1-eshaan2031@icloud.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: LQvDOUylx1PXj9H-FFSn7ucTBZ8nLp4A
X-Proofpoint-ORIG-GUID: LQvDOUylx1PXj9H-FFSn7ucTBZ8nLp4A
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE5MDAyMiBTYWx0ZWRfX5fC7RJkSXs9u
 e9rxyM2lnvZDbiT6trT+WerMZBrfgEwjjLe+RbzvvrA/q5GMowzgmG8KBi+bCA5i17S+TTfqXzi
 HMAs2F0haAFRSUbYzQz31N066qxvjSc3mPxZxSbdNrKZi4vGSAHb2aNzq8KYeJYGA0lT1Hzl/WW
 MH3p/v8SreU5zvVAVg/V77tCC0gRM2R+tEd+lWR5rj3rahXyc4FmnyDIonc9T/IDXZPiIO3GbNP
 cCxGODFdJOFNGmx/47fKkAIUe0PCZ9FcBjZNl1Pwx4rp7LB+IAVb8fhq48DzNcHiFTdmnHdHClZ
 6aOwk781Dh0/npyrgC5Qap4WzSfwyEyc+BgDmB62hBjd6GYyx0mSNMDq4Jx5rk=
X-Authority-Info-Out: v=2.4 cv=E9/AZKdl c=1 sm=1 tr=0 ts=6a8521bf
 cx=c_apl:c_pps:t_out a=oyWFxbOnq+dmhQrAPgaJYA==:117
 a=oyWFxbOnq+dmhQrAPgaJYA==:17 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=ea8ixM18I5MA:10 a=VkNPw1HP01LnGYTKEx00:22 a=-oGykA3_1HC3A3QQqTgA:9
X-JNJ: AAAAAAABDHEdfqArtBjUK5FFV/El34pPyA3GCdrzj0HeO0Pi7wdwTbWF9/my3P7LgyCl9ftqJwBnUCGr3uIsigDclIPPUbX04UFc1t66A1mb8PMUWj4OvxbUfJw2RNeTa2gFBZ4Tdv93PLUlzmYWMReLogvkjosillhRXuklX0a9zlES6/QvvVV97VaXs5oOgQq26yLABpNFGP/7hRzMNbyjxvB93UDJJ6nWSFmShCI31wYphFlcbXMAzTG+FmcNtnZv5mozk+YO9F/Dxm4lKNZxGuM4u/bm7ycNFjVpbxmg2zjvhMlBjfXie5rn8yj3BWMJom1nTq6ylt2OYcJGpdLn9JaY3WPOgNnBUvZFJjfwdYE6vVmsUVBdpIDgyiRrw3U9HKzPfXdAYQNYLytoICxqhQoUSYwgJn3wihZrTX6q5Wy9HlEKztdtCRo7nZpKjNjdU/5XpqEDpfI1L75lumqhsQ4EhizF9BhsynjKrxrSoM0TRaBqrK5NOS4aDkr8PNR90hI2BOnvkTZeKTEutEihcBLjjGpLMB5HXmhlNsKMDxOHiFNwe2hNGaG2C/WsSvPl74PckmYmkiWOYD9CYCSlPuHzFYXPb18PYmRKzknANSJn19WS8V0JsKsnuJ0yXIXpr8kFxB8aGe6BUO1Frm1DFE9opNq49jM6PQ0Oo66C50/fRWQVXfGdAWsOjUBWXz1f14OI99UUYUEFPd1XQ/Dh8hVPUt2mg1EA49/8tYCsuPqEKvPNUs1KjQbaXukN4ffN2GL1oVHfRxrVjjYnRZlLP7I4fzWhfoENh48EsZzbjS+rxKFxsElThUD6xBfdOE5HNEmqqSCWmLuW+2qQM07bYWfsVrSo5oeClsTgX41FIDX6h2bOA/XFtv0gHV5QqqGREOY1G8fxPE6ZC8eHw5bedHiaq+kBx/43D0QuacYdSJ8XbzJklw1O/HQnScOUjrTkp1MZMlE3xuT53l+yGjnFkCC058I
 IZqozlRFSiOQWgCfUOv6e3vqCOOATnuYf0IM3lBO3WiZB+SN8U1tc+xjB4Z/XlGAiHj7r59exn43qNbEVj6qTg8NNq919vxukUr8gY/7ytYO0ndtc2JXMH7hljn4SqYnC0xLaG+gDWOwo30Vwr4izp/X68bOXqpc8ZD2HkfClGF0dXQ1MksAgK9DuwNOIbb/JXePCdX56jH0FHhP5xdYOqJWG01Kj1c4rSeRjy6BrUGtTZSoubD7uILycPUdf5glJUq0il9Ae3SQsqS5s8AiSFze11mMD5iDU

Fix label control flow for the function sas_ex_add_parent_port(). Remove
labels and move the code back to their original places.

Eshaan Deshmukh (3):
  scsi: libsas: Handle errors in sas_ex_add_parent_port()
  scsi: libsas: Handle errors in sas_set_ex_phy()
  scsi: libsas: Handle errors in  sas_ex_discover_expander()

 drivers/scsi/libsas/sas_expander.c | 75 ++++++++++++++++++++----------
 1 file changed, 50 insertions(+), 25 deletions(-)

-- 
2.55.0

