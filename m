Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E47D146596;
	Tue,  4 Jun 2024 12:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717505247; cv=none; b=ualRdUfY0Ux5p8H72Zn7FsvsVzwwnTgBEXvEgnTWr4x5O30XHlmKEHTLEdr6tGYPshpe/z5lSpnnV/TYCPsTimsIcux2YyzC+PzZ19Vj+O/KADkd/uW7z53g3Q2dlSmzk3KQ/VtDJhi4bgI8o0CyJ6C+koMe1nG9DqSaE+mki0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717505247; c=relaxed/simple;
	bh=nIYdM/OqMDhQGgNcXcpnvjFgd86iR0tNWwMbjlFjzY8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bnO8Y0aHxEMEKzBbLO7Sr0ye24p44+jYw/X1LfR/RsWZmwrpuykeY4J45KDE2zTtLhgijwGbDUPFZFOzphEso3KvV3e1y2Sfg+OcYD9f5tQPOl/Qdsmc+6F4tIhQ1GMu6kHo6NZDrvDhDOaLWEfyfBYEjD7B7fQb/ol/nc/fSsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aJr53kqw; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aJr53kqw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717505246; x=1749041246;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nIYdM/OqMDhQGgNcXcpnvjFgd86iR0tNWwMbjlFjzY8=;
  b=aJr53kqwaKRDc8RSpGLS+qYSPNrrGSPPnXqawM55sj5OcI80t+fSCPu8
   auD92u9kizpjVb5g8o3d4JYAyMfpG0ybpUjq/EFymv1pTVLc64uBw6MYl
   MrTDcmew9e+gduUhS1SsbLhLmW1HtU+5mT0RfDMeSt9XAZbjgSGqTQ5qB
   7+Zye9NxvvuNKjXLk6KhYyS5+sA6HA4mF3bey75TfRb+zkYhAK8LljkBW
   FvVzxc8oX4FysjOO3JQ6pZDS8+x49Ij6uRs0ljA1yKtnxkuvWASCrpkJ0
   Rs4/PrE3ZooH658t5m3LtmrB7liWn2RVKQE3TIrUmjKZp6NAoCqLz311S
   Q==;
X-CSE-ConnectionGUID: 7tm6RaWyQgWNxIP0NbrJiA==
X-CSE-MsgGUID: hiME9kdVRKaUXCINzDUIxw==
X-IronPort-AV: E=McAfee;i="6600,9927,11092"; a="39452959"
X-IronPort-AV: E=Sophos;i="6.08,213,1712646000"; 
   d="scan'208";a="39452959"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2024 05:47:25 -0700
X-CSE-ConnectionGUID: cyysqjZ0TUWDQwVpxCJbqg==
X-CSE-MsgGUID: ZSNcgNo6QVimcgI6g9037Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,213,1712646000"; 
   d="scan'208";a="41682173"
Received: from mattu-haswell.fi.intel.com (HELO [10.237.72.199]) ([10.237.72.199])
  by fmviesa005.fm.intel.com with ESMTP; 04 Jun 2024 05:47:23 -0700
Message-ID: <1ce90e1d-e65f-aa60-d475-e74135ea6ddb@linux.intel.com>
Date: Tue, 4 Jun 2024 15:49:20 +0300
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.13.0
Subject: Re: [Bug 218890] reset SuperSpeed USB device number 2 using xhci_hcd
Content-Language: en-US
To: Pierre Tomon <pierretom+12@ik.me>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
 USB mailing list <linux-usb@vger.kernel.org>,
 SCSI development list <linux-scsi@vger.kernel.org>
References: <bug-218890-208809@https.bugzilla.kernel.org/>
 <bug-218890-208809-ISXsODEmWC@https.bugzilla.kernel.org/>
 <70dd7ae0-b6b1-48e1-bb59-53b7c7f18274@rowland.harvard.edu>
 <yq1ikyueoz8.fsf@ca-mkp.ca.oracle.com>
 <4VrGl13122ztVS@smtp-3-0001.mail.infomaniak.ch>
From: Mathias Nyman <mathias.nyman@linux.intel.com>
In-Reply-To: <4VrGl13122ztVS@smtp-3-0001.mail.infomaniak.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 31.5.2024 11.39, Pierre Tomon wrote:
> Le Thu, 30 May 2024 21:44:13 -0400,
> "Martin K. Petersen" <martin.petersen@oracle.com> a écrit :
> 
>> Please try the following:
> 
> Both patches applied from Mathias and Martin, it works.
> See attachments for logs.
> Is it possible to apply them upstream?
> 
> Thanks.

I'll collect some other xhci fixes and submit this with them

Thanks
Mathias
