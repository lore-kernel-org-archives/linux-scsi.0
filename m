Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE49241E4;
	Fri, 22 Dec 2023 16:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="M7xlX1Mr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2FDOW+3+TDRLXOzIEQkltc11UaDDT4Rh+Z5GwJAlFHo=; b=M7xlX1MrgGdcrlbmtcelj6k4Uu
	Ro1Ax1OdCds0mPQw1Cv++MOErDQGGRZuLTh/VlDKfbzgBHjKaeTYDwX/Swk2lMRAJwEHuaMHZRx8W
	lgE9rk8Yrs+fqAp0eJg0nOFsyXwoJTNq9zwOfnEMV+jnsJXNpmxwN9RuQa7mvEUvHl56MTTNSg5Vz
	ibdkQnZAi3n+/DStTbBcQ8dw/MsZ7u+qqYw5wAxEfZWEIPWtaEJC4aNFj52dYvAlQaLxp4hkOsUIq
	6CV/IwbKuoDHb1eaYtLIB8MibMEy4D2rC31iOv3CbuXnaDHktvytm1Fi1tBX4hfX4pItOsuXoEk2r
	wLfjKIcg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1rGi2K-008Qjo-Oi; Fri, 22 Dec 2023 16:06:08 +0000
Date: Fri, 22 Dec 2023 16:06:08 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Keith Busch <kbusch@kernel.org>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>, lsf-pc@lists.linuxfoundation.org,
	linux-mm@kvack.org, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [LSF/MM/BPF TOPIC] Large block for I/O
Message-ID: <ZYWz8K98YUGf/VZp@casper.infradead.org>
References: <7970ad75-ca6a-34b9-43ea-c6f67fe6eae6@iogearbox.net>
 <4343d07b-b1b2-d43b-c201-a48e89145e5c@iogearbox.net>
 <03ebbc5f-2ff5-4f3c-8c5b-544413c55257@suse.de>
 <5c356222-fe9e-41b0-b7fe-218fbcde4573@acm.org>
 <BB694C7D-0000-4E2F-B26C-F0E719119B0C@dubeyko.com>
 <ZYWm_tMtfrKaNf3t@kbusch-mbp>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZYWm_tMtfrKaNf3t@kbusch-mbp>

On Fri, Dec 22, 2023 at 08:10:54AM -0700, Keith Busch wrote:
> If the host really wants to write in small granularities, then larger
> block sizes just shifts the write amplification from the device to the
> host, which seems worse than letting the device deal with it.

Maybe?  I'm never sure about that.  See, if the drive is actually
managing the flash in 16kB chunks internally, then the drive has to do a
RMW which is increased latency over the host just doing a 16kB write,
which can go straight to flash.  Assuming the host has the whole 16kB in
memory (likely?)  Of course, if you're PCIe bandwidth limited, then a
4kB write looks more attractive, but generally I think drives tend to
be IOPS limited not bandwidth limited today?

