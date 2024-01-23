Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C78A56741
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2024 07:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705996214; cv=none; b=axt7cKQx+CXxNodwfprwLuHAo9Z0h5+jYaGrOqNpWqZ/omeLxqEGm8Ba+80bXbD5RY8fPBiTMlKUSWthqvFdgVHmG/dIskU/WWzDAKee++3jJ2ObbroV15xRQQUgWnaWbWT4BYfP3S9W9eqsryKi2b9gJBGeEgzS5Rvvcj3+Og8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705996214; c=relaxed/simple;
	bh=ZRdX7fCSUjlrhMEaWb09pn1Fdn3m8NhZ0ggK2V0dldA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cSLMlsQlLulxcoAmJvX6wECNFHU9h+IbKge2m/a8pyJAkSkioFS4hJSTJ8Whjat08bv5BWLLtlbL4tAFsceKzUJubZBim6ZzmoIYwmb1ohWG9CXJ7a5GyFhWiCK+pRIONzyN+EVApF6a1fu0i4mKaG6cSj4bNbC5Jh/PnwjPN6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6454A68BEB; Tue, 23 Jan 2024 08:49:59 +0100 (CET)
Date: Tue, 23 Jan 2024 08:49:58 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mike Christie <michael.christie@oracle.com>
Cc: john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
	hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
	james.bottomley@hansenpartnership.com
Subject: Re: [PATCH v13 00/19] scsi: Allow scsi_execute users to request
 retries
Message-ID: <20240123074958.GA25540@lst.de>
References: <20240123002220.129141-1-michael.christie@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240123002220.129141-1-michael.christie@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jan 22, 2024 at 06:22:01PM -0600, Mike Christie wrote:
> The following patches were made over Linus's tree which contains
> a fix for sd which was not in Martin's branches.
> 
> The patches allow scsi_execute_cmd users to have scsi-ml retry the
> cmd for it instead of the caller having to parse the error and loop
> itself.

Looks good:

Acked-by: Christoph Hellwig <hch@lst.de>

let's get this in early for 6.9..

