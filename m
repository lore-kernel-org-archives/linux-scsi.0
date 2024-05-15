Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061565684
	for <linux-scsi@vger.kernel.org>; Wed, 15 May 2024 11:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715770845; cv=none; b=LAx5GfBxGcD6PwOVYRLzVM0wQs+ivsbAiytPiEYvJqAhyaA5m+7qULm90ZgmzRmbsyRrYmxhuaEpZ63+2VmAD2aW33E+2QYAGf4SswE/HY9xJHc+Rb9r5pU9V+83X5wvZqlPVVxonXON12UABP8Z6/oC50GYZgpm6niOOk00AoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715770845; c=relaxed/simple;
	bh=J+Hmfj+yXRKDyexdBUckE024dQ8Dcy3gLUX78DwMUlM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WN/o7JbTeMySyPvMWKLdyQIRLsS70ywc6oD9k7slPk/VXfkIgea5uyZKZTwIJvoLCJq8CWykP0d0ENr8hCkDkkw+EfGOLKYdruZQ2SM5DH3x/itwbR6ZAZLZl1OcESOryYZRfl724ED6SPVuGO1l13rz4W0qvXdZZqSfT25M088=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K92SLe53; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K92SLe53"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715770842; x=1747306842;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=J+Hmfj+yXRKDyexdBUckE024dQ8Dcy3gLUX78DwMUlM=;
  b=K92SLe53LRQwdQbRJiizWQF4n1xBoFpK2Der7/EmG4sROTwQFRAi7o8N
   WmvrUr4h+DWE6+XDFFg7XNhf4RgtT5+8BMAIwXe8ULNlMQKJLh63IABcH
   jUofU276GN8HfCxglDKZCab6NF2dLwPbS6iU5q+LT8IzWxu3WwlaYOLAS
   Zrvysnv06lSwuADQH4URag7eVgTmqyYnNzcAP5YPwddNvY0KTX7iV430t
   hHQvzNGWZo+0ytCyoUAGCPOGSgkOdWQSZtDTJGaDBlNjhBUOJo22RWaFs
   QtzB0wT8pBNlNYn/kdoPPITuroHlWV+nwoUs+UWzSlSbrua13By8QKCHI
   w==;
X-CSE-ConnectionGUID: RcuP+2M7SN6w2yft9nCNbQ==
X-CSE-MsgGUID: lyqH1k+3QG2zWH9sLGvMkQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11073"; a="29302695"
X-IronPort-AV: E=Sophos;i="6.08,161,1712646000"; 
   d="scan'208";a="29302695"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 04:00:42 -0700
X-CSE-ConnectionGUID: 7UPC0DvKTOizPS439Kc4iw==
X-CSE-MsgGUID: 0/47tvnmSsyYWIhmx8HErQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,161,1712646000"; 
   d="scan'208";a="35560125"
Received: from lkp-server01.sh.intel.com (HELO f8b243fe6e68) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 15 May 2024 04:00:39 -0700
Received: from kbuild by f8b243fe6e68 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1s7CNA-000CkR-2v;
	Wed, 15 May 2024 11:00:36 +0000
Date: Wed, 15 May 2024 19:00:29 +0800
From: kernel test robot <lkp@intel.com>
To: Ranjan Kumar <ranjan.kumar@broadcom.com>, linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: oe-kbuild-all@lists.linux.dev, rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com, sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com, prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: Re: [PATCH v1 3/6] mpi3mr: Dump driver and dmesg logs into driver
 diag buffer
Message-ID: <202405151829.zc0uNh0u-lkp@intel.com>
References: <20240514142858.51992-4-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240514142858.51992-4-ranjan.kumar@broadcom.com>

Hi Ranjan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on jejb-scsi/for-next linus/master v6.9 next-20240515]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ranjan-Kumar/mpi3mr-HDB-allocation-and-posting-for-hardware-and-Firmware-buffers/20240514-223346
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20240514142858.51992-4-ranjan.kumar%40broadcom.com
patch subject: [PATCH v1 3/6] mpi3mr: Dump driver and dmesg logs into driver diag buffer
config: alpha-allyesconfig (https://download.01.org/0day-ci/archive/20240515/202405151829.zc0uNh0u-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240515/202405151829.zc0uNh0u-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202405151829.zc0uNh0u-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/scsi/mpi3mr/mpi3mr_fw.c:1214: warning: Excess function parameter 'prev_offset' description in 'mpi3mr_do_mini_dump'


vim +1214 drivers/scsi/mpi3mr/mpi3mr_fw.c

  1202	
  1203	/**
  1204	 * mpi3mr_do_mini_dump - copy system logs associated with mrioc.
  1205	 * @mrioc: Adapter instance reference
  1206	 * @prev_offset: offset returned from previous operation
  1207	 *
  1208	 * Read system logs and search for pattern mpi3mr%d and copy the lines
  1209	 * into driver diag buffer
  1210	 *
  1211	 * Return: next available location in driver diag buffer.
  1212	 */
  1213	static int mpi3mr_do_mini_dump(struct mpi3mr_ioc *mrioc)
> 1214	{
  1215		int n = 0, lines, pos_mini_dump = 0;
  1216		struct mpi3mr_kmsg_dumper dumper;
  1217		size_t len;
  1218		char buf[201];
  1219		char *mini_start = "<6> Minidump start\n";
  1220		char *mini_end = "<6> Minidump end\n";
  1221	
  1222		struct mpi3_driver_buffer_header *drv_buff_header = NULL;
  1223	
  1224		dumper = mrioc->dump;
  1225	
  1226		kmsg_dump_rewind(&dumper.kdumper);
  1227		while (kmsg_dump_get_line(&dumper.kdumper, 1, NULL, 0, NULL))
  1228			n++;
  1229	
  1230		lines = n;
  1231		kmsg_dump_rewind(&dumper.kdumper);
  1232	
  1233		drv_buff_header = (struct mpi3_driver_buffer_header *)mrioc->drv_diag_buffer;
  1234		drv_buff_header->signature = 0x43495243;
  1235		drv_buff_header->logical_buffer_start = 0;
  1236		drv_buff_header->circular_buffer_size =
  1237			mrioc->drv_diag_buffer_sz - sizeof(struct mpi3_driver_buffer_header);
  1238		drv_buff_header->flags =
  1239			MPI3_DRIVER_DIAG_BUFFER_HEADER_FLAGS_CIRCULAR_BUF_FORMAT_ASCII;
  1240	
  1241		if ((pos_mini_dump + strlen(mini_start)
  1242				    < mrioc->drv_diag_buffer_sz)) {
  1243			sprintf((char *)mrioc->drv_diag_buffer + pos_mini_dump,
  1244				"%s\n", mini_start);
  1245			pos_mini_dump += strlen(mini_start);
  1246		} else {
  1247			ioc_info(mrioc, "driver diag buffer is full. minidump is not started\n");
  1248			goto out;
  1249		}
  1250	
  1251		while (kmsg_dump_get_line(&dumper.kdumper, 1, buf, sizeof(buf), &len)) {
  1252			if (!lines--)
  1253				break;
  1254			if (strstr(buf, mrioc->name) &&
  1255				((pos_mini_dump + len + strlen(mini_end))
  1256				    < mrioc->drv_diag_buffer_sz)) {
  1257				sprintf((char *)mrioc->drv_diag_buffer
  1258				    + pos_mini_dump, "%s", buf);
  1259				pos_mini_dump += len;
  1260			}
  1261		}
  1262	
  1263		if ((pos_mini_dump + strlen(mini_end)
  1264				    < mrioc->drv_diag_buffer_sz)) {
  1265			sprintf((char *)mrioc->drv_diag_buffer + pos_mini_dump,
  1266				"%s\n", mini_end);
  1267			pos_mini_dump += strlen(mini_end);
  1268		}
  1269	
  1270	out:
  1271		drv_buff_header->logical_buffer_end =
  1272			pos_mini_dump - sizeof(struct mpi3_driver_buffer_header);
  1273	
  1274		ioc_info(mrioc, "driver diag buffer base_address(including 4K header) 0x%016llx, end_address 0x%016llx\n",
  1275		    (unsigned long long)mrioc->drv_diag_buffer_dma,
  1276		    (unsigned long long)mrioc->drv_diag_buffer_dma +
  1277		    mrioc->drv_diag_buffer_sz);
  1278		ioc_info(mrioc, "logical_buffer end_address 0x%016llx, logical_buffer_end 0x%08x\n",
  1279		    (unsigned long long)mrioc->drv_diag_buffer_dma +
  1280		    drv_buff_header->logical_buffer_end,
  1281		    drv_buff_header->logical_buffer_end);
  1282	
  1283		return pos_mini_dump;
  1284	}
  1285	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
