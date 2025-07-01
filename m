Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54261275AFD
	for <linux-scsi@vger.kernel.org>; Tue,  1 Jul 2025 13:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751378091; cv=none; b=nKXHQCyu9sCkqS7qE7CYVHx3llEucKvc+IwjlBsXSZHiXU+PO+2bZ5BYIv8JBQ9PThIR3N3yo2yrkopq5CVORhSf1HDy1mnoAXWNL/r8MYfSyPBDLdt1asrATcwTWDEnJ7OGUbrUaorksgcWepKnewS05iliciCE8HEvratql2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751378091; c=relaxed/simple;
	bh=OZa4yKRHVDO+7SZUwMFN1ZqXJzB6v61X3RuYjqeq4EI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H4PHapo+Ls1dFnB9m4WNSZdQ19lx3bwfm6Zb4xyS39m4lP/LnLSYBeZvh52aI9cADLXV8BdauzNKhW0HyJg+jOTg+FIcyeO+cCJNKkDHXvBU0Omt3pruRIMFSjnzrdDIoM+pjL8pcA7NmpCFSWL2Ik2BDx3uWFz5QhaGNdv7HCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qW7LzJ++; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=p10Zy082; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qW7LzJ++; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=p10Zy082; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qW7LzJ++";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="p10Zy082";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qW7LzJ++";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="p10Zy082"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 96C8D1F393;
	Tue,  1 Jul 2025 13:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751378088; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OZa4yKRHVDO+7SZUwMFN1ZqXJzB6v61X3RuYjqeq4EI=;
	b=qW7LzJ++TZAzgZzJJ8dmmAQ3FyyHzXkr28sOR7UKjG+7dWpaaMSxDYuzxYJ90697etJ2fs
	oqLVJPIJNNtOoXor5lYq0cqHsB6quP7YUwFrJICByatLKoRqvjSGs/sO9tD6aU7VWRcV+u
	mmXFtKYwwysFM+lKd3sIE2zEFo1bSOQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751378088;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OZa4yKRHVDO+7SZUwMFN1ZqXJzB6v61X3RuYjqeq4EI=;
	b=p10Zy082goSNDSHYdjSff+NcvPSNoCEK4P0Pp5IS1mnYA/UxSuvlPWc9Ynakx8tMU51g6B
	1AmCwGgHFnVN82AA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751378088; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OZa4yKRHVDO+7SZUwMFN1ZqXJzB6v61X3RuYjqeq4EI=;
	b=qW7LzJ++TZAzgZzJJ8dmmAQ3FyyHzXkr28sOR7UKjG+7dWpaaMSxDYuzxYJ90697etJ2fs
	oqLVJPIJNNtOoXor5lYq0cqHsB6quP7YUwFrJICByatLKoRqvjSGs/sO9tD6aU7VWRcV+u
	mmXFtKYwwysFM+lKd3sIE2zEFo1bSOQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751378088;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OZa4yKRHVDO+7SZUwMFN1ZqXJzB6v61X3RuYjqeq4EI=;
	b=p10Zy082goSNDSHYdjSff+NcvPSNoCEK4P0Pp5IS1mnYA/UxSuvlPWc9Ynakx8tMU51g6B
	1AmCwGgHFnVN82AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 740281364B;
	Tue,  1 Jul 2025 13:54:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OMToGajoY2i3BQAAD6G6ig
	(envelope-from <dwagner@suse.de>); Tue, 01 Jul 2025 13:54:48 +0000
Date: Tue, 1 Jul 2025 15:54:43 +0200
From: Daniel Wagner <dwagner@suse.de>
To: Aaron Tomlin <atomlin@atomlin.com>
Cc: Christoph Hellwig <hch@infradead.org>, 
	John Garry <john.g.garry@oracle.com>, Daniel Wagner <wagi@kernel.org>, "Sean A." <sean@ashe.io>, 
	"James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "kashyap.desai@broadcom.com" <kashyap.desai@broadcom.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, 
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>, 
	"mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>, "sreekanth.reddy@broadcom.com" <sreekanth.reddy@broadcom.com>, 
	"sumit.saxena@broadcom.com" <sumit.saxena@broadcom.com>
Subject: Re: [RFC PATCH v2 1/1] scsi: mpi3mr: Introduce smp_affinity_enable
 module parameter
Message-ID: <c4c82ac2-c9f9-4bef-8f6f-a6cc9a2a0545@flourine.local>
References: <1xjYfSjJndOlG0Uro2jPuAmIrfqi5AVbfpFeWh7RfLfzqqH9u8ePoqgaP32ElXrGyOB47UvesV_Y2ypmM3cZtWit2EPnV3aj6i9w_DMo1eI=@ashe.io>
 <077ffc15-f949-41d4-a13b-4949990ba830@oracle.com>
 <aFjjf3qbuEOeWUjt@infradead.org>
 <0233e47b-894f-49e0-822c-bc1436352c98@flourine.local>
 <itze7fhv7yx6j4l4ammx2znkknr2v6iducahcsxdjpfbasdsz5@nz4hvmv3s234>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <itze7fhv7yx6j4l4ammx2znkknr2v6iducahcsxdjpfbasdsz5@nz4hvmv3s234>
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[13];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 

On Wed, Jun 25, 2025 at 09:03:42AM -0400, Aaron Tomlin wrote:
> Understood. I agree, common functionality is indeed preferred.
> Daniel, I look forward to your submission.

Sorry for the delay. I found a few bugs in the new cpu queue mapping
code and it took a while to debug and fix them all. I should have it
ready to post by tomorrow. Currently, my brain overheating due to summer
:)

FWIW, the last standing issue is that the qla2xxx driver allocates
queues for scsi and reuses a subset of these queues for nvme. So the irq
allocating is done for the scsi queues, e.g 16 queues, but the nvme code
limits it to 8 queues. Currently, there is a disconnect between the irq
mapping and the cpu mapping code. The solution here is to use the
irq_get_affinity function instead creating a new map based only on the
housekeeping cpumask.
