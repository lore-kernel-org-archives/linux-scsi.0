Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4362E64A;
	Fri, 28 Jun 2024 12:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719577828; cv=none; b=t6p0vENkwA0QELIU6nipIhGA87S/Uvl6GC9YllHR6UeAv3YT3+TCtrEZxzjFX/R72ibZlJIl9mGQVIi/JmEYZYtswVgH+dpiMRXytFHcFTsFCmYn+T/qbQ0sBxElmyO0Y9KP73uFx1MQ1BQbHao764hRx2dvpVxIC89Mx4ItikU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719577828; c=relaxed/simple;
	bh=DEd6fYnQdW1eGRC/v3qIp4/j35TYIZwX4UyhWHLTJAk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=putWwTQdEvstqZsgZfQtrSuqnv5gFfixuH4W5r6HI/ABjoULoFf6zkJFcWwV203A2Q3Pt32cnt4nbf4RBEM4eyTL/45UGJklSMYG/geekXNoCI9Bf1APg25SSwfT0jKnM8lBOHmaZpmgfUdCjY/rIOOlYoMHCbnmxV212kKJqLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EF15468CFE; Fri, 28 Jun 2024 14:30:19 +0200 (CEST)
Date: Fri, 28 Jun 2024 14:30:19 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Ming Lei <ming.lei@redhat.com>,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	linux-block@vger.kernel.org, megaraidlinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com
Subject: Re: get drivers out of setting queue flags
Message-ID: <20240628123019.GA17080@lst.de>
References: <20240627124926.512662-1-hch@lst.de> <e93e3171-3b30-4af1-80d8-acb9ff4900a2@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e93e3171-3b30-4af1-80d8-acb9ff4900a2@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jun 28, 2024 at 08:46:08AM +0100, John Garry wrote:
> On 27/06/2024 13:49, Christoph Hellwig wrote:
>> Hi all,
>>
>> now that driver features have been moved out of the queue flags,
>> the abuses where drivers set random internal queue flags stand out
>> even more.  This series fixes them up.
>
> If no driver needs to know about these flags, could they now live in 
> block/*.h ?

That is my ultimate plan, but currently they still are checked in
a few places in drivers.  I'll need some more time to sort this
out properly, but I hope that we'll get there.

