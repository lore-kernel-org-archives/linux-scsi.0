From: Alex Shi <alex.shi@intel.com>
Subject: Re: [PATCH] [SCSI] mpt2sas : Fix unsafe using smp_processor_id()
 inpreemptible
Date: Mon, 23 Apr 2012 09:29:42 +0800
Message-ID: <4F94B086.4000502@intel.com>
References: <20120418031441.GA10862@parisc-linux.org> <4565AEA676113A449269C2F3A549520FB5AE22E7@cosmail03.lsi.com> <20120418041359.GB10862@parisc-linux.org> <A6888A6805518E4EA4AF7072A28264A6067E89B20C@inbmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:64442 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074Ab2DWBap (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Apr 2012 21:30:45 -0400
In-Reply-To: <A6888A6805518E4EA4AF7072A28264A6067E89B20C@inbmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Cc: Matthew Wilcox <matthew@wil.cx>, "Moore, Eric" <Eric.Moore@lsi.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>, "jejb@kernel.org" <jejb@kernel.org>

On 04/20/2012 07:00 PM, Nandigama, Nagalakshmi wrote:

> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
> index 272fab7..0f47f56 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
> @@ -1792,7 +1792,10 @@ static inline void _base_writeq(__u64 b, volatile void __iomem *addr,
>  static inline u8
>  _base_get_msix_index(struct MPT2SAS_ADAPTER *ioc)
>  {
> -       return ioc->cpu_msix_table[smp_processor_id()];
> +       int cpu = get_cpu();
> +       put_cpu();
> +       return ioc->cpu_msix_table[cpu];
> +
>  }


If we don't care the correctness interrupt CPU. Do
preempt_enable/preempt_disable is just waste of time.
A patch like following is enough, :)

 _base_get_msix_index(struct MPT2SAS_ADAPTER *ioc)
 {
-       return ioc->cpu_msix_table[smp_processor_id()];
+       return ioc->cpu_msix_table[raw_smp_processor_id()];
 }


BTW, I didn't subscribe linux-scsi mailing list, so cc to me is
appreciated.
