Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931441A5BA8;
	Thu,  6 Feb 2025 18:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738868278; cv=none; b=s5K/NmD5WvcC22JRTKjAXPImKbkvUXvBU2QabkYJZZsUkjkOUEEpLBMHacbsOltVEiMrQdtYPBy55AuwjmhoLhe7aDwtZXBJiEjEJc4IjXrvxsm6MNdDiIfzE8aOq04bfIX+bwcKg4hUeZWAY6zGKsQQvgnXDdrqd6XR6XAUjDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738868278; c=relaxed/simple;
	bh=vo+P2NZF5QXcQ115W/Z6cTiMMe3WZKFKo0eNxqMPj9M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IpB1vov68s9XQLQq+Dyz+HXtuQhgiz4O7y0fAsvsZIKnxejxhszN4P+/Xv9ydhw+GVzIyfyMkAodCTooO5BwYtO6CeSFQU645CWrPxuDrzl2BvR2ah8Chs1IU2ZfdyHCPVqQEoAv2o9S8kuNznyKQdM7Z9Hlye9XmGJeXr2mRi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wdme3CO7; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wdme3CO7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738868278; x=1770404278;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=vo+P2NZF5QXcQ115W/Z6cTiMMe3WZKFKo0eNxqMPj9M=;
  b=Wdme3CO7xnaihLouZBk2ZmW38d5DUkCDHU74Li1SDHLiKknZGpI30yKU
   1qupzCDC6AnFzx9nbDMJX753Tx8BB4vrFhK5rVJxcZHCMEyD4va2BatDA
   UdzQ7gbn27AmEN36hX4cTO8RVhRKLZcZ9E4xa8LBiHP/gZW+ou5cke4eD
   mtukuWzZ8RWo2nnI0xzLNSLhQtdxIY6Cy1cSZNn76bRswEvXYZ5zlNI7q
   MS4nl0UERJIJK9HN98/aULpAWTm9f4XOQqMXQIgrXpxFwLzxCqIRREvNY
   7RaDcEoYMkkh2YTY7sGgPcrDiLLOU4+72wVE3CiF1/KHnNXnQvTB811W1
   A==;
X-CSE-ConnectionGUID: x3KKB2C4SduOdIb53KJx4g==
X-CSE-MsgGUID: veeFkhP6Q9KQut5+g9RwbA==
X-IronPort-AV: E=McAfee;i="6700,10204,11336"; a="39186025"
X-IronPort-AV: E=Sophos;i="6.13,265,1732608000"; 
   d="scan'208";a="39186025"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2025 10:57:57 -0800
X-CSE-ConnectionGUID: t6nPuH2fT46gejFFIbbvgA==
X-CSE-MsgGUID: 5kmxk2eSSqeNqXKgRs6ZcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="112191610"
Received: from smile.fi.intel.com ([10.237.72.58])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2025 10:57:55 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.98)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1tg74S-00000008p0Q-0QAX;
	Thu, 06 Feb 2025 20:57:52 +0200
Date: Thu, 6 Feb 2025 20:57:51 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Justin Tee <justintee8345@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Justin Tee <justin.tee@broadcom.com>, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	James Smart <james.smart@broadcom.com>,
	Dick Kennedy <dick.kennedy@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH v1 1/1] scsi: lpfc: Switch to use %ptTs
Message-ID: <Z6UGL5P-ws9prRBA@smile.fi.intel.com>
References: <20250206155822.1126056-1-andriy.shevchenko@linux.intel.com>
 <CABPRKS-7c+8sQPzYugAeQ5OeC6P82XGDjKowkoJZFNaQz59CBw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABPRKS-7c+8sQPzYugAeQ5OeC6P82XGDjKowkoJZFNaQz59CBw@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Thu, Feb 06, 2025 at 10:16:09AM -0800, Justin Tee wrote:
> Hi Andy,
> 
> The purpose of the lpfc_cgn_update_tstamp routine is more than just
> printf.  The *ts pointer argument is updated with cur_time, and is
> typically a pointer to a global statistics struct used by the device
> driver in various contexts.  Sorry, but we can’t remove the lines
> suggested in this patch.

Ah, you are right, the ts is used somewhere else.

-- 
With Best Regards,
Andy Shevchenko


