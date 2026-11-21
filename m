Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795231511;
	b=L39V7x11CmXT+nMW4ecCX4tUxq62FiezdnIo0KCXM99TWbIgL5qx75p8YFGuISp7MIic
	 QOPiqRNRgt/tD8OyRJCYtaawmn9EXSuVuZzpTn04Gbh6Pzj7i5B+/rNAXGCLVjcd0y2kC
	 ZjnE+jFrZHd9h7R0t1b1Pbqb7mbhQQ837GPDVTiPlrgZ9V2bvfMJAr0oozGz/EhDvVdpE
	 PZOkS9/PXCHuPKZPzGaXG7BuxhejrGp2W/yvmoxey1cNjozuXF1mw6RW6cmCityvPAARq
	 269J0Z2PFa/SLa+phIqnVUXQ8YCE5cM4xdg/OwNF8DeTjJ9UecuRIpeaH1zF9F8vvwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795231511;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=Vrzvmhs2xGOQakquF51D4yM2qpY1pzLzz3vKEUHa5AM=;
	b=hi2in38Bn1fEY42Ok/UDS7zuQfFSfyNC6/zNpnOQN9uVOgrG9bctwI5Gn3uPJhVGRA6d
	 Q5ryfNsu70Qk9oW7q4g8hsfbjVpTy7xW59gPTMpxqSyRqQoalOADcQ/6nKbvO6Vz9BjLo
	 XJYpnbwGtMzHwf1S5bOSa+KDkPe4lfy1ALZ0u11t/ETqkOlQLP3mU2037ehq6Lg/P0CLw
	 zJvM0ugerqKyisGJixodr8WnPu7Gh3CKJNkcJnkGnXTPWjAhmpoO8hiTYQuWMFE6iUhtj
	 5A433e2XPjP3z49Q1Px+p/U4ctCAN933M6IBfIpMRN2KzPVBUWPA5kdGGBAo+vLAMsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="cS2g9/iR";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124A1606A325;
	Sat, 21 Nov 2026 03:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cS2g9/iR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A2471F000C6;
	Sat, 21 Nov 2026 03:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795231510;
	bh=Vrzvmhs2xGOQakquF51D4yM2qpY1pzLzz3vKEUHa5AM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cS2g9/iRXGSkep321PExLIT9pUUWyacWHJP/A9ZdGC52EefhY/cMYtiiphB/TnFYY
	 PGlw31v5V7AfpJg3dKNviY1roIMaVyWH5M/Ud52h3g1Yz9FktJyM5UGDXuIizyQifq
	 cOWz3ySxrbwrvSOmDf9tkROIFCSqvxE+VWJj7lMJUEds8L8f3NuYYAs8Gtu3TbzKLY
	 ZFmobKeF+kU8smzLdIF3N4/YTTN1ckNL6NVjHCVWiN9sTI+sVhigDECws8PH3JxlNV
	 eCWn56u8bMq6ugKvkBIXVSXt4JnM7Zvs5gQbhO0Nm9sdwgptA/uHM7QJhNWilUrhJ6
	 CZ3X5lBV4/dLQ==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	michael.christie@oracle.com,
	bvanassche@acm.org,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] scsi: target: iscsi: run the Time2Retain handler in process context
Date: Fri, 20 Nov 2026 22:24:55 -0500
Message-ID: <179523145633.420187.12194753573535044193.b4-ty@b4>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261117211346.2132827-1-yhlee@isslab.korea.ac.kr>
References: <20261117211346.2132827-1-yhlee@isslab.korea.ac.kr>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 18 Nov 2026 06:13:46 +0900, Yehyeong Lee wrote:

> iscsit_handle_time2retain_timeout() is a timer callback, so it runs in
> timer softirq context, and from there it closes the session:
> 
> 	iscsit_handle_time2retain_timeout()	<- timer softirq
> 	  iscsit_close_session(sess, false)
> 	    transport_deregister_session()
> 	      target_for_each_device(target_release_res, se_sess)
> 	        mutex_lock(&device_mutex)
> 
> [...]

Applied to 7.4/scsi-fixes, thanks!

[1/1] scsi: target: iscsi: run the Time2Retain handler in process context
      https://git.kernel.org/mkp/scsi/c/b30d7199af28

-- 
Martin K. Petersen
