Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3EF129A71;
	Tue, 26 Mar 2024 06:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711435871; cv=none; b=Kx38Rp2NQ+aRR1VXDc9PcmLiF7AFAPNCBg44J6amss3YnRg6iMlTCOoJ0wK4AfF2cIdn4UrOJDlNb1B6u/PTGzq2F2SOJ1x//1PJYj0jlAcePt2MYdaEKJy+MmdVoEzvTr94TpY8txoRBFNduDQ0McUmS37Vm4ZqtEekTTOqznY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711435871; c=relaxed/simple;
	bh=X3M7LWspWJxxZOOABMLIQiq4yGfei5/T8qUtqoSh9L4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lPpCicZ1NKMI9r76CQZpP6lCSM6eiirt28A9jR2lcWMhZhwBbxLLOdwXtLYJkG5Zk1jbmEZsLSf9KIlDLXAOMhwyuWciGhCNw4CQb2nalFoxyGwS8nIlhO1C/bp68aduE0g2uGJWjV9JVAXW94I/KYZNJ1xsCgLjNoMy2EKX66M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8035368D37; Tue, 26 Mar 2024 07:51:06 +0100 (CET)
Date: Tue, 26 Mar 2024 07:51:06 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 07/28] block: Introduce zone write plugging
Message-ID: <20240326065106.GF7986@lst.de>
References: <20240325044452.3125418-1-dlemoal@kernel.org> <20240325044452.3125418-8-dlemoal@kernel.org> <f3b298bb-b68a-4375-a3b4-fc91229740c1@acm.org> <839ebf2a-4dc6-433b-bc47-fd7915ed0ecf@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <839ebf2a-4dc6-433b-bc47-fd7915ed0ecf@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Mar 26, 2024 at 12:12:03PM +0900, Damien Le Moal wrote:
> Nope, we cannot. The reason is that BIO issuing and zone reset/finish can be
> concurrently processed and we need to be ready for a user doing really stupid
> things like resetting or finishing a zone while BIOs for that zone are being
> issued. When zone reset/finish is processed, the plug is removed from the hash
> table, but disk_get_zone_wplug_locked() may still get a reference to it because
> we do not have the plug locked yet. Hence the flag, to prevent reusing the plug
> for the reset/finished zone that was already removed from the hash table. This
> is mentioned with a comment in disk_get_zone_wplug_locked():
> 
> 	/*
> 	 * Check that a BIO completion or a zone reset or finish
> 	 * operation has not already flagged the zone write plug for
> 	 * freeing and dropped its reference count. In such case, we
> 	 * need to get a new plug so start over from the beginning.
> 	 */
> 
> The reference count dropping to 0 will then be the trigger for actually freeing
> the plug, after all in-flight or plugged BIOs are completed (most likely failed).

Maybe the comment should be expanded even more and move to the definition
of the freeing flag?
