Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64AE13A87C;
	Sun, 10 Nov 2024 19:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731268664; cv=none; b=ENEOj+SN/1PC6BfNFkxdP7u9+8QdNUTqaSqmja6LwTrzpMPPSuvJqi6xqKO7ACxJ5JqrvBVZq0AI7nnaGWDtFzr3KFMJBdCZrO04CBobxoyW1BHpmG5mWaxOQo+Q4I3c9fFuYwO42+96HLLefXXmfWNkcv4J5hWMZ0V0pqFuWJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731268664; c=relaxed/simple;
	bh=t5o95VKolGNwuTZOMbTSwEHJVtGUn83UNE6mDL/SRkU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ihxstC+eTVnJZnMj1csx9d/bVWinYWEghVOD23rWu2nmv2p1VF+D4ojsd2CyMsDj33t+NuHR5QLUIrTRzZ16JUC5OGzmCxtnPKZC8Guxoo96OIjNHokTLE1Jo2EYwdCI4g6mr1cvIQTC94E7pK3ip3rxd2E9m7nPlCgYpVlYkRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RI5N6bs+; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RI5N6bs+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731268662; x=1762804662;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=t5o95VKolGNwuTZOMbTSwEHJVtGUn83UNE6mDL/SRkU=;
  b=RI5N6bs+X8hA/VcWD1Iu+YleOlcZZXGDhUx111tl/yU0pARLnpCTifo3
   rWqKMpjnm8SUHqzw4awYNNqCrrJTDDmECr/Kne9tE1n/qtk16aKk4+fGo
   4GH/8JzQDyuw7+eIYS6Y3p8FedN5N0d7ipYHemfw5bsAz0cKjxeUipnT3
   P4QrrSOt5dtqps1v7R0c4JoIAfDBLvyGCAS/Ej6CsDcE8lOjKn+hNv7Hk
   O2YGwdxdQZ0lanvYAHghK+A8P/mdXibQG674QIFAR3YGAAa5dOg/WN62T
   RDebSdHif2YHfPHcD2TugRNJWOX4JU+FldQ1Op9Ja0z2NkrkVFWfQ002w
   g==;
X-CSE-ConnectionGUID: kF3LNp6iTJ6vI1omz5ks6A==
X-CSE-MsgGUID: ldfS91dvSd6Jj519P8HuQA==
X-IronPort-AV: E=McAfee;i="6700,10204,11252"; a="48595993"
X-IronPort-AV: E=Sophos;i="6.12,143,1728975600"; 
   d="scan'208";a="48595993"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2024 11:57:41 -0800
X-CSE-ConnectionGUID: xm8BLjwFQE66C3JJgcMDxg==
X-CSE-MsgGUID: TMBMR7lxSEWJ8u7Jhr0j/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,143,1728975600"; 
   d="scan'208";a="117488860"
Received: from lkp-server01.sh.intel.com (HELO 7b17a4138caf) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 10 Nov 2024 11:57:38 -0800
Received: from kbuild by 7b17a4138caf with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tAE40-0000Mv-14;
	Sun, 10 Nov 2024 19:57:36 +0000
Date: Mon, 11 Nov 2024 03:57:24 +0800
From: kernel test robot <lkp@intel.com>
To: Thorsten Blum <thorsten.blum@linux.dev>, Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-hardening@vger.kernel.org,
	Thorsten Blum <thorsten.blum@linux.dev>,
	open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: Replace zero-length array with flexible array
 member
Message-ID: <202411110336.IDRXgcR4-lkp@intel.com>
References: <20241110151749.3311-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241110151749.3311-2-thorsten.blum@linux.dev>

Hi Thorsten,

kernel test robot noticed the following build errors:

[auto build test ERROR on jejb-scsi/for-next]
[also build test ERROR on mkp-scsi/for-next linus/master v6.12-rc6 next-20241108]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Thorsten-Blum/scsi-Replace-zero-length-array-with-flexible-array-member/20241110-232327
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20241110151749.3311-2-thorsten.blum%40linux.dev
patch subject: [PATCH] scsi: Replace zero-length array with flexible array member
config: x86_64-rhel-8.3 (https://download.01.org/0day-ci/archive/20241111/202411110336.IDRXgcR4-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241111/202411110336.IDRXgcR4-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202411110336.IDRXgcR4-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from drivers/scsi/scsi_transport_iscsi.c:23:
>> include/scsi/scsi_bsg_iscsi.h:62:18: error: flexible array member in a struct with no named members
      62 |         uint32_t vendor_rsp[];
         |                  ^~~~~~~~~~


vim +62 include/scsi/scsi_bsg_iscsi.h

    57	
    58	/* Response:
    59	 */
    60	struct iscsi_bsg_host_vendor_reply {
    61		/* start of vendor response area */
  > 62		uint32_t vendor_rsp[];
    63	};
    64	
    65	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
