From: Konrad Rzeszutek Wilk <konrad@darnok.org>
Subject: Re: [PATCH 2/2] RFC: iscsi ibft: convert iscsi_ibft module to iscsi boot lib
Date: Mon, 12 Apr 2010 22:36:13 -0400
Message-ID: <201004122236.13843.konrad@darnok.org>
References: <1271095578-4212-1-git-send-email-michaelc@cs.wisc.edu> <201004122221.05326.konrad@darnok.org> <4BC3D7C1.90307@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4BC3D7C1.90307@cs.wisc.edu>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, pjones@redhat.com, open-iscsi@googlegroups.com
List-Id: linux-scsi@vger.kernel.org

On Monday 12 April 2010 22:32:33 Mike Christie wrote:
> On 04/12/2010 09:21 PM, Konrad Rzeszutek Wilk wrote:
> >> + * Helper routiners to check to determine if the entry is valid
> >> + * in the proper iBFT structure.
> >> + */
> >> +static mode_t ibft_check_nic_for(void *data, int type)
> >> +{
> >> +	struct ibft_kobject *entry = data;
> >> +	struct ibft_nic *nic = entry->nic;
> >> +	mode_t rc = 0;
> >> +
> >> +	switch (type) {
> >> +	case ISCSI_BOOT_ETH_INDEX:
> >> +	case ISCSI_BOOT_ETH_FLAGS:
> >> +		rc = 1;
> >
> > Did you mean for that value?
> >
> >> +		break;
> >> +	case ISCSI_BOOT_ETH_IP_ADDR:
> >> +		if (memcmp(nic->ip_addr, nulls, sizeof(nic->ip_addr)))
> >> +			rc = S_IRUGO;
> >> +		break;
> >> +	case ISCSI_BOOT_ETH_SUBNET_MASK:
> >> +		if (nic->subnet_mask_prefix)
> >> +			rc = S_IRUGO;
> >> +		break;
> >> +	case ISCSI_BOOT_ETH_ORIGIN:
> >> +		rc = 1;
> >
> > and this one as well?
>
> I did not. They should be S_IRUGO. Do you want me to resubmit the
> patches or are you just going to edit those two lines if you merge them?

No need to resend them (unless Peter eyes found something I missed).
