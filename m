Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DCED1FC7D4;
	Tue,  5 Nov 2024 21:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730841655; cv=none; b=Q1UkPPRYpzTTSiQbQxtHAk1D/ICoX6Ddde9Z+o8jBmllmZFuZ5xFne6P3J2R+rOK+jgn6jf2tc/rMkPni8gsWajvmSEKheYu3le7OT7UhxzaNQrM8kwqQ+ysbYUNtzbzm3yjDx3DQuPQNFi92Kh1ja9p/gDAAJmWZ6NF+LOD14s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730841655; c=relaxed/simple;
	bh=HKzWNl+2gNPBHTjyug5xLVbK+7v2ikZFVkCCRxefCNs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j5RC1KqgAdtYlL8TDry0GkVkWZFmPbpGrJNboskwl7zmvITl9C3QMyJjBzgEuFMJBunrbiV6OBoSyOlgYN12poQYScFbnKFGj0/QkCV0FDoYbWvfukzQrNAI3vFQJaGPnuIEdonDG/8eRXbmCBBZxP7wl9Tfu5J1zDXNvrrV9Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fAil14rw; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fAil14rw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730841652; x=1762377652;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HKzWNl+2gNPBHTjyug5xLVbK+7v2ikZFVkCCRxefCNs=;
  b=fAil14rwXHrz0nV0iM4bcaGYM9OIdOoY1SU8x0yaPU4wvOJsI5532SgM
   z0vWTZ9WGh4ziObVUZa4uo1irJDeh14llOMZFaiPMWxh4AvhQYypi9/T/
   coxVH5Bn1ttvhoHoqU9p6yt+0l73Bz1DuFqMi0ilBNVjcIbjxejhsvdQ4
   LDpRMErlxYjQjs7K1DDL50hwBDr03xVWUzPc6gmTHRLQxnt0oiUGSkXv0
   xxAMNtQEyuIS4QcyvSUPbQ3W96jqGLyDvjXUT1oQ07dQJox0Ewz4spTS6
   QWZDwNdzgrpoxMjYt5HlO9R0MqzzaIVLQK1fY3lpzCXIQsgwV6rHDEZb2
   g==;
X-CSE-ConnectionGUID: OECRhiUDQDq1aVa2UeLL0A==
X-CSE-MsgGUID: O+pH6j9SSBCDOW0ct5cNPw==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="33455992"
X-IronPort-AV: E=Sophos;i="6.11,261,1725346800"; 
   d="scan'208";a="33455992"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 13:20:51 -0800
X-CSE-ConnectionGUID: Ex1FPkmbTaGNaNY+qn6sEA==
X-CSE-MsgGUID: SlG1Ac0iQDW32yIm0AkXsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,261,1725346800"; 
   d="scan'208";a="114959947"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 05 Nov 2024 13:20:49 -0800
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t8Qyk-000mUB-2f;
	Tue, 05 Nov 2024 21:20:46 +0000
Date: Wed, 6 Nov 2024 05:20:10 +0800
From: kernel test robot <lkp@intel.com>
To: Qiu-ji Chen <chenqiuji666@gmail.com>, james.smart@broadcom.com,
	dick.kennedy@broadcom.com, James.Bottomley@hansenpartnership.com,
	martin.petersen@oracle.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com, Qiu-ji Chen <chenqiuji666@gmail.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] scsi: lpfc: Fix improper handling of refcount in
 lpfc_bsg_hba_get_event()
Message-ID: <202411060527.qPI24Q8a-lkp@intel.com>
References: <20241105130902.4603-1-chenqiuji666@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241105130902.4603-1-chenqiuji666@gmail.com>

Hi Qiu-ji,

kernel test robot noticed the following build errors:

[auto build test ERROR on jejb-scsi/for-next]
[also build test ERROR on mkp-scsi/for-next linus/master v6.12-rc6 next-20241105]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Qiu-ji-Chen/scsi-lpfc-Fix-improper-handling-of-refcount-in-lpfc_bsg_hba_get_event/20241105-211110
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20241105130902.4603-1-chenqiuji666%40gmail.com
patch subject: [PATCH] scsi: lpfc: Fix improper handling of refcount in lpfc_bsg_hba_get_event()
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20241106/202411060527.qPI24Q8a-lkp@intel.com/config)
compiler: clang version 19.1.3 (https://github.com/llvm/llvm-project ab51eccf88f5321e7c60591c5546b254b6afab99)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241106/202411060527.qPI24Q8a-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202411060527.qPI24Q8a-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   In file included from drivers/scsi/lpfc/lpfc_bsg.c:25:
   In file included from include/linux/pci.h:1650:
   In file included from include/linux/dmapool.h:14:
   In file included from include/linux/scatterlist.h:8:
   In file included from include/linux/mm.h:2213:
   include/linux/vmstat.h:504:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     504 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     505 |                            item];
         |                            ~~~~
   include/linux/vmstat.h:511:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     511 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     512 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
   include/linux/vmstat.h:518:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     518 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
   include/linux/vmstat.h:524:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     524 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     525 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
>> drivers/scsi/lpfc/lpfc_bsg.c:1297:8: error: use of undeclared label 'job_error_unref'
    1297 |                 goto job_error_unref;
         |                      ^
>> drivers/scsi/lpfc/lpfc_bsg.c:1332:1: warning: unused label 'job_err_unref' [-Wunused-label]
    1332 | job_err_unref:
         | ^~~~~~~~~~~~~~
   drivers/scsi/lpfc/lpfc_bsg.c:2810:11: warning: variable 'offset' set but not used [-Wunused-but-set-variable]
    2810 |         int cnt, offset = 0, i = 0;
         |                  ^
   6 warnings and 1 error generated.

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for MODVERSIONS
   Depends on [n]: MODULES [=y] && !COMPILE_TEST [=y]
   Selected by [y]:
   - RANDSTRUCT_FULL [=y] && (CC_HAS_RANDSTRUCT [=y] || GCC_PLUGINS [=n]) && MODULES [=y]


vim +/job_error_unref +1297 drivers/scsi/lpfc/lpfc_bsg.c

  1243	
  1244	/**
  1245	 * lpfc_bsg_hba_get_event - process a GET_EVENT bsg vendor command
  1246	 * @job: GET_EVENT fc_bsg_job
  1247	 **/
  1248	static int
  1249	lpfc_bsg_hba_get_event(struct bsg_job *job)
  1250	{
  1251		struct lpfc_vport *vport = shost_priv(fc_bsg_to_shost(job));
  1252		struct lpfc_hba *phba = vport->phba;
  1253		struct fc_bsg_request *bsg_request = job->request;
  1254		struct fc_bsg_reply *bsg_reply = job->reply;
  1255		struct get_ct_event *event_req;
  1256		struct get_ct_event_reply *event_reply;
  1257		struct lpfc_bsg_event *evt, *evt_next;
  1258		struct event_data *evt_dat = NULL;
  1259		unsigned long flags;
  1260		uint32_t rc = 0;
  1261	
  1262		if (job->request_len <
  1263		    sizeof(struct fc_bsg_request) + sizeof(struct get_ct_event)) {
  1264			lpfc_printf_log(phba, KERN_WARNING, LOG_LIBDFC,
  1265					"2613 Received GET_CT_EVENT request below "
  1266					"minimum size\n");
  1267			rc = -EINVAL;
  1268			goto job_error;
  1269		}
  1270	
  1271		event_req = (struct get_ct_event *)
  1272			bsg_request->rqst_data.h_vendor.vendor_cmd;
  1273	
  1274		event_reply = (struct get_ct_event_reply *)
  1275			bsg_reply->reply_data.vendor_reply.vendor_rsp;
  1276		spin_lock_irqsave(&phba->ct_ev_lock, flags);
  1277		list_for_each_entry_safe(evt, evt_next, &phba->ct_ev_waiters, node) {
  1278			if (evt->reg_id == event_req->ev_reg_id) {
  1279				if (list_empty(&evt->events_to_get))
  1280					break;
  1281				lpfc_bsg_event_ref(evt);
  1282				evt->wait_time_stamp = jiffies;
  1283				evt_dat = list_entry(evt->events_to_get.prev,
  1284						     struct event_data, node);
  1285				list_del(&evt_dat->node);
  1286				break;
  1287			}
  1288		}
  1289		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
  1290	
  1291		/* The app may continue to ask for event data until it gets
  1292		 * an error indicating that there isn't anymore
  1293		 */
  1294		if (evt_dat == NULL) {
  1295			bsg_reply->reply_payload_rcv_len = 0;
  1296			rc = -ENOENT;
> 1297			goto job_error_unref;
  1298		}
  1299	
  1300		if (evt_dat->len > job->request_payload.payload_len) {
  1301			evt_dat->len = job->request_payload.payload_len;
  1302			lpfc_printf_log(phba, KERN_WARNING, LOG_LIBDFC,
  1303					"2618 Truncated event data at %d "
  1304					"bytes\n",
  1305					job->request_payload.payload_len);
  1306		}
  1307	
  1308		event_reply->type = evt_dat->type;
  1309		event_reply->immed_data = evt_dat->immed_dat;
  1310		if (evt_dat->len > 0)
  1311			bsg_reply->reply_payload_rcv_len =
  1312				sg_copy_from_buffer(job->request_payload.sg_list,
  1313						    job->request_payload.sg_cnt,
  1314						    evt_dat->data, evt_dat->len);
  1315		else
  1316			bsg_reply->reply_payload_rcv_len = 0;
  1317	
  1318		if (evt_dat) {
  1319			kfree(evt_dat->data);
  1320			kfree(evt_dat);
  1321		}
  1322	
  1323		spin_lock_irqsave(&phba->ct_ev_lock, flags);
  1324		lpfc_bsg_event_unref(evt);
  1325		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
  1326		job->dd_data = NULL;
  1327		bsg_reply->result = 0;
  1328		bsg_job_done(job, bsg_reply->result,
  1329			       bsg_reply->reply_payload_rcv_len);
  1330		return 0;
  1331	
> 1332	job_err_unref:
  1333		spin_lock_irqsave(&phba->ct_ev_lock, flags);
  1334		lpfc_bsg_event_unref(evt);
  1335		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
  1336	job_error:
  1337		job->dd_data = NULL;
  1338		bsg_reply->result = rc;
  1339		return rc;
  1340	}
  1341	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
