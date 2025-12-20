Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD2A29D26E;
	Sat, 20 Dec 2025 14:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766241314; cv=none; b=NeV9WlVqQSSsfpN3e7uEz0ee/clDely05z9wMsxM1+BXb3qKDAouAJ2haS+tKkWl/2dSV9nCO+2DsHmY9NviYwpMScRCFUqByz3etkFzLa6HAk3oEAKK8iqZmqU04AkV6Y6UkAaxeAlrRccuR2cw20ACONF/2F0snvRY7nfLNtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766241314; c=relaxed/simple;
	bh=rBqL956gH3K0poiy0iTZqF+U+rad4keWG+Egb5t3fJE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KcN/joNxjHRGI9SuuzmlQ+Ff5J+lvDvmy+rrcoLhksgJR2M8JjYANUvgWiyXv1sSvhXQY0Zd7kVZc4erM6bzqkkqkxT/YG4S0afBDUokBVS9GVeBP1grSn+vTPEECpYFENmVI+HXQV15muRl52BhYN2wLXpQbKU0Pwp/d+a8W7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AoQWYrnU; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AoQWYrnU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766241311; x=1797777311;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rBqL956gH3K0poiy0iTZqF+U+rad4keWG+Egb5t3fJE=;
  b=AoQWYrnUyiUEQdlRAb5UEPMQr3xNlHq5lHEfIclSCU/Llk84UGS1LSCW
   wkLJjf5d72PQvbFUpOdftNna41byKDEtiRzIbB5Q3GurIiRal8MCWafaK
   978ZdsC+8FsliqYelzNc9SVqgaZNKbeLnh1a7/PpZ/Y3AZpSA82mabRfO
   Qt4WxEVvGp84PQyKFSmu4k8y6LpKbUslue0yYaAY2Eco/WKEr3aMl/xQK
   bAgiKHYYXjDBR8z+olcdwZvOxwwnjqcUWIl+SaW4bRzwebotIKvFwoo2L
   noybLSfX2e9jF9V/9raPO/eS5wHE6r6FqBlr9YLIa4GEt3K1WfiWAqw+Z
   A==;
X-CSE-ConnectionGUID: dAf0ypatTg2ei0vNmV9pXQ==
X-CSE-MsgGUID: PK5y7cydRW6pL4N/KVZ8YA==
X-IronPort-AV: E=McAfee;i="6800,10657,11648"; a="93650001"
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="93650001"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2025 06:35:09 -0800
X-CSE-ConnectionGUID: KyzH7cUZS5+bjqHEtnY7hQ==
X-CSE-MsgGUID: WzYVUxAhQz+sk8Dk7O42VA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="199023545"
Received: from lkp-server01.sh.intel.com (HELO 0d09efa1b85f) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 20 Dec 2025 06:35:07 -0800
Received: from kbuild by 0d09efa1b85f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vWy2z-000000004eU-19c7;
	Sat, 20 Dec 2025 14:35:05 +0000
Date: Sat, 20 Dec 2025 22:34:13 +0800
From: kernel test robot <lkp@intel.com>
To: Shipei Qu <qu@darknavy.com>, Adam Radford <aradford@gmail.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Shipei Qu <qu@darknavy.com>, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, DARKNAVY <vr@darknavy.com>
Subject: Re: [PATCH v2] scsi: 3w-sas: validate request_id reported by
 controller
Message-ID: <202512202253.30DG2Afm-lkp@intel.com>
References: <20251216060156.41320-1-qu@darknavy.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216060156.41320-1-qu@darknavy.com>

Hi Shipei,

kernel test robot noticed the following build errors:

[auto build test ERROR on jejb-scsi/for-next]
[also build test ERROR on mkp-scsi/for-next linus/master v6.19-rc1 next-20251219]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Shipei-Qu/scsi-3w-sas-validate-request_id-reported-by-controller/20251216-140928
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20251216060156.41320-1-qu%40darknavy.com
patch subject: [PATCH v2] scsi: 3w-sas: validate request_id reported by controller
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20251220/202512202253.30DG2Afm-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251220/202512202253.30DG2Afm-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512202253.30DG2Afm-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/scsi/3w-sas.c:1190:7: error: too many arguments provided to function-like macro invocation
    1190 |                                   request_id);
         |                                   ^
   drivers/scsi/3w-sas.h:207:9: note: macro 'TW_PRINTK' defined here
     207 | #define TW_PRINTK(h,a,b,c) { \
         |         ^
>> drivers/scsi/3w-sas.c:1188:4: error: use of undeclared identifier 'TW_PRINTK'
    1188 |                         TW_PRINTK(tw_dev->host, TW_DRIVER, 0x10,
         |                         ^
   drivers/scsi/3w-sas.c:1579:49: warning: shift count >= width of type [-Wshift-count-overflow]
    1579 |         retval = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
         |                                                        ^~~~~~~~~~~~~~~~
   include/linux/dma-mapping.h:93:54: note: expanded from macro 'DMA_BIT_MASK'
      93 | #define DMA_BIT_MASK(n) (((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
         |                                                      ^ ~~~
   drivers/scsi/3w-sas.c:1796:49: warning: shift count >= width of type [-Wshift-count-overflow]
    1796 |         retval = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
         |                                                        ^~~~~~~~~~~~~~~~
   include/linux/dma-mapping.h:93:54: note: expanded from macro 'DMA_BIT_MASK'
      93 | #define DMA_BIT_MASK(n) (((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
         |                                                      ^ ~~~
   2 warnings and 2 errors generated.


vim +1190 drivers/scsi/3w-sas.c

  1117	
  1118	/* Interrupt service routine */
  1119	static irqreturn_t twl_interrupt(int irq, void *dev_instance)
  1120	{
  1121		TW_Device_Extension *tw_dev = (TW_Device_Extension *)dev_instance;
  1122		int i, handled = 0, error = 0;
  1123		dma_addr_t mfa = 0;
  1124		u32 reg, regl, regh, response, request_id = 0;
  1125		struct scsi_cmnd *cmd;
  1126		TW_Command_Full *full_command_packet;
  1127	
  1128		spin_lock(tw_dev->host->host_lock);
  1129	
  1130		/* Read host interrupt status */
  1131		reg = readl(TWL_HISTAT_REG_ADDR(tw_dev));
  1132	
  1133		/* Check if this is our interrupt, otherwise bail */
  1134		if (!(reg & TWL_HISTATUS_VALID_INTERRUPT))
  1135			goto twl_interrupt_bail;
  1136	
  1137		handled = 1;
  1138	
  1139		/* If we are resetting, bail */
  1140		if (test_bit(TW_IN_RESET, &tw_dev->flags))
  1141			goto twl_interrupt_bail;
  1142	
  1143		/* Attention interrupt */
  1144		if (reg & TWL_HISTATUS_ATTENTION_INTERRUPT) {
  1145			if (twl_handle_attention_interrupt(tw_dev)) {
  1146				TWL_MASK_INTERRUPTS(tw_dev);
  1147				goto twl_interrupt_bail;
  1148			}
  1149		}
  1150	
  1151		/* Response interrupt */
  1152		while (reg & TWL_HISTATUS_RESPONSE_INTERRUPT) {
  1153			if (sizeof(dma_addr_t) > 4) {
  1154				regh = readl(TWL_HOBQPH_REG_ADDR(tw_dev));
  1155				regl = readl(TWL_HOBQPL_REG_ADDR(tw_dev));
  1156				mfa = ((u64)regh << 32) | regl;
  1157			} else
  1158				mfa = readl(TWL_HOBQPL_REG_ADDR(tw_dev));
  1159	
  1160			error = 0;
  1161			response = (u32)mfa;
  1162	
  1163			/* Check for command packet error */
  1164			if (!TW_NOTMFA_OUT(response)) {
  1165				for (i=0;i<TW_Q_LENGTH;i++) {
  1166					if (tw_dev->sense_buffer_phys[i] == mfa) {
  1167						request_id = le16_to_cpu(tw_dev->sense_buffer_virt[i]->header_desc.request_id);
  1168						if (tw_dev->srb[request_id] != NULL)
  1169							error = twl_fill_sense(tw_dev, i, request_id, 1, 1);
  1170						else {
  1171							/* Skip ioctl error prints */
  1172							if (request_id != tw_dev->chrdev_request_id)
  1173								error = twl_fill_sense(tw_dev, i, request_id, 0, 1);
  1174							else
  1175								memcpy(tw_dev->command_packet_virt[request_id], tw_dev->sense_buffer_virt[i], sizeof(TW_Command_Apache_Header));
  1176						}
  1177	
  1178						/* Now re-post the sense buffer */
  1179						writel((u32)((u64)tw_dev->sense_buffer_phys[i] >> 32), TWL_HOBQPH_REG_ADDR(tw_dev));
  1180						writel((u32)tw_dev->sense_buffer_phys[i], TWL_HOBQPL_REG_ADDR(tw_dev));
  1181						break;
  1182					}
  1183				}
  1184			} else
  1185				request_id = TW_RESID_OUT(response);
  1186	
  1187			if (request_id >= TW_Q_LENGTH) {
> 1188				TW_PRINTK(tw_dev->host, TW_DRIVER, 0x10,
  1189					  "Received out-of-range request id %u",
> 1190					  request_id);
  1191				TWL_MASK_INTERRUPTS(tw_dev);
  1192				/* let the reset / error handling path deal with it */
  1193				goto twl_interrupt_bail;
  1194			}
  1195	
  1196			full_command_packet = tw_dev->command_packet_virt[request_id];
  1197	
  1198			/* Check for correct state */
  1199			if (tw_dev->state[request_id] != TW_S_POSTED) {
  1200				if (tw_dev->srb[request_id] != NULL) {
  1201					TW_PRINTK(tw_dev->host, TW_DRIVER, 0xe, "Received a request id that wasn't posted");
  1202					TWL_MASK_INTERRUPTS(tw_dev);
  1203					goto twl_interrupt_bail;
  1204				}
  1205			}
  1206	
  1207			/* Check for internal command completion */
  1208			if (tw_dev->srb[request_id] == NULL) {
  1209				if (request_id != tw_dev->chrdev_request_id) {
  1210					if (twl_aen_complete(tw_dev, request_id))
  1211						TW_PRINTK(tw_dev->host, TW_DRIVER, 0xf, "Error completing AEN during attention interrupt");
  1212				} else {
  1213					tw_dev->chrdev_request_id = TW_IOCTL_CHRDEV_FREE;
  1214					wake_up(&tw_dev->ioctl_wqueue);
  1215				}
  1216			} else {
  1217				cmd = tw_dev->srb[request_id];
  1218	
  1219				if (!error)
  1220					cmd->result = (DID_OK << 16);
  1221	
  1222				/* Report residual bytes for single sgl */
  1223				if ((scsi_sg_count(cmd) <= 1) && (full_command_packet->command.newcommand.status == 0)) {
  1224					if (full_command_packet->command.newcommand.sg_list[0].length < scsi_bufflen(tw_dev->srb[request_id]))
  1225						scsi_set_resid(cmd, scsi_bufflen(cmd) - full_command_packet->command.newcommand.sg_list[0].length);
  1226				}
  1227	
  1228				/* Now complete the io */
  1229				scsi_dma_unmap(cmd);
  1230				scsi_done(cmd);
  1231				tw_dev->state[request_id] = TW_S_COMPLETED;
  1232				twl_free_request_id(tw_dev, request_id);
  1233				tw_dev->posted_request_count--;
  1234			}
  1235	
  1236			/* Check for another response interrupt */
  1237			reg = readl(TWL_HISTAT_REG_ADDR(tw_dev));
  1238		}
  1239	
  1240	twl_interrupt_bail:
  1241		spin_unlock(tw_dev->host->host_lock);
  1242		return IRQ_RETVAL(handled);
  1243	} /* End twl_interrupt() */
  1244	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
