Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF1653800;
	Fri,  8 Mar 2024 10:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709892619; cv=none; b=AfHFE1GRikcshO1C4YVJCx4f05bK3hMYnd93FPyctbXGTWdVHG6S13OAoqS1yZzNCrdke/7fB6hKG0XgoI2Gm7/qsbeWA1z1qGJ87bnH86t8o6m7KAW0RiKj1WXum6eACbRnLKSIX85w8AejEWbUbyiVZt7rDuhfZyvd0ZnEIBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709892619; c=relaxed/simple;
	bh=yFIHiCNxp8CTvLs2jBeRYcIY14xPQMn4i3TCqU6alQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t0XgSCKlY8p3Cl7/81o3AP9NvJqsa4r6LSlJJQlkwprR0aMSPRYKmvfknJCFZYQnhEiOL4ULIhjwHL/xJ45+R9cXaESp7fnGab571KB0+cUYgTFwa/QbEQs05JCdZSSWbu6I7TqiIztpdQ5P5+CHxadIiB1AwN+Y18uOcxSdsKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i9zibUd/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i9zibUd/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41BF2C433F1;
	Fri,  8 Mar 2024 10:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709892619;
	bh=yFIHiCNxp8CTvLs2jBeRYcIY14xPQMn4i3TCqU6alQQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i9zibUd/qJT8SFy1GTnqSv1/p2uq8Jw9B1GvdSAqQy8MqbUreNS6lFwTB5oMEstkK
	 7xLNBEV57y1+ZyMvhHkmwGKBTt02f6Dp7DDs4bs77DmT9JGTjHvr5XqUnND850LaKF
	 TlyN1/2Cv9JQ1kEuROHuDO8x2JK1e3Yt4qYZDNBt2rzAYDo7VWq4/reYet7L8c/0pM
	 uwj74VDcSFvZ5EZF4tgn6MnfteTEt5CmeeJ8XqacCKnO/tkRQNkEUlVKU/59jCGQjA
	 Oinyo+56tu8nF2bxcASk3Bi2x44V3uC1ms01ktuY+KYrKFdDZjKQd8Ho9YYZ6B+r6l
	 X0+Xwo+FvD+rA==
Date: Fri, 8 Mar 2024 11:10:13 +0100
From: Niklas Cassel <cassel@kernel.org>
To: Igor Pylypiv <ipylypiv@google.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Hannes Reinecke <hare@suse.de>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
	Bart Van Assche <bvanassche@acm.org>,
	TJ Adams <tadamsjr@google.com>, linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 2/7] scsi: libsas: Define NCQ Priority sysfs
 attributes for SATA devices
Message-ID: <ZerkBaYn-jxg7Of9@ryzen>
References: <20240307214418.3812290-1-ipylypiv@google.com>
 <20240307214418.3812290-3-ipylypiv@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240307214418.3812290-3-ipylypiv@google.com>

On Thu, Mar 07, 2024 at 01:44:13PM -0800, Igor Pylypiv wrote:
> Libata sysfs attributes cannot be used for libsas managed SATA devices
> because the ata_port location is different for libsas.
> 
> Defined sysfs attributes (visible for SATA devices only):
> - /sys/block/sda/device/ncq_prio_enable
> - /sys/block/sda/device/ncq_prio_supported
> 
> The newly defined attributes will pass the correct ata_port to libata
> helper functions.
> 
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Jason Yan <yanaijie@huawei.com>
> Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
> ---

Reviewed-by: Niklas Cassel <cassel@kernel.org>
