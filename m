From: Ching Huang <ching2048@areca.com.tw>
Subject: Re: [PATCH 4/4] scsi: arcmsr: simplify all arcmsr_hbaX_get_config
 routine by call a new get_adapter_config function
Date: Thu, 14 Dec 2017 15:41:48 +0800
Message-ID: <1513237308.4715.10.camel@Centos6.3-64>
References: <1513076013.5249.27.camel@Centos6.3-64>
         <201712141218.O3SFtK1p%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201712141218.O3SFtK1p%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dan.carpenter@oracle.com, hch@infradead.org, colin.king@canonical.com
List-Id: linux-scsi@vger.kernel.org

On Thu, 2017-12-14 at 13:13 +0800, kbuild test robot wrote:
> Hi Ching,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on scsi/for-next]
> [also build test WARNING on next-20171213]
> [cannot apply to v4.15-rc3]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
As what I have said in [PATCH 0/4], this serial patches are apply to
Martin's 4.16/scsi-queue only. Now scsi/for-next and next-20171213 are
synchronized to Martin's 4.16/scsi-queue, so these patches can apply to
them. But v4.15-rc3 has to do some patches like 4.16/scsi-queue done
before, or this patch can not apply.
> 
> url:    https://github.com/0day-ci/linux/commits/Ching-Huang/scsi-arcmsr-simplify-hba_get_config-routine/20171213-224803
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
> reproduce:
>         # apt-get install sparse
>         make ARCH=x86_64 allmodconfig
>         make C=1 CF=-D__CHECK_ENDIAN__
> 
> 
> sparse warnings: (new ones prefixed by >>)
> 
> 
> vim +2971 drivers/scsi/arcmsr/arcmsr_hba.c
> 
>   2958	
>   2959	static void arcmsr_get_adapter_config(struct AdapterControlBlock *pACB, uint32_t *rwbuffer)
>   2960	{
>   2961		int count;
>   2962		uint32_t *acb_firm_model = (uint32_t *)pACB->firm_model;
>   2963		uint32_t *acb_firm_version = (uint32_t *)pACB->firm_version;
>   2964		uint32_t *acb_device_map = (uint32_t *)pACB->device_map;
>   2965		uint32_t *firm_model = &rwbuffer[15];
>   2966		uint32_t *firm_version = &rwbuffer[17];
>   2967		uint32_t *device_map = &rwbuffer[21];
>   2968	
>   2969		count = 2;
>   2970		while (count) {
> > 2971			*acb_firm_model = readl(firm_model);
>   2972			acb_firm_model++;
>   2973			firm_model++;
>   2974			count--;
>   2975		}
>   2976		count = 4;
>   2977		while (count) {
>   2978			*acb_firm_version = readl(firm_version);
>   2979			acb_firm_version++;
>   2980			firm_version++;
>   2981			count--;
>   2982		}
>   2983		count = 4;
>   2984		while (count) {
>   2985			*acb_device_map = readl(device_map);
>   2986			acb_device_map++;
>   2987			device_map++;
>   2988			count--;
>   2989		}
>   2990		pACB->signature = readl(&rwbuffer[0]);
>   2991		pACB->firm_request_len = readl(&rwbuffer[1]);
>   2992		pACB->firm_numbers_queue = readl(&rwbuffer[2]);
> > 2993		pACB->firm_sdram_size = readl(&rwbuffer[3]);
> > 2994		pACB->firm_hd_channels = readl(&rwbuffer[4]);
>   2995		pACB->firm_cfg_version = readl(&rwbuffer[25]);
>   2996		pr_notice("Areca RAID Controller%d: Model %s, F/W %s\n",
>   2997			pACB->host->host_no,
>   2998			pACB->firm_model,
>   2999			pACB->firm_version);
>   3000	}
>   3001	
>   3002	static bool arcmsr_hbaA_get_config(struct AdapterControlBlock *acb)
>   3003	{
>   3004		struct MessageUnit_A __iomem *reg = acb->pmuA;
>   3005	
>   3006		arcmsr_wait_firmware_ready(acb);
>   3007		writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
>   3008		if (!arcmsr_hbaA_wait_msgint_ready(acb)) {
>   3009			printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
>   3010				miscellaneous data' timeout \n", acb->host->host_no);
>   3011			return false;
>   3012		}
> > 3013		arcmsr_get_adapter_config(acb, reg->message_rwbuffer);
>   3014		return true;
>   3015	}
>   3016	static bool arcmsr_hbaB_get_config(struct AdapterControlBlock *acb)
>   3017	{
>   3018		struct MessageUnit_B *reg = acb->pmuB;
>   3019	
>   3020		arcmsr_wait_firmware_ready(acb);
>   3021		writel(ARCMSR_MESSAGE_START_DRIVER_MODE, reg->drv2iop_doorbell);
>   3022		if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
>   3023			printk(KERN_ERR "arcmsr%d: can't set driver mode.\n", acb->host->host_no);
>   3024			return false;
>   3025		}
>   3026		writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);
>   3027		if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
>   3028			printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
>   3029				miscellaneous data' timeout \n", acb->host->host_no);
>   3030			return false;
>   3031		}
> > 3032		arcmsr_get_adapter_config(acb, reg->message_rwbuffer);
>   3033		return true;
>   3034	}
>   3035	
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
