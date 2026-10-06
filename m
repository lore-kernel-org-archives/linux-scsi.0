Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14DE12D77F7;
	Tue,  6 Oct 2026 02:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791252576; cv=none; b=MR046hNbJV/YDYR/pzYP0WumsSQL8V4p5E6Jm4rXPgPlT87mMqZjkaeYTvEO4Kuu1SXYC85iWHF0IZh0m8zowCXh7otREEroqSP/0UYxgX6zgHHSma2D3uBqq5XrcuWz1f8dEj9m6EOKPKpWjianC4r2pmT0qGg+KEoPOGdwzJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791252576; c=relaxed/simple;
	bh=mQ4RypGE4/q/eosvDgY8EVCunTE2zZt3nJ7yUdoVzyY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=Xd3TgO5bNlWBn0GTlAdkswwJKFX2E5t1cZOQ4uUk5oqU1seeKJrXwidv7woG0abfb25/fb4A7nPDE+MQu4iE2xYQXqq34oy4WBZ5aBcF9Rm+7qZNJu25gAZChNMS5mjJOnA5lxmujXQfQUZrqGcdjGv0G4GsBFdrCJjhfcj8Fu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mSEh7mWd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mSEh7mWd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D5BB1F000FF;
	Tue,  6 Oct 2026 02:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791252574;
	bh=p0c2foeYpRFuVvhXJiSQQD3PlhLRXKwovVGVGGn6NLE=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=mSEh7mWdBcTKHRELmiIRmyB5tI2/H6s/Pztx0/Zsi5LO19bt3bOXD1D9PSzyGrwuh
	 UaykVhbNSZ+yMdcCXPV4i0jTnN5Wox9N+eCvsE7eNze4RmOAeD7aplf3CB3cTBbuKQ
	 Ak+qxqmfSrkr++lU6WnttBtnRojEXT55jTaW8FxIi/PX24sB1RTe0pb3y7yQgZJx7t
	 4pecfJEGMyBxx5CetiJV8i6QSntFLFUgOaovEeaeqn0QvYy4zVPA2j/TbfWOcS8Uso
	 WNNMOzNDXKbSg5yubnn6LFlW0WItBUsbT+1QQ6zUyp23QS7aiC9hQTS2V3MAtTZ7D9
	 eaL26EscKIZlg==
To: Stanley Jhu <stanleyjhu@google.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,  "James E . J .
 Bottomley" <James.Bottomley@HansenPartnership.com>,  Alim Akhtar
 <alim.akhtar@samsung.com>,  Avri Altman <avri.altman@sandisk.com>,  Bart
 Van Assche <bvanassche@acm.org>,  Bean Huo <beanhuo@micron.com>,  Damien
 Le Moal <dlemoal@kernel.org>,  Jorge Ramirez-Ortiz
 <jorge.ramirez@oss.qualcomm.com>,  linux-scsi@vger.kernel.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: ufs: rpmb: Fix power-on UNIT ATTENTION retry
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20260929140806.2859367-1-stanleyjhu@google.com>
Message-ID: <yq14iezk2ay.fsf@mail.kernel.org>
References: <20260929031352.1355691-1-stanleyjhu@google.com>
	<20260929140806.2859367-1-stanleyjhu@google.com>
Date: Mon, 05 Oct 2026 22:09:33 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Stanley,

> A merge conflict resolution dropped SCMD_FAILURE_ASCQ_ANY from the
> retry added by commit a8a34238e5e6 ("scsi: ufs: rpmb: Retry power-on
> UNIT ATTENTION on the RPMB WLUN"), so only 29h/00h is retried, not the
> other 29h ASCQs.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
