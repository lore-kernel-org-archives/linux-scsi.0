Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0AAF285419
	for <linux-scsi@vger.kernel.org>; Thu, 26 Feb 2026 03:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772077035; cv=none; b=Y9IrAw/WWmwnSF0R0d8DoIE50tRDejZKMb/uWAMzunP4TZ6cqSBMJRsMmbjdaqcpMwaVnBgKCJZwDkmhVp57GB/wK1/PhZLcBrHVQi/5CFaPxHQUTq1uC2VdmL/1vTi0eY2U3TFNv6twdLMErvP9sqSzGpOaeXUYbzGWWl5/muM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772077035; c=relaxed/simple;
	bh=2NoCN6+mTCZfckAbUadVoYxFffzxni/k9obOl9HI1y4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iipXko0QJzpaQRe9v+qRZhvpJC8SJZzARgn5n9dG4xU2bz03sSonvPOkJa2Di8TJWyQQ6tgkUiHL2bTIxRwYx/dvWhnI02bcCc2wINJsHS4V/xgkexwYaFbF6Kd5Ms6NXaXGrYnNzzAKOWojE0EyNzx2fjhlk24WtG0Ve/PIU50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Js00sw4f; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Js00sw4f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772077033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bkLc+GDTQrnsggrpWJFZMbOK/80PHJQs/QIq3lF3I4w=;
	b=Js00sw4fef6sg7jEVkaHQPxIl54HgfxWfJxFFdAYqFkhdVtadgOY7ReEbjp+0387Hl0m7u
	hW+4ePiWPdpCfVIzws1QfPK5uunXuojDRzs5ZTsWbwI9SQ55p4tfbDKZG3Uu6kvC+yX0dt
	8NME8lbqV/TR6I4YWL+j10cbcBXk4y8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-553-st2cy_XBNqSdjq7AuUSX_w-1; Wed,
 25 Feb 2026 22:37:09 -0500
X-MC-Unique: st2cy_XBNqSdjq7AuUSX_w-1
X-Mimecast-MFC-AGG-ID: st2cy_XBNqSdjq7AuUSX_w_1772077027
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 304EC19560A3;
	Thu, 26 Feb 2026 03:37:06 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DE9641800465;
	Thu, 26 Feb 2026 03:37:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 61Q3b3hQ1680267
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 25 Feb 2026 22:37:03 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 61Q3b33W1680266;
	Wed, 25 Feb 2026 22:37:03 -0500
Date: Wed, 25 Feb 2026 22:37:03 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: John Garry <john.g.garry@oracle.com>
Cc: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/13] libmultipath: Add path selection support
Message-ID: <aZ-_3_hXEkFEClhs@redhat.com>
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
 <20260225153225.1031169-4-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225153225.1031169-4-john.g.garry@oracle.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Wed, Feb 25, 2026 at 03:32:15PM +0000, John Garry wrote:
> +__maybe_unused
> +static struct mpath_device *mpath_find_path(struct mpath_head *mpath_head)
> +{
> +	enum mpath_iopolicy_e iopolicy =
> +			mpath_head->mpdt->get_iopolicy(mpath_head);
> +
> +	switch (iopolicy) {
> +	case MPATH_IOPOLICY_QD:
> +		return mpath_queue_depth_path(mpath_head);
> +	case MPATH_IOPOLICY_RR:
> +		return mpath_round_robin_path(mpath_head, iopolicy);
> +	default:
> +		return mpath_numa_path(mpath_head, iopolicy);

When we're in mpath_round_robin_path() and mpath_numa_path(), we know the
iopolicy, so we don't really need to pass it in.

-Ben

> +	}
> +}
> +

