Received: from cvsmtppost06.nm.naver.com (cvsmtppost06.nm.naver.com [114.111.35.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95005391E7C
	for <linux-scsi@vger.kernel.org>; Tue,  6 Oct 2026 09:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.111.35.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791277915; cv=none; b=NzFHkXSlC3D/+6raqDEDdlvdrEECRUAY2MWoZSF2uzNv0nqm7tAOlwSoJIKsSSj0xQzc1YD/73pZXYx0O7YHBxRUS21oXFeeuUSCFc9pWaheq2QkDZdNVTRVQAzgMtn1Lccs412h+FJ1MC8rROXO9tJZYEdOP3WCvbfKu8c1oKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791277915; c=relaxed/simple;
	bh=r7GWK6joItOg6Ntv0ykmRQ+Tls4D1qhGwDu9d9IJOXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gc2c46cSNKYSTWHlfAjmKZzqE8AZbSpf2/42siEnT5jjSXWXlfg0LnK1zlJoje8ujjnBDCQgJpz/oBW+2py2m6MAyq9fXrQKn1s1+uCJP5SX8z1eGSh6MxdSKSJi+lHmjiCA8upcS1eeusdvd0uUD/0iK483r4Q8g0xG/qBQZOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com; spf=pass smtp.mailfrom=naver.com; dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b=UXs19Q9L; arc=none smtp.client-ip=114.111.35.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=naver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=naver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=naver.com header.i=@naver.com header.b="UXs19Q9L"
Received: from cvsendbo010.nm ([10.112.20.44])
  by cvsmtppost06.nm.naver.com with ESMTP id zduQChuEQy6l51dj++OfGA
  for <linux-scsi@vger.kernel.org>;
  Tue, 06 Oct 2026 09:11:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=naver.com; s=s20171208;
	t=1791277906; bh=r7GWK6joItOg6Ntv0ykmRQ+Tls4D1qhGwDu9d9IJOXQ=;
	h=From:To:Subject:Date:Message-ID:From:Subject:Feedback-ID:
	 X-Works-Security;
	b=UXs19Q9LeU67sqtFr98u1XjzOHd7hJhaxuWAUXcktjfC71RbcufPON5kEvOsyfPhw
	 xt4weK6zXKUAEA606ZAJ+6oDqDwSvGhnAcuvxErqDv9rnzP+LqGxrISa0RXUerbIfG
	 VBWX7hyuLuKbiURRsYRkJQX94WpxTnaDEEH2jY3G1TyVwRMOIOaIPDLiA4KJmApSVK
	 gkD54DnJYLcybZJTW2lVQwMS5LcYdOtG4u9dMmyy9LQGy/W1of41pi//+hVqzOxXGV
	 wpCeGPDUSzW6szUCB1rExEENWpC0ht09gXtzwM/EtzIaFPOWJtsL7Q00VIPFRO9bAe
	 oxkbldF7Pl+dw==
X-Session-ID: kaYUNaXsSC24pT6O6xNBew
X-Works-Send-Opt: OsFwpzGdjHmdKHFOMr39Ko3YKHm/jAudFqM9KqMqFxIYkEljxBmwjAg=
X-Works-Smtp-Source: /ZYdKoulFqJZ+Hm9KAE9+6E=
Received: from localhost.localdomain ([115.136.205.4])
  by cvnsmtp008.nm.naver.com with ESMTP id kaYUNaXsSC24pT6O6xNBew
  for <multiple recipients>
  (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
  Tue, 06 Oct 2026 09:11:45 -0000
From: sungbyeongchan <tjdqudcks0424@naver.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowangio@gmail.com>
Cc: linux-scsi@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	security@kernel.org
Subject: [BUG] scsi: short virtio-scsi VPD response exposes stale heap data
Date: Tue,  6 Oct 2026 18:11:36 +0900
Message-ID: <20261006091138.827988-1-tjdqudcks0424@naver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

I found a stale heap information disclosure in the SCSI VPD cache path
when a virtio-scsi backend completes a short data-in response as
successful.

The backend first declares a 256-byte VPD page, then writes only the
four-byte VPD header.  virtscsi_vq_done() obtains the used length from
virtqueue_get_buf(), but that length is not propagated to
virtscsi_complete_cmd().  With good status and resid=0, the SCSI core
accepts the device-declared page size.  scsi_get_vpd_buf() allocates the
cache with kmalloc(), and the mode-0444 vpd_pg80 sysfs attribute later
copies the unwritten tail to an unprivileged reader.

I reproduced this twice on commit
ff47652a4b66c067c765a7ad464d930b5a9367cc with a local
vhost-user-scsi backend.  In both runs, uid 65534 read 252 stale bytes
from a reused same-size heap object after the four valid VPD bytes.  A
normal full response returned only its valid data.  Reporting the short
transfer through resid prevented the stale marker from being returned.

The demonstrated impact is a bounded guest-kernel heap disclosure to an
unprivileged sysfs reader.  I did not demonstrate arbitrary read/write,
code execution, host compromise, guest escape, or privilege escalation.

As a minimal disclosure mitigation I tested changing the cached VPD
allocation to kzalloc().  The malicious fixed A/B returned a zero tail,
and the normal VPD control was unchanged.  This mitigation prevents the
disclosure but does not make virtio-scsi reject every inconsistent
used-length/residual pair; maintainers may prefer to propagate and
validate the actual transfer length instead.

I performed a best-effort public duplicate search through 2026-10-06
and found no exact public report for this short virtio-scsi VPD response
and sysfs disclosure path.

This report was prepared with AI assistance and is being treated as
public under Documentation/process/security-bugs.rst.  A tested source
reproducer, backend, logs, configuration, and proposed mitigation are
available to the maintainers on request; the reproducer is intentionally
not attached to this public report.

Assisted-by: LLM

Regards,
sungbyeongchan

