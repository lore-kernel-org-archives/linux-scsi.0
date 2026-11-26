Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795664103;
	b=IhwEBg8uajbetSdtbBbexuGXfsbh7ObVnpE3MedfFQ4ZopU8wAzUStAKITLDMrSdGB5/
	 mJHV82EVzpJ1WJlBIeDRd871AArHAbqYVqcmeR5/owcXQLuTL4N1rmfS5r9uju85PVCUn
	 AzLWE26ypyD3oe3fya1uFr708SuCsNgJkHaE7VnjDZJv/3eFPtMW9KapE4/iexrYd1RrJ
	 3XPLY4QBoCgPJenVnuppCpE7NeF07JKsdl8gidOxlayqf4RaEApOUYDRch+kDPPnGeNkt
	 maCL+onrq6Cel/AyjFyrPPffeFa/6sP+aQMSvnPMkLJSxejMn/0RfTi1tvDDDLF8OuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795664103;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=UPukCNTK7zFhxllQcaE4LGdiIYNWyuXJusPGpDAU2OQ=;
	b=LiegTKnCDDLGNA7LSvF2sUxRdn3F6LHqhkJ9V52MfkuqtOHkK7f0qVoG2lvHD0Z15sey
	 U+kN7wKhdYffB2WIcDoYjpTEKlbsUDPrNtnaSo1zH9Xe/y0TNxWDvhCHx8+lKCBpf10NH
	 lmXbDiStBUEAl+oaGaW3Fwke1GVZCQdAXbmyilMBOKPjgu6jSjHpjIuIy1HGleJCB7Tgo
	 fNB//tOhLbXY7dtXp6G6hIGzVW25gjfsUHbnYwlJPO8gy+MwZPksGY5XYmkEoPJsaHG0J
	 M2ewvEGwdYjS0J3xKigk1UJSrzDAbsO7lLLI7g/tAalqjiReZS7W6H51hWMwX4LAy8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="iSc8v/p8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0BF7606A331;
	Thu, 26 Nov 2026 03:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iSc8v/p8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3416D1F000C4;
	Thu, 26 Nov 2026 03:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795664103;
	bh=UPukCNTK7zFhxllQcaE4LGdiIYNWyuXJusPGpDAU2OQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iSc8v/p8Iz2r7k0/xZltuC5wJC0iSSFO+OVfPXJu2koBjM7RtFT5NY2A228YjYr9B
	 RqubGeehyoRXKlUsdLZxvYA0IwsqSyOwBw8eHKIKZLFn6PhnN8tiEs5TWxg3zgiYSy
	 H+eNkV5+59TlZEVoZv5TpTLfhim+IKG0J3b5oNz64vdfQV/OtZxNgxaSuzkPVDPf/x
	 WgmNMLkfOKoKwryZIvzyKjWQt/uStWZeTWg1xmOofldHoN674Ba26tsZZpwffNtoeB
	 quejQK+5QUliCw8anAdq45/ZwPtw6ovEnBNMm8WvMijMcavnuN1GqMLi/u8W/YGSl+
	 2/pI+Sjt1oCDw==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Jack Wang <jinpu.wang@cloud.ionos.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Ian Rogers <irogers@google.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	Elkin Cruz <elkin@google.com>
Subject: Re: [PATCH] scsi: pm8001: Fix abort completion status in pm8001_mpi_task_abort_resp()
Date: Wed, 25 Nov 2026 22:34:48 -0500
Message-ID: <179566062794.467514.1304420493773676333.b4-ty@b4>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261119170905.1530613-1-irogers@google.com>
References: <20261119170905.1530613-1-irogers@google.com>
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

On Thu, 19 Nov 2026 09:09:05 -0800, Ian Rogers wrote:

> In pm8001_mpi_task_abort_resp(), the IO_NOT_VALID branch assigns
> TMF_RESP_FUNC_FAILED (enum tmf_resp, 5) to ts->resp (enum
> service_response) instead of ts->stat, leaving ts->stat at 0. In
> addition, switch (status) has no default case, so any other non-zero
> firmware abort failure status leaves both ts->resp and ts->stat at
> their zero-initialized values (SAS_TASK_COMPLETE and
> SAS_SAM_STAT_GOOD), causing sas_execute_internal_abort() to falsely
> treat a failed abort as TMF_RESP_FUNC_COMPLETE.
> 
> [...]

Applied to 7.5/scsi-queue, thanks!

[1/1] scsi: pm8001: Fix abort completion status in pm8001_mpi_task_abort_resp()
      https://git.kernel.org/mkp/scsi/c/fac36816b057

-- 
Martin K. Petersen
