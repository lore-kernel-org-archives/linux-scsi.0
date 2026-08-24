Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818C349362B;
	Mon, 24 Aug 2026 02:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787537757; cv=none; b=Me22DnreX1dDZL8d3BosxnR4O3EoMgXIIw/GHpZmkaVuTkq4Bu0Y1uguHz3yqE/z1ZJ7jtRHY+NjTRc/Q0bC7FWrBUXN00rKn++T5pmk48uoXxnvc2lFhisQfftTzOWozaTENKBbSZ6U9BMWyyuk9ditJRZqIo9sLzwjz8Eze0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787537757; c=relaxed/simple;
	bh=k9sUFuvFMOl8ZXUcTmdxb6GnD5luKwWY/PgGBH00+e4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=TTx7dCGBy/+D7UgkJmz620dlVm/2KDIqwAOsWTBkekJrjEgwsMpuRSQyRMLp0ZlbR0l+T6gkUT51jQWkDoWkXdq0AQ+9POIx9uk3IMe7cNs61jGzfhTRgyMC9CtcQHQ4GfMNccwVvSK7qI4qwqqBQ27oGaxxbu+sQHat6ziSHLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VTV8UUeR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VTV8UUeR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C146B1F000E9;
	Mon, 24 Aug 2026 02:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787537756;
	bh=C25YMGrGsmckspMXFyPm3h4b6WibrKz9jRhEOjvTQaI=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=VTV8UUeRm9stw6DjOkwdVR1TPV5DZOT3IlvT5Qa7kVMORKDSlqHWVK8YQYCVMtMWl
	 xBpDebAIUa5bA82t1WJx46w8cRWvGrbklzUe5RySIIU5z6JrOLXKgnp77m0Qf+dGLo
	 kPCB3DFkBmWpoJsBlpdETJ2xZotvrnM2Lb/KzMv5RFqPVikJHj08MKSANSWBo5g2H9
	 4PG4iCkSaTYbKcqVq51nk2IK8eXhMzTamX4lCZdDdqwNBZvthHJyP5iZGhUvZH19Wq
	 xyUVuyc9FlCi+hOr3ySjBC7Ph8nkIIxpXg+wWigOARxGL4ix+g7JZP5hDcRfEAI3G4
	 DE9GfwoC04WuQ==
To: Chen Changcheng <chenchangcheng@kylinos.cn>
Cc: <kartilak@cisco.com>,  <nmusini@cisco.com>,  <sebaddel@cisco.com>,
  <ames.Bottomley@HansenPartnership.com>,  <linux-scsi@vger.kernel.org>,
  <linux-kernel@vger.kernel.org>,  <ccc194101@163.com>
Subject: Re: [PATCH] scsi: snic: Fix scsi host leak on workqueue allocation
 failure
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <20260727073438.209673-1-chenchangcheng@kylinos.cn> (Chen
	Changcheng's message of "Mon, 27 Jul 2026 15:34:38 +0800")
Message-ID: <yq1bjasnu0t.fsf@mail.kernel.org>
References: <20260727073438.209673-1-chenchangcheng@kylinos.cn>
Date: Sun, 23 Aug 2026 22:15:54 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Chen,

> In snic_add_host(), if scsi_add_host() succeeds but
> alloc_ordered_workqueue() fails, the function returns -ENOMEM with
> shost->work_q left as NULL. The caller's error path then calls
> snic_del_host(), which returns early when !shost->work_q without
> calling scsi_remove_host(). The Scsi_Host remains registered in sysfs
> as a zombie device even after the probe has failed. This causes:

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
