Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F6A1C1AB6
	for <linux-scsi@vger.kernel.org>; Thu, 14 Nov 2024 01:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731549267; cv=none; b=b90rTQ+ul8rAIK+lotQ1qiiPybxr8BDlM+aYEcFKFuEv/ATjVenZnRP94gcOKBqBp0VjIqtNnRncyIKgmnRfqhcDURUUMxd2ioCxXep5LY/8+/PB8ceMw/2iXvMOf7k4HKQzEitU6oWRCcMPJsmt6kee8xD8RwOvBXPFudZ3CSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731549267; c=relaxed/simple;
	bh=vmFtAgYAC3ih8oQubzav6OADI0tAlUMd9HfmGqdzdBs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E7fFBXWXrNHDo/GeQLywgc9l48OdQOEiV9uQdSwCXbpege4vUuKTj3sSWGEippz4N7lHxleXm1j6ktQzDaqtk23l/DG5o0oR+PfOeQH8xWDYznCHJvOPzY4R6H6dK4ShzpL9WuFxh0TA4LjE96jcQ77CN9lhLyTEyk4vKkKfvWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PNYj6Bbd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PNYj6Bbd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731549263;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iPEBI9PDOju2MBvGQMSSVZLa6nuW9DvNY9/cM/alX4c=;
	b=PNYj6BbdcOpyOms8btXN7DAQvG/X9lXyKHJBv3q0cnWv4s0Rtv+HdhYjc9llug7pGFA4a7
	S27x15VrQ2Xum2XPoXtu600YOFSN9bwjl1EBlwRLjDDKRfUOVD+bjMumP9QDeQacIf5mXc
	EwuSYdQ3qZO2ZNSoonYemDt8wxO0NIk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-587-fL807C5WPemKmCPt940ZEg-1; Wed,
 13 Nov 2024 20:54:20 -0500
X-MC-Unique: fL807C5WPemKmCPt940ZEg-1
X-Mimecast-MFC-AGG-ID: fL807C5WPemKmCPt940ZEg
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 39C271956057;
	Thu, 14 Nov 2024 01:54:16 +0000 (UTC)
Received: from fedora (unknown [10.72.116.113])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E4EDF19560A3;
	Thu, 14 Nov 2024 01:54:02 +0000 (UTC)
Date: Thu, 14 Nov 2024 09:53:57 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Daniel Wagner <wagi@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Bjorn Helgaas <bhelgaas@google.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	John Garry <john.g.garry@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hannes Reinecke <hare@suse.de>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	virtualization@lists.linux.dev, linux-scsi@vger.kernel.org,
	megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
	MPT-FusionLinux.pdl@broadcom.com, storagedev@microchip.com,
	linux-nvme@lists.infradead.org
Subject: Re: [PATCH v4 03/10] PCI: hookup irq_get_affinity callback
Message-ID: <ZzVYNf3BTGyYGz8k@fedora>
References: <20241113-refactor-blk-affinity-helpers-v4-0-dd3baa1e267f@kernel.org>
 <20241113-refactor-blk-affinity-helpers-v4-3-dd3baa1e267f@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241113-refactor-blk-affinity-helpers-v4-3-dd3baa1e267f@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Wed, Nov 13, 2024 at 03:26:17PM +0100, Daniel Wagner wrote:
> struct bus_type has a new callback for retrieving the IRQ affinity for a
> device. Hook this callback up for PCI based devices.
> 
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Daniel Wagner <wagi@kernel.org>

Reviewed-by: Ming Lei <ming.lei@redhat.com> 

-- 
Ming

