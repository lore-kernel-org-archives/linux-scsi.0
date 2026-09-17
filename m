Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E792931D5
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 01:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789609982; cv=none; b=bOsNAiOW0uIUZfP6KOtiVqIl74EA0VR6L1bfaZRNIqWCF29Pz23UCVl32NItPmTTxJa2UR6wBaCFa7ZfUaIIAJ4/IR7kjVmvrBQjFjacdBRNtvzxf6a++B5W4AzdiAAVCDMXSM1YiNMzvJ9NsNQ/MGgoBrP3hU9TVMjmVCmq6cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789609982; c=relaxed/simple;
	bh=VP/ABV4hGuwWBALeptv48BD7i9n4B3zAThApkAiSb/Y=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=cmXlrlJ+OjdJQnHl1ZSbKYhOFq2x0Wpw8otZsqSSDnLGue/bLq3b55uA6U8Fcfh2iQV807oTH6AVz0KctGhH9uYWPM6hFlyF/s82FybxWU2oC0eb2rk9BylBB9AYlRf7e1TIPn0iAdduO/iHPVFnrpKVykhUCtpYeLtVFB/l3Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lChcK3wC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lChcK3wC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AADD41F000FF;
	Thu, 17 Sep 2026 01:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789609981;
	bh=2oWrVpSkbUvH/WjbHttgS15nV3bGaO/xIVrAjTk3HoQ=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=lChcK3wCGXEhWXT619oPbOVRaNdZse6yP9SHzVph/UMIPJ7+oN32b95pFWbW0tmbR
	 SGDIAxjWuEmZBmFWhBbzJnI143+seNhG6zKwBSGkcbhfgJDrQVThu/IbbVkfKaGBy7
	 o4U885aqoTQRF+4ndlmBC9tD9JZhXJAsIcaEu+jxgxx7WImRO91R428lsRh/WWX0uN
	 aT59RdE65hcw7zzDUw/c0XijGmYsVBrbwQg5nZ4ThVIiiwll2FO92l9Ef5QoZFWXqG
	 hnbl6XHHbECiYxqjUSonvdMvOYR4ifzG0IZQoPd6HbIrpyLMcXMlYxfHnPEVv8Y2SW
	 sqextd/Up0BYQ==
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
  linux-scsi@vger.kernel.org,  Jack Wang <jinpu.wang@cloud.ionos.com>,
  "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,  "Martin
 K. Petersen" <mkp@kernel.org>,  Nathan Chancellor <nathan@kernel.org>,
  Lindar Liu <lindar_liu@usish.com>,  Kevin Ao <aoqingyun@usish.com>,  Tom
 Peng <tom_peng@usish.com>,  Sakthivel K
 <Sakthivel.SaravananKamalRaju@pmcs.com>,  Hannes Reinecke <hare@suse.de>,
  Anand Kumar S <AnandKumar.Santhanam@pmcs.com>
Subject: Re: [PATCH] scsi: pm8001: Fix SATA FIS offset in struct hw_event_resp
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <31963d53810f42970447e78ef46030ab13d2e91f.1788198434.git.bvanassche@acm.org>
Message-ID: <yq1a4pgve3v.fsf@mail.kernel.org>
References: <31963d53810f42970447e78ef46030ab13d2e91f.1788198434.git.bvanassche@acm.org>
Date: Wed, 16 Sep 2026 21:52:59 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Bart,

> In struct hw_event_resp, sas_identify was defined using struct
> sas_identify_frame, which is 32 bytes long because it includes a
> 4-byte CRC field. However, PM8001 and PM80xx hardware does not send
> the CRC in the event response frame, providing only the 28-byte
> identify payload.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
