Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 8D2AC14900F
	for <linux-scsi@vger.kernel.org>; Tue,  4 Jun 2024 14:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.131.102.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717512552; cv=none; b=C6EHeLR0JBIYE6CxtbrEdsWzpULrNqLH36H0scG1zI00RvJnHZK2fkFHZJiMVCxuWh88oXxnVg7htEpZ2vfYKMXyYqtZJjdSf8c0nqrkhUamZ1fj0v3DPJN3PFi/+7t1sjs0LiVrgi+/IfBhkpj8Zd99gg9cL0Zx3kQZxU5WqDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717512552; c=relaxed/simple;
	bh=WKYMVgaaNVok3jDmZNPdQNYbatoc/97e13Vxwir3Ia8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GWLFNc+YeLq/6u5zKuhf+TYXDCM4fY0ZjeIbT+ltA729KpxHbqJwvmyqhrtg7k7vTaxt8abdKjzMzB6AvY0m4Pf9O0lErRaV0UNrYU8w03Z5jXYtDZcii5CcK0DtKIlob7R/QGm+FniBWGzfPDCVw5nOkAHVpe54bVxYc5VCgnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=rowland.harvard.edu; spf=pass smtp.mailfrom=netrider.rowland.org; arc=none smtp.client-ip=192.131.102.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=rowland.harvard.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netrider.rowland.org
Received: (qmail 159291 invoked by uid 1000); 4 Jun 2024 10:49:09 -0400
Date: Tue, 4 Jun 2024 10:49:09 -0400
From: Alan Stern <stern@rowland.harvard.edu>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Pierre Tomon <pierretom+12@ik.me>
Subject: Re: [PATCH] scsi: sd: Use READ(16) when reading block zero on large
 capacity disks
Message-ID: <26160d8a-f2be-4657-9733-ec089f103f16@rowland.harvard.edu>
References: <4VrGl13122ztVS@smtp-3-0001.mail.infomaniak.ch>
 <20240604144501.3862738-1-martin.petersen@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240604144501.3862738-1-martin.petersen@oracle.com>

On Tue, Jun 04, 2024 at 10:45:01AM -0400, Martin K. Petersen wrote:
> Commit 321da3dc1f3c ("scsi: sd: usb_storage: uas: Access media prior
> to querying device properties") triggered a read to LBA 0 before
> attempting to inquire about device characteristics. This was done
> because some protocol bridge devices will return generic values until
> an attached storage device's media has been accessed.
> 
> Pierre Tomon reported that this change caused problems on a large
> capacity external drive connected via a bridge device. The bridge in
> question does not appear to implement the READ(10) command.
> 
> Issue a READ(16) instead of READ(10) when a device has been identified
> as preferring 16-byte commands (use_16_for_rw heuristic).
> 
> Cc: stable@vger.kernel.org
> Fixes: 321da3dc1f3c ("scsi: sd: usb_storage: uas: Access media prior to querying device properties")
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=218890
> Reported-by: Pierre Tomon <pierretom+12@ik.me>
> Suggested-by: Alan Stern <stern@rowland.harvard.edu>
> Tested-by: Pierre Tomon <pierretom+12@ik.me>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---

Thanks a lot, Martin!

Alan Stern
