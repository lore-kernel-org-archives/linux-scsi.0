Received: from fgw20-4.mail.saunalahti.fi (fgw20-4.mail.saunalahti.fi [62.142.5.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAA44E73B2
	for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2026 15:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783987; cv=none; b=S3d+s214srLuKjHFhPIaiIhA3Hfr4WeDB3tA2vfUIOqARJT0UJVHhAv26omZhpV2hu3GpUeX1+9V4c1EQL65YHSwRrreyhlp8XMUKdSI+WqJMKtSJvB9FsuMKLDfkItlqejsP8LGsqtHcufrqQbB2/DRyBZ+7zmNvf9fQ1BhClU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783987; c=relaxed/simple;
	bh=g7Picei7NVF5yRnJ9+++aOz1/JYCC0VksuNv8ysk790=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=VrCrPCYQm1Gnb40O7mLX9MYr/VgQ7pBmiIlLmVivGanY3fsul2V5hzwS41DEGMRsVI0ibEiXNMXXIfggmoK0Ay5ihJr8xqB2+Y8Uia3lzDpd7FePOSkBFf4BOPG2d3APDQ/QW0KdX/was1fSC0tlMfO803r/WILzgOJyLpngoEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=cJ62/vo+; arc=none smtp.client-ip=62.142.5.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="cJ62/vo+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from:to:cc:reply-to:subject:date:in-reply-to:
	 references:list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=g7Picei7NVF5yRnJ9+++aOz1/JYCC0VksuNv8ysk790=;
	b=cJ62/vo+LZPZqSCQt6C+DunIq+5hzcABs7/iGrJx9We6QkxhrVeS++lmwDjWgvdSMIOi03f2thWrh
	 tcu0yu/SoGvQVE2dcO+fEntp5crLd4JFDmQLHZdZ93QkjTXObYaBGuPKskOumXfvc/FY2kNb7OAtNS
	 50etqRuV62gLyU/J10KDVYqWIChA7u1NBU4x0g5b/WLE9LyM0TFxyS0LbM9hzf4bgNWx26wgmLxA24
	 RyhAbaT0fVYHEcJJ8Kj5NFTZclapXsscEmyhTzD0WUg58jayWI5Y1nS86M5bJYnK0hmh32P6+PfAC/
	 NpFqCKAeS7v2Z12j76A42dNv71aze3w==
Received: from smtpclient.apple (91-158-174-119.elisa-laajakaista.fi [91.158.174.119])
	by fgw20.mail.saunalahti.fi (Halon) with ESMTPSA
	id c3bd98ff-bce7-11f1-9563-005056bd6ce9;
	Wed, 30 Sep 2026 18:58:23 +0300 (EEST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v4 0/4] scsi: st: Restore drive settings and state after
 reset and MTLOAD
From: =?utf-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVtYnVzKSI=?= <kai.makisara@kolumbus.fi>
In-Reply-To: <20260929192821.997675-1-loberman@redhat.com>
Date: Wed, 30 Sep 2026 18:58:13 +0300
Cc: linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <mkp@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 John Meneghini <jmeneghi@redhat.com>,
 emilne@redhat.com,
 bgurney@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <E85E5AC9-9162-41AC-9536-0D98843A96BB@kolumbus.fi>
References: <20260929192821.997675-1-loberman@redhat.com>
To: Laurence Oberman <loberman@redhat.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)



> On 29. Sep 2026, at 22.28, Laurence Oberman <loberman@redhat.com> =
wrote:
>=20
> After a device reset st blocks tape access until one of MTREW, MTOFFL,
> MTLOAD, MTRETEN, MTERASE, MTSEEK or MTEOM clears the reset condition.
> Testing the reset handling on scsi_debug and on IBM LTO drives found =
that
> several settings and parts of the driver state do not survive the =
reset
> or an MTLOAD.
...

Looks good. For the whole series:

Reviewed-by: Kai M=C3=A4kisara <kai.makisara@kolumbus.fi =
<mailto:kai.makisara@kolumbus.fi>>

Thanks,
Kai

