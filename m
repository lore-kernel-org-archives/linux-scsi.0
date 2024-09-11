Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FD4143C6C;
	Wed, 11 Sep 2024 23:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726097009; cv=none; b=RJIvA6s5iqByfunlsOhuP1NoiP+2za6K0y2M1LB50qM7si+cwhmR0K5XmJp8ICLRIL1p3OqylvjU3iSTppfr/haqPL5o6hH6ZyeS5uO7Qwibkp16SV6htDw3qm6tKafgds0BIVUqBALWf/wVo6fQ2eV9545JJjx132JuIKzfN/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726097009; c=relaxed/simple;
	bh=fzeEecEtUpF8stRcCeg34tBgDLIrgkBerDWOvGLlTAw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sHWymRotqdiHIbfPAnqQXLhhHZFc0i1AMTddGcCve1u6a3Zoo+XbdCxNWbxWFSEWifM7xqIJaWrSdja27tdzuYkXSrwJaTjmQ6w6fAPLILiziiZ/y1WTYUK3oJsLzXS0dVNTPYWqhMQwQL9l0k+0fTZ8LvsVkvrwNgaFRlQ5DXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OBp+8AGo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OBp+8AGo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3828C4CEC0;
	Wed, 11 Sep 2024 23:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726097009;
	bh=fzeEecEtUpF8stRcCeg34tBgDLIrgkBerDWOvGLlTAw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OBp+8AGoYbgHyz5jGnBrKs+2Ckxn4y4gmUkpdURkvV/lxEPM8hysSxVND8MA2vhZ1
	 E6HxkFfKeF6dkQzXG7N4jVYmqZXJ+EdmM6inpuLc2NckAX9UBeH0Md73b/0NXfj4LB
	 qEnN24Ih5tJ2R8uDzGhSzvpHN1juoN2l1hIRhNumLyrgnUf2zH1QqBLvJ2ULbky4If
	 DWwhU/io570CA5Gj0zKSMlMj5N5KT5widyClG8rXLsTyLONfAL3aUvg0BIQdBLlK6v
	 hVRRn2PJ3805hIBUAksczDuW8+EoGUSYyX1WeBD1IXzM54plBsRt15J3OiVWoSYTy/
	 q47/6rrM++Akg==
Date: Wed, 11 Sep 2024 17:23:26 -0600
From: Keith Busch <kbusch@kernel.org>
To: Keith Busch <kbusch@meta.com>
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, sagi@grimberg.me
Subject: Re: [PATCHv4 10/10] blk-integrity: improved sg segment mapping
Message-ID: <ZuImbgYqqZzLZkho@kbusch-mbp.dhcp.thefacebook.com>
References: <20240911201240.3982856-1-kbusch@meta.com>
 <20240911201240.3982856-11-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240911201240.3982856-11-kbusch@meta.com>

On Wed, Sep 11, 2024 at 01:12:40PM -0700, Keith Busch wrote:
> @@ -102,6 +103,12 @@ int blk_rq_map_integrity_sg(struct request_queue *q, struct bio *bio,
> +	 */
> +	BUG_ON(segments > blk_rq_nr_phys_segments(rq));

Doh, this was mixed up with the copy from blk_rq_map_sg. It should say:

	BUG_ON(segments > blk_rq_nr_integrity_segments(rq));

Question though, blk_rq_map_sg uses WARN and scsi used BUG for this
check. But if the condition is true, a buffer overrun occured. So BUG,
right?
