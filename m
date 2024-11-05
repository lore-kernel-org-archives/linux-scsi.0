Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4D01FE11E;
	Tue,  5 Nov 2024 20:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730837871; cv=none; b=d5XnVraJruULRmfk9lxUH+dMaIw3d5opdwnCt5xuiK9+CZkdCE/tF70m76kjIOz4k4hZe4W5+BgvuDPdBGhHCzGM7zx19okAuytJCOMBel9Vck7LwTJfcYbcdK84Jpg6r0/u4CImtd8oTb9IxEEeqsOu6lL2Hnqul+L/A4/++Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730837871; c=relaxed/simple;
	bh=G4KvV+fKvQz4xW9wWgjXJe2AgMxSBP7vJwJ6Xb4Jf0w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bDhnL40ixBDtMudRb5jQSyJjCfNRxkhP81v97VMcwfrlQq5sX4fmD+L/1YP38uhpmtgTq7vUViS6ixk8Qn1+r4W+Uml5CcIjJ+XdZSlSo/Dnxo7/KAVKi3X7C7aVmJPR+l6umDvnZaf1Mf1TEosm1A8gtqe+u27MwWg7H/OXoBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cw5dGJPP; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cw5dGJPP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730837869; x=1762373869;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=G4KvV+fKvQz4xW9wWgjXJe2AgMxSBP7vJwJ6Xb4Jf0w=;
  b=cw5dGJPPTL4DXrwvAeHpjTwHr3McYp4dxWchO1z/X2MYGM2eaXmqzKuO
   MyY6HWVTbswy5qhispfakXJQbbh3Sc6eACf/KqM6EM+/z1v3aLJWuNeyx
   ax3NTfNcBGwhZ6K8YBExqBYWVYf+hjNAzf1MwEK78zkzCEoIiXD9Ajl75
   MlCWrakHRzrikU0ly3V8Lv7j3jC9WTeDip3NXgfDeZmV8ELFdI51ayQNw
   ZFrYbybvdZpL/tIvcnL9O9re2ZObX8nKgjz4QG3dMz6G56DdbXHDwGciF
   JSQojg66FdwHAabwV17Z/Ht6B+CXR63fjHB3Fzfa5JNnV3t3JOZHsjugV
   Q==;
X-CSE-ConnectionGUID: 22Q+Mo8CQNusPo+uz+x2Sg==
X-CSE-MsgGUID: k9yvc/7bStelO4rJQSkBmw==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="34538092"
X-IronPort-AV: E=Sophos;i="6.11,261,1725346800"; 
   d="scan'208";a="34538092"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 12:17:49 -0800
X-CSE-ConnectionGUID: Lh33xTkyS1GF6g50pUIdfw==
X-CSE-MsgGUID: oF/C8elwRp2NhgGGip5fxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,261,1725346800"; 
   d="scan'208";a="88109239"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 05 Nov 2024 12:17:47 -0800
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t8Pzk-000mQJ-1T;
	Tue, 05 Nov 2024 20:17:44 +0000
Date: Wed, 6 Nov 2024 04:16:49 +0800
From: kernel test robot <lkp@intel.com>
To: Qiu-ji Chen <chenqiuji666@gmail.com>, james.smart@broadcom.com,
	dick.kennedy@broadcom.com, James.Bottomley@hansenpartnership.com,
	martin.petersen@oracle.com
Cc: oe-kbuild-all@lists.linux.dev, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, baijiaju1990@gmail.com,
	Qiu-ji Chen <chenqiuji666@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] scsi: lpfc: Fix improper handling of refcount in
 lpfc_bsg_hba_get_event()
Message-ID: <202411060332.fmmxsBzv-lkp@intel.com>
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
config: i386-allmodconfig (https://download.01.org/0day-ci/archive/20241106/202411060332.fmmxsBzv-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241106/202411060332.fmmxsBzv-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202411060332.fmmxsBzv-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   drivers/scsi/lpfc/lpfc_bsg.c: In function 'lpfc_bsg_hba_get_event':
>> drivers/scsi/lpfc/lpfc_bsg.c:1332:1: warning: label 'job_err_unref' defined but not used [-Wunused-label]
    1332 | job_err_unref:
         | ^~~~~~~~~~~~~
>> drivers/scsi/lpfc/lpfc_bsg.c:1297:17: error: label 'job_error_unref' used but not defined
    1297 |                 goto job_error_unref;
         |                 ^~~~

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for MODVERSIONS
   Depends on [n]: MODULES [=y] && !COMPILE_TEST [=y]
   Selected by [y]:
   - RANDSTRUCT_FULL [=y] && (CC_HAS_RANDSTRUCT [=n] || GCC_PLUGINS [=y]) && MODULES [=y]
   WARNING: unmet direct dependencies detected for GET_FREE_REGION
   Depends on [n]: SPARSEMEM [=n]
   Selected by [m]:
   - RESOURCE_KUNIT_TEST [=m] && RUNTIME_TESTING_MENU [=y] && KUNIT [=m]


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
